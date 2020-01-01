//
//  ParticipantsVC.swift
//  IzyParty
//
//  Created by iOSA on 30/09/19.
//  Copyright © 2019 iOSA. All rights reserved.
//


import UIKit
import Alamofire
import SVProgressHUD

class ViewAttendeesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var ViewHeader:UIView!
    @IBOutlet var tableView:UITableView!

    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblBack : UILabel!
    
    
    var arrayNames = ["Prem","New","Rajesh","Pint","Shikha"]
    var arrayPhone = ["1965656970","1546456970","194564561970","1965456970","1945541970",]
    
     var EventID = ""
    
    var dictNumbers = NSDictionary()
    var dictUsers = NSDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupUI()
        self.tableView.register(UINib(nibName: "ViewAttendeesCell", bundle: nil), forCellReuseIdentifier: "ViewAttendeesCell")
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        API_GetAttendees(strEventID: EventID)
    }
    
    
    func SetupUI()
    {
        
        setGradientBackground()
    
        
        ViewHeader.layer.shadowColor = UIColor.black.cgColor
        ViewHeader.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        ViewHeader.layer.shadowOpacity = 0.5
        ViewHeader.layer.shadowRadius = 2.0
        ViewHeader.layer.masksToBounds = false
        
        
        lblTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "participants") as String
        lblBack.text = appConstants.appDelegate.languageSelectedStringForKey(key: "back") as String
        
        
    }
    
    func setGradientBackground() {
        let colorTop =  Utility.color(withHexString: appConstants.gradientOne)?.cgColor
        let colorBottom = Utility.color(withHexString: appConstants.gradientTwo)?.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop as Any, colorBottom as Any]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame =   CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:ViewHeader.frame.size.height )
        
        ViewHeader.layer.insertSublayer(gradientLayer, at:0)
        
    }
    
    @IBAction func backButtonTapped(_sender: UIButton)
    {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func moreButtonTap(sender: AnyObject)
    {
        appConstants.appDelegate.showPopup(view: self)
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return 2
        
    }
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let viewContainer = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        viewContainer.backgroundColor = UIColor.clear
        
        let lblTitle = UILabel.init(frame: CGRect.init(x: 10, y: 10, width: UIScreen.main.bounds.width-20, height: 20))
        lblTitle.textColor = UIColor.white
        lblTitle.textAlignment = .center
        if section == 0
        {
            lblTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "registeredUsers") as String
            
        }
        else
        {
            lblTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "nonAppPhoneNumbers") as String
        }
        viewContainer.addSubview(lblTitle)
        
        return viewContainer
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0
        {
            if dictUsers.allKeys.count == 0
            {
                return 0
            }
            return 40
        }
            
        else
        {
            if dictNumbers.allKeys.count == 0
            {
                return 0
            }
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return dictUsers.allKeys.count
        }
        else
        {
            return dictNumbers.allKeys.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewAttendeesCell", for: indexPath) as! ViewAttendeesCell
        //cell.nameLbl.text = self.arrayNames[indexPath.row]
        //cell.phoneLbl.text = self.arrayPhone[indexPath.row]
        if indexPath.section == 0
        {
        let arrNames = (dictUsers.allKeys as AnyObject as! [String]).sorted()
        cell.nameLbl.text = arrNames[indexPath.row]
        cell.phoneLbl.text = (dictUsers.value(forKey: arrNames[indexPath.row]) as! String)
        }
        else
        {
            let arrNames = (dictNumbers.allKeys as AnyObject as! [String]).sorted()
            cell.nameLbl.text = arrNames[indexPath.row]
            cell.phoneLbl.text = (dictNumbers.value(forKey: arrNames[indexPath.row]) as! String)
        }
        
        return cell
    }
    
    
    
    func API_GetAttendees(strEventID:String)
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        
        
        let parameters : Parameters = ["eventId": strEventID,
                                       "platform":"ios",
                                       "language": appConstants.appDelegate.getLang() == "FR" ? "french" : "english"
                                       ]
        
        print("API_GetAttendees = \(URLS.GET_ATTENDEES)")
        
        Alamofire.request(URLS.GET_ATTENDEES, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            
            
            SVProgressHUD.dismiss()
            
            
            self.dictNumbers = NSDictionary()
            self.dictUsers = NSDictionary()
            
            if let JSON = response.result.value
            {
                print("API_GetAttendees JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        
                       // self.fillData(dict: jsonDict)
                        if let val = jsonDict["data"]
                        {
                            let dictData = val as! NSDictionary
                            
                            if dictData["numbers"] != nil
                            {
                                self.dictNumbers = dictData["numbers"] as! NSDictionary
                            }
                            if dictData["users"] != nil
                            {
                                self.dictUsers = dictData["users"] as! NSDictionary
                            }
                        }
                        
                        
                        
                    }
                        
                    else
                    {
                       // self.fillData(dict: jsonDict)
                        // Utility.alert(jsonDict?["message"] as! String, andTitle: appConstants.AppName, andController: self)
                    }
                    
                    
                    
                    
                }
                else
                {
                    
                    Utility.alert("Something went wrong.", andTitle: appConstants.AppName, andController: self)
                }
                
            }
            
            
            self.tableView.reloadData()
        }
    }
}
