//
//  AddNewPartyVC.swift
//  IzyParty
//
//  Created by iOSA on 27/09/19.
//  Copyright © 2019 iOSA. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class AddNewPartyVC: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate {
    
    @IBOutlet var scroller:TPKeyboardAvoidingScrollView!
    @IBOutlet var addParticipantsButton:UIButton!
    @IBOutlet var txtDetailpickUpData: UITextField!
    @IBOutlet var txtTimeStartpickUpData: UITextField!
    @IBOutlet var txtTimeEndpickUpData: UITextField!
    @IBOutlet var switchPartyTheme:UISwitch!
    @IBOutlet var switchGuestSee:UISwitch!
    @IBOutlet var partyThemeView:UIView!
    @IBOutlet var addPartImgView:UIImageView!
    @IBOutlet var txtAddInfo:UITextView!
    @IBOutlet var txtStreet:UITextField!
    @IBOutlet var txtCity:UITextField!
    @IBOutlet var txtZip:UITextField!
    @IBOutlet var txtChildName:UITextField!
    @IBOutlet var txtTheme:UITextField!
    @IBOutlet var ViewHeader : UIView!
    
    @IBOutlet var heightLabel : NSLayoutConstraint!
    
    
    
    var isEdit = false
    var EventID = ""
    
    
    
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblBack : UILabel!
    @IBOutlet var lblNameOfChildTitle : UILabel!
    @IBOutlet var lblAllowTheGuestTitle : UILabel!
    @IBOutlet var lblAllowYes_NoTitle : UILabel!
    @IBOutlet var lblPartyThemeTitle : UILabel!
    @IBOutlet var lblIndicateTitle : UILabel!
    @IBOutlet var lblPartyTheme_Yes_No_Title : UILabel!
    @IBOutlet var lblDetail_of_party_Title : UILabel!
    @IBOutlet var lblTime_StartTitle : UILabel!
    @IBOutlet var lblTime_EndTitle : UILabel!
    @IBOutlet var lblVenueTitle : UILabel!
    @IBOutlet var lblIndicate_All_The_info_Title : UILabel!
    
    @IBOutlet var heightPartyThemeViewconstant : NSLayoutConstraint!
    
   
    
   /* var tagValue = Int()
    
    let dateComponents = DateComponents(year: year, month: month)
    let calendar = Calendar.current
    let date = calendar.date(from: dateComponents)!
    
    let range = calendar.range(of: .day, in: .month, for: date)!
    let numDays = range.count
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
    var arrDates = [Date]()
    for day in 1...numDays {
    let dateString = "\(day) \(month) \(year)"
    if let date = formatter.date(from: dateString) {
    arrDates.append(date)
    }
    print(arrDates)
    }*/

    
     var arrayDetail = [String]()
    var arrayTimeStart = ["0:00","0:30","1:00","1:30","2:00","2:30","3:00","3:30","4:00","4:30","5:00","5:30","6:00","6:30","7:00","7:30","8:00","8:30","9:00","9:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00","22:30","23:00","23:30","24:00"]
    var arrayTimeEnd = ["0:00","0:30","1:00","1:30","2:00","2:30","3:00","3:30","4:00","4:30","5:00","5:30","6:00","6:30","7:00","7:30","8:00","8:30","9:00","9:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00","22:30","23:00","23:30","24:00"]
    
    
    var startTimeIndex = -1
    var endTimeIndex = -1
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createToolbar(txt: txtDetailpickUpData)
        createDayPicker(txt: txtDetailpickUpData)
        createToolbar(txt: txtTimeStartpickUpData)
        createDayPicker(txt: txtTimeStartpickUpData)
        createToolbar(txt: txtTimeEndpickUpData)
        createDayPicker(txt: txtTimeEndpickUpData)
        
        addPartImgView.layer.cornerRadius = 5
        addPartImgView.clipsToBounds = true
        addParticipantsButton.layer.cornerRadius = 5
        addParticipantsButton.layer.shadowColor = UIColor.black.cgColor
        addParticipantsButton.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        addParticipantsButton.layer.shadowOpacity = 0.5
        addParticipantsButton.layer.shadowRadius = 5.0
        addParticipantsButton.layer.masksToBounds = false
        
       
       
        
        
        
        let leftViewPaddign = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        txtChildName.leftView = leftViewPaddign
        txtChildName.rightView = leftViewPaddign
        txtChildName.leftViewMode = .always

        
       
        
        setGradientBackground()
        
        ViewHeader.layer.shadowColor = UIColor.black.cgColor
        ViewHeader.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        ViewHeader.layer.shadowOpacity = 0.5
        ViewHeader.layer.shadowRadius = 2.0
        ViewHeader.layer.masksToBounds = false
        
        generateDates()
        
        
        
        SetupUI()
        
        if isEdit
        {
            API_GetEvent_InfoDetails(strEventID: EventID)
            // addParticipantsButton.setTitle("Update", for: .normal)
            addParticipantsButton.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "update") as String, for: .normal)
            lblTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "edit_party") as String
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
    
    func generateDates()
    {
        //arrayDetail
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        
        for index in 0..<60
        {
            let today = Date()
            let nextDate = Calendar.current.date(byAdding: .day, value: index, to: today)
            arrayDetail.append(formatter.string(from: nextDate!))
        }
        
    }
    
    func SetupUI()
    {
      lblTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "add_event_title") as String
      lblBack.text = appConstants.appDelegate.languageSelectedStringForKey(key: "back") as String
      lblNameOfChildTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "please_enter_the_name_of_your_child") as String
      lblAllowTheGuestTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "allow_the_guest_to_see_the_responses") as String
      lblAllowYes_NoTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "yes_no") as String
      lblPartyThemeTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "party_theme") as String
      lblIndicateTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "please_indicate_if_there_is_a_special_theme_for_the_party") as String
      lblPartyTheme_Yes_No_Title.text = appConstants.appDelegate.languageSelectedStringForKey(key: "yes_no") as String
      lblDetail_of_party_Title.text = appConstants.appDelegate.languageSelectedStringForKey(key: "date") as String
      lblTime_StartTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "time_start") as String
      lblTime_EndTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "time_end") as String
      lblVenueTitle.text = appConstants.appDelegate.languageSelectedStringForKey(key: "venue") as String
    
        //lblIndicate_All_The_info_Title.text = appConstants.appDelegate.languageSelectedStringForKey(key: "indicate_all_the_informations_regarding_the_bithday_party_of_your_child_and_send_the_invitation_n_it_doesn_t_prevent_you_to_give_a_funny_invitation_card_to_the_kids") as String
        
        
        let attributedString = NSMutableAttributedString(string: appConstants.appDelegate.languageSelectedStringForKey(key: "indicate_all_the_informations_regarding_the_bithday_party_of_your_child_and_send_the_invitation_n_it_doesn_t_prevent_you_to_give_a_funny_invitation_card_to_the_kids") as String)
        
        
        
        //attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 23, length: 10))
        
        //attributedString.addAttribute(NSAttributedString.Key.underlineColor, value:UIColor.white, range:NSRange(location: 23, length: 10))
        
    
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 2 // Whatever line spacing you want in points
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: NSRange(location: 0, length: attributedString.length))
        
        
        if appConstants.appDelegate.getLang() == "FR"
        {
            attributedString.addAttribute(NSAttributedString.Key.font, value:UIFont.boldSystemFont(ofSize: 13), range:NSRange(location: 43, length: 15))
        }
        else
        {
            attributedString.addAttribute(NSAttributedString.Key.font, value:UIFont.boldSystemFont(ofSize: 14), range:NSRange(location: 39, length: 13))
        }
        
        
        lblIndicate_All_The_info_Title.attributedText = attributedString
      
        self.view.layoutIfNeeded()
        
        
        txtTheme.placeholder = appConstants.appDelegate.languageSelectedStringForKey(key: "enter_theme") as String
        
        
        
        txtDetailpickUpData.placeholder = appConstants.appDelegate.languageSelectedStringForKey(key: "please_select_detail") as String
        
        txtTimeStartpickUpData.placeholder = appConstants.appDelegate.languageSelectedStringForKey(key: "please_select_time_slot") as String
         txtTimeEndpickUpData.placeholder = appConstants.appDelegate.languageSelectedStringForKey(key: "please_select_time_slot") as String
        
        txtStreet.placeholder = appConstants.appDelegate.languageSelectedStringForKey(key: "street_addresse") as String
        txtCity.placeholder = appConstants.appDelegate.languageSelectedStringForKey(key: "city_name") as String
        txtZip.placeholder = appConstants.appDelegate.languageSelectedStringForKey(key: "zip_code") as String
        
        addParticipantsButton.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "add_participants") as String, for: .normal)
        
        
        txtAddInfo.text = appConstants.appDelegate.languageSelectedStringForKey(key: "add_here_all_the_infomation_n_required_such_as_ndrop_pin_code") as String
        txtAddInfo.textColor = UIColor.lightGray
        textViewDidBeginEditing(txtAddInfo)
        txtAddInfo.delegate = self
        
        
    }
    
    
   
    
    @IBAction func moreButtonTap(sender: AnyObject)
    {
        appConstants.appDelegate.showPopup(view: self)
    }
    
    
    
    @IBAction func backButtonTapped(_sender: UIButton)
    {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addPartBtnTapped(_sender:UIButton){
        
        
        if switchPartyTheme.isOn
        {
            if(txtDetailpickUpData.text == "" || txtTimeStartpickUpData.text == "" || txtTimeEndpickUpData.text == "" || txtStreet.text == "" || txtCity.text == "" || txtZip.text == "" || txtChildName.text == "" || txtTheme.text == "")
            {
                let windows = UIApplication.shared.windows
                windows.last?.makeToast(appConstants.appDelegate.languageSelectedStringForKey(key: "fill_all_fields") as String)
                //self.view.makeToast("Please fill all the fields correctly")
                return
            }
        }
        
        if(txtDetailpickUpData.text == "" || txtTimeStartpickUpData.text == "" || txtTimeEndpickUpData.text == "" || txtStreet.text == "" || txtCity.text == "" || txtZip.text == "" || txtChildName.text == "" )
        {
            let windows = UIApplication.shared.windows
            windows.last?.makeToast(appConstants.appDelegate.languageSelectedStringForKey(key: "fill_all_fields") as String)
            //self.view.makeToast("Please fill all the fields correctly")
        }
        else if startTimeIndex >= endTimeIndex
        {
            let windows = UIApplication.shared.windows
            windows.last?.makeToast(appConstants.appDelegate.languageSelectedStringForKey(key: "time_warning") as String)
        }
        else
        {
            if isEdit
            {
                API_EditEvent()
            }
            else
            {
               let dict =  ["childName":txtChildName.text!,
                 "theme": (txtTheme.isHidden) ? "" : txtTheme.text! ,
                 "street": txtStreet.text!,
                 "city":txtCity.text!,
                 "zipCode":txtZip.text!,
                 "otherAddress" :txtAddInfo.text! == appConstants.appDelegate.languageSelectedStringForKey(key: "add_here_all_the_infomation_n_required_such_as_ndrop_pin_code") as String ? "" : txtAddInfo.text!,
                 "isSpecialTheme":switchPartyTheme.isOn ?  "true" : "false",
                 "guestSee": switchGuestSee.isOn ? "true" : "false",
                 //"date":(NSDate().timeIntervalSince1970)*1000,
                "date":getTimeStampofSelectedDate(),
                "datetext" : getFormattedDateFromSelectedDate(),
                 "timeStart": txtTimeStartpickUpData.text!,
                 "timeEnd":txtTimeEndpickUpData.text!,
                 "eventId": EventID
                ] as NSDictionary
                
                let objAddEvent = AddAttendeesVC()
                objAddEvent.dictEvent = dict
                objAddEvent.isFromAddEvent = true
                self.navigationController?.pushViewController(objAddEvent, animated: true)
            }
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }

    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView.text == appConstants.appDelegate.languageSelectedStringForKey(key: "add_here_all_the_infomation_n_required_such_as_ndrop_pin_code") as String
        {
            textView.textColor = UIColor.black
            textView.text = ""
        }
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if textView.text.count == 0
        {
            textView.text = appConstants.appDelegate.languageSelectedStringForKey(key: "add_here_all_the_infomation_n_required_such_as_ndrop_pin_code") as String
            textView.textColor = UIColor.lightGray
            
        }
    }

    
    @IBAction func switchPartyThemepONOff(sender: UISwitch){
        
     if switchPartyTheme.isOn {
            partyThemeView.alpha = 1.0
        //heightPartyThemeViewconstant.constant = 50
       // self.view.layoutIfNeeded()
        }
     else{
            partyThemeView.alpha = 0
            //heightPartyThemeViewconstant.constant = 0
            //self.view.layoutIfNeeded()
        }
    }
   
    
    @IBAction func pickerViewDetailBtnTapped(sender: UIButton){
        
        
        //        selectedbtn = sender as! UIButton
        
       // tagValue = sender.tag
        
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
        
        myPicker.tag = sender.tag
        alertController.view.addSubview(myPicker)
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func pickerViewStartTimeBtnTapped(sender: UIButton){
        
        
      //  tagValue = sender.tag
        //        selectedbtn = sender as! UIButton
        
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
        myPicker.tag = sender.tag
        
        alertController.view.addSubview(myPicker)
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func pickerViewEndTimeBtnTapped(sender: UIButton){
        
        
        //        selectedbtn = sender as! UIButton
       // tagValue = sender.tag
        
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
        myPicker.tag = sender.tag
        
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
    
    
    func fillData(dict: NSDictionary)
    {
        
        
        if  dict["success"]! as! Bool
        {
            
            if dict["event"]! is NSDictionary
            {
                
                let dictEvent = dict["event"]! as! NSDictionary
                
            if let val = dictEvent["childName"]
            {
                txtChildName.text = val as? String
            }
            
            
            if let val = dictEvent["guestSee"]
            {
                if (val as! Bool)
                {
                    switchGuestSee.isOn = (val as! Bool)
                }
            }
                
                
                if let val = dictEvent["isSpecialTheme"]
                {
                    if (val as! Bool)
                    {
                        switchPartyTheme.isOn = (val as! Bool)
                    }
                    
                    if switchPartyTheme.isOn {
                        partyThemeView.alpha = 1.0
                    }
                    else{
                        partyThemeView.alpha = 0
                    }
                }
            
            
            if let val = dictEvent["theme"]
            {
                
                txtTheme.text = val as? String
                
            }
            
            
            if let val = dictEvent["date"]
            {
                let Array : NSArray = (val as! String).split(separator: "T") as NSArray
                
                
                let dateFormatter = DateFormatter()
                let tempLocale = dateFormatter.locale // save locale temporarily
                // dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                //dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                  dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from: (Array.object(at: 0) as? String)!)!
                dateFormatter.dateFormat = "dd MM yyyy" ; //"dd-MM-yyyy HH:mm:ss"
               dateFormatter.locale = tempLocale // reset the locale --> but no need here
                let dateString = dateFormatter.string(from: date)
                
                txtDetailpickUpData.text = dateString
            }
                
                if let val = dictEvent["timeStart"]
                {
                    txtTimeStartpickUpData.text = val as? String
                    startTimeIndex = arrayTimeStart.firstIndex(of: txtTimeStartpickUpData.text!)!
                }
            
                if let val = dictEvent["timeEnd"]
                {
                    txtTimeEndpickUpData.text = val as? String
                     endTimeIndex = arrayTimeEnd.firstIndex(of: txtTimeEndpickUpData.text!)!
                }
                
                if let val = dictEvent["street"]
                {
                    txtStreet.text = val as? String
                }
                
                
                if let val = dictEvent["city"]
                {
                    txtCity.text = val as? String
                }
                
                if let val = dictEvent["zipCode"]
                {
                    txtZip.text = val as? String
                }
                
                if let val = dictEvent["otherAddress"]
                {
                    txtAddInfo.text = val as? String
                }
            
            }
            
        }
        
    }
    
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var val = Int()
        
        if pickerView.tag == 0 {
            val = arrayDetail.count
        }
        else if pickerView.tag == 1{
            val = arrayTimeStart.count
        }
        else if pickerView.tag == 2{
            val = arrayTimeStart.count
        }
        return val
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var Val = String()
        
        if pickerView.tag == 0 {
            Val = arrayDetail[row]
        }
        else if pickerView.tag == 1{
            Val = arrayTimeStart[row]
        }
        else if pickerView.tag == 2{
            Val = arrayTimeEnd[row]
        }
        return Val
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
  
        if pickerView.tag == 0 {
            txtDetailpickUpData.text = arrayDetail[row]
        }
        else if pickerView.tag == 1{
            startTimeIndex = row
            txtTimeStartpickUpData.text = arrayTimeStart[row]
        }
        else if pickerView.tag == 2{
            endTimeIndex = row
            txtTimeEndpickUpData.text = arrayTimeEnd[row]
        }
        
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
        
        if pickerView.tag == 0 {
            label.text = arrayDetail[row]
        }
        else if pickerView.tag == 1{
            label.text = arrayTimeStart[row]
        }
        else if pickerView.tag == 2{
            label.text = arrayTimeEnd[row]
        }
        
        return label
    }

    
    
    func getTimeStampofSelectedDate() -> Double
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        
        let selectedDate = formatter.date(from: txtDetailpickUpData.text!)
        
        return (selectedDate!.timeIntervalSince1970)*1000
    }
    
    
    func getFormattedDateFromSelectedDate() -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        
        let selectedDate = formatter.date(from: txtDetailpickUpData.text!)
        
        formatter.dateFormat = "dd MMMM yyyy"
        print(formatter.string(from: selectedDate!))
        return formatter.string(from: selectedDate!)
    }
    
    
    func API_EditEvent()
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        
        
        let parameters : Parameters = ["childName":txtChildName.text!,
                                       "theme": (txtTheme.isHidden) ? "" : txtTheme.text! ,
                                       "street": txtStreet.text!,
                                       "city":txtCity.text!,
                                       "zipCode":txtZip.text!,
                                       "otherAddress":txtAddInfo.text!,
                                       "isSpecialTheme":switchPartyTheme.isOn ?  "true" : "false",
                                       "guestSee": switchGuestSee.isOn ? "true" : "false",
                                      //"date":(NSDate().timeIntervalSince1970)*1000,
                                        "date":getTimeStampofSelectedDate(),
                                        "datetext" : getFormattedDateFromSelectedDate(),
                                       "timeStart": txtTimeStartpickUpData.text!,
                                       "timeEnd":txtTimeEndpickUpData.text!,
                                       "eventId": EventID,
                                       "platform":"ios",
                                       "language": appConstants.appDelegate.getLang() == "FR" ? "french" : "english"
        ]
        
        print(parameters)
        
        print("API_EditEvent = \(URLS.UPDATE_EVENT)")
        
        Alamofire.request(URLS.UPDATE_EVENT, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            
            
            SVProgressHUD.dismiss()
            
           // self.arrEventsList.removeAllObjects()
            
            if let JSON = response.result.value
            {
                print("API_EditEvent JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        
                        
                        self.navigationController?.popViewController(animated: true)
                        
                        
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
    
    
    
    
    
    func API_GetEvent_InfoDetails(strEventID:String)
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        SVProgressHUD.show(withStatus: appConstants.appDelegate.languageSelectedStringForKey(key: "loading1") as String)
        
        
        
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        
        
        let parameters : Parameters = ["eventId": strEventID]
        
         print("API_GetEvent_InfoDetails parameters = \(parameters)")
         print("API_GetEvent_InfoDetails header = \(header)")
        
        print("API_GetEvent_InfoDetails = \(URLS.EVENT_INFO_DETAIL)")
        
        Alamofire.request(URLS.EVENT_INFO_DETAIL, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
            
            
            SVProgressHUD.dismiss()
            
            
            
            if let JSON = response.result.value
            {
                print("API_GetEvent_InfoDetails JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        
                        self.fillData(dict: jsonDict)
                        
                    }
                        
                    else
                    {
                        self.fillData(dict: jsonDict)
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
