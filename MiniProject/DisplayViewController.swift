
//
//  ViewController.swift
//  MiniProject
//
//  Created by Nikunjkumar Patel on 15/02/21.
//

import UIKit



class DisplayViewController: UITableViewController, ChangeValueDelegate {
   
    @IBOutlet weak var displayTableView: UITableView!
    var noOfSection: Int = 0
    enum Tag: Int{
        case imageView = 991
        case userName = 992
        case country = 993
        case slogan = 994
    }
    
    var flagBool : [Bool]?
    var userUnion: [UserData] = []
    var flag: Bool = true
    var loadingFlag = false
    var airlineElementArray: [AirlineElement] = []
    var dataString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiRequest(section: noOfSection)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.register(UINib(nibName: "HeaderFooterCell", bundle: nil), forCellReuseIdentifier: "headerFooterCell")
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if loadingFlag{
            return noOfSection
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loadingFlag{
            return 24
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if loadingFlag {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerFooterCell") as? HeaderFooterCell
            cell?.textLabel?.text = "Header" + String(section)
            return cell
        }
        return nil
    }
 
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if loadingFlag {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerFooterCell") as? HeaderFooterCell
            cell?.textLabel?.text = "Footer" + String(section)
            return cell
        }
        return nil
    }
    
    
    func getAirlineElement(indexPath: IndexPath) -> AirlineElement? {
        var airlineElement: AirlineElement?
        if let airLineElementEncoded = try? JSONEncoder().encode(            userUnion[indexPath.section].data?[indexPath.row].airline) {
                if let airline = try? JSONDecoder().decode(AirlineElement.self, from: airLineElementEncoded){
                    airlineElement = airline
                }
                if let airline = try? JSONDecoder().decode([AirlineElement].self, from: airLineElementEncoded ){
                    airlineElement = airline[0]
                    
                }
        }
        return airlineElement
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
            if section + 1 == noOfSection{
                  apiRequest(section: section + 1)
                }
        if loadingFlag {
           let cell = view as? UITableViewCell
            cell?.textLabel?.text = "Footer" + String(section)
       }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if loadingFlag {
            let airlineElement = getAirlineElement(indexPath: indexPath)
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as? CustomCell
            if let imageView =  cell?.imageLabel {
                imageView.downloaded(from: airlineElement?.logo ?? "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f1/Atkinson_Rowan.jpg/440px-Atkinson_Rowan.jpg")
            }
            if let nameLabel = cell?.nameLabel, let countryLabel = cell?.countryLabel, let sloganLabel = cell?.sloganLabel{
                nameLabel.text = userUnion[indexPath.section].data?[indexPath.row].name
                if let name = airlineElement?.name, let country = airlineElement?.country, let slogan = airlineElement?.slogan {
                    let nameText = NSMutableAttributedString.init(string: name)
                    nameText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                                                  NSAttributedString.Key.foregroundColor: UIColor.gray],
                                             range: NSMakeRange(0, nameText.length))
                    let countryText = NSMutableAttributedString.init(string: country)
                    countryText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
                                               NSAttributedString.Key.foregroundColor: UIColor.gray],
                                             range: NSMakeRange(0, countryText.length))
                    let combination = NSMutableAttributedString()
                    combination.append(nameText)
                    combination.append(countryText)
                    countryLabel.attributedText = combination
                    sloganLabel.text = slogan
                }
            }
            if let returnCell = cell {
                return returnCell
            }
        }
        else {
            let cell = Loading.createCell()
            if let returnCell = cell {
                return returnCell
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let airlineElement = getAirlineElement(indexPath: indexPath)
        let urlString = "https://"+(airlineElement?.website ??  "www.google.com")
        if let storyBoard = self.storyboard {
            let webViewController = storyBoard.instantiateViewController(identifier: "webViewController") as? WebViewController
            if let tempViewController = webViewController {
                if let navigator = navigationController {
                    tempViewController.urlString = urlString
                    navigator.pushViewController( tempViewController, animated: true)
                    }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func apiRequest(section: Int)  {
        
        if flag == true {
            let url = URL(string: "https://api.instantwebtools.net/v1/passenger?page=\(section)&size=24")
            var request: URLRequest?
            if let urlString = url {
                 request = URLRequest(url: urlString)
            }
            request?.httpMethod = "GET"
            if let requestData = request {
                let task = URLSession.shared.dataTask(with: requestData) { (data, response, error) in
                    guard let data = data else {return}
                        let jsonData = try? JSONDecoder().decode(UserData.self, from: data)
                        if let responseData = jsonData {
                            self.userUnion.append(responseData)
                            self.noOfSection = self.userUnion.count
                            if responseData.data?.count ?? 0 < 24
                            {
                                self.flag = false
                            }
                            else
                            {
                                DispatchQueue.main.async {
                                    self.loadingFlag = true
                                    self.tableView.reloadData()
                                }
                            }
                        }
                }
                task.resume()
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        if let storyBoard = self.storyboard {
            let addViewController = storyBoard.instantiateViewController(identifier: "formViewController") as? FormTableViewController
            if let tempViewController = addViewController {
                if let navigator = navigationController {
                    tempViewController.displayDelegate = self
                    navigator.pushViewController( tempViewController, animated: true)
                    
                }
            }
        }
    }
    
    func showToast(controller: UIViewController, messgae: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: messgae, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.2
        alert.view.layer.cornerRadius = 15
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds){
            alert.dismiss(animated: true)
        }
    }
    
    func valueChanged(dataString: String) {
        self.dataString = dataString
        showToast(controller: self, messgae: dataString, seconds: 0.5)
    }
    
   
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}






