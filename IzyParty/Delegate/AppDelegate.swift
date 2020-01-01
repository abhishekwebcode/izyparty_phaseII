//
//  AppDelegate.swift
//  IzyParty
//
//  Created by neha on 24/09/19.
//  Copyright © 2019 neha. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {

    var window: UIWindow?
    var navigationController:UINavigationController?
    
     var dictLanguageData:NSDictionary!
    
    var strNotificationType = ""
    var strEventID = ""
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
        
       // setLang(strValue: "EN")
        
        FirebaseApp.configure()
       
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor=UIColor.white
        
         loadLanguageData()
        
        RegisterNotification(objApplication: application)
        
        UIApplication.shared.statusBarStyle=UIStatusBarStyle.lightContent

        
        
        
        if(launchOptions != nil)
        {
            NSLog("launch value %@", launchOptions ?? "")
            
            let userData = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? NSDictionary
            
            
            if (userData != nil)
            {
                if userData!["type"] as! String == "NEW_INVITE"
                {
                        strNotificationType = "NEW_INVITE"
                }
                
                
                if userData!["type"] as! String == "INVITE_RESPOND"
                {
                    strNotificationType = "INVITE_RESPOND"
                    strEventID = userData!["eventId"] as! String
                }
                
                
                if userData!["type"] as! String == "CHANGE_EVENT"
                {
                    strNotificationType = "CHANGE_EVENT"
                    strEventID = userData!["eventId"] as! String
                }
                
                
                if userData!["type"] as! String == "GIFT_ADD"
                {
                    strNotificationType = "GIFT_ADD"
                    strEventID = userData!["eventId"] as! String
                }
                
                if userData!["type"] as! String == "GIFT_SELECTED"
                {
                    strNotificationType = "GIFT_SELECTED"
                    strEventID = userData!["eventId"] as! String
                }
                
                if userData!["type"] as! String == "GIFT_DELETED"
                {
                    strNotificationType = "GIFT_DELETED"
                    strEventID = userData!["eventId"] as! String
                }
                
                
                
                //print(userData)
            }
        }
        
        
        
        if getLang().count == 0
        {
            let  objController = SplashViewController()
            navigationController=UINavigationController(rootViewController: objController)
            navigationController?.isNavigationBarHidden =  true
            self.window!.rootViewController = navigationController
        }
        else
        {
        
        if getToken().count > 0
        {
            OpenHomeScreen()
        }
        else
        {
            OpenOnboardScreen()
        }
        }
        
        return true
    }
    
    
    
    func RegisterNotification(objApplication:UIApplication)
    {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            objApplication.registerUserNotificationSettings(settings)
        }
        Messaging.messaging().delegate = self
        objApplication.registerForRemoteNotifications()
    }
    

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    
    func OpenOnboardScreen()
    {
        let  objOnboardControle=OnboardingViewController()
        navigationController=UINavigationController(rootViewController: objOnboardControle)
        navigationController?.isNavigationBarHidden =  true
        self.window!.rootViewController = navigationController
    }
    

    func OpenHomeScreen()
    {
        let homeObj = HomeVC()
        navigationController=UINavigationController(rootViewController: homeObj)
        navigationController?.isNavigationBarHidden =  true
        self.window!.rootViewController = navigationController
    }
    
    func OpenLoginScreen()
    {
        let homeObj = LoginVC()
        navigationController=UINavigationController(rootViewController: homeObj)
        navigationController?.isNavigationBarHidden =  true
        self.window!.rootViewController = navigationController
    }
    
    
    
    func showPopup(view:UIViewController)
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: appConstants.appDelegate.languageSelectedStringForKey(key: "profile") as String, style: .default, handler: { (_) in
            print("User click Approve button")
            
            let objProfile = MyProfileVC()
            view.navigationController?.pushViewController(objProfile, animated: true)
            
        }))
        
        alert.addAction(UIAlertAction(title: appConstants.appDelegate.languageSelectedStringForKey(key: "change_password") as String, style: .default, handler: { (_) in
            print("User click Edit button")
            let objControl = ChangePassVC()
            view.navigationController?.pushViewController(objControl, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: appConstants.appDelegate.languageSelectedStringForKey(key: "forgot_password") as String, style: .default, handler: { (_) in
            print("User click Delete button")
            let objControl = ForgotVC()
            view.navigationController?.pushViewController(objControl, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: appConstants.appDelegate.languageSelectedStringForKey(key: "logout") as String, style: .default, handler: { (_) in
            print("User click Dismiss button")
            self.API_Logout()
            appConstants.appDelegate.setToken(strValue: "")
            appConstants.appDelegate.OpenLoginScreen()
        }))
        
        
        alert.addAction(UIAlertAction(title: appConstants.appDelegate.languageSelectedStringForKey(key: "cancel") as String, style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = view.view
            popoverController.sourceRect = CGRect(x: view.view.bounds.midX, y: view.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        
        view.present(alert, animated: true, completion: {
            print("completion block")
        })
        
        
       
    }
    
    
    
    //MARK: - Token
    func setToken(strValue:String)
    {
        let defaults=UserDefaults.standard
        defaults.setValue(strValue, forKey: "Token")
        defaults.synchronize()
    }
    
    
    func getToken() -> String
    {
        
        if UserDefaults.standard.value(forKey: "Token") == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.value(forKey: "Token") as! String
        }
    }
    
    
    
    
    
     //MARK: - LangaugeStatus
    func setLang(strValue:String)
    {
        let defaults=UserDefaults.standard
        defaults.setValue(strValue, forKey: "Lang")
        defaults.synchronize()
    }
    
    
    func getLang() -> String
    {
        
        if UserDefaults.standard.value(forKey: "Lang") == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.value(forKey: "Lang") as! String
        }
    }
    
    
    
    
    func loadLanguageData()
    {
        
        if getLang() == "FR"
        {
            // var dict: NSDictionary?
            
            let fname = Bundle.main.path(forResource: "French", ofType: "strings")
            // dict = NSDictionary(contentsOfFile: fname!)
            dictLanguageData = NSDictionary(contentsOfFile: fname!)
            
            
        }
        
        else
        {
            
            let fname = Bundle.main.path(forResource: "English", ofType: "strings")
            dictLanguageData = NSDictionary(contentsOfFile: fname!)
            
        }
        
    }
    
    
    
    
    func languageSelectedStringForKey(key : NSString) -> String
    {
        //let strlang = getLangaugeStatus()
        
        /*if getLangaugeStatus() == "ta-US"
         {
         // var dict: NSDictionary?
         
         let fname = Bundle.main.path(forResource: "tamil", ofType: "strings")
         // dict = NSDictionary(contentsOfFile: fname!)
         let dict = NSDictionary(contentsOfFile: fname!)
         
         let Strloc = dict?.object(forKey: key)
         
         return Strloc as! String
         }
         else
         {
         var dict: NSDictionary?
         
         let fname = Bundle.main.path(forResource: "english", ofType: "strings")
         dict = NSDictionary(contentsOfFile: fname!)
         let Strloc = dict?.object(forKey: key)
         
         return Strloc as! String
         }*/
        
        let Strloc = dictLanguageData?.object(forKey: key)
        
        return Strloc as! String
        
        
    }
    
    
    
    
    
    
    func API_Logout()
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true, andTitle: nil)
        
        //http://beta.api.ezeelo.in/api/TerritoryHierarchyByPincode/Getcity
        
        
        
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(appConstants.appDelegate.getToken())"
            
        ]
        
        let parameters : Parameters = [: ]
        
        print("API_Logout = \(URLS.LOGOUT)")
        print("Logout = \(appConstants.appDelegate.getToken())")
        
        Alamofire.request(URLS.LOGOUT, method: .post, parameters: parameters, headers:header).responseJSON { response in
            debugPrint(response)
           
            if let JSON = response.result.value
            {
                print("API_Logout JSON: \(JSON)")
                
                let jsonDict = JSON as! NSDictionary
                if (jsonDict.allKeys as NSArray).contains("success")
                {
                    if  jsonDict["success"]! as! Bool
                    {
                        /*if let val = jsonDict["data"]
                        {
                            if val is NSDictionary
                            {
                                self.fillData(dictUserInfo: val as! NSDictionary)
                            }
                        }*/
                    }
                        
                    else
                    {
                        // self.fillData(dict: jsonDict)
                        // Utility.alert(jsonDict?["message"] as! String, andTitle: appConstants.AppName, andController: self)
                    }
                }
                else
                {
                    
                   // Utility.alert("Something went wrong.", andTitle: appConstants.AppName, andController: self)
                }
                
            }
        }
    }
    
    
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let _:[String: String] = ["token": fcmToken]
        //  NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    
    private func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any])
    {
        
        print("UserInfo = \(userInfo)")
        
        if userInfo["type"] as! String == "NEW_INVITE"
        {
            
            if application.applicationState == .background
            {
                strNotificationType = "NEW_INVITE"
                OpenHomeScreen()
            }
            if application.applicationState == .active
            {
                
                
                
                let apsDict = userInfo["aps"]  as! NSDictionary
                let alertDict = apsDict["alert"]  as! NSDictionary
                
                let mpgNotification : MPGNotification!
                mpgNotification = MPGNotification(title: alertDict["title"] as? String, subtitle: alertDict["body"] as? String , backgroundColor: UIColor.black, iconImage: UIImage.init(named: "Icon-App-60x60@3x.png"))
                mpgNotification.layer.cornerRadius = 10
                mpgNotification.duration = 8
                mpgNotification.swipeToDismissEnabled = true
                mpgNotification.backgroundTapsEnabled = true
                
                mpgNotification.show(buttonHandler: { (notification:MPGNotification!, buttonIndex:NSInteger!) in
                    
                    if buttonIndex == mpgNotification.backgroundView.tag || buttonIndex == notification.backgroundView.tag
                    {
                        print("notification call")
                        
                        // NotificationCenter.default.post(name: Notification.Name("ReciveNotification"), object: "Success", userInfo: DictGetData)
                        self.strNotificationType = "NEW_INVITE"
                        self.OpenHomeScreen()
                        
                        
                    }
                    
                } )
                
                
                mpgNotification.show()
            }
            
        }
        else if userInfo["type"] as! String == "INVITE_RESPOND"
        {
            
            if application.applicationState == .background
            {
                strNotificationType = "INVITE_RESPOND"
                strEventID = userInfo["eventId"] as! String
                OpenHomeScreen()
            }
            if application.applicationState == .active
            {
                
                
                
                let apsDict = userInfo["aps"]  as! NSDictionary
                let alertDict = apsDict["alert"]  as! NSDictionary
                
                let mpgNotification : MPGNotification!
                mpgNotification = MPGNotification(title: alertDict["title"] as? String, subtitle: alertDict["body"] as? String , backgroundColor: UIColor.black, iconImage: UIImage.init(named: "Icon-App-60x60@3x.png"))
                mpgNotification.layer.cornerRadius = 10
                mpgNotification.duration = 8
                mpgNotification.swipeToDismissEnabled = true
                mpgNotification.backgroundTapsEnabled = true
                
                mpgNotification.show(buttonHandler: { (notification:MPGNotification!, buttonIndex:NSInteger!) in
                    
                    if buttonIndex == mpgNotification.backgroundView.tag || buttonIndex == notification.backgroundView.tag
                    {
                        print("notification call")
                        
                        // NotificationCenter.default.post(name: Notification.Name("ReciveNotification"), object: "Success", userInfo: DictGetData)
                        self.strNotificationType = "INVITE_RESPOND"
                        self.strEventID = userInfo["eventId"] as! String
                        self.OpenHomeScreen()
                        
                        
                    }
                    
                } )
                
                
                mpgNotification.show()
            }
            
        }
        else if userInfo["type"] as! String == "CHANGE_EVENT"
        {
            
            if application.applicationState == .background
            {
                strNotificationType = "CHANGE_EVENT"
                strEventID = userInfo["eventId"] as! String
                OpenHomeScreen()
            }
            if application.applicationState == .active
            {
                
                
                
                let apsDict = userInfo["aps"]  as! NSDictionary
                let alertDict = apsDict["alert"]  as! NSDictionary
                
                let mpgNotification : MPGNotification!
                mpgNotification = MPGNotification(title: alertDict["title"] as? String, subtitle: alertDict["body"] as? String , backgroundColor: UIColor.black, iconImage: UIImage.init(named: "Icon-App-60x60@3x.png"))
                mpgNotification.layer.cornerRadius = 10
                mpgNotification.duration = 8
                mpgNotification.swipeToDismissEnabled = true
                mpgNotification.backgroundTapsEnabled = true
                
                mpgNotification.show(buttonHandler: { (notification:MPGNotification!, buttonIndex:NSInteger!) in
                    
                    if buttonIndex == mpgNotification.backgroundView.tag || buttonIndex == notification.backgroundView.tag
                    {
                        print("notification call")
                        
                        // NotificationCenter.default.post(name: Notification.Name("ReciveNotification"), object: "Success", userInfo: DictGetData)
                        self.strNotificationType = "CHANGE_EVENT"
                        self.strEventID = userInfo["eventId"] as! String
                        self.OpenHomeScreen()
                        
                        
                    }
                    
                } )
                
                
                mpgNotification.show()
            }
            
        }
        
        else if userInfo["type"] as! String == "GIFT_ADD"
        {
            
            if application.applicationState == .background
            {
                strNotificationType = "GIFT_ADD"
                strEventID = userInfo["eventId"] as! String
                OpenHomeScreen()
            }
            if application.applicationState == .active
            {
                
                
                
                let apsDict = userInfo["aps"]  as! NSDictionary
                let alertDict = apsDict["alert"]  as! NSDictionary
                
                let mpgNotification : MPGNotification!
                mpgNotification = MPGNotification(title: alertDict["title"] as? String, subtitle: alertDict["body"] as? String , backgroundColor: UIColor.black, iconImage: UIImage.init(named: "Icon-App-60x60@3x.png"))
                mpgNotification.layer.cornerRadius = 10
                mpgNotification.duration = 8
                mpgNotification.swipeToDismissEnabled = true
                mpgNotification.backgroundTapsEnabled = true
                
                mpgNotification.show(buttonHandler: { (notification:MPGNotification!, buttonIndex:NSInteger!) in
                    
                    if buttonIndex == mpgNotification.backgroundView.tag || buttonIndex == notification.backgroundView.tag
                    {
                        print("notification call")
                        
                        // NotificationCenter.default.post(name: Notification.Name("ReciveNotification"), object: "Success", userInfo: DictGetData)
                        self.strNotificationType = "GIFT_ADD"
                        self.strEventID = userInfo["eventId"] as! String
                        self.OpenHomeScreen()
                        
                        
                    }
                    
                } )
                
                
                mpgNotification.show()
            }
            
        }
        
        else if userInfo["type"] as! String == "GIFT_SELECTED"
        {
            
            if application.applicationState == .background
            {
                strNotificationType = "GIFT_SELECTED"
                strEventID = userInfo["eventId"] as! String
                OpenHomeScreen()
            }
            if application.applicationState == .active
            {
                
                
                
                let apsDict = userInfo["aps"]  as! NSDictionary
                let alertDict = apsDict["alert"]  as! NSDictionary
                
                let mpgNotification : MPGNotification!
                mpgNotification = MPGNotification(title: alertDict["title"] as? String, subtitle: alertDict["body"] as? String , backgroundColor: UIColor.black, iconImage: UIImage.init(named: "Icon-App-60x60@3x.png"))
                mpgNotification.layer.cornerRadius = 10
                mpgNotification.duration = 8
                mpgNotification.swipeToDismissEnabled = true
                mpgNotification.backgroundTapsEnabled = true
                
                mpgNotification.show(buttonHandler: { (notification:MPGNotification!, buttonIndex:NSInteger!) in
                    
                    if buttonIndex == mpgNotification.backgroundView.tag || buttonIndex == notification.backgroundView.tag
                    {
                        print("notification call")
                        
                        // NotificationCenter.default.post(name: Notification.Name("ReciveNotification"), object: "Success", userInfo: DictGetData)
                        self.strNotificationType = "GIFT_SELECTED"
                        self.strEventID = userInfo["eventId"] as! String
                        self.OpenHomeScreen()
                        
                        
                    }
                    
                } )
                
                
                mpgNotification.show()
            }
            
        }
        
        else if userInfo["type"] as! String == "GIFT_DELETED"
        {
            
            if application.applicationState == .background
            {
                strNotificationType = "GIFT_DELETED"
                strEventID = userInfo["eventId"] as! String
                OpenHomeScreen()
            }
            if application.applicationState == .active
            {
                
                
                
                let apsDict = userInfo["aps"]  as! NSDictionary
                let alertDict = apsDict["alert"]  as! NSDictionary
                
                let mpgNotification : MPGNotification!
                mpgNotification = MPGNotification(title: alertDict["title"] as? String, subtitle: alertDict["body"] as? String , backgroundColor: UIColor.black, iconImage: UIImage.init(named: "Icon-App-60x60@3x.png"))
                mpgNotification.layer.cornerRadius = 10
                mpgNotification.duration = 8
                mpgNotification.swipeToDismissEnabled = true
                mpgNotification.backgroundTapsEnabled = true
                
                mpgNotification.show(buttonHandler: { (notification:MPGNotification!, buttonIndex:NSInteger!) in
                    
                    if buttonIndex == mpgNotification.backgroundView.tag || buttonIndex == notification.backgroundView.tag
                    {
                        print("notification call")
                        
                        // NotificationCenter.default.post(name: Notification.Name("ReciveNotification"), object: "Success", userInfo: DictGetData)
                        self.strNotificationType = "GIFT_DELETED"
                        self.strEventID = userInfo["eventId"] as! String
                        self.OpenHomeScreen()
                        
                        
                    }
                    
                } )
                
                
                mpgNotification.show()
            }
            
        }
        
        
        
       /* let DictNotifi =  userInfo as NSDictionary
        
        let DictFinalData = convertToDictionary(text: DictNotifi.value(forKey: "body") as! String) as! NSDictionary
        
        
        userPerson = Person()
        userPerson.Grupid = DictFinalData.value(forKey: "groupId") as? String
        userPerson.CategID = DictFinalData.value(forKey: "categoryId") as? String
        userPerson.Groupname = String.init(format: "#%@", DictFinalData.value(forKey: "group_name") as! String)
        
        
        /* let  objController = ChatViewController()
         objController.user = user
         navigationController = UINavigationController.init(rootViewController: objController)
         self.window?.rootViewController = navigationController*/
        
        
        
        
        
        if application.applicationState == .active
        {
            
            
            if DictFinalData["groupId"] as! String == strStoreGroupOpen
            {
                return
            }
            
            
            let mpgNotification : MPGNotification!
            mpgNotification = MPGNotification(title: DictFinalData["group_name"] as? String, subtitle: String.init(format: "%@ : %@" , DictFinalData["user_name"] as! String,DictFinalData["message"] as! String), backgroundColor: UIColor.black, iconImage: UIImage.init(named: "Icon-App-40x40@2x.png"))
            mpgNotification.layer.cornerRadius = 10
            mpgNotification.duration = 8
            mpgNotification.swipeToDismissEnabled = true
            mpgNotification.backgroundTapsEnabled = true
            
            mpgNotification.show(buttonHandler: { (notification:MPGNotification!, buttonIndex:NSInteger!) in
                
                if buttonIndex == mpgNotification.backgroundView.tag || buttonIndex == notification.backgroundView.tag
                {
                    print("notification call")
                    
                    // NotificationCenter.default.post(name: Notification.Name("ReciveNotification"), object: "Success", userInfo: DictGetData)
                    self.StrNotiType = "recipe"
                    self.ShowMainController(index: 0)
                    
                    
                }
                
            } )
            
            
            mpgNotification.show()
        }
        else
        {
            StrNotiType = "recipe"
            ShowMainController(index: 0)
            
            
        }
        
        
        */
        
        
        
    }
}

