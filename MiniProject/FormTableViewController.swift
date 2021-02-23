//
//  FormTableViewController.swift
//  MiniProject
//
//  Created by Nikunjkumar Patel on 19/02/21.
//

import UIKit


protocol ChangeValueDelegate {
    func valueChanged(dataString: String)
}

class FormTableViewController: UIViewController,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
   
    enum PickerData: String, CaseIterable {
           case quatar = "Quatar Airways"
           case eva = "Eva Air"
           case lufthansa = "Deutsche Lufthansa AG"
           case thai = "Thai Airways"
           case japan = "Japan Airlines"
           case myanmar = "MM Airline"
           case qantas = "Qantas"
           case cathy = "Cathay Pacific"
           case airindia = "Air India"
           case united = "United Airlines"
       
       }
        
    var doneToolbar: UIToolbar?
    let pickerDataarray = PickerData.allCases
    let thePicker = UIPickerView()
    var dataString: String?
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        airlineTextField?.text = pickerDataarray[row].rawValue
        formData.airline = row
        checkForSubmit()
    }
    
    var displayDelegate: ChangeValueDelegate?
    var airlineTextField: UITextField?
    var nameTextField: UITextField?
    var tripTextField: UITextField?
    struct FormData :Codable{
        var name: String?
        var trips: Int?
        var airline: Int?
    }
    
    enum TextfiledChecker: Int {
        case name = 791
        case trip = 792
        case airline = 793
    }
    
    enum TextFieldCell: Int {
        case textFieldCell = 999
    }
    
    var formData = FormData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thePicker.delegate = self
        addSubmitButtonOnKeyboard()
        doneToolbar?.items?[1].isEnabled = false
    }

    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nsString = textField.text as NSString?
        var newString = nsString?.replacingCharacters(in: range, with: string)
        switch  TextfiledChecker.init(rawValue: textField.tag){
        case .name:
            newString = newString?.trimmingCharacters(in: .whitespaces)
            if let stringChecker = newString {
                formData.name = stringChecker
            }
        case .trip:
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")
            if let stringChecker = newString {
                let characterSet = CharacterSet(charactersIn: stringChecker)
                let  limitNumber: Int = Int(stringChecker) ?? 0
                if allowedCharacters.isSuperset(of: characterSet)  {
                    formData.trips = limitNumber
                }else {
                   checkForSubmit()
                    return false
                }
            }
        case . airline:
            return false
        default:
            print("No Available TextField")
        }
        checkForSubmit()
        return true
    }
    
    func checkForSubmit()
    {
        if !(formData.name?.isEmpty ?? true) && (formData.trips ?? -1) != -1 && (formData.airline ?? -1) != -1{
            doneToolbar?.items?[1].isEnabled = true
        } else {
            doneToolbar?.items?[1].isEnabled = false
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          return 10
      }
      
      func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
      
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return pickerDataarray[row].rawValue
        }
    
    func addSubmitButtonOnKeyboard() {
        self.doneToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        self.doneToolbar?.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(self.submitButtonAction))
        let items = [flexSpace, done]
        self.doneToolbar?.items = items
        self.doneToolbar?.sizeToFit()
    }
    
    @objc  func submitButtonAction (){
        guard let url = URL(string: "https://api.instantwebtools.net/v1/passenger") else {
                    return
                }
                
                guard let jsonData = try? JSONEncoder().encode(formData) else {
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                request.httpBody = jsonData
                let task = URLSession.shared.dataTask(with: request) { data, response, error in                    guard let data = data else {
                        return
                    }
                        self.dataString = String(data: data, encoding: .utf8)
                    self.displayDelegate?.valueChanged(dataString: self.dataString ?? "Please Enter Details")
                }
                    task.resume()
        
        if self.storyboard != nil {
            navigationController?.popViewController(animated: true)
            }
    }
    
    
}



extension FormTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FormCell", for: indexPath)
        switch indexPath.row {
        case 0:
            nameTextField = cell.contentView.viewWithTag(TextFieldCell.textFieldCell.rawValue) as? UITextField
            nameTextField?.tag = TextfiledChecker.name.rawValue
            nameTextField?.delegate = self
            nameTextField?.inputAccessoryView = doneToolbar
            nameTextField?.placeholder = "Enter Name"
        case 1:
            tripTextField = cell.contentView.viewWithTag(TextFieldCell.textFieldCell.rawValue) as? UITextField
            tripTextField?.tag = TextfiledChecker.trip.rawValue
            tripTextField?.delegate = self
            tripTextField?.inputAccessoryView = doneToolbar
            tripTextField?.placeholder = "Enter Trips"
        case 2:
            airlineTextField = cell.contentView.viewWithTag(TextFieldCell.textFieldCell.rawValue) as? UITextField
            airlineTextField?.tag = TextfiledChecker.airline.rawValue
            airlineTextField?.delegate = self
            airlineTextField?.inputView = thePicker
            airlineTextField?.inputAccessoryView = doneToolbar
            airlineTextField?.placeholder = "Qataur Airlines"
        default:
            print("No Cell")
        }
       return cell
    }
    
}
    
    
extension FormTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

