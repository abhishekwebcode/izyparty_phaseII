//
//  MyGiftsVC.swift
//  IzyParty
//
//  Created by iOSA on 01/10/19.
//  Copyright © 2019 iOSA. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class MyGiftsVC: UIViewController {

    @IBOutlet var acceptBtn:UIButton!
    @IBOutlet var rejectBtn:UIButton!
    @IBOutlet var acceptBtnImg:UIImageView!
    @IBOutlet var rejectBtnImg:UIImageView!
     @IBOutlet var ViewHeader:UIView!
    
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblBack : UILabel!
    
    
    
    var eventId = ""
    var response_id = ""
    var fromNotif = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        SetupUI()
    }
    

    func SetupUI()
    {
        
        
        setGradientBackground()
        
        ViewHeader.layer.shadowColor = UIColor.black.cgColor
         ViewHeader.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
         ViewHeader.layer.shadowOpacity = 0.5
         ViewHeader.layer.shadowRadius = 2.0
         ViewHeader.layer.masksToBounds = false
         
       /*  addBtn.layer.cornerRadius = 5
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
    
    
    @IBAction func backButtonTapped(_sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func moreButtonTap(sender: AnyObject)
    {
        appConstants.appDelegate.showPopup(view: self)
    }
    
    
    
    @IBAction func ChangeGiftTapped(_sender: UIButton){
        
        let objController = ChangeGiftVC()
        objController.response_id = response_id
        objController.eventId = eventId
        objController.fromNotif = fromNotif
        self.navigationController?.pushViewController(objController, animated: true)
        
    }
    
    
    @IBAction func DontChangeBtnTapped(_sender: UIButton){
        
        self.navigationController?.popViewController(animated: true)
    }
}
