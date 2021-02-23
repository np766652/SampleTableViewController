//
//  HeaderFooterTableViewCell.swift
//  MiniProject
//
//  Created by Nikunjkumar Patel on 18/02/21.
//

import UIKit

class HeaderFooterTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func createCell() -> HeaderFooterTableViewCell? {
            let nib = UINib(nibName: "HeaderFooterTableViewCell", bundle: nil)
            let cell = nib.instantiate(withOwner: self, options: nil).last as? HeaderFooterTableViewCell
            return cell
        }
    
}
