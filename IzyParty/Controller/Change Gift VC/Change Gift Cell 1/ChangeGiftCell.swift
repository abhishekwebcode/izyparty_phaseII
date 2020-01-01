//
//  ParticipantsCell.swift
//  IzyParty
//
//  Created by iOSA on 30/09/19.
//  Copyright © 2019 iOSA. All rights reserved.
//

import UIKit

class ChangeGiftCell: UITableViewCell {

    @IBOutlet var cellView:UIView!
    @IBOutlet var detailbl:UILabel!
    @IBOutlet var imgView:UIImageView!
    @IBOutlet var selBtn:UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selBtn.layer.cornerRadius = 2
        selBtn.clipsToBounds = true
        
        imgView.layer.cornerRadius = 10
        imgView.clipsToBounds = true
        cellView.layer.cornerRadius = 10
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        cellView.layer.shadowOpacity = 0.5
        cellView.layer.shadowRadius = 5.0
        cellView.layer.masksToBounds = false
        
        
      selBtn.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "select") as String, for: .normal)
        selBtn.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "selected") as String, for: .selected)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        
    }
    
}
