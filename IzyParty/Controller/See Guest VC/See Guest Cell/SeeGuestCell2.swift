//
//  SeeGuestCell2.swift
//  IzyParty
//
//  Created by iOSA on 01/10/19.
//  Copyright © 2019 iOSA. All rights reserved.
//

import UIKit

class SeeGuestCell2: UITableViewCell {
    
    @IBOutlet var cellView:UIView!
    @IBOutlet var imgView:UIImageView!
    @IBOutlet var titleLbl:UILabel!
    @IBOutlet var presentLbl:UILabel!
    @IBOutlet var dateLbl:UILabel!
    @IBOutlet var lblAllergiesTitle:UILabel!
    
    @IBOutlet var lblGiftTitle:UILabel!
    @IBOutlet var lblGift:UILabel!
    
    @IBOutlet var childName:UILabel!
    @IBOutlet var childNameText:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
        imgView.layer.cornerRadius = 10
        imgView.clipsToBounds = true
        cellView.layer.cornerRadius = 10
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        cellView.layer.shadowOpacity = 0.5
        cellView.layer.shadowRadius = 5.0
        cellView.layer.masksToBounds = false
    }
    
}
