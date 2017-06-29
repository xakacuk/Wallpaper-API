//
//  ViewController.swift
//  API
//
//  Created by Евгений Бейнар on 24.06.17.
//  Copyright © 2017 Евгений Бейнар. All rights reserved.
//-

import UIKit
import MBProgressHUD

class CategoriesViewController: UIViewController {
    
//MARK: - Variable
    var categories = [[String: Any]]()
    var httpManager: HTTPManager!
    var passedCategory: Int!

//MARK: - IB O
    @IBOutlet weak var tableView: UITableView!
    
//MARK: - Life C
    override func viewDidLoad() {
        
        let cellNib = UINib(nibName: "CategoryCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "customCell")
        
        super.viewDidLoad()
        
        self.setupTableView()
        httpManager = (UIApplication.shared.delegate as! AppDelegate).getHTTPManager()
        loadCats()
    }
    
    func loadCats()  {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .indeterminate
        hud.label.text = "Loading ..."
        self.httpManager.getCategoris(completionHandler: {jsonCats, error in
            if let cats = jsonCats {
                for category in cats {
                    guard let name = category["name"].string else { return }
                    guard let count = category["count"].int else { return }
                    guard let catID = category["id"].int else {return}
                    let cat = ["id": catID, "name": name, "count": count] as [String : Any]
                    self.categories.append(cat)
                }
                self.tableView.reloadData()
                hud.hide(animated: true)
            } else if let _ = error {
              //  print (error)
             hud.hide(animated: true)
                self.showAlertMessadge()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MARK: - Configure methods
    fileprivate func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "subCatSegue" {
            let controller = segue.destination as! SubCategoriesViewController
            controller.categoryId = self.passedCategory
        }
    }
    
}

//MARK: - UITableViewDataSource
extension CategoriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CategoryCell
        let category = categories[indexPath.row]
        cell.configureCell(cat: category )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

//MARK: - UITableViewDelegate
extension CategoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = self.categories[indexPath.row]
        let currentCatId = selectedCategory["id"] as! Int
        self.passedCategory = currentCatId
        performSegue(withIdentifier: "subCatSegue", sender: self)

    }
    
}
