//
//  Assets.swift
//  BottleToBody
//
//  Created by EITBIZ on 28/01/19.
//  Copyright © 2019 EITBIZ. All rights reserved.
//

import UIKit

class helperFunc: NSObject {
    
    static let shared = helperFunc();
    
    func giveTxtFieldInnerSpace(width: CGFloat, field: [UITextField]?) {
        if field != nil {
            for f in field! {
                let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: f.frame.height))
                f.leftView = spaceView;
                f.leftViewMode = .always;
            }
        }
    }
    
    func roundView(view: [UIView]?, img: [UIImageView]?, btn: [UIButton]?, field: [UITextField]?, srchField: [UISearchBar]?) {
        if view != nil {
            for v in view! {
                v.layer.cornerRadius = v.frame.height / 2;
            }
        }
        
        if img != nil  {
            for i in img! {
                i.layer.cornerRadius = i.frame.height / 2;
            }
        }
        
        if btn != nil  {
            for b in btn! {
                b.layer.cornerRadius = b.frame.height / 2;
            }
        }
        
        if field != nil  {
            for f in field! {
                f.layer.cornerRadius = f.frame.height / 2;
                f.layer.masksToBounds = true
            }
        }
        
        if srchField != nil {
            for s in srchField! {
                s.layer.cornerRadius = s.frame.height / 2;
                s.layer.masksToBounds = true
            }
        }
    }
    
    func getColor(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1);
    }
    
    func radientView(color: [CGColor], uiview: [UIView]?) {
        if uiview != nil {
            for u in uiview! {
                DispatchQueue.main.async {
                    let layer = CAGradientLayer()
                    layer.colors = color
                    layer.startPoint = CGPoint(x: 0.0, y: 0.5)
                    layer.endPoint = CGPoint(x: 1.0, y: 0.5)
                    
                    layer.frame = u.bounds
                    u.layer.cornerRadius = 10;
                    u.layer.masksToBounds = true;
                    u.layer.insertSublayer(layer, at: 0)
                }
            }
        }
    }
    
    
}


class errorName: NSObject {
    static let tokenExpire = "token expire please login again";
}




func combineURl(child: String) -> String {
    return URLS.BASE_URL + child;
}
class URLS: NSObject {
    static let BASE_URL = "http://server.izyparty.com/";
    static let LOGIN_USER = combineURl(child: "login");
    static let REGISTER = combineURl(child: "signup");
    static let FORGOT_PASSWORD = combineURl(child: "password/reset");
    static let EVENT_LIST = combineURl(child: "events/list");
    static let EVENT_OVERVIEW = combineURl(child: "events/overview");
    static let ADD_EVENT = combineURl(child: "events/add");
    static let UPDATE_EVENT = combineURl(child: "events/update");
    
    static let EVENT_INFO_DETAIL = combineURl(child: "events/infodetail");
    static let GET_ATTENDEES = combineURl(child: "event/getAttendees");
    static let RESEND_NOTIFICATIONS = combineURl(child: "events/resendNotifications");
    static let DELETE_EVENT = combineURl(child: "events/delete");
    static let UPDATE_EVENT_CONTATCS = combineURl(child: "events/updateContacts");
    static let GET_RESPONSES = combineURl(child: "events/listResponses");
    static let GET_INVITES = combineURl(child: "invites/list");
    static let GET_INVITE = combineURl(child: "invites/info");
    static let ACCEPT_INVITE = combineURl(child: "invites/accept");
    static let REJECT_INVITE = combineURl(child: "invites/reject");
    static let CHECK_GIFT = combineURl(child: "gifts/check");
    static let GET_RESPONSE_ID = combineURl(child: "gifts/getResponseId");
    static let GET_GIFTS_INVITEE = combineURl(child: "gifts/listInvitee");
    static let MARK_GIFT = combineURl(child: "gifts/mark");
    static let GET_TODOS = combineURl(child: "todos/list");
    static let ADD_TODO = combineURl(child: "todos/create");
    static let UPDATE_TODO = combineURl(child: "todos/update");
    static let DELETE_TODO = combineURl(child: "todos/delete");
    static let ADD_GIFT = combineURl(child: "gifts/add");
    static let GET_GIFTS = combineURl(child: "gifts/list");
    static let DELETE_GIFT = combineURl(child: "gifts/delete");
    static let GET_PROFILE = combineURl(child: "me/profile");
    static let CHANGE_PASSWORD = combineURl(child: "me/changePassword");
    static let LOGOUT = combineURl(child: "logout");
    static let BADGE_OVERVIEW = combineURl(child: "badge/overview");
    static let BADGE_INVITES = combineURl(child: "badge/invites");
    static let BADGE_EVENT = combineURl(child: "badge/events");
    static let BADGE_GIFT = combineURl(child: "badge/gifts");
    static let BADGE_INVITES_GIFT = combineURl(child: "badge/invitesGifts");
    
    
    
    
}

@IBDesignable
class abc: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path  = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}

extension UIView {
    
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        
        DispatchQueue.main.async {
            let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path  = maskPath.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    func giveShadow() {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 1, height: 2);
        layer.shadowOpacity = 2;
        layer.shadowColor = UIColor.black.cgColor;
        layer.shadowRadius = 1;
    }
}

extension Notification.Name {
    static let sendPushNotif = Notification.Name(rawValue: "sendPush");
}




class APPKEYS: NSObject {
    static let responseSuccess = "response_success";
    static let responseCode = "success";
    static let userId = "user_id";
    static let roleId = "role_id";
    static let classId = "class_id";
    static let schoolId = "school_id";
    static let id = "id";
    static let productiD = "product_id";
    static let name = "name";
    static let subtitle = "subtitle";
    static let recipe = "recipe";
    static let oilstouse = "oils_to_use";
    static let directions = "directions";
    static let responseError = "CODE";
    static let responseErrorMessage = "message";
    static let responseData = "number";
    static let firstname = "first_name";
    static let lastname = "last_name";
    static let email = "email";
    static let socialId = "id";
    static let message = "message";
    static let phone = "phone";
    static let details = "details";
    static let optionDetails = "option_details";
    static let notificationStatus = "notifications_status";
    static let clubNotificationStatus = "club_notification_status";
    static let classNotificationStatus = "class_notification_status";
    
}





//MARK:- UserDefaults
class UserDefaultKey: NSObject {
    static let savedUserid = "id";
    static let savedRoleid = "role_id";
    static let savedName = "name";
    static let savedPhone = "phone";
    static let savedMobileVerify = "mobile_verify";
    static let savedSessionId = "session_id";
    static let savedMembership = "is_membership";
    
    
    
    static let savedImage = "ProfilePic";
    static let notificationStatus = "notificationStatus";
    static let recipeStatus = "recipeStatus";
    static let notificationType = "notificationtype";
    
    
    
    
}

