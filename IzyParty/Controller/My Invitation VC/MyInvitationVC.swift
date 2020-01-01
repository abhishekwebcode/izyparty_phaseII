//
//  MyInvitationVC.swift
//  IzyParty
//
//  Created by iOSA on 26/09/19.
//  Copyright © 2019 iOSA. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class MyInvitationVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var ViewHeader:UIView!
    @IBOutlet var tableView:UITableView!
   
    var arrInvitationList = NSMutableArray()
    
   
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblBack : UILabel!
    
      var arrayBadgeInvite = NSMutableArray()
    var arrayBadgeInvitesGifts = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupUI()
        self.tableView.register(UINib(nibName: "MyInvitationCell1", bundle: nil), forCellReuseIdentifier: "MyInvitationCell1")
        self.tableView.register(UINib(nibName: "MyInvitationCell2", bundle: nil), forCellReuseIdentifier: "MyInvitationCell2")
        self.tableView.register(UINib(nibName: "MyInvitationCell1_Guest", bundle: nil), forCellReuseIdentifier: "MyInvitationCell1_Guest")
        self.tableView.register(UINib(nibName: "MyInvitationCell2_Guest", bundle: nil), forCellReuseIdentifier: "MyInvitationCell2_Guest")
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        
       // API_GetInvitationList()
        
        
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
         API_GetInvitationList()
    }
    
    
    func SetupUI()
    {
        
        setGradientBackground()
        
        ViewHeader.layer.shadowColor = UIColor.black.cgColor
        ViewHeader.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        ViewHeader.layer.shadowOpacity = 0.5
        ViewHeader.layer.shadowRadius = 2.0
        ViewHeader.layer.masksToBounds = false
        
        
        lblTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "invitation_screen_title") as String
        lblBack.text = appConstants.appDelegate.languageSelectedStringForKey(key: "back") as String
        
    }
    
    func setGradientBackground() {
        let colorTop =  Utility.color(withHexString: appConstants.gradientOne)?.cgColor
        let colorBottom = Utility.color(withHexString: appConstants.gradientTwo)?.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop as Any, colorBottom as Any]
        gradientLayer.locations = [0.0, 1.0]
        //gradientLayer.frame = ViewHeader.bounds
        gradientLayer.frame =   CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:ViewHeader.frame.size.height )
//        gradientLayer.frame = tableView.bounds
        
        ViewHeader.layer.insertSublayer(gradientLayer, at:0)
//       tableView.layer.insertSublayer(gradientLayer, at:0)
        
    }
    
    
    
    @IBAction func moreButtonTap(sender: AnyObject)
    {
        appConstants.appDelegate.showPopup(view: self)
    }
    
    
    @IBAction func backButtonTapped(_sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func selectGiftButtonTapped(_ sender: UIButton)
    {
         let dict = arrInvitationList[sender.tag] as! NSDictionary
        //let objController = MyGiftsVC()
        let objController = ChangeGiftVC()
        objController.eventId =  dict["_id"] as! String
        objController.fromNotif = true
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    
    
    @IBAction func SeeGuestTapped(_ sender: UIButton)
    {
        let dict = arrInvitationList[sender.tag] as! NSDictionary
        let objGuest = SeeGuestVC()
        objGuest.EventID = dict["_id"] as! String
        objGuest.isGuest = true
        self.navigationController?.pushViewController(objGuest, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrInvitationList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let dict = arrInvitationList[indexPath.row] as! NSDictionary
        
        if (dict.allKeys as NSArray).contains("showGiftOption")
        {
            if dict["showGiftOption"] as! Bool
            {
                if dict["guestSee"] as! Bool
                {
                    return 183
                }
                else
                {
                    return 140
                }
            }
            else
            {
                if dict["guestSee"] as! Bool
                {
                    return 140
                }
                else
                {
                    return 97
                }
               
            }
        }
        else
        {
            if dict["guestSee"] as! Bool
            {
                return 140
            }
            else
            {
                return 97
            }
        }
        
       
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
           let dict = arrInvitationList[indexPath.row] as! NSDictionary
        
        
        if (dict.allKeys as NSArray).contains("showGiftOption")
        {
            if dict["showGiftOption"] as! Bool
            {
                
                var  cell: MyInvitationCell1? = nil
                
                if dict["guestSee"] as! Bool
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: "MyInvitationCell1_Guest", for: indexPath) as? MyInvitationCell1
                    cell?.seetheGuestBtn.tag = indexPath.row
                    cell?.seetheGuestBtn.addTarget(self, action: #selector(SeeGuestTapped(_:)), for: .touchUpInside)
                }
                else
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: "MyInvitationCell1", for: indexPath) as? MyInvitationCell1
                }
                
                if appConstants.appDelegate.getLang().uppercased() == "FR".uppercased()
                {
                    cell?.nameLbl.text = "Anniversaire de \(dict["childName"] as? String ?? "")"
                }
                else
                {
                    cell?.nameLbl.text = "\(dict["childName"] as? String ?? "") BDay"
                }
                cell?.dobLbl.text = appConstants.Convert_yyyy_MM_ddTHH_mm_ss_SSSZ_To_DD_MM_YYYY(strDate: (dict["date"] as? String)!)
                
                
                cell?.selectBtn.tag = indexPath.row
                cell?.selectBtn.addTarget(self, action: #selector(selectGiftButtonTapped), for: .touchUpInside)
                
                
                if arrayBadgeInvite.count > 0
                {
                    if arrayBadgeInvite.contains(dict["_id"]!)
                    {
                        cell?.countLbl.alpha = 1
                    }
                    else
                    {
                        cell?.countLbl.alpha = 0
                    }
                    
                }
                else
                {
                    cell?.countLbl.alpha = 0
                }
                
                
                
                if cell?.giftBadgeLbl != nil
                {
                    if arrayBadgeInvitesGifts.count > 0
                    {
                        if arrayBadgeInvitesGifts.contains(dict["_id"]!)
                        {
                            cell?.giftBadgeLbl.alpha = 1
                        }
                        else
                        {
                            cell?.giftBadgeLbl.alpha = 0
                        }
                        
                    }
                    else
                    {
                        cell?.giftBadgeLbl.alpha = 0
                    }
                }
               
                
                cell?.selectionStyle = .none
                return cell!
            }
            else
            {
                
                
                
                var  cell:MyInvitationCell2? = nil
                
                if dict["guestSee"] as! Bool
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: "MyInvitationCell2_Guest", for: indexPath) as? MyInvitationCell2
                    
                    cell?.seetheGuestBtn.tag = indexPath.row
                    cell?.seetheGuestBtn.addTarget(self, action: #selector(SeeGuestTapped(_:)), for: .touchUpInside)
                }
                else
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: "MyInvitationCell2", for: indexPath) as? MyInvitationCell2
                }
               // let cell = tableView.dequeueReusableCell(withIdentifier: "MyInvitationCell2", for: indexPath) as! MyInvitationCell2
                //cell?.nameLbl.text = "\(dict["childName"] as? String ?? "") BDay"
                
                if appConstants.appDelegate.getLang().uppercased() == "FR".uppercased()
                {
                    cell?.nameLbl.text = "Anniversaire de \(dict["childName"] as? String ?? "")"
                }
                else
                {
                    cell?.nameLbl.text = "\(dict["childName"] as? String ?? "") BDay"
                }
                
                cell?.dobLbl.text = appConstants.Convert_yyyy_MM_ddTHH_mm_ss_SSSZ_To_DD_MM_YYYY(strDate: (dict["date"] as? String)!)
                
                cell?.selectionStyle = .none
                
                if arrayBadgeInvite.count > 0
                {
                    if arrayBadgeInvite.contains(dict["_id"]!)
                    {
                        cell?.countLbl.alpha = 1
                    }
                    else
                    {
                        cell?.countLbl.alpha = 0
                    }
                    
                }
                else
                {
                    cell?.countLbl.alpha = 0
                }
                
                
                if cell?.giftBadgeLbl != nil
                {
                if arrayBadgeInvitesGifts.count > 0
                {
                    if arrayBadgeInvitesGifts.contains(dict["_id"]!)
                    {
                        cell?.giftBadgeLbl.alpha = 1
                    }
                    else
                    {
                        cell?.giftBadgeLbl.alpha = 0
                    }
                    
                }
                else
                {
                    cell?.giftBadgeLbl.alpha = 0
                }
                }
                
                
                
                return cell!
            }
        }
        else
        {
            var  cell:MyInvitationCell2? = nil
            
            if dict["guestSee"] as! Bool
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "MyInvitationCell2_Guest", for: indexPath) as? MyInvitationCell2
                
                cell?.seetheGuestBtn.tag = indexPath.row
                cell?.seetheGuestBtn.addTarget(self, action: #selector(SeeGuestTapped(_:)), for: .touchUpInside)
            }
            else
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "MyInvitationCell2", for: indexPath) as? MyInvitationCell2
            }
            //let cell = tableView.dequeueReusableCell(withIdentifier: "MyInvitationCell2", for: indexPath) as! MyInvitationCell2
            //cell?.nameLbl.text = "\(dict["childName"] as? String ?? "") BDay"
            
            if appConstants.appDelegate.getLang().uppercased() == "FR".uppercased()
            {
                cell?.nameLbl.text = "Anniversaire de \(dict["childName"] as? String ?? "")"
            }
            else
            {
                cell?.nameLbl.text = "\(dict["childName"] as? String ?? "") BDay"
            }
            
            cell?.dobLbl.text = appConstants.Convert_yyyy_MM_ddTHH_mm_ss_SSSZ_To_DD_MM_YYYY(strDate: (dict["date"] as? String)!)
            
            if arrayBadgeInvite.count > 0
            {
                if arrayBadgeInvite.contains(dict["_id"]!)
                {
                    cell?.countLbl.alpha = 1
                }
                else
                {
                    cell?.countLbl.alpha = 0
                }
                
            }
            else
            {
                cell?.countLbl.alpha = 0
            }
            
            
            
            if cell?.giftBadgeLbl != nil
            {
                if arrayBadgeInvitesGifts.count > 0
                {
                    if arrayBadgeInvitesGifts.contains(dict["_id"]!)
                    {
                        cell?.giftBadgeLbl.alpha = 1
                    }
                    else
                    {
                        cell?.giftBadgeLbl.alpha = 0
                    }
                    
                }
                else
                {
                    cell?.giftBadgeLbl.alpha = 0
                }
            }
            
            
            cell?.selectionStyle = .none
            return cell!
        }
        
        
        
       
       
       
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       
        let dict = arrInvitationList[indexPath.row] as! NSDictionary
        
        let objInvite = InvitationVC()
        objInvite.InvitationID = dict["_id"] as! String
        self.navigationController?.pushViewController(objInvite, animated: true)
    }
    
    
    func API_GetInvitationList()
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        
        
        let parameters : Parameters = ["platform":"ios",
                                       "language": appConstants.appDelegate.getLang() == "FR" ? "french" : "english"
                                        ]
        
        print("API_GetEventList = \(URLS.GET_INVITES)")
        
        Alamofire.request(URLS.GET_INVITES, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            
            
            SVProgressHUD.dismiss()
            
            self.arrInvitationList.removeAllObjects()
            
            if let JSON = response.result.value
            {
                print("API_GetEventList JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        
                        if let val = jsonDict["invites"]
                        {
                            
                            
                            if val is NSArray
                            {
                                self.arrInvitationList = (val as! NSArray).mutableCopy() as! NSMutableArray
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
            
            self.API_Badge_Invites_List()

        }
    }
    
    
    
    
    func API_Badge_Invites_List()
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        
        let parameters : Parameters = [:]
        
        print("API_Badge_Invites_List = \(URLS.BADGE_INVITES)")
        
        Alamofire.request(URLS.BADGE_INVITES, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            
            SVProgressHUD.dismiss()
            
            self.arrayBadgeInvite.removeAllObjects()
            if let JSON = response.result.value
            {
                print("API_Badge_Invites_List JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        if let val = jsonDict["data"]
                        {
                            if let val2 = (val as! NSDictionary)["badgesInvites"]
                            {
                                if (val2 as! NSArray).count > 0
                                {
                                    self.arrayBadgeInvite = (val2 as! NSArray).mutableCopy() as! NSMutableArray
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
            self.API_Badge_Invites_Gift()
        }
    }
    
    
    
    func API_Badge_Invites_Gift()
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        
        let parameters : Parameters = [:]
        
        print("API_Badge_Invites_Gift = \(URLS.BADGE_INVITES_GIFT)")
        
        Alamofire.request(URLS.BADGE_INVITES_GIFT, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            
            SVProgressHUD.dismiss()
            
            self.arrayBadgeInvitesGifts.removeAllObjects()
            if let JSON = response.result.value
            {
                print("API_Badge_Invites_Gift JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        if let val = jsonDict["data"]
                        {
                            if let val2 = (val as! NSDictionary)["badgesInvitesGifts"]
                            {
                                if (val2 as! NSArray).count > 0
                                {
                                    self.arrayBadgeInvitesGifts = (val2 as! NSArray).mutableCopy() as! NSMutableArray
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
    
}
