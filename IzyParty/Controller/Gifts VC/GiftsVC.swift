//
//  MyTo-DoVC.swift
//  IzyParty
//
//  Created by iOSA on 02/10/19.
//  Copyright © 2019 iOSA. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class GiftsVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var ViewHeader:UIView!
    @IBOutlet var tableView:UITableView!
    @IBOutlet var addView:UIView!
    @IBOutlet var addImg:UIImageView!
    @IBOutlet var mainPopView:UIView!
    @IBOutlet var popUpView:UIView!
    @IBOutlet var addBtn:UIButton!
    @IBOutlet var cancelBtn:UIButton!
    @IBOutlet var txtToDo:UITextField!
    
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblBack : UILabel!
    @IBOutlet var lblPopupHeading : UILabel!
    
    
   
    
    var arrGiftsList = NSMutableArray()
    
    var EventID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupUI()
        self.tableView.register(UINib(nibName: "GiftsCell", bundle: nil), forCellReuseIdentifier: "GiftsCell")
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        API_GetGifts(offset: 0)
    }
    
    
    func SetupUI()
    {
        
        setGradientBackground()
        
        
        ViewHeader.layer.shadowColor = UIColor.black.cgColor
        ViewHeader.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        ViewHeader.layer.shadowOpacity = 0.5
        ViewHeader.layer.shadowRadius = 2.0
        ViewHeader.layer.masksToBounds = false
        
        addBtn.layer.cornerRadius = 5
        addBtn.clipsToBounds = true
        cancelBtn.layer.cornerRadius = 5
        cancelBtn.clipsToBounds = true
        
        addImg.layer.cornerRadius = addImg.frame.size.width / 2
        addImg.clipsToBounds = true
        addView.layer.cornerRadius = addView.frame.size.width / 2
        addView.layer.shadowColor = UIColor.black.cgColor
        addView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        addView.layer.shadowOpacity = 0.5
        addView.layer.shadowRadius = 5.0
        addView.layer.masksToBounds = false
        
        
        lblTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "gifts_title") as String
        lblBack.text = appConstants.appDelegate.languageSelectedStringForKey(key: "back") as String
        lblPopupHeading.text = appConstants.appDelegate.languageSelectedStringForKey(key: "add_gift") as String
        
        addBtn.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "add") as String, for: .normal)
        cancelBtn.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "cancel") as String, for: .normal)
        
        addBtn.titleLabel?.textAlignment = .center
        cancelBtn.titleLabel?.textAlignment = .center
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
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    
    
    @IBAction func addButtonTapped(_sender: UIButton){
        
        
        if txtToDo.text == ""
        {
            Utility.alert(appConstants.appDelegate.languageSelectedStringForKey(key: "gift_add_error") as String, andTitle: appConstants.AppName, andController: self)
        }
        else if txtToDo.text != "" {
            self.view.endEditing(true)
            //arrayNames.append(txtToDo.text!)
            UIView.animate(withDuration: 1) {
                self.mainPopView.alpha =  0.0
            }
            //tableView.reloadData()
            
            API_Add_Gift()
        }
        
        
    }
    @IBAction func cancelButtonTapped(_sender: UIButton){
       
        
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 1) {
            self.mainPopView.alpha =  0.0
        }
    }
    @IBAction func addEventButtonTapped(_sender: UIButton){
        txtToDo.text = ""
        UIView.animate(withDuration: 1) {
            self.mainPopView.alpha =  1.0
        }
    }
    
    
    @IBAction func moreButtonTap(sender: AnyObject)
    {
        appConstants.appDelegate.showPopup(view: self)
    }
    
    
    
    @IBAction func deleteButtonTapped(_ sender: UIButton)
    {
        
        let dict = self.arrGiftsList[sender.tag] as! NSDictionary
        API_Delete_Gift(giftID: dict["_id"] as! String)
        
    }
    
    
    
    
    @IBAction func backButtonTapped(_sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrGiftsList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GiftsCell", for: indexPath) as! GiftsCell
        
        
         let dict = self.arrGiftsList[indexPath.row] as! NSDictionary
       cell.LblToDo.text = dict["gift"] as? String
       
        cell.btnCheck.isSelected = dict["selected"] as! Bool
        
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
 
        return cell
    }
    
    
    
    
    func API_GetGifts(offset:Int)
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        
        
        let parameters : Parameters = ["eventId":EventID,
                                       "offset" : String(offset),
                                       "platform":"ios",
                                       "language": appConstants.appDelegate.getLang() == "FR" ? "french" : "english"
        ]
        
        print("API_GetGifts = \(URLS.GET_GIFTS)")
        
        Alamofire.request(URLS.GET_GIFTS, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            
            
            SVProgressHUD.dismiss()
            
            self.arrGiftsList.removeAllObjects()
            
            if let JSON = response.result.value
            {
                print("API_GetGifts JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        
                        if let val = jsonDict["gifts"]
                        {
                            
                            
                            if val is NSArray
                            {
                                self.arrGiftsList = (val as! NSArray).mutableCopy() as! NSMutableArray
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
            
            
            self.tableView.reloadData()
        }
    }
    
    
    
    
    func API_Delete_Gift(giftID:String)
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        
        
        let parameters : Parameters = [
            "giftId" : giftID,
            "platform":"ios",
            "language": appConstants.appDelegate.getLang() == "FR" ? "french" : "english"
        ]
        
        print("API_Delete_Gift = \(URLS.DELETE_GIFT)")
        print("API_Delete_Gift param = \(parameters)")
        
        Alamofire.request(URLS.DELETE_GIFT, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            
            
            SVProgressHUD.dismiss()
            
            
            
            if let JSON = response.result.value
            {
                print("API_Delete_Gift JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        
                        
                        self.API_GetGifts(offset: 0)
                        
                        
                        
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
    
    
    
    
    func API_Add_Gift()
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        
        
        let parameters : Parameters = ["eventId":EventID,
                                       "todo" : txtToDo.text!,
                                       "platform":"ios",
                                       "language": appConstants.appDelegate.getLang() == "FR" ? "french" : "english"
        ]
        
        print("API_Add_Gift = \(URLS.ADD_GIFT)")
        
        Alamofire.request(URLS.ADD_GIFT, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            
            
            SVProgressHUD.dismiss()
            
            
            
            if let JSON = response.result.value
            {
                print("API_Add_ToDo JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        
                        
                        self.API_GetGifts(offset: 0)
                       
                        self.txtToDo.text = ""
                        
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
