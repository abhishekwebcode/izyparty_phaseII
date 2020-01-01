//
//  ManagePartyVC.swift
//  IzyParty
//
//  Created by iOSA on 26/09/19.
//  Copyright © 2019 iOSA. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import MessageUI

class ManagePartyVC: UIViewController
, MFMessageComposeViewControllerDelegate{
    @IBOutlet var ViewHeader : UIView! 
    @IBOutlet var chngEventDetailView:UIView!
    @IBOutlet var seeGuestView:UIView!
    @IBOutlet var viewAttendeesView:UIView!
    @IBOutlet var RemindUnreponsiveView:UIView!
    @IBOutlet var addAttendeesView:UIView!
    @IBOutlet var DeleteEventView:UIView!
 
    @IBOutlet var chngEventDetailBtn:UIButton!
    @IBOutlet var seeGuestBtn:UIButton!
    @IBOutlet var viewAttendeesBtn:UIButton!
    @IBOutlet var RemindUnreponsiveBtn:UIButton!
    @IBOutlet var addAttendeesBtn:UIButton!
    @IBOutlet var DeleteEventBtn:UIButton!
    
    var EventID = ""
    
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblBack : UILabel!
    
    @IBOutlet var lblChngEventDetailTitle:UILabel!
    @IBOutlet var lblSeeGuestTitle:UILabel!
    @IBOutlet var lblViewAttendeesTitle:UILabel!
    @IBOutlet var lblRemindUnreponsiveTitle:UILabel!
    @IBOutlet var lblAddAttendeesTitle:UILabel!
    @IBOutlet var lblDeleteEventTitle:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupUI()
    }
    
    
    func SetupUI()
    {
        
        setGradientBackground()
        

        btnCornerRadius(btn: chngEventDetailBtn)
        btnCornerRadius(btn: seeGuestBtn)
        btnCornerRadius(btn: viewAttendeesBtn)
        btnCornerRadius(btn: RemindUnreponsiveBtn)
        btnCornerRadius(btn: addAttendeesBtn)
        btnCornerRadius(btn: DeleteEventBtn)
        
        viewCornerShadow(viewShadow: chngEventDetailView)
        viewCornerShadow(viewShadow: seeGuestView)
        viewCornerShadow(viewShadow: viewAttendeesView)
        viewCornerShadow(viewShadow: RemindUnreponsiveView)
        viewCornerShadow(viewShadow: addAttendeesView)
        viewCornerShadow(viewShadow: DeleteEventView)
        
        ViewHeader.layer.shadowColor = UIColor.black.cgColor
        ViewHeader.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        ViewHeader.layer.shadowOpacity = 0.5
        ViewHeader.layer.shadowRadius = 2.0
        ViewHeader.layer.masksToBounds = false
        
      
      lblTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "events_option_title") as String
      lblBack.text = appConstants.appDelegate.languageSelectedStringForKey(key: "back") as String
      
      lblChngEventDetailTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "change_event_details") as String
      lblSeeGuestTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "view_responses") as String
      lblViewAttendeesTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "view_attendees") as String
      lblRemindUnreponsiveTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "Resend_notifi") as String
      lblAddAttendeesTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "add_attendees") as String
      lblDeleteEventTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "delete_event") as String
    }
    
    func setGradientBackground() {
        let colorTop =  Utility.color(withHexString: appConstants.gradientOne)?.cgColor
        let colorBottom = Utility.color(withHexString: appConstants.gradientTwo)?.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop as Any, colorBottom as Any]
        gradientLayer.locations = [0.0, 1.0]
        //gradientLayer.frame = ViewHeader.bounds
         gradientLayer.frame =   CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:ViewHeader.frame.size.height )
        
        
        ViewHeader.layer.insertSublayer(gradientLayer, at:0)
        
    }
    
    func btnCornerRadius(btn:UIButton){
        
        btn.layer.cornerRadius = 13
        btn.clipsToBounds = true
    }
    
    func viewCornerShadow(viewShadow:UIView){
        
        viewShadow.layer.cornerRadius = 13
        viewShadow.layer.shadowColor = UIColor.black.cgColor
        viewShadow.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        viewShadow.layer.shadowOpacity = 0.5
        viewShadow.layer.shadowRadius = 5.0
        viewShadow.layer.masksToBounds = false
    }
    
    
    
    func openSMS_Composer(dict:NSDictionary)  {
        
        if dict["send_sms"] as! Bool
        {
            let strSMS_Datas = dict["send_sms_datas"] as! String
            let arrSMS_Data = strSMS_Datas.components(separatedBy: ";")
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                
                controller.body = "\(appConstants.appDelegate.languageSelectedStringForKey(key: "sms_start_text") as String) \(dict["sms_invite_link"] as! String)"
                controller.recipients = arrSMS_Data
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }
        }
        else
        {
        
        Utility.alert( appConstants.appDelegate.languageSelectedStringForKey(key: "NOTFI") as String , andTitle: appConstants.AppName, andController: self)
        }
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func backButtonTapped(_sender: UIButton)
    {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func ChangeEventDetailsButtonTapped(_sender: UIButton)
    {
        let objEdit = AddNewPartyVC()
        objEdit.isEdit = true
        objEdit.EventID = EventID
        self.navigationController?.pushViewController(objEdit, animated: true)
        
    }
    
    
    @IBAction func ViewAttendeesDetailsButtonTapped(_sender: UIButton)
    {
        let objAttendees = ViewAttendeesVC()
        
        objAttendees.EventID = EventID
        self.navigationController?.pushViewController(objAttendees, animated: true)
        
    }
    
    @IBAction func RemindUnresponsiveGuestButtonTapped(_sender: UIButton)
    {
        API_Remind_UneresponsiveGuest(strEventID: EventID)
        
    }
    
    
    @IBAction func SeeGuestButtonTapped(_sender: UIButton)
    {
        let objGuest = SeeGuestVC()
        objGuest.EventID = EventID
        self.navigationController?.pushViewController(objGuest, animated: true)
        
    }
    
    
    @IBAction func DeleteEventButtonTapped(_sender: UIButton)
    {
        
        API_Delete_Event(strEventID: EventID)
        
    }
    
    @IBAction func AddAttendeesButtonTapped(_sender: UIButton)
    {
       let objAddAtt = AddAttendeesVC()
        objAddAtt.EventID = EventID
        self.navigationController?.pushViewController(objAddAtt, animated: true)
        
    }
    
    
    @IBAction func moreButtonTap(sender: AnyObject)
    {
        appConstants.appDelegate.showPopup(view: self)
    }
    
    
   
   /* func API_Remind_UneresponsiveGuest(strEventID:String)
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: "Please wait")
        
        
        
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        
        
        let parameters : Parameters = ["eventId": strEventID]
        
        print("API_Remind_UneresponsiveGuest = \(URLS.RESEND_NOTIFICATIONS)")
        
       /* Alamofire.request(URLS.RESEND_NOTIFICATIONS, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            
            
            SVProgressHUD.dismiss()
            
            
           
            
            if let JSON = response.result.value
            {
                print("API_Remind_UneresponsiveGuest JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        
                       
                        
                        
                        
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
    */
    
        
        
        Alamofire.upload(multipartFormData:{ multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        },
                         usingThreshold:UInt64.init(),
                         to:URLS.RESEND_NOTIFICATIONS,
                         method:.post,
                         headers:["Authorization": "auth_token"],
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    debugPrint(response)
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                            }
        })
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            
           /* // ProfilePic
            if self.imgData != nil
            {
                let filename = String.init(format: "%@.jpg", Utility.getTimeStamp())
                
                multipartFormData.append(self.imgData! as Data, withName: "ProfilePic", fileName: filename, mimeType: "image/jpg")
            }
            */
            
            
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
            
        }, to:URLS.RESEND_NOTIFICATIONS,
           method:.post,
           headers:header)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
               /* upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                    
                    
                    let str =  String.init(format: "%.2f%%", Progress.fractionCompleted * 100) // for progess in precentage
                    
                    //  hud?.progress = Float(str)!
                    hud?.labelText = str
                    
                    
                })
                */
                
                upload.responseJSON { response in
                    //self.delegate?.showSuccessAlert()
                    print(response.request!)  // original URL request
                    if response.response == nil
                    {
                        Utility.alert("Error form server respone", andTitle: appConstants.AppName, andController: self)
                        
                        //hud?.hide(true)
                        
                        return
                    }
                    
                    print(response.response!) // URL response
                    print(response.data!)     // server data
                    print(response.result)   // result of response serialization
                    //                        self.showSuccesAlert()
                    //self.removeImage("frame", fileExtension: "txt")
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        
                        // MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                        
                       // hud?.hide(true)
                        
                        let jsonDict = JSON as? NSDictionary
                        
                        if(jsonDict?["success"]! as! Int == 1)
                        {
                            // Utility.alert(jsonDict?["message"] as! String, andTitle: appConstants.AppName, andController: self)
                            
                           // self.API_GetUserDetail()
                            
                        }
                            
                        else
                        {
                            Utility.alert(jsonDict?["message"] as! String, andTitle: appConstants.AppName, andController: self)
                        }
                    }
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError)
                // MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                //hud?.hide(true)
                
            }
        }
        
         }*/
    
    
    func API_Remind_UneresponsiveGuest(strEventID:String)
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
        
        print("API_Remind_UneresponsiveGuest = \(URLS.RESEND_NOTIFICATIONS)")
        
        Alamofire.request(URLS.RESEND_NOTIFICATIONS, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            SVProgressHUD.dismiss()
            if let JSON = response.result.value
            {
                print("API_Remind_UneresponsiveGuest JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        self.openSMS_Composer(dict: jsonDict)
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
    
    
    
    
    
    func API_Delete_Event(strEventID:String)
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
        
        print("API_Delete_Event = \(URLS.RESEND_NOTIFICATIONS)")
        
        Alamofire.request(URLS.DELETE_EVENT, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            SVProgressHUD.dismiss()
            if let JSON = response.result.value
            {
                print("API_Delete_Event JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        self.navigationController?.popToRootViewController(animated: true)
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
    
    
    
    
}
