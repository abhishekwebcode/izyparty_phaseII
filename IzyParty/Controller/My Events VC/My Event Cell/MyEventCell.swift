//
//  MyEventCell.swift
//  IzyParty
//
//  Created by iOSA on 25/09/19.
//  Copyright © 2019 iOSA. All rights reserved.
//

import UIKit

class MyEventCell: UITableViewCell {
    
    @IBOutlet var cellView:UIView!
    @IBOutlet var nameLbl:UILabel!
    @IBOutlet var dobLbl:UILabel!
    @IBOutlet var countLbl : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView.layer.cornerRadius = 10.0
        cellView.clipsToBounds  = true
        
        
        countLbl.layer.cornerRadius = countLbl.frame.size.width/2
        countLbl.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        
    }
    
}
