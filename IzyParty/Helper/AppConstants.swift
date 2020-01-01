//
//  AppConstants.swift
//  CellRepair
//
//  Created by zinzu on 29/03/2017.
//  Copyright © 2017 zinzu. All rights reserved.
//

import UIKit

let appConstants = AppConstants()
class AppConstants: NSObject {
    let AppName = "IzyParty";
    let PLEASE_WAIT =         "Please Wait.";
    let viewBGColor = "BE212D"
    let lightGray = "A9A9A9"
    
    
    let gradientOne = "EF4667"
    let gradientTwo = "ED6F60"
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    
    //let GOOGLE_API_KEY = "AIzaSyCsO6zscYPsqMkOlMHuhgjcpwIvCBC_dHo";
       
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    
    
    
    func getStringSafely(strData : Any?) -> String {
        
        if let safeString = strData as? String {
            return safeString
        }else if let safeString = strData as? Int {
            return String(safeString)
        }else if let safeString = strData as? Double {
            return String(safeString)
        }else{
            return ""
        }
    }
    
    
    
    func Convert_TimeStamp_To_DD_MMM_YYYY(timeStamp:NSNumber) -> String
    {
        let strTimeStamp =  TimeInterval.init((timeStamp.doubleValue)/1000)
        
        let date = Date(timeIntervalSince1970: strTimeStamp)
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.timeZone = NSTimeZone.system
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd MMM, yyyy" //Specify your format that you want
        let strExpireDate = dateFormatter.string(from: date)
       // let ExpireDate = dateFormatter.date(from: strExpireDate)
        
       
            return strExpireDate
       
        
    }
    
    
    func Convert_yyyy_MM_ddTHH_mm_ss_SSSZ_To_DD_MM_YYYY(strDate :String)->String{
        
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
       // dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let Array  : NSArray = strDate.split(separator: "T") as NSArray
       // dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
          dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: Array.object(at: 0) as! String)!
        dateFormatter.dateFormat = "dd/MM/yyyy" ; //"dd-MM-yyyy HH:mm:ss"
        dateFormatter.locale = tempLocale // reset the locale --> but no need here
        let dateString = dateFormatter.string(from: date)
        //        print("EXACT_DATE : \(dateString)")
        
            return dateString
        
    }
    
    
    func ConvertJsonDictionayToJsonString(DictData: NSMutableDictionary) -> NSString
    {
        var JsonString : String = ""
        do
        {
            if let postData : NSData = try JSONSerialization.data(withJSONObject: DictData, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
            {
                JsonString = NSString(data: postData as Data, encoding: String.Encoding.utf8.rawValue)! as String
            }
        }
        catch
        {
            print(error)
        }
        
        return JsonString as NSString
    }
    
    
    func ConvertJsonArrayToJsonString(DictData: [String]) -> NSString
    {
        var JsonString : String = ""
        do
        {
            if let postData : NSData = try JSONSerialization.data(withJSONObject: DictData, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
            {
                JsonString = NSString(data: postData as Data, encoding: String.Encoding.utf8.rawValue)! as String
            }
        }
        catch
        {
            print(error)
        }
        
        return JsonString as NSString
    }
}
