//
//  ForgotVC.swift
//  IzyParty
//
//  Created by neha on 24/09/19.
//  Copyright © 2019 neha. All rights reserved.
//

import UIKit
import AccountKit

class ForgotVC: BaseViewController, AKFViewControllerDelegate {

     @IBOutlet var Scroll : TPKeyboardAvoidingScrollView!
    
    @IBOutlet var ViewHeader : UIView!
     @IBOutlet var imgICLauncher : UIImageView!
    @IBOutlet var txtPass : UITextField!
    @IBOutlet var txtCnfmPass : UITextField!
    
    @IBOutlet var lblTitle : UILabel!
    
    @IBOutlet var btnContinue : UIButton!
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
        Utility.setTextFieldStyle(txtPass)
        Utility.setTextFieldStyle(txtCnfmPass)
        
        imgICLauncher.layer.cornerRadius = imgICLauncher.frame.size.width/2
        imgICLauncher.clipsToBounds = true
        
        ViewHeader.layer.shadowColor = UIColor.black.cgColor
        ViewHeader.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        ViewHeader.layer.shadowOpacity = 0.5
        ViewHeader.layer.shadowRadius = 2.0
        ViewHeader.layer.masksToBounds = false
        
        txtPass.placeholder = appConstants.appDelegate.languageSelectedStringForKey(key: "Enter_new_password") as String
        txtCnfmPass.placeholder = appConstants.appDelegate.languageSelectedStringForKey(key: "confirm_password") as String
        lblTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "forgot_password") as String
        btnContinue.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "continue2") as String, for: .normal)
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
    

    @IBAction func backButtonTapped(_sender: UIButton)
    {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func FogotClick(sender: AnyObject)
    {
         let windows = UIApplication.shared.windows
        if(txtPass.text == "" || txtCnfmPass.text == "")
        {
            windows.last?.makeToast(appConstants.appDelegate.languageSelectedStringForKey(key: "fill_all_fields") as String)
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
            windows.last?.makeToast("Your password must have atleast 1 uppercase letter and 1 special character and 1 number")
        }
        else
        {
            // if _accountKit == nil {
            _accountKit = AccountKit.init(responseType: .accessToken)
            loginWithPhone()
            // }
        }
        
    }
    
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
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
        // self.prepareLoginViewController(loginViewController: vc)
        self.present(vc as UIViewController, animated: true, completion: nil)
    }
    
    
    
    func viewController(_ viewController: UIViewController & AKFViewController, didCompleteLoginWith code: String, state: String) {
        
        print("did complete login with code \(code) state \(state)")
        
    }
    
    func viewController(_ viewController: UIViewController & AKFViewController, didCompleteLoginWith accessToken: AccessToken, state: String) {
        
        print("did complete login with access token \(accessToken.tokenString) state \(state)")
        
        
        ApiForgotPassword(strToken: accessToken.tokenString)
        
    }
    
    func viewController(_ viewController: UIViewController & AKFViewController, didFailWithError error: Error) {
        
        print("did fail with error = \(error)")
        
    }
    
    // MARK: - APi Method
    func ApiForgotPassword(strToken : String)
    {
        self.showLoader()
        self.forgotPassword(pass: txtPass.text!, TokenCode: strToken)
        { (result, response) in
            if result == "Success"
            {
                self.hideLoader()
                 let windows = UIApplication.shared.windows
                windows.last?.makeToast(appConstants.appDelegate.languageSelectedStringForKey(key: "successful_reset_password") as String)
                
            }
            else
            {
                self.hideLoader()
                /*self.showAlert(title: APPNAME, body: response[APPKEYS.responseError] as! String, singleBtn: true, completion: { (check) in
                 print("response Success");
                 })*/
                
                if appConstants.getStringSafely(strData: response[APPKEYS.responseErrorMessage]) != ""
                { let windows = UIApplication.shared.windows
                    windows.last?.makeToast(appConstants.getStringSafely(strData: response[APPKEYS.responseErrorMessage]))
                }
                
                
            }
        }
        
    }
    
    
    
}
