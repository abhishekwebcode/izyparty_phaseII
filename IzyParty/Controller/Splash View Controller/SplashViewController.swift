//
//  SplashViewController.swift
//  IzyParty
//
//  Created by Apple on 07/10/19.
//  Copyright © 2019 neha. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        showLangAlert()
    }


    func showLangAlert() {
        let alert = UIAlertController(title: nil, message: "Please select your language",         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Anglais (ENGLISH)", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
            appConstants.appDelegate.setLang(strValue: "EN")
            appConstants.appDelegate.loadLanguageData()
            appConstants.appDelegate.OpenOnboardScreen()
            
        }))
        alert.addAction(UIAlertAction(title: "Français (FRENCH)",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        appConstants.appDelegate.setLang(strValue: "FR")
                                        appConstants.appDelegate.loadLanguageData()
                                        appConstants.appDelegate.OpenOnboardScreen()
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
