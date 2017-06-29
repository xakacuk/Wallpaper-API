//-
import UIKit

class CategoryCell: UITableViewCell {

//MARK: - IB O


    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!

    
    func configureCell(cat: [String: Any]) {
        guard let name = cat["name"] else {return}
        guard let count: Int = cat["count"] as? Int else {return}
        
        nameLabel.text = (name as! String).capitalized
        countLabel.text = "Total images: \(count)"
    }
}

