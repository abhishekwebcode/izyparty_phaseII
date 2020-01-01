//
//  LoginVC.swift
//  IzyParty
//
//  Created by iOSA on 24/09/19.
//  Copyright © 2019 iOSA. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: BaseViewController {
    
    
     @IBOutlet var Scroll:TPKeyboardAvoidingScrollView!
    
     @IBOutlet var ViewNumber : UIView!
    @IBOutlet var txtPhone : UITextField!
    
    @IBOutlet var ViewPass : UIView!
     @IBOutlet var txtPass : UITextField!
    
    @IBOutlet var imgView:UIImageView!

     @IBOutlet var BtnLogin:UIButton!
      @IBOutlet var BtnCreateNewAccount:UIButton!
    
     @IBOutlet var BtnTermsConditions:UIButton!
    @IBOutlet var btnForgot:UIButton!
    @IBOutlet var lblOr:UILabel!
    
    @IBOutlet var lblSubTitle:UILabel!
    
    
    var strToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SetupUI()
        
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
               // self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
                self.strToken = result.token
            }
        }
       
    }


    func SetupUI()
    {
        Scroll.contentSizeToFit()
        
        
        
        
       /* DispatchQueue.main.async {
            let inputImage = CIImage(cgImage: (self.imgView.image?.cgImage)!)
            let filter = CIFilter(name: "CIGaussianBlur")
            filter?.setValue(inputImage, forKey: "inputImage")
            filter?.setValue(20, forKey: "inputRadius")
            let blurred = filter?.outputImage
            
            var newImageSize: CGRect = (blurred?.extent)!
            newImageSize.origin.x += (newImageSize.size.width - (self.imgView.image?.size.width)!) / 2
            newImageSize.origin.y += (newImageSize.size.height - (self.imgView.image?.size.height)!) / 2
            newImageSize.size = (self.imgView.image?.size)!
            
            let resultImage: CIImage = filter?.value(forKey: "outputImage") as! CIImage
            let context: CIContext = CIContext.init(options: nil)
            let cgimg: CGImage = context.createCGImage(resultImage, from: newImageSize)!
            let blurredImage: UIImage = UIImage.init(cgImage: cgimg)
            self.imgView.image = blurredImage
        }*/
        
        
        
        
        
        Utility.setupButtonStyle(BtnLogin)
         Utility.setupButtonStyle(BtnCreateNewAccount)
        Utility.setupViewStyle(ViewPass)
        Utility.setupViewStyle(ViewNumber)
        
        
        BtnTermsConditions.titleLabel?.textAlignment = NSTextAlignment.center
        let attributedString = NSMutableAttributedString(string: appConstants.appDelegate.languageSelectedStringForKey(key: "by_using_the_app_you_agree_with_our_terms_and_conditions") as String)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 23, length: 10))
        
        //attributedString.addAttribute(NSAttributedString.Key.underlineColor, value:UIColor.white, range:NSRange(location: 23, length: 10))
        if appConstants.appDelegate.getLang() == "FR"
        {
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value:NSUnderlineStyle.single.rawValue, range:NSRange(location: 46, length: 20))
        }
        else
        {
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value:NSUnderlineStyle.single.rawValue, range:NSRange(location: 32, length: 20))
        }
        
        
      
        
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 2 // Whatever line spacing you want in points
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
           attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 14), range: NSRange(location: 0, length: attributedString.length))
        
        
        
        // btnCreateAcc.titleLabel?.textAlignment = NSTextAlignment.center
        
        BtnTermsConditions.setAttributedTitle(attributedString, for: .normal)
        
        txtPass.placeholder = appConstants.appDelegate.languageSelectedStringForKey(key: "password") as String
        btnForgot.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "forgot_password") as String, for: .normal)
        BtnLogin.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "login") as String, for: .normal)
        lblOr.text = appConstants.appDelegate.languageSelectedStringForKey(key: "or") as String
        BtnCreateNewAccount.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "create_new_account") as String, for: .normal)
        lblSubTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "plan_share_invite") as String
        
    }
    
    // MARK: - IBAction Method
    @IBAction func LoginClick(sender: AnyObject)
    {
       // let homeObj = HomeVC()
       // self.navigationController?.pushViewController(homeObj, animated: true)
        
        if(txtPhone.text == "" || txtPass.text == "" )
        {
             let windows = UIApplication.shared.windows
            windows.last?.makeToast(appConstants.appDelegate.languageSelectedStringForKey(key: "fill_all_fields") as String)
            //self.view.makeToast("Please fill all the fields correctly")
        }
        else
        {
       ApiLogin()
        }
    }
 
    @IBAction func ForgotClick(sender: AnyObject)
    {
            let objController = ForgotVC()
            self.navigationController?.pushViewController(objController, animated: true)
        
    }
    
    @IBAction func CreateAccountClick(sender: AnyObject)
    {
        let objController = RegisterVC()
        self.navigationController?.pushViewController(objController, animated: true)
        
    }
    
    
    // MARK: - APi Method
    func ApiLogin()
    {
        self.showLoader()
        
        self.login(number: String.init(format: "+33%@", txtPhone.text!), password: txtPass.text!, fcm_token: strToken)
           // self.login(number: String.init(format: "+91%@", txtPhone.text!), password: txtPass.text!, fcm_token: "")
        { (result, response) in
            if result == "Success"
            {
                self.hideLoader()
                
                if let val = response["token"]
                {
                    appConstants.appDelegate.setToken(strValue: val as! String)
                    appConstants.appDelegate.OpenHomeScreen()
                }
                    
             
                
            }
            else
            {
                self.hideLoader()
                /*self.showAlert(title: APPNAME, body: response[APPKEYS.responseError] as! String, singleBtn: true, completion: { (check) in
                    print("response Success");
                })*/
                
                 let windows = UIApplication.shared.windows
                //windows.last?.makeToast(response[APPKEYS.responseError] as! String)
                 windows.last?.makeToast(appConstants.appDelegate.languageSelectedStringForKey(key: "login_error") as String)
            }
        }
        
    }
    
    
    
}
