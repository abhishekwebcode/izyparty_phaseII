//
//  MyTo-DoCell.swift
//  IzyParty
//
//  Created by iOSA on 02/10/19.
//  Copyright © 2019 iOSA. All rights reserved.
//

import UIKit

class GiftsCell: UITableViewCell {
    
    
    @IBOutlet var LblToDo:UILabel!
    @IBOutlet var btnCheck:UIButton!
    @IBOutlet var btnDelete:UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    

   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
  
    
}
