//
//  MyEventVC.swift
//  IzyParty
//
//  Created by iOSA on 25/09/19.
//  Copyright © 2019 iOSA. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class MyEventVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet var ViewHeader:UIView!
    @IBOutlet var tableView:UITableView!
    @IBOutlet var plusButton:UIButton!
    @IBOutlet var plusImg:UIImageView!

    
     var arrEventsList = NSMutableArray()
    
     @IBOutlet var lblNoEventMessage : UILabel!
     @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblBack : UILabel!
    
    var arrayBadgeEvent = NSMutableArray()
    
    var isFrom = ""
    
     var isAPICall = false
    var isDone = false

    override func viewDidLoad() {
        super.viewDidLoad()

        SetupUI()
        self.tableView.register(UINib(nibName: "MyEventCell", bundle: nil), forCellReuseIdentifier: "MyEventCell")
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
         isAPICall = false
         isDone = false
       
        arrEventsList.removeAllObjects()
        //tableView.reloadData()
        API_GetEventList()
    }
    
    
    
    
    func SetupUI()
    {
        
        setGradientBackground()
        
        plusImg.layer.cornerRadius = plusImg.frame.size.width/2
        plusImg.clipsToBounds = true
        plusButton.layer.cornerRadius = plusButton.frame.size.width/2
        plusButton.layer.shadowColor = UIColor.black.cgColor
        plusButton.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        plusButton.layer.shadowOpacity = 0.4
        plusButton.layer.shadowRadius = 2.0
        plusButton.layer.masksToBounds = false
        
        ViewHeader.layer.shadowColor = UIColor.black.cgColor
        ViewHeader.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        ViewHeader.layer.shadowOpacity = 0.5
        ViewHeader.layer.shadowRadius = 2.0
        ViewHeader.layer.masksToBounds = false
        
       
       
        
        
        
        lblTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "mes_v_nements") as String
        lblBack.text = appConstants.appDelegate.languageSelectedStringForKey(key: "back") as String
        lblNoEventMessage.text = appConstants.appDelegate.languageSelectedStringForKey(key: "no_events") as String
        
        if isFrom.count > 0
        {
            plusImg.isHidden = true
            plusButton.isHidden = true
            lblNoEventMessage.text = appConstants.appDelegate.languageSelectedStringForKey(key: "no_events_other") as String
        }
        
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
    
    
    @IBAction func addNewPartyButtonTapped(_sender: UIButton)
    {
        
        let objNewParty = AddNewPartyVC()
        self.navigationController?.pushViewController(objNewParty, animated: true)
    }

    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrEventsList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyEventCell", for: indexPath) as! MyEventCell
        cell.nameLbl.text = ""
        cell.dobLbl.text = ""
        
        let dict = arrEventsList[indexPath.row] as! NSDictionary
        
        if let val = dict["name"]
        {
            cell.nameLbl.text = val as? String
        }
        
        
        if let val = dict["date"]
        {
            cell.dobLbl.text = appConstants.Convert_TimeStamp_To_DD_MMM_YYYY(timeStamp: (val as? NSNumber)!)
          
        }
        
        
        if arrayBadgeEvent.count > 0
        {
            if arrayBadgeEvent.contains(dict["id"]!)
            {
                cell.countLbl.alpha = 1
            }
            else
            {
                cell.countLbl.alpha = 0
            }
            
        }
        else
        {
             cell.countLbl.alpha = 0
        }
       
        
        
        
        cell.selectionStyle = .none
       
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict = arrEventsList[indexPath.row] as! NSDictionary
        
      if isFrom.uppercased() == "Todo".uppercased()
      {
        let objController = MyToDoVC()
        objController.EventID = dict["id"] as! String
        self.navigationController?.pushViewController(objController, animated: true)
        }
        else if isFrom.uppercased() == "MyGift".uppercased()
        {
            let objController = GiftsVC()
            objController.EventID = dict["id"] as! String
            self.navigationController?.pushViewController(objController, animated: true)
        }
        else
      {
        let objPartyOver = PartyOverviewVC()
        objPartyOver.EventID = dict["id"] as! String
        self.navigationController?.pushViewController(objPartyOver, animated: true)
        }
    }
    
    
    
    //MARK: - scrollview
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.view.endEditing(true)
        
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ))
        {
            if !isAPICall && !isDone
            {
                isAPICall = true
                
               
                
                API_GetEventList()
                
            }
        }
    }
    
    
    
    
    func API_GetEventList()
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
        ]
        
        
        var parameters : Parameters = [
            "platform":"ios",
            "offset" : String(arrEventsList.count),
            "language": appConstants.appDelegate.getLang() == "FR" ? "french" : "english"
        ]
        
        
        if (isFrom.uppercased()  == "MyGift".uppercased()) ||  (isFrom.uppercased() == "Todo".uppercased())
        {
            parameters.updateValue("1", forKey: "listGifts")
        }
        
        print("API_GetEventList = \(URLS.EVENT_LIST)")
        print("Param = \(parameters)")
        
        
        Alamofire.request(URLS.EVENT_LIST, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            
            SVProgressHUD.dismiss()
            
          
           // self.arrEventsList.removeAllObjects()
           
            
            if let JSON = response.result.value
            {
                print("API_GetEventList JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        if let val = jsonDict["events"]
                        {
                            if val is NSArray
                            {
                                
                                for item in val as! NSArray
                                {
                                    self.arrEventsList.add(item)
                                }
                                
                                if (val as! NSArray).count != 10
                                {
                                    self.isDone = true
                                }
                                
                               // self.arrEventsList = (val as! NSArray).mutableCopy() as! NSMutableArray
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
            
            
            
            if self.arrEventsList.count > 0
            {
                self.lblNoEventMessage.isHidden = true
                self.tableView.isHidden = false
            }
            else
            {
                self.lblNoEventMessage.isHidden = false
                self.tableView.isHidden = true
            }
            
            self.tableView.reloadData()
            self.API_Badge_Events_List()
            
            //DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
                self.isAPICall = false
            //})
        }
    }
    
    
    
    func API_Badge_Events_List()
    {
       
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
       
        
        let parameters : Parameters = [:]
        
        var strUrl = ""
        if isFrom.uppercased() == "MyGift".uppercased()
        {
           strUrl = URLS.BADGE_GIFT
        }
        else
        {
            strUrl = URLS.BADGE_EVENT
        }

        
        print("API_Badge_Events_List = \(strUrl)")
        
        Alamofire.request(strUrl, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            
            
            SVProgressHUD.dismiss()

            
            self.arrayBadgeEvent.removeAllObjects()
            if let JSON = response.result.value
            {
                print("API_Badge_Events_List JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        
                        if let val = jsonDict["data"]
                        {
                            if self.isFrom.uppercased() == "MyGift".uppercased()
                            {
                                if let val2 = (val as! NSDictionary)["badgesGifts"]
                                {
                                    if (val2 as! NSArray).count > 0
                                    {
                                        self.arrayBadgeEvent = (val2 as! NSArray).mutableCopy() as! NSMutableArray
                                        
                                    }
                                }
                            }
                            else
                            {
                                if let val2 = (val as! NSDictionary)["badgesEvents"]
                                {
                                    if (val2 as! NSArray).count > 0
                                    {
                                        self.arrayBadgeEvent = (val2 as! NSArray).mutableCopy() as! NSMutableArray
                                        
                                    }
                                }
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
}
