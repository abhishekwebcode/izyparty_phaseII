//
//  ForgotVC.swift
//  IzyParty
//
//  Created by neha on 24/09/19.
//  Copyright © 2019 neha. All rights reserved.
//

import UIKit
import AccountKit
import Alamofire
import SVProgressHUD

class RegisterVC: BaseViewController,AKFViewControllerDelegate {

     @IBOutlet var Scroll : TPKeyboardAvoidingScrollView!
    
    @IBOutlet var ViewHeader : UIView!
     @IBOutlet var imgICLauncher : UIImageView!
    
    @IBOutlet var txtName : UITextField!
    @IBOutlet var txtEmail : UITextField!
    @IBOutlet var txtPass : UITextField!
    @IBOutlet var txtCnfmPass : UITextField!
    
    @IBOutlet var lblTitle : UILabel!
    
    @IBOutlet var btnSignup : UIButton!
    @IBOutlet var btnCancel : UIButton!
    
    var _accountKit: AccountKit!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SetupUI()
    }

    
    func SetupUI()
    {
        Scroll.contentSizeToFit()
       setGradientBackground()
        
        
        Utility.setTextFieldPaddingStyle(txtPass)
         Utility.setTextFieldPaddingStyle(txtCnfmPass)
          Utility.setTextFieldPaddingStyle(txtName)
         Utility.setTextFieldPaddingStyle(txtEmail)
        
        Utility.setTextFieldStyle(txtPass)
        Utility.setTextFieldStyle(txtCnfmPass)
         Utility.setTextFieldStyle(txtName)
         Utility.setTextFieldStyle(txtEmail)
        
        imgICLauncher.layer.cornerRadius = imgICLauncher.frame.size.width/2
        imgICLauncher.clipsToBounds = true
        
        ViewHeader.layer.shadowColor = UIColor.black.cgColor
        ViewHeader.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        ViewHeader.layer.shadowOpacity = 0.5
        ViewHeader.layer.shadowRadius = 2.0
        ViewHeader.layer.masksToBounds = false
        
        
       
        
        txtName.placeholder = appConstants.appDelegate.languageSelectedStringForKey(key: "name") as String
        txtEmail.placeholder = appConstants.appDelegate.languageSelectedStringForKey(key: "email_address") as String
        txtPass.placeholder = appConstants.appDelegate.languageSelectedStringForKey(key: "password") as String
        txtCnfmPass.placeholder = appConstants.appDelegate.languageSelectedStringForKey(key: "confirm_password") as String
       
        lblTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "sign_up") as String
        btnSignup.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "sign_up") as String, for: .normal)
        btnCancel.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "cancel") as String, for: .normal)
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
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }

    // MARK: - IBAction Method
    @IBAction func CancelClick(sender: AnyObject)
    {
       self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func RegisterClick(sender: AnyObject)
    {
      let windows = UIApplication.shared.windows
        if(txtName.text == "" || txtEmail.text == "" || txtPass.text == "" || txtCnfmPass.text == "")
        {
           
            windows.last?.makeToast(appConstants.appDelegate.languageSelectedStringForKey(key: "fill_all_fields") as String)
            //self.view.makeToast("Please fill all the fields correctly")
        }
        else if(!( Utility.validateEmail(with: txtEmail.text)))
        {
            windows.last?.makeToast(appConstants.appDelegate.languageSelectedStringForKey(key: "valid_Email") as String)
        }
        else if(txtPass.text != txtCnfmPass.text)
        {
            windows.last?.makeToast(appConstants.appDelegate.languageSelectedStringForKey(key: "fill_passwords_coorecy") as String)
        }
        else if(txtPass.text!.count < 8)
        {
            windows.last?.makeToast(appConstants.appDelegate.languageSelectedStringForKey(key: "PASSWORD_LENGTH") as String)
        }
        else if(!(isPasswordValid(txtPass.text!)))
        {
            windows.last?.makeToast(appConstants.appDelegate.languageSelectedStringForKey(key: "password_validation_message") as String)
        }
        else
        {
            
            
            // if _accountKit == nil {
            _accountKit = AccountKit.init(responseType: .authorizationCode)
            loginWithPhone()
            // }
        }
        
     
        
        
    }
   
    func prepareLoginViewController(loginViewController: AKFViewController) {
        loginViewController.delegate = self
        
        //Costumize the theme
        let theme:Theme = Theme.default()
        theme.headerBackgroundColor = UIColor(red: 0.325, green: 0.557, blue: 1, alpha: 1)
        theme.headerTextColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        theme.iconColor = UIColor(red: 0.325, green: 0.557, blue: 1, alpha: 1)
        theme.inputTextColor = UIColor(white: 0.4, alpha: 1.0)
        theme.statusBarStyle = .default
        theme.textColor = UIColor(white: 0.3, alpha: 1.0)
        theme.titleColor = UIColor(red: 0.247, green: 0.247, blue: 0.247, alpha: 1)
        loginViewController.setTheme(theme)
    }
    
    
    func loginWithPhone(){
        let inputState = UUID().uuidString
        let vc = (_accountKit?.viewControllerForPhoneLogin(with: nil, state: inputState))!
        vc.isSendToFacebookEnabled = true
        vc.defaultCountryCode = "FR"
        vc.whitelistedCountryCodes = ["FR","IN"]
        vc.delegate = self
        // self.prepareLoginViewController(loginViewController: vc)
        self.present(vc as UIViewController, animated: true, completion: nil)
    }
    
    
    
    func viewController(_ viewController: UIViewController & AKFViewController, didCompleteLoginWith code: String, state: String) {
        
        print("did complete login with code \(code) state \(state)")
        ApiRegister(strToken: code)

    }
   
    func viewController(_ viewController: UIViewController & AKFViewController, didCompleteLoginWith accessToken: AccessToken, state: String) {
        
        print("did complete login with access token \(accessToken.tokenString) state \(state)")

        
       // API_Register(strToken: accessToken.tokenString)
        
    }
    
    func viewController(_ viewController: UIViewController & AKFViewController, didFailWithError error: Error) {
        
       print("did fail with error = \(error)")

    }
    
   
    // MARK: - APi Method
    func ApiRegister(strToken : String)
    {
        self.showLoader()
        self.signUp(name: txtName.text!, email: txtEmail.text!, password: txtPass.text!, cnfmPass:txtCnfmPass.text!, TokenCode: strToken)
        { (result, response) in
            if result == "Success"
            {
                self.hideLoader()
                 let windows = UIApplication.shared.windows
                windows.last?.makeToast( appConstants.appDelegate.languageSelectedStringForKey(key: "successfully_register") as String)
                self.navigationController?.popViewController(animated: true)
             
            }
            else
            {
                self.hideLoader()
                /*self.showAlert(title: APPNAME, body: response[APPKEYS.responseError] as! String, singleBtn: true, completion: { (check) in
                 print("response Success");
                 })*/
                
                if appConstants.getStringSafely(strData: response[APPKEYS.responseErrorMessage]) != ""
                {
                     let windows = UIApplication.shared.windows
                     windows.last?.makeToast(appConstants.getStringSafely(strData: response[APPKEYS.responseErrorMessage]))
                }
                
              
            }
        }
        
    }
    
    
   /* func API_Register(strToken : String)
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        
        
        
       /* let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]*/
        
        
        
        let parameters : Parameters = [
            "name": txtName.text!,
            "email" : txtEmail.text!,
            "password" : txtPass.text!,
             "passwordConfirm": txtCnfmPass.text!,
             "code" : strToken
        ]
        
        print("API_Register = \(URLS.REGISTER)")
        print("API_Register param = \(parameters)")
        
        Alamofire.request(URLS.REGISTER, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            debugPrint(response)
            
            
            SVProgressHUD.dismiss()
            
            
            
            if let JSON = response.result.value
            {
                print("API_Register JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        
                        //self.fillData(dict: jsonDict)
                        
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
    }*/
    
    
}
