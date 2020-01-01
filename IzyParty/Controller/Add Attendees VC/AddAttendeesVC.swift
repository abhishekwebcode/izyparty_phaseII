//
//  ParticipantsVC.swift
//  IzyParty
//
//  Created by iOSA on 30/09/19.
//  Copyright © 2019 iOSA. All rights reserved.
//

import UIKit
import ContactsUI
import Alamofire
import SVProgressHUD
import MessageUI


class AddAttendeesVC: UIViewController,UITableViewDelegate,UITableViewDataSource, CNContactPickerDelegate, MFMessageComposeViewControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var ViewHeader:UIView!
    @IBOutlet var mainPopView:UIView!
    @IBOutlet var popUpView:UIView!
    @IBOutlet var tableView:UITableView!
    @IBOutlet var txtName:UITextField!
    @IBOutlet var txtNumber:UITextField!
    @IBOutlet var addBtn:UIButton!
    @IBOutlet var cancelBtn:UIButton!
    @IBOutlet var addEventBtn:UIButton!
    @IBOutlet var addEventBtn1:UIButton!
    @IBOutlet var validateBtn:UIButton!
    @IBOutlet var addEventImg:UIImageView!
    @IBOutlet var addEventImg1:UIImageView!
    @IBOutlet var validateImg:UIImageView!
    @IBOutlet var lblHeadingText:UILabel!
    
    var deletePlanetIndexPath: NSIndexPath? = nil
    
    
    var arrayNames = [String]()
    var arrayPhone = [String]()
    
    var EventID = ""
    
    var dictEvent:NSDictionary? = nil
    
    var isFromAddEvent = false
    
    
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblBack : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupUI()
        self.tableView.register(UINib(nibName: "AddAttendeesCell", bundle: nil), forCellReuseIdentifier: "AddAttendeesCell")
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
       
        validateBtn.titleLabel?.textAlignment = .center
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
        
        addEventImg.layer.cornerRadius = 5
        addEventImg.clipsToBounds = true
        addEventBtn.layer.cornerRadius = 5
        addEventBtn.layer.shadowColor = UIColor.black.cgColor
        addEventBtn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        addEventBtn.layer.shadowOpacity = 0.5
        addEventBtn.layer.shadowRadius = 5.0
        addEventBtn.layer.masksToBounds = false
        
        
        addEventImg1.layer.cornerRadius = 5
        addEventImg1.clipsToBounds = true
        addEventBtn1.layer.cornerRadius = 5
        addEventBtn1.layer.shadowColor = UIColor.black.cgColor
        addEventBtn1.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        addEventBtn1.layer.shadowOpacity = 0.5
        addEventBtn1.layer.shadowRadius = 5.0
        addEventBtn1.layer.masksToBounds = false
        
        
        validateImg.layer.cornerRadius = 5
        validateImg.clipsToBounds = true
        validateBtn.layer.cornerRadius = 5
        validateBtn.layer.shadowColor = UIColor.black.cgColor
        validateBtn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        validateBtn.layer.shadowOpacity = 0.5
        validateBtn.layer.shadowRadius = 5.0
        validateBtn.layer.masksToBounds = false
        
        
        
        
        popUpView.layer.cornerRadius = 5
        popUpView.clipsToBounds = true
        
        lblTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "participants") as String
        lblBack.text = appConstants.appDelegate.languageSelectedStringForKey(key: "back") as String
        
        
        addEventBtn.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "add_attendees") as String, for: .normal)
          addEventBtn1.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "add_attendees") as String, for: .normal)
        
        validateBtn.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "validate_the_event") as String, for: .normal)
        
        addEventBtn.titleLabel?.textAlignment = .center
        addEventBtn1.titleLabel?.textAlignment = .center
        validateBtn.titleLabel?.textAlignment = .center
        
        lblHeadingText.text = appConstants.appDelegate.languageSelectedStringForKey(key: "add_phone_email") as String
        txtName.placeholder = appConstants.appDelegate.languageSelectedStringForKey(key: "name") as String
        txtNumber.placeholder = appConstants.appDelegate.languageSelectedStringForKey(key: "number") as String
        addBtn.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "add") as String, for: .normal)
        cancelBtn.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "cancel") as String, for: .normal)
        
        txtName.delegate = self
        txtNumber.delegate = self
    }
    
    
    
    
    func setGradientBackground() {
        let colorTop =  Utility.color(withHexString: appConstants.gradientOne)?.cgColor
        let colorBottom = Utility.color(withHexString: appConstants.gradientTwo)?.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop as Any, colorBottom as Any]
        gradientLayer.locations = [0.0, 1.0]
       // gradientLayer.frame = ViewHeader.bounds
        gradientLayer.frame =   CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:ViewHeader.frame.size.height )
        
        ViewHeader.layer.insertSublayer(gradientLayer, at:0)
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       if textField == txtNumber
       {
        let maxLength = 10
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        }
        else
       {
        return true
        }
    }
    
    @IBAction func backButtonTapped(_sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func moreButtonTap(sender: AnyObject)
    {
        appConstants.appDelegate.showPopup(view: self)
    }
    
    
    
    @IBAction func addButtonTapped(_sender: UIButton){
        
        if(txtName.text == "" || txtNumber.text == "" )
        {
            let windows = UIApplication.shared.windows
            windows.last?.makeToast(appConstants.appDelegate.languageSelectedStringForKey(key: "fill_all_fields") as String)
            //self.view.makeToast("Please fill all the fields correctly")
            return
        }
        
        
        if txtNumber.text!.count > 10
        {
            let windows = UIApplication.shared.windows
            windows.last?.makeToast(appConstants.appDelegate.languageSelectedStringForKey(key: "valid_phone") as String)
            //self.view.makeToast("Please fill all the fields correctly")
            return
        }
        
        arrayNames.append(txtName.text!)
        arrayPhone.append(txtNumber.text!)
        tableView.reloadData()
       
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.5, animations: {
             self.mainPopView.alpha =  0.0
        }) { (Bool) in
            self.txtName.text  = ""
            self.txtNumber.text  = ""
        }
        
        
    }
    @IBAction func cancelButtonTapped(_sender: UIButton){
       self.view.endEditing(true)
       /* UIView.animate(withDuration: 1) {
            self.mainPopView.alpha =  0.0
        }*/
        UIView.animate(withDuration: 0.5, animations: {
            self.mainPopView.alpha =  0.0
        }) { (Bool) in
            self.txtName.text  = ""
            self.txtNumber.text  = ""
        }
    }
    @IBAction func addEventButtonTapped(_sender: UIButton){
       
        /*UIView.animate(withDuration: 1) {
            self.mainPopView.alpha =  1.0
        }*/
        
        let alert = UIAlertController(title: appConstants.appDelegate.languageSelectedStringForKey(key: "add_contacts") as String, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: appConstants.appDelegate.languageSelectedStringForKey(key: "phonebook") as String, style: .default, handler: { action in
            print("Yay! You brought your towel!")
            
            let contactPicker = CNContactPickerViewController()
            contactPicker.delegate = self
            contactPicker.displayedPropertyKeys =
                [CNContactGivenNameKey
                    , CNContactPhoneNumbersKey]
            self.present(contactPicker, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: appConstants.appDelegate.languageSelectedStringForKey(key: "custom_numbers") as String, style: .default, handler: { action in
            print("Yay! You brought your towel!")
            UIView.animate(withDuration: 0.5) {
                self.mainPopView.alpha =  1.0
            }
        }))
        
        alert.addAction(UIAlertAction(title: appConstants.appDelegate.languageSelectedStringForKey(key: "cancel") as String, style: .destructive, handler: { action in
            print("Yay! You brought your towel!")
            
        }))
        
        
       
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        
        self.present(alert, animated: true)
    }
    
    
    
     @IBAction func validateEventButtonTapped(_sender: UIButton)
     {
        if isFromAddEvent
        {
            API_AddEvent()
        }
        else
        {
        if arrayNames.count > 0
        {
            API_UpdateContacts(strEventID: EventID)
        }
        }
    }
    
    
    
    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contactProperty: CNContactProperty) {
        
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        // You can fetch selected name and number in the following way
        
        // user name
        let userName:String = contact.givenName
        
        // user phone number
        let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
        let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
        
        
        // user phone number string
        let primaryPhoneNumberStr:String = firstPhoneNumber.value(forKey: "digits") as! String
        print(userName)
        print(primaryPhoneNumberStr)
        
        arrayNames.append(userName)
        arrayPhone.append(primaryPhoneNumberStr)
         tableView.reloadData()
        
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
    }
    
    
    
    
    func openSMS_Composer(dict:NSDictionary)  {
        
        if dict["send_sms"] as! Bool
        {
            let strSMS_Datas = dict["send_sms_datas"] as! String
            let arrSMS_Data = strSMS_Datas.components(separatedBy: ";")
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.body = "\(appConstants.appDelegate.languageSelectedStringForKey(key: "sms_start_text") as String) \(dict["sms_invite_link"] as! String)"
                controller.recipients = arrSMS_Data
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }
        }
        else
        {
            
            Utility.alert("Re-notified guests successfully", andTitle: appConstants.AppName, andController: self)
        }
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arrayNames.count == 0
        {
            if isFromAddEvent
            {
               validateBtn.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "add_participants_later") as String, for: .normal)
                addEventBtn1.isHidden = false
                validateBtn.isHidden = false
                addEventBtn.isHidden = true
                
                addEventImg1.isHidden = false
                validateImg.isHidden = false
                addEventImg.isHidden = true
            }
           else
            {
               
            addEventBtn1.isHidden = true
            validateBtn.isHidden = true
            addEventBtn.isHidden = false
            
            addEventImg1.isHidden = true
            validateImg.isHidden = true
            addEventImg.isHidden = false
            }
            
        }
        else
        {
             validateBtn.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "validate_the_event") as String, for: .normal)
            
          
            addEventBtn1.isHidden = false
            validateBtn.isHidden = false
            addEventBtn.isHidden = true
            
            addEventImg1.isHidden = false
            validateImg.isHidden = false
            addEventImg.isHidden = true
        }
        
        return arrayNames.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddAttendeesCell", for: indexPath) as! AddAttendeesCell
        cell.nameLbl.text = self.arrayNames[indexPath.row]
        cell.phoneLbl.text = self.arrayPhone[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            arrayNames.remove(at: indexPath.row)
            arrayPhone.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    
    func getNamesSerialised() -> NSMutableDictionary
    {
        let parameters  = NSMutableDictionary()
        
        for index in 0..<arrayPhone.count
        {
            parameters.setValue(arrayPhone[index], forKey: arrayNames[index])
            
        }
        return parameters
    }
    
    
    func API_UpdateContacts(strEventID:String)
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        print(appConstants.ConvertJsonArrayToJsonString(DictData: arrayPhone))
            print( appConstants.ConvertJsonDictionayToJsonString(DictData: getNamesSerialised()))
        
        let parameters : Parameters = [
            "eventId": strEventID,
            "data":  appConstants.ConvertJsonArrayToJsonString(DictData: arrayPhone) ,
            "names":  appConstants.ConvertJsonDictionayToJsonString(DictData: getNamesSerialised()),
            "platform":"ios",
            "language": appConstants.appDelegate.getLang() == "FR" ? "french" : "english"
        ]
        
        
        print("API_UpdateContacts = \(URLS.UPDATE_EVENT_CONTATCS)")
        
        Alamofire.request(URLS.UPDATE_EVENT_CONTATCS, method: .post, parameters: parameters,  encoding: JSONEncoding.default , headers:header).responseJSON { response in
            debugPrint(response)
            
            
            SVProgressHUD.dismiss()
            
            
            
            if let JSON = response.result.value
            {
                print("API_UpdateContacts JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        
                        //self.fillData(dict: jsonDict)
                         self.openSMS_Composer(dict: jsonDict)
                        
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
    }
    
    
    func API_AddEvent()
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        print(appConstants.ConvertJsonArrayToJsonString(DictData: arrayPhone))
        print( appConstants.ConvertJsonDictionayToJsonString(DictData: getNamesSerialised()))
        
        let parameters : Parameters = [
            "event": appConstants.ConvertJsonDictionayToJsonString(DictData: NSMutableDictionary.init(dictionary: dictEvent!) ),
            "data":  appConstants.ConvertJsonArrayToJsonString(DictData: arrayPhone) ,
            "names":  appConstants.ConvertJsonDictionayToJsonString(DictData: getNamesSerialised()),
            "platform":"ios",
            "language": appConstants.appDelegate.getLang() == "FR" ? "french" : "english"
        ]
        
        
        print("API_AddEvent = \(URLS.ADD_EVENT)")
        
        Alamofire.request(URLS.ADD_EVENT, method: .post, parameters: parameters,  encoding: JSONEncoding.default , headers:header).responseJSON { response in
            debugPrint(response)
            
            
            SVProgressHUD.dismiss()
            
            
            
            if let JSON = response.result.value
            {
                print("API_AddEvent JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        
                        if (jsonDict["send_sms"]! as! Bool) &&  (jsonDict["send_sms_datas"]! as! String != "")
                        {
                            self.openSMS_Composer(dict: jsonDict)
                            
                        }
                        else
                        {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        //self.fillData(dict: jsonDict)
                        //self.openSMS_Composer(dict: jsonDict)
                       // self.navigationController?.popToRootViewController(animated: true)
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
    }
    
}
