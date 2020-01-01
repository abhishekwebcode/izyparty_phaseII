//
//  OnBoardingCollectionViewCell.swift
//  Learn Nagamese
//
//  Created by Neha on 27/11/17.
//  Copyright © 2017 Neha. All rights reserved.
//

import UIKit

class OnBoardingCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet var imgonboard : UIImageView!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var imgonboardBoard : UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
     imgonboardBoard.layer.cornerRadius = 5
        imgonboardBoard.clipsToBounds = true
      
        
       
        
        
    }

}
