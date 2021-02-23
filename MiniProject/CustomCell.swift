//
//  CustomCell.swift
//  MiniProject
//
//  Created by Nikunjkumar Patel on 16/02/21.
//

import UIKit

class CustomCell: UITableViewCell {


    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var sloganLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    class func createCell() -> CustomCell? {
            let nib = UINib(nibName: "CustomCell", bundle: nil)
            let cell = nib.instantiate(withOwner: self, options: nil).last as? CustomCell
        return cell
        }
}
