//
//  DataManager.swift
//  BottleToBody
//
//  Created by EITBIZ on 15/03/19.
//  Copyright © 2019 EITBIZ. All rights reserved.
//

import UIKit
import Alamofire
class DataManager: NSObject {
    
    static let shared = DataManager()
    
    
    
    
    func postData(url: String, sendMethod: HTTPMethod, param: [String: Any]?, completionHandler: @escaping ([String: Any]) -> Void)
    {
        
       // let paramNew: Parameters = param as! Parameters
        Alamofire.request(URL(string: url)!, method: sendMethod, parameters: param).responseJSON { (response) in
            
            guard let sendData = response.result.value as? [String: Any] else { return }
            if response.result.isSuccess {
                completionHandler(sendData);
            }
            
        }
        
        
    }
    
    func postMultipartData(url: String, sendMethod: HTTPMethod, param: [String: Any]?, completionHandler: @escaping ([String: Any]) -> Void)  {
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param! {
                
                print("key = \(key)")
                 print("value = \(value)")
                
                if key == "ProfilePic"
                {
                    let filename = String.init(format: "%@.jpg", Utility.getTimeStamp())
                    multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key, fileName: filename ,mimeType: "image/jpg")
                }
                else
                {
                    multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        }, to: url) { (result) in
            
            switch result {
            case .success(let request, _, _):
                request.uploadProgress(closure: { (progress) in
                    print("Uploading");
                    
                })
                
                request.responseJSON(completionHandler: { (response) in
                    if response.result.isSuccess {
                        completionHandler(response.result.value as! [String : Any])
                    } else {
                        completionHandler(["Fail": "Data not post"]);
                    }
                })
            case .failure(let error):
                completionHandler(error as! [String : Any]);
            }
        }
    }
}
