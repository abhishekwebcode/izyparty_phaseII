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
import EventKit
import EventKitUI

class MyToDoVC: UIViewController,UITableViewDelegate,UITableViewDataSource,EKEventEditViewDelegate, UITextFieldDelegate {
    
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
   
    
    var EventID = ""
    
     var arrToDoList = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupUI()
        self.tableView.register(UINib(nibName: "MyToDoCell", bundle: nil), forCellReuseIdentifier: "MyToDoCell")
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        API_GetToDoList(offset: 0)
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
        
        lblTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "todo_title") as String
        lblBack.text = appConstants.appDelegate.languageSelectedStringForKey(key: "back") as String
        lblPopupHeading.text = appConstants.appDelegate.languageSelectedStringForKey(key: "add_todo_titel") as String
        
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
    
    @IBAction func moreButtonTap(sender: AnyObject)
    {
        appConstants.appDelegate.showPopup(view: self)
    }
    
    
    
    @IBAction func addButtonTapped(_sender: UIButton){
        
        
        if txtToDo.text == ""
        {
            Utility.alert(appConstants.appDelegate.languageSelectedStringForKey(key: "todo_add_error") as String, andTitle: appConstants.AppName, andController: self)
        }
        else if txtToDo.text != "" {
            self.view.endEditing(true)
             API_Add_ToDo()
            UIView.animate(withDuration: 0.5) {
                self.mainPopView.alpha =  0.0
            }
            
        }
        
        
    }
    @IBAction func cancelButtonTapped(_sender: UIButton){
        
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.5) {
            self.mainPopView.alpha =  0.0
        }
    }
    @IBAction func addEventButtonTapped(_sender: UIButton){
        
        UIView.animate(withDuration: 0.5) {
            self.mainPopView.alpha =  1.0
        }
    }
    
    
    
    @IBAction func backButtonTapped(_sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func Change_ToDo_Status(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        let dict = self.arrToDoList[sender.tag] as! NSDictionary
        API_Update_ToDo(status: sender.isSelected, todoID: dict["_id"] as! String)
    }
    
    
    
    @IBAction func deleteButtonTapped(_ sender: UIButton)
    {
       
        let dict = self.arrToDoList[sender.tag] as! NSDictionary
        API_Delete_ToDo(todoID: dict["_id"] as! String)
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrToDoList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyToDoCell", for: indexPath) as! MyToDoCell
        
        let dict = self.arrToDoList[indexPath.row] as! NSDictionary
        cell.LblToDo.text = dict["todo"] as? String
        cell.btnCheck.isSelected = (dict["done"] as? Bool)!
        
        cell.btnCheck.tag = indexPath.row
        cell.btnCheck.addTarget(self, action: #selector(Change_ToDo_Status), for: .touchUpInside)
        
        
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
 
        return cell
    }
    
    
    func AddCalenderPopup(strText :String) {
        let alert = UIAlertController(title: nil , message: appConstants.appDelegate.languageSelectedStringForKey(key: "add_todo_using_calendar") as String,         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: appConstants.appDelegate.languageSelectedStringForKey(key: "yes") as String, style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
            
            DispatchQueue.main.async {
            let store = EKEventStore()
            store.requestAccess(to: .event) { (granted, error) in
                
                if (granted) && (error == nil) {
            let event = EKEvent(eventStore: store)
            event.title = strText
            event.startDate = Date()
                event.endDate = Date()
                    
            
            // prompt user to add event (to whatever calendar they want)
            
            let controller = EKEventEditViewController()
            controller.event = event
            controller.eventStore = store
            controller.editViewDelegate = self
                    
            self.present(controller, animated: true)
            
            
                }
                else{
                    
                    print("failed to save event with error : \(error) or access not granted")
                }
            }
            }
            
        }))
        alert.addAction(UIAlertAction(title: appConstants.appDelegate.languageSelectedStringForKey(key: "no") as String,
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        //Sign out action
        }))
        self.present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
    
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true)
    }
    
    
    
    func API_GetToDoList(offset:Int)
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
        
        print("API_GetToDoList = \(URLS.GET_TODOS)")
        
        Alamofire.request(URLS.GET_TODOS, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            
            
            SVProgressHUD.dismiss()
            
            self.arrToDoList.removeAllObjects()
            
            if let JSON = response.result.value
            {
                print("API_GetToDoList JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        
                        if let val = jsonDict["todos"]
                        {
                            
                            
                            if val is NSArray
                            {
                                self.arrToDoList = (val as! NSArray).mutableCopy() as! NSMutableArray
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
    
    
    func API_Add_ToDo()
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
        
        print("API_Add_ToDo = \(URLS.ADD_TODO)")
        
        Alamofire.request(URLS.ADD_TODO, method: .post, parameters: parameters, headers:header).responseJSON { response in
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
                        
                        
                        self.API_GetToDoList(offset: 0)
                        self.AddCalenderPopup(strText:self.txtToDo.text!)
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
    
    
    
    func API_Update_ToDo(status:Bool, todoID:String)
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        
        
        let parameters : Parameters = ["item":EventID,
                                       "itemID" : todoID,
                                       "status" :  status ?  "true" : "false",
                                       "platform":"ios",
                                       "language": appConstants.appDelegate.getLang() == "FR" ? "french" : "english"
        ]
        
        print("API_Update_ToDo = \(URLS.UPDATE_TODO)")
        print("API_Update_ToDo param = \(parameters)")
        
        Alamofire.request(URLS.UPDATE_TODO, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            
            
            SVProgressHUD.dismiss()
            
           
            
            if let JSON = response.result.value
            {
                print("API_Update_ToDo JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        
                        
                        self.API_GetToDoList(offset: 0)
                      
                      
                        
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
    
    
    
    func API_Delete_ToDo(todoID:String)
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        
        
        let parameters : Parameters = [
                                       "todoId" : todoID,
                                       "platform":"ios",
                                       "language": appConstants.appDelegate.getLang() == "FR" ? "french" : "english"
                                        ]
        
        print("API_Delete_ToDo = \(URLS.DELETE_TODO)")
        print("API_Delete_ToDo param = \(parameters)")
        
        Alamofire.request(URLS.DELETE_TODO, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            
            
            SVProgressHUD.dismiss()
            
            
            
            if let JSON = response.result.value
            {
                print("API_Delete_ToDo JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        
                        
                        self.API_GetToDoList(offset: 0)
                        
                        
                        
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
