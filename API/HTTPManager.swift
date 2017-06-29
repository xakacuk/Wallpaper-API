//
//  HTTPManager.swift
//  API
//
//  Created by Евгений Бейнар on 24.06.17.
//  Copyright © 2017 Евгений Бейнар. All rights reserved.
//-

import Alamofire
import SwiftyJSON

class HTTPManager {

//MARK: - Struct
    struct Const {
        static let Url = "https://wall.alphacoders.com/api2.0/get.php"
    }
    
    struct Config {
        static let timeout: TimeInterval = 15.0
        static let key = "c49a821fa3b780caac2fe00d74be5dd2"
    }
    
   lazy var networkSessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = Config.timeout
        configuration.timeoutIntervalForRequest = Config.timeout
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        return sessionManager
    } ()
    
    
//MARK: - getCat
    func getCategoris(completionHandler: ((_ cats: [JSON]?, _ error: String?) -> ())?) {
        
        let params = ["auth": Config.key, "method": "category_list"] as [String: Any]
        
        self.networkSessionManager.request(Const.Url, method: .get, parameters: params).validate().responseJSON { response in switch response.result {
            
            case .success(let json):
                let jsonDict = JSON(json)

                if let categories = jsonDict["categories"].array{
                    completionHandler?(categories,nil)}
                
               // print("Response: \(jsonDict)")
            
        case .failure(let error):
                print("Error while load cats")
                if error._code == NSURLErrorTimedOut{
                    completionHandler?(nil,"Please check you connection")
                } else {
                    completionHandler?(nil, error.localizedDescription)
                }
            }
        }
    }
 
//MARK: - getSubCat
    func getSubCategoris(catId: Int, completionHandler: ((_ cats: [JSON]?, _ error: String?) -> ())?) {
        
        let params = ["auth": Config.key, "method": "sub_category_list", "id": catId] as [String: Any]
        
        self.networkSessionManager.request(Const.Url, method: .get, parameters: params).validate().responseJSON { response in switch response.result {
            
        case .success(let json):
            let jsonDict = JSON(json)
            
            if let subCategories = jsonDict["sub-categories"].array{
                completionHandler?(subCategories,nil)}
            
             //print("subResponse: \(jsonDict)")
            
        case .failure(let error):
            print("Error while load subCats")
            if error._code == NSURLErrorTimedOut{
                completionHandler?(nil,"Please check you connection")
            } else {
                completionHandler?(nil, error.localizedDescription)
            }
            }
        }
    }
    
//MARK: - getColl
    func getCollection(catId: Int, page: Int, completionHandler: ((_ response: [String:JSON]?, _ error: String?) -> ())?) {
        
        let params = [
            "auth": Config.key,
            "method": "sub_category",
            "id": catId,
            "page": page,
            "check_last": 1
            ] as [String: Any]
        
        self.networkSessionManager.request(Const.Url, method: .get, parameters: params).validate().responseJSON { response in switch response.result {
            
        case .success(let json):
            let jsonDict = JSON(json)
            
            if let collection = jsonDict.dictionary{
                completionHandler?(collection,nil)
            }
            
           // print("collectionResponse: \(jsonDict)")
            
        case .failure(let error):
            print("Error while load subCats")
            if error._code == NSURLErrorTimedOut{
                completionHandler?(nil,"Please check you connection")
            } else {
                completionHandler?(nil, error.localizedDescription)
            }
            }
        }
    }
}
