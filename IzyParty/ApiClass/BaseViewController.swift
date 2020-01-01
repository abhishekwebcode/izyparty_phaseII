//
//  BaseViewController.swift
//  BottleToBody
//
//  Created by EITBIZ on 28/01/19.
//  Copyright © 2019 EITBIZ. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

var APPNAME : String {
    get {
        return "lzyParty"//Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    }
}

class BaseViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
   
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
    
    func showLoader() {
        //SVProgressHUD.setForegroundColor(UIColor.darkGray);
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        let when = DispatchTime.now() + 40
        DispatchQueue.main.asyncAfter(deadline: when) {
            SVProgressHUD.dismiss()
        }
    }
    
    func hideLoader() {
        SVProgressHUD.dismiss()
    }
    
    func hideNavigationbar() {
        navigationController?.navigationBar.isHidden = true;
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false;
    }
    
    func showNavigationbar() {
        navigationController?.navigationBar.isHidden = false;
    }
    
    func showAlert(title: String?, body: String, singleBtn: Bool, completion: @escaping (Bool) -> Void) {
        
        let alert = UIAlertController(title: title, message: body, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (act) in
            completion(true);
        }))
        
        if singleBtn == false {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (act) in
                completion(false);
            }))
        }
        present(alert, animated: true, completion: nil);
    }
    
    
    //mobile, otp, app_type, fcm_id
    
    func login(number: String, password: String, fcm_token: String, completionHandler: @escaping (String, [String: Any]) -> Void) {
        let param = ["number": number, "password": password,  "iOSTOKEN": fcm_token,"platform":"ios",
                     "language": appConstants.appDelegate.getLang() == "FR" ? "french" : "english"];
        
         print("Login param = \(param)")
        
        DataManager.shared.postData(url: URLS.LOGIN_USER, sendMethod: .post, param: param) { (response) in
            
              print("Login response = \(response)")
            
            if response[APPKEYS.responseCode] as? Int == 1 {
                completionHandler("Success", response);
            } else {
                completionHandler("Fail", response);
            }
        }
    }
    

    
    func signUp(name: String, email: String, password: String, cnfmPass: String, TokenCode: String, completionHandler: @escaping (String, [String: Any]) -> Void) {
        let param = ["name": name, "email": email, "password": password,  "passwordConfirm": cnfmPass, "code" : TokenCode];
        
        print("signUp param = \(param)")
        
        DataManager.shared.postData(url: URLS.REGISTER, sendMethod: .post, param: param) { (response) in
            
            print("signUp response = \(response)")
            
            if response[APPKEYS.responseCode] as? Int == 1 {
                completionHandler("Success", response);
            } else {
                completionHandler("Fail", response);
            }
        }
    }
    

    func forgotPassword(pass: String, TokenCode: String, completionHandler: @escaping (String, [String: Any]) -> Void) {
        let param = ["password": pass, "code" : TokenCode];
        
        print("forgotPassword param = \(param)")
        
        DataManager.shared.postData(url: URLS.FORGOT_PASSWORD, sendMethod: .post, param: param) { (response) in
            
            print("forgotPassword response = \(response)")
            
            if response[APPKEYS.responseCode] as? Int == 1 {
                completionHandler("Success", response);
            } else {
                completionHandler("Fail", response);
            }
        }
    }
    
    
   
    
   
   
    
    //MARK:- UserDefault Data
    //SAVE
    func imageSave(data: Data?) {
        if data == nil {
            UserDefaults.standard.setValue(nil, forKey: UserDefaultKey.savedImage)
        } else {
            UserDefaults.standard.setValue(data, forKey: UserDefaultKey.savedImage)
        }
    }
    
    func notificationStatus(data: Data?) {
        if data == nil {
            UserDefaults.standard.setValue(nil, forKey: UserDefaultKey.notificationStatus)
        } else {
            UserDefaults.standard.setValue(data, forKey: UserDefaultKey.notificationStatus)
        }
    }
    
    func saveMembershipStatus(IsMembership: String?)
    {
        if IsMembership != nil
        {
            UserDefaults.standard.setValue(IsMembership, forKey: UserDefaultKey.savedMembership)
        }
    }
    
    
    
    func saveData(userID: String?, IsMobileVerify: String?, name: String?, phone: String?, roleID: String?, sessionID: String?) {
        
        if userID != nil {
            UserDefaults.standard.setValue(userID, forKey: UserDefaultKey.savedUserid)
        }
        
        if IsMobileVerify != nil {
            UserDefaults.standard.setValue(IsMobileVerify, forKey: UserDefaultKey.savedMobileVerify)
        }
        
        if name != nil {
            UserDefaults.standard.setValue(name, forKey: UserDefaultKey.savedName)
        }
        if phone != nil {
            UserDefaults.standard.setValue(phone, forKey: UserDefaultKey.savedPhone)
        }
        
        if roleID != nil {
            UserDefaults.standard.setValue(roleID, forKey: UserDefaultKey.savedRoleid)
        }
        
        if sessionID != nil {
            UserDefaults.standard.setValue(sessionID, forKey: UserDefaultKey.savedSessionId)
        }
    }
    
    //GET
    func getSavedData(value: defaultSavedData) -> Any? {
        
       if value == defaultSavedData.userID {
            if UserDefaults.standard.value(forKey: UserDefaultKey.savedUserid) != nil {
                return UserDefaults.standard.value(forKey: UserDefaultKey.savedUserid)
            } else {
                return nil;
            }
        }
       else if value == defaultSavedData.IsMobileVerify {
        if UserDefaults.standard.value(forKey: UserDefaultKey.savedMobileVerify) != nil {
            return UserDefaults.standard.value(forKey: UserDefaultKey.savedMobileVerify)
        } else {
            return nil;
        }
       }
        else if value == defaultSavedData.name {
            if UserDefaults.standard.value(forKey: UserDefaultKey.savedName) != nil {
                return UserDefaults.standard.value(forKey: UserDefaultKey.savedName)
            } else {
                return nil;
            }
        }
       else if value == defaultSavedData.phone {
            if UserDefaults.standard.value(forKey: UserDefaultKey.savedPhone) != nil {
                return UserDefaults.standard.value(forKey: UserDefaultKey.savedPhone)
            } else {
                return nil;
            }
       }
       else if value == defaultSavedData.roleID {
        if UserDefaults.standard.value(forKey: UserDefaultKey.savedRoleid) != nil {
            return UserDefaults.standard.value(forKey: UserDefaultKey.savedRoleid)
        } else {
            return nil;
        }
       }
       else if value == defaultSavedData.sessionID {
        if UserDefaults.standard.value(forKey: UserDefaultKey.savedSessionId) != nil {
            return UserDefaults.standard.value(forKey: UserDefaultKey.savedSessionId)
        } else {
            return nil;
        }
       }
       else if value == defaultSavedData.IsMembership {
        if UserDefaults.standard.value(forKey: UserDefaultKey.savedMembership) != nil {
            return UserDefaults.standard.value(forKey: UserDefaultKey.savedMembership)
        } else {
            return nil;
        }
       }
       else {
            return nil
        }
    }
    
    // REMOVE
    func removeSavedData() -> Bool? {
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.savedUserid);
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.savedName);
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.savedPhone);
          UserDefaults.standard.removeObject(forKey: UserDefaultKey.savedRoleid);
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.savedMobileVerify)
          UserDefaults.standard.removeObject(forKey: UserDefaultKey.savedSessionId)
         UserDefaults.standard.removeObject(forKey: UserDefaultKey.savedMembership)
        
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.savedImage)
        
        UserDefaults.standard.removeObject(forKey: "fcm_token")
        return true;
    }
}

enum defaultSavedData {
    case userID
    case name
    case phone
    case roleID
    case IsMobileVerify
     case sessionID
     case IsMembership
   
}
