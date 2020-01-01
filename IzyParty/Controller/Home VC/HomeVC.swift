//
//  ForgotVC.swift
//  IzyParty
//
//  Created by neha on 24/09/19.
//  Copyright © 2019 neha. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HomeVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    
    @IBOutlet var ViewHeader : UIView!
     @IBOutlet var imgICLauncher : UIImageView!
    
    @IBOutlet var eventTopView:UIView!
    @IBOutlet var eventBottomView:UIView!
    
    @IBOutlet var invitationTopView:UIView!
    @IBOutlet var invitationBottomView:UIView!
    
    @IBOutlet var toDoListTopView:UIView!
    @IBOutlet var toDoListBottomView:UIView!
    
    @IBOutlet var giftsTopView:UIView!
    @IBOutlet var giftsBottomView:UIView!
    
    
    @IBOutlet var lblEvent:UILabel!
    @IBOutlet var lblEventDesc:UILabel!
    
    @IBOutlet var lblInvitation:UILabel!
    @IBOutlet var lblInvitationDesc:UILabel!
    
    
    @IBOutlet var lblTo_Do:UILabel!
    @IBOutlet var lblTo_DoDesc:UILabel!
    
    
    @IBOutlet var lblGift:UILabel!
    @IBOutlet var lblGiftDesc:UILabel!
    
    
     @IBOutlet var lbleventCount:UILabel!
     @IBOutlet var lblinviteCount:UILabel!
     @IBOutlet var lblgiftCount:UILabel!
    
    
    var PickerSelect: UIPickerView!
    var ArrayGetList : NSArray = [appConstants.appDelegate.languageSelectedStringForKey(key: "profile") as String,
                                  appConstants.appDelegate.languageSelectedStringForKey(key: "change_password") as String, appConstants.appDelegate.languageSelectedStringForKey(key: "forgot_password") as String, appConstants.appDelegate.languageSelectedStringForKey(key: "logout") as String]
    var StrPrefix = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SetupUI()
       

    }

    override func viewWillAppear(_ animated: Bool)
    {
        if appConstants.appDelegate.strNotificationType == "NEW_INVITE"
        {
            appConstants.appDelegate.strNotificationType = ""
        let objMyInvitation = MyInvitationVC()
        self.navigationController?.pushViewController(objMyInvitation, animated: true)
        }
        
        if appConstants.appDelegate.strNotificationType == "INVITE_RESPOND"
        {
            appConstants.appDelegate.strNotificationType = ""
            let objGuest = SeeGuestVC()
            objGuest.EventID = appConstants.appDelegate.strEventID
            self.navigationController?.pushViewController(objGuest, animated: true)
            appConstants.appDelegate.strEventID = ""
        }
        
        if appConstants.appDelegate.strNotificationType == "CHANGE_EVENT"
        {
            appConstants.appDelegate.strNotificationType = ""
             let objInvite = InvitationVC()
            objInvite.InvitationID = appConstants.appDelegate.strEventID
            self.navigationController?.pushViewController(objInvite, animated: true)
            appConstants.appDelegate.strEventID = ""
        }
        
        if appConstants.appDelegate.strNotificationType == "GIFT_ADD"
        {
            appConstants.appDelegate.strNotificationType = ""
            let objController = ChangeGiftVC()
            objController.eventId = appConstants.appDelegate.strEventID
            objController.fromNotif = true
            self.navigationController?.pushViewController(objController, animated: true)
            appConstants.appDelegate.strEventID = ""
        }
        
        
        if appConstants.appDelegate.strNotificationType == "GIFT_SELECTED"
        {
            appConstants.appDelegate.strNotificationType = ""
            let objGuest = SeeGuestVC()
            objGuest.EventID = appConstants.appDelegate.strEventID
            self.navigationController?.pushViewController(objGuest, animated: true)
            appConstants.appDelegate.strEventID = ""
        }
        
        
        if appConstants.appDelegate.strNotificationType == "GIFT_DELETED"
        {
            appConstants.appDelegate.strNotificationType = ""
            let objController = ChangeGiftVC()
            objController.eventId = appConstants.appDelegate.strEventID
            objController.fromNotif = true
            self.navigationController?.pushViewController(objController, animated: true)
            appConstants.appDelegate.strEventID = ""
        }
       
        
        
         API_Badge_Overview()
    }
    
    
    func SetupUI()
    {
       setGradientBackground()
        
        setViewBotomProperty(viewBottom: giftsBottomView)
      setViewBotomProperty(viewBottom: eventBottomView)
        setViewBotomProperty(viewBottom: invitationBottomView)
        setViewBotomProperty(viewBottom: toDoListBottomView)
        
        
        setViewTopProperty(viewTop: eventTopView)
        setViewTopProperty(viewTop: invitationTopView)
        setViewTopProperty(viewTop: toDoListTopView)
        setViewTopProperty(viewTop: giftsTopView)
        
        imgICLauncher.layer.cornerRadius = imgICLauncher.frame.size.width/2
        imgICLauncher.clipsToBounds = true
        
        lbleventCount.layer.cornerRadius = lbleventCount.frame.size.width/2
        lbleventCount.clipsToBounds = true
        
        lblinviteCount.layer.cornerRadius = lblinviteCount.frame.size.width/2
        lblinviteCount.clipsToBounds = true
        
        lblgiftCount.layer.cornerRadius = lblgiftCount.frame.size.width/2
        lblgiftCount.clipsToBounds = true
        
        ViewHeader.layer.shadowColor = UIColor.black.cgColor
        ViewHeader.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        ViewHeader.layer.shadowOpacity = 0.5
        ViewHeader.layer.shadowRadius = 2.0
        ViewHeader.layer.masksToBounds = false
        
        
        lblEvent.text = appConstants.appDelegate.languageSelectedStringForKey(key: "events") as String
        lblEventDesc.text = appConstants.appDelegate.languageSelectedStringForKey(key: "manage_invites") as String
        
        
        lblInvitation.text = appConstants.appDelegate.languageSelectedStringForKey(key: "invitations") as String
        lblInvitationDesc.text = appConstants.appDelegate.languageSelectedStringForKey(key: "respond_to_hosts") as String
        
        
        lblTo_Do.text = appConstants.appDelegate.languageSelectedStringForKey(key: "to_do_list") as String
        lblTo_DoDesc.text = appConstants.appDelegate.languageSelectedStringForKey(key: "manage_time") as String
        
        
        lblGift.text = appConstants.appDelegate.languageSelectedStringForKey(key: "gifts") as String
        lblGiftDesc.text = appConstants.appDelegate.languageSelectedStringForKey(key: "never_forget_you_kids_wish") as String
        
      
        
    }
    
    func setGradientBackground() {
        let colorTop =  Utility.color(withHexString: appConstants.gradientOne)?.cgColor
        let colorBottom = Utility.color(withHexString: appConstants.gradientTwo)?.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        //gradientLayer.frame = ViewHeader.bounds
        gradientLayer.frame =   CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:ViewHeader.frame.size.height )
        
        ViewHeader.layer.insertSublayer(gradientLayer, at:0)
    }
    
    
    func setViewBotomProperty(viewBottom :UIView)
     {
        viewBottom.layer.cornerRadius = 10
        viewBottom.layer.shadowOpacity = 0.5
        viewBottom.layer.shadowRadius = 8
        viewBottom.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    func setViewTopProperty(viewTop :UIView)
    {
        viewTop.layer.cornerRadius = 10
        viewTop.clipsToBounds = true
    }

    
    //MARK: - Picker view Delegates and data sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return ArrayGetList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
            return  ArrayGetList[row] as? String
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
            StrPrefix = ArrayGetList[row] as! String
    }
    
    
    //MARK: - IBaction
    @IBAction func moreButtonTap(sender: AnyObject)
    {
        /*let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction) in
            
            
        })
        
        // defaultAction.setValue(UIColor.white, forKey: "titleTextColor")
        alertController.addAction(defaultAction)
        self.PickerSelect=UIPickerView()
        // self.PickerSelectGradeGender.frame=CGRect(x:0, y:0, width:alertController.view.frame.size.width-20, height:250)
        self.PickerSelect.frame=CGRect(x:0, y:0, width:250, height:250)
        self.PickerSelect.delegate = self
        
        alertController.view.addSubview(self.PickerSelect)
        self.present(alertController, animated: true, completion: nil)*/
        
        
        appConstants.appDelegate.showPopup(view: self)
        
    }
    
    @IBAction func ActionOpenEvents(sender: AnyObject)
    {
        let objMyEvents = MyEventVC()
        self.navigationController?.pushViewController(objMyEvents, animated: true)
    }
    
    
    @IBAction func ActionOpenInvitations(sender: AnyObject)
    {
        let objMyInvitation = MyInvitationVC()
        self.navigationController?.pushViewController(objMyInvitation, animated: true)
    }
    
    
    @IBAction func ActionOpenTodolist(sender: AnyObject)
    {
        let objMyEvents = MyEventVC()
        objMyEvents.isFrom = "ToDo"
        self.navigationController?.pushViewController(objMyEvents, animated: true)
    }
    
    @IBAction func ActionOpenGifts(sender: AnyObject)
    {
        let objMyEvents = MyEventVC()
        objMyEvents.isFrom = "MyGift"
        self.navigationController?.pushViewController(objMyEvents, animated: true)
    }
    
    
    
    
    
    
    
    func API_Badge_Overview()
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        

        
        let parameters : Parameters = ["platform":"ios",
                                       "language": appConstants.appDelegate.getLang() == "FR" ? "french" : "english"]
        
        print("API_Badge_Overview = \(URLS.BADGE_OVERVIEW)")
        
        Alamofire.request(URLS.BADGE_OVERVIEW, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            
            
            SVProgressHUD.dismiss()
            
            
            
            if let JSON = response.result.value
            {
                print("API_Badge_Overview JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        
                        if let val = jsonDict["data"]
                        {
                            if let val2 = (val as! NSDictionary)["badgesMain"]
                            {
                                if let valEvent = (val2 as! NSDictionary)["events"]
                                {
                                    
                                   if (valEvent as? NSNumber)!.intValue > 0
                                   {
                                        self.lbleventCount.alpha = 1
                                        self.lbleventCount.text = (valEvent as? NSNumber)!.stringValue
                                    }
                                   else
                                   {
                                    self.lbleventCount.alpha = 0
                                    }
                                }
                                
                                if let valGift = (val2 as! NSDictionary)["gifts"]
                                {
                                    
                                    if (valGift as? NSNumber)!.intValue > 0
                                    {
                                        self.lblgiftCount.alpha = 1
                                        self.lblgiftCount.text = (valGift as? NSNumber)!.stringValue
                                    }
                                    else
                                    {
                                        self.lblgiftCount.alpha = 0
                                    }
                                }
                                
                                if let valinvite = (val2 as! NSDictionary)["invites"]
                                {
                                    
                                    if (valinvite as? NSNumber)!.intValue > 0
                                    {
                                        self.lblinviteCount.alpha = 1
                                        self.lblinviteCount.text = (valinvite as? NSNumber)!.stringValue
                                    }
                                    else
                                    {
                                         self.lblinviteCount.alpha = 0
                                    }
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
            
            
          
        }
    }
    
}
