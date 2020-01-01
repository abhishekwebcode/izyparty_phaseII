//
//  InvitationVC.swift
//  IzyParty
//
//  Created by iOSA on 30/09/19.
//  Copyright © 2019 iOSA. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class InvitationVC: UIViewController {
    
    @IBOutlet var scroller:TPKeyboardAvoidingScrollView!
    @IBOutlet var acceptBtn:UIButton!
    @IBOutlet var rejectBtn:UIButton!
    @IBOutlet var acceptBtnImg:UIImageView!
    @IBOutlet var rejectBtnImg:UIImageView!
     @IBOutlet var ViewHeader:UIView!
    
    
    @IBOutlet var btnResponse:UIButton!
     @IBOutlet var lblChildName:UILabel!
    @IBOutlet var lblDate:UILabel!
    @IBOutlet var lblTimeStart:UILabel!
    @IBOutlet var lblTimeEnd:UILabel!
    @IBOutlet var lblVenue:UILabel!
    
    
    @IBOutlet var lblTitle : UILabel!
    
    @IBOutlet var lblPartyDetailTitle : UILabel!
    @IBOutlet var lblStartTimeTitle : UILabel!
    @IBOutlet var lblEndTimeTitle : UILabel!
    @IBOutlet var lblVenueTitle : UILabel!
    
     var InvitationID = ""
    
     var strOwnName = ""

    override func viewDidLoad() {
        super.viewDidLoad()

    
        SetupUI()
        
        API_GetInvite_Info(strInviteID: InvitationID)
    }
    
    
    
    func SetupUI()
    {
        
        
        
        
     /*   ViewHeader.layer.shadowColor = UIColor.black.cgColor
        ViewHeader.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        ViewHeader.layer.shadowOpacity = 0.5
        ViewHeader.layer.shadowRadius = 2.0
        ViewHeader.layer.masksToBounds = false
        
        addBtn.layer.cornerRadius = 5
        addBtn.clipsToBounds = true
        cancelBtn.layer.cornerRadius = 5
        cancelBtn.clipsToBounds = true*/
        
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
        
         setGradientBackground()
        
        
        ViewHeader.layer.shadowColor = UIColor.black.cgColor
        ViewHeader.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        ViewHeader.layer.shadowOpacity = 0.5
        ViewHeader.layer.shadowRadius = 2.0
        ViewHeader.layer.masksToBounds = false
        
        btnResponse.titleLabel?.textAlignment = .center
      
       lblTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "rsvp_card") as String
       lblPartyDetailTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "date") as String
       lblStartTimeTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "time_start") as String
       lblEndTimeTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "time_end") as String
       lblVenueTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "venue") as String
        acceptBtn.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "accept_and_rsvp") as String, for: .normal)
        rejectBtn.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "reject") as String, for: .normal)
        
        acceptBtn.titleLabel?.textAlignment = .center
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
    
    
    
    
    
    
    func fillData(dict: NSDictionary)
    {
        
        lblChildName.text = "\(dict["childName"] as? String ?? "") \(appConstants.appDelegate.languageSelectedStringForKey(key: "has_invited_you") as String)"
        lblDate.text = appConstants.Convert_yyyy_MM_ddTHH_mm_ss_SSSZ_To_DD_MM_YYYY(strDate: dict["date"] as! String)
        lblTimeStart.text = dict["timeStart"] as? String
        lblTimeEnd.text = dict["timeEnd"] as? String
        
        
        let strAddress = NSMutableString()
        
        if let val = dict["street"]
        {
            if val is String
            {
                strAddress.append((val as? String)!)
            }
        }
        
        
        if let val = dict["city"]
        {
            if val is String
            {
                if strAddress.length > 0 && (val as! String).count > 0
                {
                     strAddress.append("\n")
                }
                strAddress.append((val as? String)!)
            }
        }
        
        if let val = dict["zipCode"]
        {
            if val is String
            {
                if strAddress.length > 0 && (val as! String).count > 0
                {
                    strAddress.append("\n")
                }
                strAddress.append((val as? String)!)
            }
        }
        
        
        if let val = dict["otherAddress"]
        {
            if val is String
            {
                if strAddress.length > 0 && (val as! String).count > 0
                {
                    strAddress.append("\n")
                }
                strAddress.append((val as? String)!)
            }
        }
        
        lblVenue.text = strAddress as String
      
        
    }
    
    
    @IBAction func backButtonTapped(_sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func respondButtonTapped(_sender: UIButton)
    {
        btnResponse.isHidden = true
    }
    
    
    @IBAction func acceptBtnTapped(_sender: UIButton){
        
        let vc = ChooseAllergiesVC()
        vc.EventID = InvitationID
        vc.strName = self.strOwnName
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func RejectBtnTapped(_sender: UIButton){
        
        API_RejectInvite()
        
    }

    
    @IBAction func moreButtonTap(sender: AnyObject)
    {
        appConstants.appDelegate.showPopup(view: self)
    }
  

    
    
    func API_GetInvite_Info(strInviteID:String)
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        
        
        let parameters : Parameters = ["eventId": strInviteID,
                                       "platform":"ios",
                                       "language": appConstants.appDelegate.getLang() == "FR" ? "french" : "english"
                                        ]
        
        print("API_GetInvite_Info = \(URLS.GET_INVITE)")
        
        Alamofire.request(URLS.GET_INVITE, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            
            
            SVProgressHUD.dismiss()
            
            
            
            if let JSON = response.result.value
            {
                print("API_GetInvite_Info JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        
                      //  self.fillData(dict: jsonDict)
                        
                        if let val = jsonDict["invite"]
                        {
                            if val is NSDictionary
                            {
                                self.fillData(dict: val as! NSDictionary)
                            }
                        }
                        
                        
                        if let val = jsonDict["owner"]
                        {
                            if val is NSDictionary
                            {
                                self.strOwnName = (val as! NSDictionary).value(forKey: "name") as! String
                            }
                        }
                        
                        
                        
                        
                        
                        if !(jsonDict["sent"] as! Bool)
                        {
                            self.btnResponse.isHidden = true
                        }
                        else
                        {
                            self.btnResponse.isHidden = false
                            
                            var initial  = ""
                            
                            if (jsonDict["intention"] as! String).uppercased() == "going".uppercased()
                            {
                                initial = appConstants.appDelegate.languageSelectedStringForKey(key: "going") as String
                            }
                            else
                            {
                              initial = appConstants.appDelegate.languageSelectedStringForKey(key: "notgoing") as String
                            }
                            
                            self.btnResponse.setTitle(initial, for: .normal)
                            
                            
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
            
            
            
        }
    }
    
    
    
    
    
    func API_RejectInvite()
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        
        
        let parameters : Parameters = [
            "eventId": InvitationID,
            "platform":"ios",
            "language": appConstants.appDelegate.getLang() == "FR" ? "french" : "english"
           
        ]
        
        
        print("API_RejectInvite = \(URLS.REJECT_INVITE)")
        
        Alamofire.request(URLS.REJECT_INVITE, method: .post, parameters: parameters,  encoding: JSONEncoding.default , headers:header).responseJSON { response in
            debugPrint(response)
            
            
            SVProgressHUD.dismiss()
            
            
            
            if let JSON = response.result.value
            {
                print("API_RejectInvite JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                       
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                        
                    else
                    {
                        //self.fillData(dict: jsonDict)
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
}
