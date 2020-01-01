//
//  SeeGuestVC.swift
//  IzyParty
//
//  Created by iOSA on 01/10/19.
//  Copyright © 2019 iOSA. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class SeeGuestVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var ViewHeader:UIView!
    @IBOutlet var tableView:UITableView!
    
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblBack : UILabel!
    
    var arrayNames = ["No gift for this party","yea! gitf","No gift for this party","yea! gitf",]
    
    var EventID = ""
    var isGuest = false
    
    
    var arrList = NSArray()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupUI()
        self.tableView.register(UINib(nibName: "SeeGuestCell2", bundle: nil), forCellReuseIdentifier: "SeeGuestCell2")
        self.tableView.register(UINib(nibName: "SeeGuestCell", bundle: nil), forCellReuseIdentifier: "SeeGuestCell")
        self.tableView.register(UINib(nibName: "SeeGuestCell_No_Gift", bundle: nil), forCellReuseIdentifier: "SeeGuestCell_No_Gift")
        self.tableView.register(UINib(nibName: "SeeGuestCell_isGuest", bundle: nil), forCellReuseIdentifier: "SeeGuestCell_isGuest")
        
        self.tableView.register(UINib(nibName: "SeeGuestCell2_Gift", bundle: nil), forCellReuseIdentifier: "SeeGuestCell2_Gift")
        
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        
        API_GetGuestList(strEventID: EventID)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 330
    }
    
    
    func SetupUI()
    {
        
        setGradientBackground()
        
        ViewHeader.layer.shadowColor = UIColor.black.cgColor
        ViewHeader.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        ViewHeader.layer.shadowOpacity = 0.5
        ViewHeader.layer.shadowRadius = 2.0
        ViewHeader.layer.masksToBounds = false
        
        lblTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "see_responses") as String
        lblBack.text = appConstants.appDelegate.languageSelectedStringForKey(key: "back") as String
        
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
    
    
    @IBAction func moreButtonTap(sender: AnyObject)
    {
        appConstants.appDelegate.showPopup(view: self)
    }
    
    
    @IBAction func backButtonTapped(_sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let dict = arrList[indexPath.row] as! NSDictionary
        
        if isGuest
        {
            return 150
        }
        else
        {
            
            if (dict.allKeys as NSArray).contains("isAllergy")
            {
                if dict["isAllergy"] as! String == "true"
                {
                    return UITableView.automaticDimension
                    
                }
                else  if dict["isGift"] as! Bool
                {
                    return 270
                }
                else
                {
                    return 200
                }
            }
            else
            {
                return UITableView.automaticDimension
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let dict = arrList[indexPath.row] as! NSDictionary
        
        
        if isGuest
        {
            let  cell =  tableView.dequeueReusableCell(withIdentifier: "SeeGuestCell_isGuest", for: indexPath) as! SeeGuestCell
            
            
            cell.titleLbl.text = (dict["name"] as! String)
            cell.dateLbl.text = appConstants.Convert_TimeStamp_To_DD_MMM_YYYY(timeStamp: dict["date_created"] as! NSNumber)
            
            cell.imgView.image = dict["intention"] as! Bool ? UIImage.init(named: "check") :  UIImage.init(named: "close")
            
            
            
            cell.lblPresentTitle.text =   dict["intention"] as! Bool ? appConstants.appDelegate.languageSelectedStringForKey(key: "present") as String : appConstants.appDelegate.languageSelectedStringForKey(key: "Absent") as String
            
            
            cell.selectionStyle = .none
            return cell
        }
        else
        {
            if (dict.allKeys as NSArray).contains("isAllergy")
            {
                if dict["isAllergy"] as! String == "true"
                {
                    var  cell : SeeGuestCell? = nil
                    if dict["isGift"] as! Bool
                    {
                        cell = tableView.dequeueReusableCell(withIdentifier: "SeeGuestCell", for: indexPath) as? SeeGuestCell
                        print("Cell type 1")
                        /*
                         By abhishek mathur
                         */
                        cell!.childName.text = appConstants.appDelegate.languageSelectedStringForKey(key: "childNameLabel") as String
                        cell!.childName.textAlignment = .center
                        cell!.childNameText.text = (dict["childNameAllergy"] as! String)
                        cell!.childNameText.textAlignment = .center
                        //            cell.detailbl.text = self.arrayNames[indexPath.row]
                        
                        cell!.lblGift .text = ""
                        if let val = dict["gift"]
                        {
                            if val is String
                            {
                                cell!.lblGift.text = (val as! String)
                            }
                        }
                        
                    }
                    else
                    {
                        cell = tableView.dequeueReusableCell(withIdentifier: "SeeGuestCell_No_Gift", for: indexPath) as? SeeGuestCell
                        /*
                         By abhishek mathur
                         */
                        cell!.childName.text = appConstants.appDelegate.languageSelectedStringForKey(key: "childNameLabel") as String
                        cell!.childName.textAlignment = .center
                        cell!.childNameText.text = (dict["childNameAllergy"] as! String)
                        cell!.childNameText.textAlignment = .center
                        print("Cell type 2")
                    }
                
                    
                    cell!.titleLbl.text = (dict["name"] as! String)
                    cell!.dateLbl.text = appConstants.Convert_TimeStamp_To_DD_MMM_YYYY(timeStamp: dict["date_created"] as! NSNumber)
                    
                    cell!.imgView.image = dict["intention"] as! Bool ? UIImage.init(named: "check") :  UIImage.init(named: "close")
                    
                    
                    let strAllergy = NSMutableString()
                    
                    if let val = dict["allergy1"]
                    {
                        if val is String
                        {
                            if (val as! String == "Others") || (val as! String == "Autres")
                            {
                                
                            }
                            else
                            {
                                strAllergy.append(val as! String)
                            }
                        }
                    }
                    
                    if let val = dict["allergy2"]
                    {
                        if val is String
                        {
                            if strAllergy.length > 0
                            {
                                strAllergy.append("\n")
                            }
                            // strAllergy.append(val as! String)
                            if (val as! String == "Others") || (val as! String == "Autres")
                            {
                                
                            }
                            else
                            {
                                strAllergy.append(val as! String)
                            }
                        }
                    }
                    
                    if let val = dict["allergy3"]
                    {
                        if val is String
                        {
                            if strAllergy.length > 0
                            {
                                strAllergy.append("\n")
                            }
                            strAllergy.append(val as! String)
                        }
                    }
                    
                    cell!.lblAllergies.text = strAllergy as String
                    
                    
                    if cell?.lblPresentTitle != nil
                    {
                        //cell?.lblPresentTitle.text =  appConstants.appDelegate.languageSelectedStringForKey(key: "present") as String
                        cell?.lblPresentTitle.text =   dict["intention"] as! Bool ? appConstants.appDelegate.languageSelectedStringForKey(key: "present") as String : appConstants.appDelegate.languageSelectedStringForKey(key: "Absent") as String
                    }
                    
                    if cell?.lblAllergiesTitle != nil
                    {
                        cell?.lblAllergiesTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "allergies_indicated") as String
                    }
                    
                    
                    if cell?.lblGiftTitle != nil
                    {
                        cell?.lblGiftTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "gift_selected") as String
                    }
                    
                    cell!.selectionStyle = .none
                    return cell!
                    
                }
                else  if dict["isGift"] as! Bool
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SeeGuestCell2_Gift", for: indexPath) as! SeeGuestCell2
                       print("Cell type 10")
                    /*
                     By abhishek mathur
                     */
                    cell.childName.text = appConstants.appDelegate.languageSelectedStringForKey(key: "childNameLabel") as String
                    cell.childName.textAlignment = .center
                    cell.childNameText.text = (dict["childNameAllergy"] as! String)
                    cell.childNameText.textAlignment = .center
                    
                    cell.lblGift.text = ""
                    if let val = dict["gift"]
                    {
                        if val is String
                        {
                            cell.lblGift.text = (val as! String)
                        }
                    }
                    
                    
                    cell.titleLbl.text = (dict["name"] as! String)
                    cell.dateLbl.text = appConstants.Convert_TimeStamp_To_DD_MMM_YYYY(timeStamp: dict["date_created"] as! NSNumber)
                    
                    cell.imgView.image = dict["intention"] as! Bool ? UIImage.init(named: "check") :  UIImage.init(named: "close")
                    
                    
                    
                    if cell.presentLbl != nil
                    {
                        //cell?.lblPresentTitle.text =  appConstants.appDelegate.languageSelectedStringForKey(key: "present") as String
                        cell.presentLbl.text =   dict["intention"] as! Bool ? appConstants.appDelegate.languageSelectedStringForKey(key: "present") as String : appConstants.appDelegate.languageSelectedStringForKey(key: "Absent") as String
                    }
                    
                    if cell.lblAllergiesTitle != nil
                    {
                        cell.lblAllergiesTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "no_allergies") as String
                    }
                    
                    
                    if cell.lblGiftTitle != nil
                    {
                        cell.lblGiftTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "gift_selected") as String
                    }
                    
                    cell.selectionStyle = .none
                    return cell
                }
                else
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SeeGuestCell2", for: indexPath) as! SeeGuestCell2
                    print("Cell type 3")
                    /*
                     By abhishek mathur
                     */
                    cell.childName.text = appConstants.appDelegate.languageSelectedStringForKey(key: "childNameLabel") as String
                    cell.childName.textAlignment = .center
                    cell.childNameText.text = (dict["childNameAllergy"] as! String)
                    cell.childNameText.textAlignment = .center
                    //            cell.detailLbl.text = self.arrayNames[indexPath.row]
                    
                    cell.titleLbl.text = dict["name"] as? String ?? ""
                    cell.dateLbl.text = appConstants.Convert_TimeStamp_To_DD_MMM_YYYY(timeStamp: dict["date_created"] as! NSNumber)
                    cell.imgView.image = dict["intention"] as! Bool ? UIImage.init(named: "check") :  UIImage.init(named: "close")
                    
                    
                    
                    if cell.presentLbl != nil
                    {
                        //cell.presentLbl.text =  appConstants.appDelegate.languageSelectedStringForKey(key: "present") as String
                        cell.presentLbl.text =   dict["intention"] as! Bool ? appConstants.appDelegate.languageSelectedStringForKey(key: "present") as String : appConstants.appDelegate.languageSelectedStringForKey(key: "Absent") as String
                    }
                    
                    if cell.lblAllergiesTitle != nil
                    {
                        cell.lblAllergiesTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "no_allergies") as String
                    }
                    
                    
                    
                    
                    cell.selectionStyle = .none
                    return cell
                }
            }
            else    if (dict.allKeys as NSArray).contains("isGift")
            {
                if dict["isGift"] as! Bool
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SeeGuestCell2_Gift", for: indexPath) as! SeeGuestCell2
                    print("Cell type 13")
                    /*
                     By abhishek mathur
                     */
                    cell.childName.text = appConstants.appDelegate.languageSelectedStringForKey(key: "childNameLabel") as String
                    cell.childName.textAlignment = .center
                    cell.childNameText.text = (dict["childNameAllergy"] as! String)
                    cell.childNameText.textAlignment = .center
                    
                    cell.lblGift.text = ""
                    if let val = dict["gift"]
                    {
                        if val is String
                        {
                            cell.lblGift.text = (val as! String)
                        }
                    }
                    
                    
                    cell.titleLbl.text = (dict["name"] as! String)
                    cell.dateLbl.text = appConstants.Convert_TimeStamp_To_DD_MMM_YYYY(timeStamp: dict["date_created"] as! NSNumber)
                    
                    cell.imgView.image = dict["intention"] as! Bool ? UIImage.init(named: "check") :  UIImage.init(named: "close")
                    
                    
                    
                    if cell.presentLbl != nil
                    {
                        //cell?.lblPresentTitle.text =  appConstants.appDelegate.languageSelectedStringForKey(key: "present") as String
                        cell.presentLbl.text =   dict["intention"] as! Bool ? appConstants.appDelegate.languageSelectedStringForKey(key: "present") as String : appConstants.appDelegate.languageSelectedStringForKey(key: "Absent") as String
                    }
                    
                    if cell.lblAllergiesTitle != nil
                    {
                        cell.lblAllergiesTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "no_allergies") as String
                    }
                    
                    
                    if cell.lblGiftTitle != nil
                    {
                        cell.lblGiftTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "gift_selected") as String
                    }
                    
                    cell.selectionStyle = .none
                    return cell
                }
                else
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SeeGuestCell2", for: indexPath) as! SeeGuestCell2
                    print("Cell type 456")
                    /*
                     By abhishek mathur
                     */
                    cell.childName.text = appConstants.appDelegate.languageSelectedStringForKey(key: "childNameLabel") as String
                    cell.childName.textAlignment = .center
                    cell.childNameText.text = (dict["childNameAllergy"] as! String)
                    cell.childNameText.textAlignment = .center
                    //            cell.detailLbl.text = self.arrayNames[indexPath.row]
                    
                    cell.titleLbl.text = (dict["name"] as! String)
                    cell.dateLbl.text = appConstants.Convert_TimeStamp_To_DD_MMM_YYYY(timeStamp: dict["date_created"] as! NSNumber)
                    cell.imgView.image = dict["intention"] as! Bool ? UIImage.init(named: "check") :  UIImage.init(named: "close")
                    
                    
                    if cell.presentLbl != nil
                    {
                        //cell.presentLbl.text =  appConstants.appDelegate.languageSelectedStringForKey(key: "present") as String
                        cell.presentLbl.text =   dict["intention"] as! Bool ? appConstants.appDelegate.languageSelectedStringForKey(key: "present") as String : appConstants.appDelegate.languageSelectedStringForKey(key: "Absent") as String
                    }
                    
                    if cell.lblAllergiesTitle != nil
                    {
                        cell.lblAllergiesTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "no_allergies") as String
                    }
                    
                    
                    cell.selectionStyle = .none
                    return cell
                }
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SeeGuestCell2", for: indexPath) as! SeeGuestCell2
                print("Cell type 768")
                /*
                 By abhishek mathur
                 */
                cell.childName.text = appConstants.appDelegate.languageSelectedStringForKey(key: "childNameLabel") as String
                cell.childName.textAlignment = .center
                cell.childNameText.text = (dict["childNameAllergy"] as! String)
                cell.childNameText.textAlignment = .center
                //            cell.detailLbl.text = self.arrayNames[indexPath.row]
                
                cell.titleLbl.text = (dict["name"] as! String)
                cell.dateLbl.text = appConstants.Convert_TimeStamp_To_DD_MMM_YYYY(timeStamp: dict["date_created"] as! NSNumber)
                cell.imgView.image = dict["intention"] as! Bool ? UIImage.init(named: "check") :  UIImage.init(named: "close")
                
                
                if cell.presentLbl != nil
                {
                    //cell.presentLbl.text =  appConstants.appDelegate.languageSelectedStringForKey(key: "present") as String
                    cell.presentLbl.text =   dict["intention"] as! Bool ? appConstants.appDelegate.languageSelectedStringForKey(key: "present") as String : appConstants.appDelegate.languageSelectedStringForKey(key: "Absent") as String
                }
                
                if cell.lblAllergiesTitle != nil
                {
                    cell.lblAllergiesTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "no_allergies") as String
                }
                
                
                cell.selectionStyle = .none
                return cell
            }
        }
        
    }
    
    func API_GetGuestList(strEventID:String)
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        
        
        let parameters : Parameters = ["eventId": strEventID,
                                       "isGuest": String(isGuest),
                                       "platform":"ios",
                                       "language": appConstants.appDelegate.getLang() == "FR" ? "french" : "english"
        ]
        
        print("API_GetAttendees = \(URLS.GET_RESPONSES)")
        
        Alamofire.request(URLS.GET_RESPONSES, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            
            
            SVProgressHUD.dismiss()
            
            
            
            
            if let JSON = response.result.value
            {
                print("API_GetAttendees JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        
                        /*// self.fillData(dict: jsonDict)
                         if let val = jsonDict["data"]
                         {
                         let dictData = val as! NSDictionary
                         
                         if dictData["numbers"] != nil
                         {
                         self.dictNumbers = dictData["numbers"] as! NSDictionary
                         }
                         if dictData["users"] != nil
                         {
                         self.dictUsers = dictData["users"] as! NSDictionary
                         }
                         }*/
                        
                        self.arrList = jsonDict["responses"]! as! NSArray
                        
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
            
            
            self.tableView.reloadData()
        }
    }
}
