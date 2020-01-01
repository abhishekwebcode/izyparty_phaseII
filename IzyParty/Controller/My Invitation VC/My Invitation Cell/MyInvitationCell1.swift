//
//  MyInvitationCell1.swift
//  IzyParty
//
//  Created by iOSA on 26/09/19.
//  Copyright © 2019 iOSA. All rights reserved.
//

import UIKit

class MyInvitationCell1: UITableViewCell {
    
    @IBOutlet var cellView:UIView!
    @IBOutlet var nameLbl:UILabel!
    @IBOutlet var dobLbl:UILabel!
     @IBOutlet var countLbl:UILabel!
    @IBOutlet var giftBadgeLbl:UILabel!
    @IBOutlet var selectBtn:UIButton!
    @IBOutlet var seetheGuestBtn:UIButton!
    
    @IBOutlet var seeGuestConstHeight : NSLayoutConstraint!

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        
        cellView.layer.cornerRadius = 10.0
        cellView.clipsToBounds  = true
        
        countLbl.layer.cornerRadius = countLbl.frame.size.width/2
        countLbl.clipsToBounds = true
        
        if giftBadgeLbl != nil
        {
            giftBadgeLbl.layer.cornerRadius = giftBadgeLbl.frame.size.width/2
            giftBadgeLbl.clipsToBounds = true
        }
        
        setGradientBackground(btn: selectBtn)
        
         selectBtn.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "select_gift") as String, for: .normal)
        
        if seetheGuestBtn != nil
        {
        setGradientBackground(btn: seetheGuestBtn)
            seetheGuestBtn.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "view_responses") as String, for: .normal)
        }
        
        self.layoutIfNeeded()
        self.contentView.layoutIfNeeded()
        
    }
    
    func setGradientBackground(btn:UIButton) {
        let colorTop =  Utility.color(withHexString: appConstants.gradientOne)?.cgColor
        let colorBottom = Utility.color(withHexString: appConstants.gradientTwo)?.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop as Any, colorBottom as Any]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = btn.bounds
        
        btn.layer.insertSublayer(gradientLayer, at:0)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
        
    }
    
}
