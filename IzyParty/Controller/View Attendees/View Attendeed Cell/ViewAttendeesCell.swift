//
//  ParticipantsCell.swift
//  IzyParty
//
//  Created by iOSA on 30/09/19.
//  Copyright © 2019 iOSA. All rights reserved.
//

import UIKit

class ViewAttendeesCell: UITableViewCell {

    @IBOutlet var cellView:UIView!
    @IBOutlet var nameLbl:UILabel!
    @IBOutlet var phoneLbl:UILabel!
    @IBOutlet var imgView:UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        imgView.layer.cornerRadius = 10
        imgView.clipsToBounds = true
        cellView.layer.cornerRadius = 10
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        cellView.layer.shadowOpacity = 0.5
        cellView.layer.shadowRadius = 5.0
        cellView.layer.masksToBounds = false
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        
    }
    
}
