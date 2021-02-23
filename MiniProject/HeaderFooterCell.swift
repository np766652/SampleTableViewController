//
//  HeaderFooterCell.swift
//  MiniProject
//
//  Created by Nikunjkumar Patel on 19/02/21.
//

import UIKit

class HeaderFooterCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func createCell() -> HeaderFooterCell? {
            let nib = UINib(nibName: "HeaderFooterCell", bundle: nil)
            let cell = nib.instantiate(withOwner: self, options: nil).last as? HeaderFooterCell
        return cell
        }
    
}
