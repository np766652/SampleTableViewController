//
//  Loading.swift
//  MiniProject
//
//  Created by Nikunjkumar Patel on 18/02/21.
//

import UIKit

class Loading: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func createCell() -> Loading? {
            let nib = UINib(nibName: "Loading", bundle: nil)
            let cell = nib.instantiate(withOwner: self, options: nil).last as? Loading
        return cell
        }
    
}
