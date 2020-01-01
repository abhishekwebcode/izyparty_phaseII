//
//  PartyOverviewVC.swift
//  IzyParty
//
//  Created by iOSA on 25/09/19.
//  Copyright © 2019 iOSA. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class PartyOverviewVC: UIViewController {

    @IBOutlet var ViewHeader:UIView!
    @IBOutlet var mainView:UIView!
    @IBOutlet var goingView:UIView!
    @IBOutlet var notGoingView:UIView!
    @IBOutlet var notRespView:UIView!
    @IBOutlet var actionBtn:UIButton!
    @IBOutlet var goingImg:UIImageView!
    @IBOutlet var notgoingImg:UIImageView!
    @IBOutlet var notRespoImg:UIImageView!
    
    @IBOutlet var lblTime:UILabel!
    @IBOutlet var lblDate:UILabel!
    @IBOutlet var lblInvites:UILabel!
    @IBOutlet var lblGoing:UILabel!
    @IBOutlet var lblNotGoing:UILabel!
    @IBOutlet var lblNotResponded:UILabel!
    
    @IBOutlet var lblGoingTitle:UILabel!
    @IBOutlet var lblNotGoingTitle:UILabel!
    @IBOutlet var lblNotRespondedTitle:UILabel!
    
    
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblBack : UILabel!
    
    
    var EventID = ""
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SetupUI()
        
        API_GetEvent_OverView(strEventID: EventID)
    }

    func SetupUI()
    {
        
        setGradientBackground()
        setGradientHeaderBackground()
        
        goingImg.layer.cornerRadius = 10
        goingImg.clipsToBounds = true
        goingView.layer.cornerRadius = 10
        goingView.layer.shadowColor = UIColor.black.cgColor
        goingView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        goingView.layer.shadowOpacity = 0.5
        goingView.layer.shadowRadius = 5.0
        goingView.layer.masksToBounds = false
        
        notgoingImg.layer.cornerRadius = 10
        notgoingImg.clipsToBounds = true
        notGoingView.layer.cornerRadius = 10
        notGoingView.layer.shadowColor = UIColor.black.cgColor
        notGoingView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        notGoingView.layer.shadowOpacity = 0.5
        notGoingView.layer.shadowRadius = 5.0
        notGoingView.layer.masksToBounds = false
        
        notRespoImg.layer.cornerRadius = 10
        notRespoImg.clipsToBounds = true
        notRespView.layer.cornerRadius = 10
        notRespView.layer.shadowColor = UIColor.black.cgColor
        notRespView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        notRespView.layer.shadowOpacity = 0.5
        notRespView.layer.shadowRadius = 5.0
        notRespView.layer.masksToBounds = false
        
        actionBtn.layer.shadowColor = UIColor.black.cgColor
        actionBtn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        actionBtn.layer.shadowOpacity = 0.5
        actionBtn.layer.shadowRadius = 2.0
        actionBtn.layer.masksToBounds = false
       
        ViewHeader.layer.shadowColor = UIColor.black.cgColor
        ViewHeader.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        ViewHeader.layer.shadowOpacity = 0.5
        ViewHeader.layer.shadowRadius = 2.0
        ViewHeader.layer.masksToBounds = false
     
        lblGoingTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "going_title") as String
        lblNotGoingTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "Notgoing_title") as String
        lblNotRespondedTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "unknown_title") as String
        lblTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "party_overview") as String
        lblBack.text = appConstants.appDelegate.languageSelectedStringForKey(key: "back") as String
        actionBtn.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "action") as String, for: .normal)
        
    }
    
    func setGradientBackground() {
        let colorTop =  Utility.color(withHexString: appConstants.gradientOne)?.cgColor
        let colorBottom = Utility.color(withHexString: appConstants.gradientTwo)?.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop as Any, colorBottom as Any]
        gradientLayer.locations = [0.0, 1.0]
        //gradientLayer.frame = mainView.bounds
        gradientLayer.frame = UIScreen.main.bounds
        
        mainView.layer.insertSublayer(gradientLayer, at:0)
        
    }
    func setGradientHeaderBackground() {
        let colorTop =  Utility.color(withHexString: appConstants.gradientOne)?.cgColor
        let colorBottom = Utility.color(withHexString: appConstants.gradientTwo)?.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop as Any, colorBottom as Any]
        gradientLayer.locations = [0.0, 1.0]
        //gradientLayer.frame = ViewHeader.bounds
        gradientLayer.frame =   CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:ViewHeader.frame.size.height )
        
        ViewHeader.layer.insertSublayer(gradientLayer, at:0)
        
    }
    
    
    
    func fillData(dict: NSDictionary)
    {
        
        lblTime.text = "00:00"
        lblDate.text = "00/00/0000"
        lblInvites.text = "0 " + appConstants.appDelegate.languageSelectedStringForKey(key: "invites") as String
        lblGoing.text = "0"
        lblNotGoing.text = "0"
        lblNotResponded.text = "0"
        if  dict["success"]! as! Bool
        {
            
            if let val = dict["time"]
            {
                lblTime.text = val as? String
            }
            
            
            if let val = dict["date"]
            {
                lblDate.text =   appConstants.Convert_yyyy_MM_ddTHH_mm_ss_SSSZ_To_DD_MM_YYYY(strDate: (val as? String)!)
            }
            
            
            if let val = dict["totalInvited"]
            {
                let  invites = appConstants.appDelegate.languageSelectedStringForKey(key: "invites") as String
                lblInvites.text =  ((val as? NSNumber)!.intValue > 1) ? "\((val as? NSNumber)!) \(invites)" : "\((val as? NSNumber)!) \(invites)"
            }
            
            
            if let val = dict["going"]
            {
                lblGoing.text = (val as? NSNumber)?.stringValue
            }
            
            if let val = dict["notGoing"]
            {
                lblNotGoing.text = (val as? NSNumber)?.stringValue
            }
            
            
            
            let valnotGoint = dict["notGoing"]
             let valGoint = dict["going"]
             let val = dict["totalInvited"]
            
            
            let NotRespn = (val as! Int) - ((valGoint as! Int) + (valnotGoint as! Int))
            
           
            lblNotResponded.text = String(NotRespn)
            
             //lblNotResponded.text = "0"
        }
       
    }
    
    
    
    
    @IBAction func moreButtonTap(sender: AnyObject)
    {
        appConstants.appDelegate.showPopup(view: self)
    }
    
    
    @IBAction func backButtonTapped(_sender: UIButton)
    {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionButtonTapped(_sender: UIButton)
    {
        
        let objManageParty = ManagePartyVC()
        objManageParty.EventID = EventID
        self.navigationController?.pushViewController(objManageParty, animated: true)
    }
    
    
    func API_GetEvent_OverView(strEventID:String)
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        
        
        let parameters : Parameters = [
            "eventId": strEventID,
            "platform":"ios",
            "language": appConstants.appDelegate.getLang() == "FR" ? "french" : "english"
        ]
        
        print("API_GetEvent_OverView = \(URLS.EVENT_LIST)")
        
        Alamofire.request(URLS.EVENT_OVERVIEW, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            
            
            SVProgressHUD.dismiss()
            
           
            
            if let JSON = response.result.value
            {
                print("API_GetEvent_OverView JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        
                       self.fillData(dict: jsonDict)
                        
                    }
                        
                    else
                    {
                        self.fillData(dict: jsonDict)
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
