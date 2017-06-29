//
//  ImageFullViewController.swift
//  API
//
//  Created by Евгений Бейнар on 27.06.17.
//  Copyright © 2017 Евгений Бейнар. All rights reserved.
//

import UIKit
import AlamofireImage
import MBProgressHUD

class ImageFullViewController: UIViewController {

//MARK: - Variable
    var urlFullImg: String!
    let downloader = ImageDownloader()
    var visibilityState: Bool = false //status bar invis
    
    
    
//MARK: - IB O
    @IBOutlet var shareImgButton: UIBarButtonItem!
    @IBOutlet var fullImgView: UIImageView!
    @IBOutlet var fullImgScrollView: UIScrollView!
    
//MARK: - IB A
    @IBAction func shareImgButton (_ sender: UIBarButtonItem) {
        
        // image to share
        let image = fullImgView.image
        
        // set up activity view controller
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
   
    
//MARK: - life C
    override func viewDidLoad() {
        super.viewDidLoad()

        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .indeterminate
        hud.label.text = "Loading ..."
        
     
        let urlRequest = URLRequest(url: URL(string: urlFullImg)!)
        
        downloader.download(urlRequest) { response in
            
            guard let loadedImage: UIImage = response.result.value else {
                print("Error")
                self.showAlertMessadge()
                self.fullImgView.image = #imageLiteral(resourceName: "placeholder")
                self.shareImgButton.isEnabled = false
                hud.hide(animated: true)
                return
            }
            
           self.fullImgView.image = loadedImage
            self.shareImgButton.isEnabled = true
            hud.hide(animated: true)
            
        }
        
        fullImgScrollView.backgroundColor = UIColor.white
        fullImgScrollView.delegate = self
        setZoomParametersForSize(fullImgScrollView.bounds.size)
        fullImgScrollView.zoomScale = fullImgScrollView.minimumZoomScale
        recenterImage()
        
        setupGesturesRecognizers()
    
        
    }
    
    //status bar invis
    override var prefersStatusBarHidden: Bool {
        return visibilityState
    }
    
//MARK: - gesture recognizer
    func setupGesturesRecognizers(){
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSingeleTap(recognizer:)))
        singleTapGesture.numberOfTapsRequired = 1
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(recognizer:)))
        doubleTapGesture.numberOfTapsRequired = 2
        singleTapGesture.require(toFail: doubleTapGesture)
        
        fullImgScrollView.addGestureRecognizer(singleTapGesture)
        fullImgScrollView.addGestureRecognizer(doubleTapGesture)
    }

//MARK: - tap1, tap2
    func handleSingeleTap(recognizer: UITapGestureRecognizer){
        
        let newState:Bool = !(navigationController?.isNavigationBarHidden)!
        navigationController?.setNavigationBarHidden(newState , animated: true)
        fullImgScrollView.backgroundColor =  newState ? UIColor.black: UIColor.white
        visibilityState = newState
        setNeedsStatusBarAppearanceUpdate()
    }

    func handleDoubleTap(recognizer: UITapGestureRecognizer){
        
        if fullImgScrollView.zoomScale == 1 {
            fullImgScrollView.zoom(to: zoomRectForScale(scale: fullImgScrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            fullImgScrollView.setZoomScale(1, animated: true)
        }
    }

//MARK: - zoom tap
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = fullImgView.frame.size.height / scale
        zoomRect.size.width  = fullImgView.frame.size.width  / scale
        let newCenter = fullImgView.convert(center, from: fullImgScrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
//MARK: - work with +/- img
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let centerPoint = CGPoint(x: fullImgScrollView.contentOffset.x + fullImgScrollView.bounds.width / 2,
                                  y: fullImgScrollView.contentOffset.y + fullImgScrollView.bounds.height / 2)
        
        coordinator.animate(alongsideTransition: { (context) -> Void in
            self.fullImgScrollView.contentOffset = CGPoint(x: centerPoint.x - size.width / 2,
                                                    y: centerPoint.y - size.height / 2)
        }, completion: nil)
    }
    
    func setZoomParametersForSize(_ scrollViewSize: CGSize) {
        let imageSize = fullImgView.bounds.size
        
        let widthScale = scrollViewSize.width / imageSize.width
        let heightScale = scrollViewSize.height / imageSize.height
        let minScale = min(widthScale, heightScale)
        
        fullImgScrollView.minimumZoomScale = minScale
        fullImgScrollView.maximumZoomScale = 3.0
    }
    
    func recenterImage() {
        let scrollViewSize = fullImgScrollView.bounds.size
        let imageSize = fullImgView.frame.size
        
        let horizontalSpace = imageSize.width < scrollViewSize.width ?
            (scrollViewSize.width - imageSize.width) / 2 : 0
        let verticalSpace = imageSize.height < scrollViewSize.height ?
            (scrollViewSize.height - imageSize.height) / 2 : 0
        
        fullImgScrollView.contentInset = UIEdgeInsets(top: verticalSpace,
                                               left: horizontalSpace,
                                               bottom: verticalSpace,
                                               right: horizontalSpace)
    }
    
    override func viewWillLayoutSubviews() {
        setZoomParametersForSize(fullImgScrollView.bounds.size)
        if fullImgScrollView.zoomScale < fullImgScrollView.minimumZoomScale {
            fullImgScrollView.zoomScale = fullImgScrollView.minimumZoomScale
        }
        recenterImage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - UIScrollViewDelegate
extension ImageFullViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fullImgView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        recenterImage()
    }

}




