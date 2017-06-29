//
//  ImageCollectionViewCell.swift
//  API
//
//  Created by Евгений Бейнар on 26.06.17.
//  Copyright © 2017 Евгений Бейнар. All rights reserved.
//

import UIKit
import AlamofireImage


class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionImageView: UIImageView!
    
    func setCellData(data: [String: String]) {
        let url = URL(string: data["thumbImage"]!)!
        let phImage = UIImage(named: "placeholder")!
        collectionImageView.af_setImage(withURL: url,placeholderImage:phImage)
    }
    
}
