//
//  ChangePassVC.swift
//  IzyParty
//
//  Created by iOSA on 26/09/19.
//  Copyright © 2019 iOSA. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class ChangePassVC: UIViewController {

    @IBOutlet var Scroll : TPKeyboardAvoidingScrollView!
    
    @IBOutlet var ViewHeader : UIView!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblBack : UILabel!
    
    
    @IBOutlet var txtExistingPass : UITextField!
    @IBOutlet var txtnewPass : UITextField!
    @IBOutlet var txtCnfmPass : UITextField!
    
    @IBOutlet var cancelBtn:UIButton!
    @IBOutlet var updateBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupUI()
    }
    
    
    func SetupUI()
    {
        Scroll.contentSizeToFit()
        setGradientBackground()
        
        lblTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "change_password") as String
        lblBack.text = appConstants.appDelegate.languageSelectedStringForKey(key: "back") as String
         txtExistingPass.placeholder = appConstants.appDelegate.languageSelectedStringForKey(key: "enter_existing_password") as String
         txtnewPass.placeholder = appConstants.appDelegate.languageSelectedStringForKey(key: "Enter_new_password") as String
         txtCnfmPass.placeholder = appConstants.appDelegate.languageSelectedStringForKey(key: "confirm_password") as String
        
          cancelBtn.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "cancel") as String, for: .normal)
        
          updateBtn.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "update") as String, for: .normal)
        
        
        Utility.setTextFieldPaddingStyle(txtnewPass)
        Utility.setTextFieldPaddingStyle(txtCnfmPass)
        Utility.setTextFieldPaddingStyle(txtExistingPass)
        
        Utility.setTextFieldStyle(txtnewPass)
        Utility.setTextFieldStyle(txtCnfmPass)
        Utility.setTextFieldStyle(txtExistingPass)
   
        ViewHeader.layer.shadowColor = UIColor.black.cgColor
        ViewHeader.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        ViewHeader.layer.shadowOpacity = 0.5
        ViewHeader.layer.shadowRadius = 2.0
        ViewHeader.layer.masksToBounds = false
    }
    
    func setGradientBackground() {
        let colorTop =  Utility.color(withHexString: appConstants.gradientOne)?.cgColor
        let colorBottom = Utility.color(withHexString: appConstants.gradientTwo)?.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop as Any, colorBottom as Any]
     /*   gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = ViewHeader.bounds*/
         gradientLayer.frame =   CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:ViewHeader.frame.size.height )
        
        ViewHeader.layer.insertSublayer(gradientLayer, at:0)
    }
    
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    
    @IBAction func CancelClick(sender: AnyObject)
    {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
    @IBAction func moreButtonTap(sender: AnyObject)
    {
        appConstants.appDelegate.showPopup(view: self)
    }
    
    
    
    
    @IBAction func UpdateBtnTapped(sender: AnyObject)
    {
        
     /*   let vc = ManagePartyVC()
        self.navigationController?.pushViewController(vc, animated: true)*/
        
        let windows = UIApplication.shared.windows
        
        if txtExistingPass.text == "" ||  txtnewPass.text == "" || txtCnfmPass.text == ""
        {
            Utility.alert("Please fill out all the fileds", andTitle: appConstants.AppName, andController: self)
        }
        else if(txtnewPass.text != txtCnfmPass.text)
        {
            windows.last?.makeToast("Your new and confirm password are not same")
        }
        else if(txtnewPass.text!.count < 8)
        {
            windows.last?.makeToast("Your password must be 8 characters long")
        }
        else if(!(isPasswordValid(txtnewPass.text!)))
        {
            windows.last?.makeToast("Your password must have atleast 1 uppercase letter and 1 special character and 1 number")
        }
        else
        {
            API_ChangePassword()
        }
        
        
        
    }
    
    
    func API_ChangePassword()
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        let parameters : Parameters = [
                                "existing": txtExistingPass.text!,
                                "new" : txtnewPass.text!,
                                "confirm" : txtCnfmPass.text!
                            ]
        
        print("API_ChangePassword = \(URLS.CHANGE_PASSWORD)")
        
        Alamofire.request(URLS.CHANGE_PASSWORD, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            SVProgressHUD.dismiss()
            if let JSON = response.result.value
            {
                print("API_ChangePassword JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        self.txtCnfmPass.text = ""
                        self.txtnewPass.text = ""
                        self.txtExistingPass.text = ""
                        
                        let windows = UIApplication.shared.windows
                        windows.last?.makeToast("Password Updated")
                        
                    }
                    else
                    {
                        let windows = UIApplication.shared.windows
                        windows.last?.makeToast("You entered password is wrong")
                    }
                    
                }
                    
                        
                    else
                    {
                          let windows = UIApplication.shared.windows
                        windows.last?.makeToast("You entered password is wrong")
                        
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
