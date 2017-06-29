//
//  CollectionViewController.swift
//  API
//
//  Created by Евгений Бейнар on 25.06.17.
//  Copyright © 2017 Евгений Бейнар. All rights reserved.
//

import UIKit
import MBProgressHUD

class CollectionViewController: UIViewController {

//MARK: - IB O
    @IBOutlet weak var collectionView: UICollectionView!
    
//MARK: - Variable
    var categoryId: Int = 0
    var httpManager: HTTPManager!
    var collectionS = [[String: String]]()
    var passimgid:Int = 0
    var pageNumber = 1

    var isAllLoaded = false
    var waiting = false
    

//MARK: - life C
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setupCollectionView()
        self.httpManager = (UIApplication.shared.delegate as! AppDelegate).getHTTPManager()
    
        //print (categoryId)
        loadCollection()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


//MARK: - Configere methods
    fileprivate func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }


    func loadCollection()  {
        
        if isAllLoaded == true { return }
        self.httpManager.getCollection(catId: categoryId, page: pageNumber, completionHandler: {jsonResponse, error in
            if let success = jsonResponse?["success"]?.boolValue {
                if success == true {
                    self.pageNumber += 1
                    guard let isLast =  jsonResponse!["is_last"]?.boolValue else {return}
                    self.isAllLoaded = isLast
                    guard let collection =  jsonResponse!["wallpapers"]?.arrayValue else {return}
                    for coll in collection {
                        guard let fullImage = coll["url_image"].string else { return }
                        guard let tumbImage = coll["url_thumb"].string else { return }
                        let colls = ["fullImage": fullImage, "thumbImage": tumbImage]
                        self.collectionS.append(colls)
                        }
                     self.collectionView.reloadData()
                } else {
                    self.showAlertMessadge()
                }
            } else if let _ = error {
                    self.showAlertMessadge()
            }
        })
        waiting = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fullImgSegue" {
            let controller = segue.destination as! ImageFullViewController
            let url = collectionS[passimgid]["fullImage"]
            controller.urlFullImg = url!
        }
    }
}

//MARK: - CollectionViewVontrollerDelegate
extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionS.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        let data = collectionS[indexPath.row]
        cell.setCellData(data: data)
        return cell
    }
    
    //make rectangle cell with  1/3 of screen
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 4
        return CGSize(width: width, height: width)
    }
}


//MARK: - CollectionViewControlleDelegate
extension CollectionViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == collectionS.count-1 && !self.waiting  {
            waiting = true;
            self.loadCollection()
            print("LOADING MORE")
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       passimgid = indexPath.row
        performSegue(withIdentifier: "fullImgSegue", sender: self)
        
      //  let collectionViewCell = collectionView.cellForItem(at: indexPath)
    }
    
}
