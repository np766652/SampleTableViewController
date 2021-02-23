//
//  NameCell.swift
//  MiniProject
//
//  Created by Nikunjkumar Patel on 19/02/21.
//

import UIKit

class NameCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("abc")
        return true
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func createCell(formVc: FormTableViewController) -> NameCell? {
        
            let nib = UINib(nibName: "NameCell", bundle: nil)
            let cell = nib.instantiate(withOwner: self, options: nil).last as? NameCell
            nameTextField.delegate = formVc
        return cell
        }
    
}
