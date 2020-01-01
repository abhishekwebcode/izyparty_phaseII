//
//  MyProfileVC.swift
//  IzyParty
//
//  Created by iOSA on 26/09/19.
//  Copyright © 2019 iOSA. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class MyProfileVC: UIViewController {

    @IBOutlet var ViewHeader : UIView!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblBack : UILabel!
    
    
    @IBOutlet var lblMyName : UILabel!
    @IBOutlet var lblMyEmail : UILabel!
    
    @IBOutlet var txtName : UITextField!
    @IBOutlet var txtEmail : UITextField!
   
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupUI()
        API_GetProfile()
    }
    
    
    func SetupUI()
    {
       
        setGradientBackground()
        
        
        
        Utility.setTextFieldPaddingStyle(txtName)
        Utility.setTextFieldPaddingStyle(txtEmail)
        
   
        Utility.setTextFieldStyle(txtName)
        Utility.setTextFieldStyle(txtEmail)
        
        lblTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "my_profile") as String
        lblBack.text = appConstants.appDelegate.languageSelectedStringForKey(key: "back") as String
        
        
        lblMyName.text = appConstants.appDelegate.languageSelectedStringForKey(key: "my_name") as String
        lblMyEmail.text = appConstants.appDelegate.languageSelectedStringForKey(key: "my_email") as String
        
        
        
       
        
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
      /*  gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = ViewHeader.bounds*/
         gradientLayer.frame =   CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:ViewHeader.frame.size.height )
     
        
        
        ViewHeader.layer.insertSublayer(gradientLayer, at:0)
        
    }
    
    
    
    func fillData(dictUserInfo : NSDictionary)
    {
        txtName.text = dictUserInfo["name"] as? String
        txtEmail.text = dictUserInfo["email"] as? String
    }
    
    
    @IBAction func moreButtonTap(sender: AnyObject)
    {
        appConstants.appDelegate.showPopup(view: self)
    }
    
    @IBAction func backButtonTapped(_sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
    func API_GetProfile()
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        let parameters : Parameters = [: ]
        
        print("API_GetProfile = \(URLS.GET_PROFILE)")
        
        Alamofire.request(URLS.GET_PROFILE, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            SVProgressHUD.dismiss()
            if let JSON = response.result.value
            {
                print("API_GetProfile JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        if let val = jsonDict["data"]
                        {
                            if val is NSDictionary
                            {
                                self.fillData(dictUserInfo: val as! NSDictionary)
                            }
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
}
