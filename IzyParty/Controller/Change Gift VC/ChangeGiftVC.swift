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

class ChangeGiftVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var ViewHeader:UIView!
    @IBOutlet var tableView:UITableView!
    @IBOutlet var viewChangeGift:UIView!
    
    @IBOutlet var acceptBtn:UIButton!
    @IBOutlet var rejectBtn:UIButton!
    @IBOutlet var acceptBtnImg:UIImageView!
    @IBOutlet var rejectBtnImg:UIImageView!
    
    @IBOutlet var lblGiftMessage:UILabel!
    
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblBack : UILabel!
    
    
    
    var eventId = ""
    var response_id = ""
    var fromNotif = false
    
    
    
    var arrGiftList = NSMutableArray()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupUI()
        self.tableView.register(UINib(nibName: "ChangeGiftCell", bundle: nil), forCellReuseIdentifier: "ChangeGiftCell")
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        API_CHECK_GIFT()
    }
    
    
    func SetupUI()
    {
        
        setGradientBackground()
     
        ViewHeader.layer.shadowColor = UIColor.black.cgColor
        ViewHeader.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        ViewHeader.layer.shadowOpacity = 0.5
        ViewHeader.layer.shadowRadius = 2.0
        ViewHeader.layer.masksToBounds = false
        
        
        acceptBtnImg.layer.cornerRadius = 5
        acceptBtnImg.clipsToBounds = true
        acceptBtn.layer.cornerRadius = 5
        acceptBtn.layer.shadowColor = UIColor.black.cgColor
        acceptBtn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        acceptBtn.layer.shadowOpacity = 0.5
        acceptBtn.layer.shadowRadius = 5.0
        acceptBtn.layer.masksToBounds = false
        
        rejectBtnImg.layer.cornerRadius = 5
        rejectBtnImg.clipsToBounds = true
        rejectBtn.layer.cornerRadius = 5
        rejectBtn.layer.shadowColor = UIColor.black.cgColor
        rejectBtn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        rejectBtn.layer.shadowOpacity = 0.5
        rejectBtn.layer.shadowRadius = 5.0
        rejectBtn.layer.masksToBounds = false

        lblTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "gifts_title") as String
        lblBack.text = appConstants.appDelegate.languageSelectedStringForKey(key: "back") as String
        acceptBtn.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "change_gift_choice") as String, for: .normal)
        rejectBtn.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "dont_change") as String, for: .normal)
        
        acceptBtn.titleLabel?.textAlignment = .center
        rejectBtn.titleLabel?.textAlignment = .center
    }
    
    func setGradientBackground() {
        let colorTop =  Utility.color(withHexString: appConstants.gradientOne)?.cgColor
        let colorBottom = Utility.color(withHexString: appConstants.gradientTwo)?.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop as Any, colorBottom as Any]
        gradientLayer.locations = [0.0, 1.0]
       // gradientLayer.frame = ViewHeader.bounds
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
    
    
    
    
    @IBAction func ChangeGiftTapped(_sender: UIButton){
        
        viewChangeGift.isHidden = true
         self.continueLoading()
        
    }
    
    
    @IBAction func DontChangeBtnTapped(_sender: UIButton){
        
        for val in self.navigationController!.viewControllers
        {
            if val is MyInvitationVC
            {
                self.navigationController?.popToViewController(val, animated: true)
            }
        }
    }
    
    
     @IBAction func giftSelectButtonTap(sender: UIButton)
     {
         let dict = self.arrGiftList[sender .tag] as! NSDictionary
        API_SELECT_GIFT(giftID: dict["_id"] as? String ?? "")
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrGiftList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dict = self.arrGiftList[indexPath.row] as! NSDictionary
        
       /* if indexPath.row % 2 == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeGiftCell2", for: indexPath) as! ChangeGiftCell2
            cell.detailLbl.text = dict["gift"] as? String
            return cell
        }
        else
        {*/
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeGiftCell", for: indexPath) as! ChangeGiftCell
            cell.detailbl.text = dict["gift"] as? String
            cell.selBtn.isSelected = dict["selected"] as! Bool
         cell.selBtn.tag = indexPath.row
        cell.selBtn.addTarget(self, action: #selector(giftSelectButtonTap(sender:)), for: .touchUpInside)
        
            return cell
        //}
        
    }
    
    
    
    func continueLoading()
    {
         viewChangeGift.isHidden = true
        if fromNotif
        {
            API_GET_RESPONSE_ID()
        }
        else
        {
            
        }
    }
    
    
    func populate()
    {
        API_GET_GIFTS_INVITEE(offset: 0)
    }
    
    
    
    
    func API_CHECK_GIFT()
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        
        
        let parameters : Parameters = ["eventId": eventId,
                                       "platform":"ios",
                                       "language": appConstants.appDelegate.getLang() == "FR" ? "french" : "english"
                                        ]
        
        print("API_CHECK_GIFT = \(URLS.CHECK_GIFT)")
        
        Alamofire.request(URLS.CHECK_GIFT, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            
            
            SVProgressHUD.dismiss()
            
         
            
            if let JSON = response.result.value
            {
                print("API_CHECK_GIFT JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        
                        if (jsonDict.allKeys as NSArray).contains("NEVER_SELECTED")
                        {
                            self.continueLoading()
                            return
                        }
                        
                        
                        if (jsonDict.allKeys as NSArray).contains("NO_GIFT")
                        {
                            self.lblGiftMessage.text =  appConstants.appDelegate.languageSelectedStringForKey(key: "no_gift_selected") as String
                        }
                        else
                        {
                            self.lblGiftMessage.text =
                                "\(appConstants.appDelegate.languageSelectedStringForKey(key: "gift_selected_title") as String) \(jsonDict["GIFT"]! as! String) \(appConstants.appDelegate.languageSelectedStringForKey(key: "change_question_gift") as String)"
                            
                        }
                        
                    }
                        
                    else
                    {
                        // Utility.alert(jsonDict?["message"] as! String, andTitle: appConstants.AppName, andController: self)
                    }
                    
                    
                    
                    
                }
                else
                {
                    Utility.alert("Something went wrong.", andTitle: appConstants.AppName, andController: self)
                }
                
            }
            
            
           
        }
    }
    
    
    func API_GET_RESPONSE_ID()
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        
        
        let parameters : Parameters = ["eventId": eventId,
                                       "platform":"ios",
                                       "language": appConstants.appDelegate.getLang() == "FR" ? "french" : "english"
                                        ]
        
        print("API_CHECK_GIFT = \(URLS.GET_RESPONSE_ID)")
        
        Alamofire.request(URLS.GET_RESPONSE_ID, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            
            
            SVProgressHUD.dismiss()
            
            
            
            if let JSON = response.result.value
            {
                print("API_CHECK_GIFT JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        
                       
                        self.response_id = jsonDict["responseId"] as! String
                        
                        self.populate()
                    }
                        
                    else
                    {
                        // Utility.alert(jsonDict?["message"] as! String, andTitle: appConstants.AppName, andController: self)
                    }
                    
                    
                    
                    
                }
                else
                {
                    Utility.alert("Something went wrong.", andTitle: appConstants.AppName, andController: self)
                }
                
            }
            
            
            
        }
    }
    
    
    
    func API_GET_GIFTS_INVITEE(offset:Int)
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        
        
        let parameters : Parameters = ["eventId": eventId,
                                       "offset":String(offset),
                                       "platform":"ios",
                                       "language": appConstants.appDelegate.getLang() == "FR" ? "french" : "english"
                                    ]
        
        print("API_GET_GIFTS_INVITEE = \(URLS.GET_GIFTS_INVITEE)")
        
        Alamofire.request(URLS.GET_GIFTS_INVITEE, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            
            self.arrGiftList.removeAllObjects()
            
            SVProgressHUD.dismiss()
            
            
            
            if let JSON = response.result.value
            {
                print("API_GET_GIFTS_INVITEE JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        
                        var emptySelected = false
                        
                        if jsonDict["giftSelected"]! is NSNull
                        {
                            emptySelected = true
                        }
                        
                        
                        if jsonDict["giftSelected"] != nil
                        {
                            if !(jsonDict["giftSelected"] is NSNull)
                            {
                            let newDict = NSMutableDictionary.init(dictionary: jsonDict["giftSelected"]  as! NSDictionary)
                            newDict.setValue(self.eventId, forKey: "eventID")
                            self.arrGiftList.add(newDict)
                            }
                        }
                        
                        
                        if offset == 0
                        {
                        let dict = NSMutableDictionary()
                        dict.setValue("", forKey: "_id")
                        dict.setValue(self.eventId, forKey: "eventID")
                        dict.setValue(appConstants.appDelegate.languageSelectedStringForKey(key: "NO_GIFT_TITLE") as String, forKey: "gift")
                            dict.setValue(emptySelected, forKey: "selected")
                             self.arrGiftList.add(dict)
                        }
                        
                        
                      
                        
                        
                        
                        if let val = jsonDict["gifts"]
                        {
                            if val is NSArray
                            {
                                for valItem in val as! NSArray
                                {
                                let newDict = NSMutableDictionary.init(dictionary: valItem as! NSDictionary)
                                newDict.setValue(self.eventId, forKey: "eventID")
                                self.arrGiftList.add(newDict)
                                }
                            }
                        }
                        
                        
                    }
                        
                    else
                    {
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
    
    
    func API_SELECT_GIFT(giftID:String)
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        
        
        let parameters : Parameters = ["eventId": eventId,
                                       "todo":giftID,
                                       "unselect" : (giftID.count > 0) ? "false" : "true",
                                       "responseId" : response_id,
                                       "platform":"ios",
                                       "language": appConstants.appDelegate.getLang() == "FR" ? "french" : "english"
        ]
        
        print("API_SELECT_GIFT = \(URLS.MARK_GIFT)")
        
        Alamofire.request(URLS.MARK_GIFT, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            
        
            
            SVProgressHUD.dismiss()
            
            
            
            if let JSON = response.result.value
            {
                print("API_SELECT_GIFT JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        
                        var isFound = false
                        for val in self.navigationController!.viewControllers
                        {
                            if val is MyInvitationVC
                            {
                                isFound = true
                                self.navigationController?.popToViewController(val, animated: true)
                                break
                            }
                        }
                        
                      if !isFound
                      {
                        appConstants.appDelegate.OpenHomeScreen()
                        }
                        
                        
                    }
                        
                    else
                    {
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
