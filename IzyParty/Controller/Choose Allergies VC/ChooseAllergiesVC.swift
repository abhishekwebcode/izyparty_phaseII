//
//  ChooseAllergiesVC.swift
//  IzyParty
//
//  Created by iOSA on 30/09/19.
//  Copyright © 2019 iOSA. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import EventKit
import EventKitUI


class ChooseAllergiesVC: UIViewController,
    UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,
                    EKEventEditViewDelegate
{
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        print("after controller top")
        controller.dismiss(animated: true)
        afterCalendar(jsonDict: tempJSON)
    }
    
    
    @IBOutlet var scroller:TPKeyboardAvoidingScrollView!
    @IBOutlet var sendButton:UIButton!
    @IBOutlet var sendImgView:UIImageView!
    @IBOutlet var txtFoodAllergiepickUpData: UITextField!
    @IBOutlet var txtPetAllergiepickUpData: UITextField!
    @IBOutlet var switchPartyTheme:UISwitch!
    @IBOutlet var FoodView:UIView!
    @IBOutlet var PetView:UIView!
    @IBOutlet var ViewHeader:UIView!
    @IBOutlet var OthersView:UIView!
    @IBOutlet var txtViewOthers:UITextView!
    
    @IBOutlet var heightConstantFood:NSLayoutConstraint!
    @IBOutlet var heightConstantPet:NSLayoutConstraint!
    @IBOutlet var heightConstantOthers:NSLayoutConstraint!
    
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblBack : UILabel!
    @IBOutlet var lblDelightedTitle : UILabel!
    @IBOutlet var lblChildHaveTitle : UILabel!
    @IBOutlet var lblWhatKidDoesTitle : UILabel!
    @IBOutlet var lblYes_NoTitle : UILabel!
    
    @IBOutlet var childNameTextbox:UITextView!
    
    var tagValue = Int()
    
    var arrayFood = [appConstants.appDelegate.languageSelectedStringForKey(key: "No_Food_Allergy") as String,
                     appConstants.appDelegate.languageSelectedStringForKey(key: "Gluten") as String,
                     appConstants.appDelegate.languageSelectedStringForKey(key: "Egg_white") as String,
                     appConstants.appDelegate.languageSelectedStringForKey(key: "Peanut") as String ,
                     appConstants.appDelegate.languageSelectedStringForKey(key: "Cow_milk") as String ,
                     appConstants.appDelegate.languageSelectedStringForKey(key: "Fabaceae") as String,
                     appConstants.appDelegate.languageSelectedStringForKey(key: "Walnut") as String ,
                     appConstants.appDelegate.languageSelectedStringForKey(key: "Others") as String
    ]
    var arrayPet = [appConstants.appDelegate.languageSelectedStringForKey(key: "No_Pet_Allergy") as String,
                    appConstants.appDelegate.languageSelectedStringForKey(key: "Dog") as String,
                    appConstants.appDelegate.languageSelectedStringForKey(key: "Cat") as String ,
                    appConstants.appDelegate.languageSelectedStringForKey(key: "Rabbit") as String,
                    appConstants.appDelegate.languageSelectedStringForKey(key: "Mouse") as String ,
                    appConstants.appDelegate.languageSelectedStringForKey(key: "Others") as String
    ]
    
    
    var tempJSON = NSDictionary()
    
    var EventID = ""
    
    var strName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupUI()
    
    }
    
    func afterCalendar(jsonDict:NSDictionary) {
        
        if (jsonDict.allKeys as NSArray).contains("chooseGifts")
        {
            /* let objController = ChangeGiftVC()
             objController.response_id = jsonDict["response_id"]! as! String
             objController.eventId = self.EventID
             objController.fromNotif = true
             self.navigationController?.pushViewController(objController, animated: true)*/
            //date = 1573410600000;
            //sendName = wyag;
            // let objController = MyGiftsVC()
            
            
            
            let objController = ChangeGiftVC()
            objController.response_id = jsonDict["response_id"]! as! String
            objController.eventId = self.EventID
            objController.fromNotif = true
            self.navigationController?.pushViewController(objController, animated: true)
            
        }
        else
        {
            for val in self.navigationController!.viewControllers
            {
                if val is MyInvitationVC
                {
                    self.navigationController?.popToViewController(val, animated: true)
                }
            }
        }
        
    }
    
    func SetupUI()
    {
        
        setGradientBackground()
        
        
        sendImgView.layer.cornerRadius = 5
        sendImgView.clipsToBounds = true
        sendButton.layer.cornerRadius = 5
        sendButton.layer.shadowColor = UIColor.black.cgColor
        sendButton.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        sendButton.layer.shadowOpacity = 0.5
        sendButton.layer.shadowRadius = 5.0
        sendButton.layer.masksToBounds = false
        
        ViewHeader.layer.shadowColor = UIColor.black.cgColor
        ViewHeader.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        ViewHeader.layer.shadowOpacity = 0.5
        ViewHeader.layer.shadowRadius = 2.0
        ViewHeader.layer.masksToBounds = false
        
        
        txtViewOthers.textColor = UIColor.lightGray
        
        FoodView.alpha = 0.0
        PetView.alpha = 0.0
        OthersView.alpha = 0.0
        
        heightConstantPet.constant = 0
        heightConstantFood.constant = 0
        heightConstantOthers.constant = 0
        self.view.layoutIfNeeded()
        
        
        lblTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "choose_allergies") as String
        lblBack.text = appConstants.appDelegate.languageSelectedStringForKey(key: "back") as String
        lblDelightedTitle.text = String.init(format: "%@ %@", strName,appConstants.appDelegate.languageSelectedStringForKey(key: "is_delighted") as String)
        lblChildHaveTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "does_your_child_have_allergies_why_we_ask_this") as String
        lblWhatKidDoesTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "what_kid_does_not_love_a_birthday_party_though_tones_of_fun_birthday_parties_can_be_the_least_controllable_experience_for_the_food_allergic_family_there_will_be_people_who_do_not_know_and_who_do_not_know_your_child_lots_of_food_food_from_different_sources_and_a_home_event_center_or_park_that_is_unfamiliar") as String
        lblYes_NoTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "yes_no") as String
        
        /*if appConstants.appDelegate.getLang().uppercased() == "FR".uppercased()
         {
         txtFoodAllergiepickUpData.placeholder = appConstants.appDelegate.languageSelectedStringForKey(key: "yes_no") as String
         }
         else
         {
         txtFoodAllergiepickUpData.placeholder = appConstants.appDelegate.languageSelectedStringForKey(key: "yes_no") as String
         }*/
        txtViewOthers.text = appConstants.appDelegate.languageSelectedStringForKey(key: "please_enter_your_allergy_precisely") as String
        sendButton.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "send") as String, for: .normal)
        
        txtFoodAllergiepickUpData.placeholder = appConstants.appDelegate.languageSelectedStringForKey(key: "No_Food_Allergy") as String
        
        txtPetAllergiepickUpData.placeholder = appConstants.appDelegate.languageSelectedStringForKey(key: "No_Pet_Allergy")
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
    
    
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView.text == appConstants.appDelegate.languageSelectedStringForKey(key: "please_enter_your_allergy_precisely") as String
        {
            textView.textColor = UIColor.black
            textView.text = ""
        }
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if textView.text.count == 0
        {
            textView.text = appConstants.appDelegate.languageSelectedStringForKey(key: "please_enter_your_allergy_precisely") as String
            textView.textColor = UIColor.lightGray
            
        }
    }
    
    
    
    
    @IBAction func moreButtonTap(sender: AnyObject)
    {
        appConstants.appDelegate.showPopup(view: self)
    }
    
    
    
    @IBAction func switchPartyThemepONOff(sender: UISwitch){
        if switchPartyTheme.isOn {
            FoodView.alpha = 1.0
            PetView.alpha = 1.0
            
            let strOther =  appConstants.appDelegate.languageSelectedStringForKey(key: "Others") as String
            if txtPetAllergiepickUpData.text?.uppercased() == strOther.uppercased() || txtFoodAllergiepickUpData.text?.uppercased() == strOther.uppercased()
            {
                OthersView.alpha = 1.0
                heightConstantOthers.constant = 90
            }
            else
            {
                OthersView.alpha = 0.0
                heightConstantOthers.constant = 0
            }
            
            
            
            heightConstantPet.constant = 50
            heightConstantFood.constant = 50
            
            self.view.layoutIfNeeded()
            
        }
        else{
            FoodView.alpha = 0.0
            PetView.alpha = 0.0
            OthersView.alpha = 0.0
            
            heightConstantPet.constant = 0
            heightConstantFood.constant = 0
            heightConstantOthers.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    @IBAction func backButtonTapped(_sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func sendButtonTapped(_sender: UIButton)
    {
        /*if switchPartyTheme.isOn
         {
         if txtPetAllergiepickUpData.text! == ""
         {
         
         }
         }
         else
         {*/
        API_AcceptInvite()
        // }
    }
    
    @IBAction func pickerViewFoodAllergiesTapped(sender: UIButton){
        
        
        //        selectedbtn = sender as! UIButton
        
        tagValue = sender.tag
        
        self.view.endEditing(true)
        
        
        let strDone = appConstants.appDelegate.languageSelectedStringForKey(key: "Done") as String
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: strDone, style: UIAlertAction.Style.cancel, handler: {(action:UIAlertAction) in
            
            
            /*if(self.selectedDropDown<self.pickerData.count)
             {
             print("selected value after done \(self.pickerData[self.selectedDropDown])")
             self.txtDropDown.text=self.pickerData[self.selectedDropDown]
             }*/
            
        })
        alertController.addAction(defaultAction)
        
        
        let myPicker = UIPickerView()
        //myPicker.frame=CGRect(x:0, y:0, width:alertController.view.frame.size.width-20, height:250)
        
        
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            if UIScreen.main.bounds.size.width == 375
            {
                myPicker.frame=CGRect(x:0, y:0, width:alertController.view.frame.size.width-105, height:250)
            }
            else if UIScreen.main.bounds.size.width == 414
            {
                myPicker.frame=CGRect(x:0, y:0, width:alertController.view.frame.size.width-145, height:250)
            }
            else
            {
                myPicker.frame=CGRect(x:0, y:0, width:alertController.view.frame.size.width-50, height:250)
            }
        }
        else
        {
            myPicker.frame=CGRect(x:0, y:0, width:270, height:250)
        }
        
        myPicker.delegate=self
        
        
        alertController.view.addSubview(myPicker)
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func pickerViewPetAllergiesBtnTapped(sender: UIButton){
        
        
        //        selectedbtn = sender as! UIButton
        
        tagValue = sender.tag
        
        self.view.endEditing(true)
        
        
        
        let strDone = appConstants.appDelegate.languageSelectedStringForKey(key: "Done") as String
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: strDone, style: UIAlertAction.Style.cancel, handler: {(action:UIAlertAction) in
            
            
            /*if(self.selectedDropDown<self.pickerData.count)
             {
             print("selected value after done \(self.pickerData[self.selectedDropDown])")
             self.txtDropDown.text=self.pickerData[self.selectedDropDown]
             }*/
            
        })
        alertController.addAction(defaultAction)
        
        
        let myPicker = UIPickerView()
        //myPicker.frame=CGRect(x:0, y:0, width:alertController.view.frame.size.width-20, height:250)
        
        
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            if UIScreen.main.bounds.size.width == 375
            {
                myPicker.frame=CGRect(x:0, y:0, width:alertController.view.frame.size.width-105, height:250)
            }
            else if UIScreen.main.bounds.size.width == 414
            {
                myPicker.frame=CGRect(x:0, y:0, width:alertController.view.frame.size.width-145, height:250)
            }
            else
            {
                myPicker.frame=CGRect(x:0, y:0, width:alertController.view.frame.size.width-50, height:250)
            }
        }
        else
        {
            myPicker.frame=CGRect(x:0, y:0, width:270, height:250)
        }
        
        myPicker.delegate=self
        
        
        alertController.view.addSubview(myPicker)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func createDayPicker(txt:UITextField) {
        
        let dayPicker = UIPickerView()
        dayPicker.delegate = self
        
        txt.inputView = dayPicker
        
        
        //Customizations
        dayPicker.backgroundColor = .white
    }
    
    
    func createToolbar(txt:UITextField) {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        //Customizations
        toolBar.barTintColor = .black
        toolBar.tintColor = .white
        
        let strDone = appConstants.appDelegate.languageSelectedStringForKey(key: "Done") as String
        
        let doneButton = UIBarButtonItem(title: strDone, style: .plain, target: self, action: #selector(AddNewPartyVC.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        txt.inputAccessoryView = toolBar
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var val = Int()
        
        if tagValue == 0 {
            val = arrayFood.count
        }
        else if tagValue == 1{
            val = arrayPet.count
        }
        return val
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var Val = String()
        
        if tagValue == 0 {
            Val = arrayFood[row]
        }
        else if tagValue == 1{
            Val = arrayPet[row]
        }
        return Val
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if tagValue == 0 {
            txtFoodAllergiepickUpData.text = arrayFood[row]
        }
        else if tagValue == 1{
            txtPetAllergiepickUpData.text = arrayPet[row]
        }
        
        let strOther =  appConstants.appDelegate.languageSelectedStringForKey(key: "Others") as String
        if txtPetAllergiepickUpData.text?.uppercased() == strOther.uppercased() || txtFoodAllergiepickUpData.text?.uppercased() == strOther.uppercased()
        {
            OthersView.alpha = 1.0
            heightConstantOthers.constant = 90
        }
        else
        {
            OthersView.alpha = 0.0
            heightConstantOthers.constant = 0
        }
        
        self.view.layoutIfNeeded()
        
        /*       let newData = String.init(format: "%@  %@ ", (arrDatabase[row] as! NSDictionary).value(forKey: "FirstN") as! String,(arrDatabase[row] as! NSDictionary).value(forKey: "LastN") as! String)*/
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 2
        
        if tagValue == 0 {
            label.text = arrayFood[row]
        }
        else if tagValue == 1{
            label.text = arrayPet[row]
        }
        
        return label
    }
    
    
    
    
    func API_AcceptInvite()
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        
        
        let parameters : Parameters = [
            "eventId": EventID,
            "isAllergy": switchPartyTheme.isOn ?  "true" : "false",
            "allergy1":  txtFoodAllergiepickUpData.text!,
            "allergy2":  txtPetAllergiepickUpData.text! ,
            "allergy3":  txtViewOthers.text! == appConstants.appDelegate.languageSelectedStringForKey(key: "please_enter_your_allergy_precisely") as String ? "" :  txtViewOthers.text!,
            "platform":"ios",
            "language": appConstants.appDelegate.getLang() == "FR" ? "french" : "english"
        ]
        
        
        print("API_AcceptInvite = \(URLS.ACCEPT_INVITE)")
        
        Alamofire.request(URLS.ACCEPT_INVITE, method: .post, parameters: parameters,  encoding: JSONEncoding.default , headers:header).responseJSON { response in
            debugPrint(response)
            
            
            SVProgressHUD.dismiss()
            
            
            
            if let JSON = response.result.value
            {
                print("API_AcceptInvite JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        
                        self.tempJSON=jsonDict
                        let d:Double = jsonDict["date"] as! Double
                        let text:String = jsonDict["sendName"] as! String
                        self.AddCalenderPopup1(strText: text, ddd: d)
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
    
    func AddCalenderPopup1(strText :String,ddd :Double) {
        let alert = UIAlertController(title: nil , message: appConstants.appDelegate.languageSelectedStringForKey(key: "add_todo_using_calendar") as String,         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: appConstants.appDelegate.languageSelectedStringForKey(key: "yes") as String, style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
            
            DispatchQueue.main.async {
                let store = EKEventStore()
                store.requestAccess(to: .event) { (granted, error) in
                    
                    if (granted) && (error == nil) {
                        let event = EKEvent(eventStore: store)
                        event.title = strText
                        event.startDate = Date(timeIntervalSince1970: (ddd/1000)-(86400) )
                        event.endDate = Date()
                        
                        
                        // prompt user to add event (to whatever calendar they want)
                        
                        let controller = EKEventEditViewController()
                        controller.event = event
                        controller.eventStore = store
                        controller.editViewDelegate = self
                        
                        self.present(controller, animated: true)
                     print("after controller run")
                        
                    }
                    else{
                        print("failed to save event with error : \(error) or access not granted")
                        self.afterCalendar(jsonDict: self.tempJSON)
                    }
                }
            }
            
        }))
        alert.addAction(UIAlertAction(title: appConstants.appDelegate.languageSelectedStringForKey(key: "no") as String,
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        //Sign out action
                                        print("after controller discarded")
                                        self.afterCalendar(jsonDict: self.tempJSON)
        }))
        self.present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
}
