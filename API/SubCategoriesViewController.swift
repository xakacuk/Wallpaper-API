//
//  SubCategoriesViewController.swift
//  API
//
//  Created by Евгений Бейнар on 25.06.17.
//  Copyright © 2017 Евгений Бейнар. All rights reserved.
//-

import UIKit
import MBProgressHUD

class SubCategoriesViewController: UIViewController {

//MARK: - Variable
    var categoryId: Int = 0
    var subCategories = [[String: Any]]()
    var httpManager: HTTPManager!
    var passedSubCategory: Int!
    //var selectedSubCategory: Any?

//MARK: - IB O
    @IBOutlet weak var subCategorieTableView: UITableView!
    
//MARK: - life C
    override func viewDidLoad() {
        
        let cellNib = UINib(nibName: "CategoryCell", bundle: nil)
        subCategorieTableView.register(cellNib, forCellReuseIdentifier: "customCell")
        
        super.viewDidLoad()
        
        setupSubCategoriesTableView()
        httpManager = (UIApplication.shared.delegate as! AppDelegate).getHTTPManager()
        loadSubCats()
        
      //  print (categoryId)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func loadSubCats()  {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .indeterminate
        hud.label.text = "Loading ..."
        self.httpManager.getSubCategoris(catId: categoryId, completionHandler: {jsonSubCats, error in
            if let subCats = jsonSubCats {
                for subCategory in subCats {
                    guard let name = subCategory["name"].string else { return }
                    guard let count = subCategory["count"].int else { return }
                    guard let catId = subCategory["id"].int else {return}
                    let subCat = ["id": catId, "name": name, "count": count] as [String : Any]
                    self.subCategories.append(subCat)
                }
                self.subCategorieTableView.reloadData()
                hud.hide(animated:true)
                
            } else if let _ = error {
                 hud.hide(animated:true)
              //  print (error)
                self.showAlertMessadge()
            }
            
        })
    }
    
//MARK: - Configure methods
    fileprivate func setupSubCategoriesTableView() {
        subCategorieTableView.dataSource = self
        subCategorieTableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collectionSegue" {
            let controller = segue.destination as! CollectionViewController
            controller.categoryId = self.passedSubCategory
        }
    }

}

//MARK: - UITableViewDataSource
extension SubCategoriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CategoryCell
        let subCategory = subCategories[indexPath.row]
        cell.configureCell(cat: subCategory)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

//MARK: - UITableViewDelegate
extension SubCategoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSubCategory = self.subCategories[indexPath.row]
        let currentSubCatId = selectedSubCategory["id"] as! Int
        self.passedSubCategory = currentSubCatId
        performSegue(withIdentifier: "collectionSegue", sender: nil)
        
    }
    
}
