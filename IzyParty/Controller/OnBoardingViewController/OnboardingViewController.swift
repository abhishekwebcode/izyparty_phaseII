//
//  OnboardingViewController.swift
//  Learn Nagamese
//
//  Created by Neha on 27/11/17.
//  Copyright © 2017 Neha. All rights reserved.
//

import UIKit
import AnimatedGradientView



class OnboardingViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate, UINavigationControllerDelegate, CAAnimationDelegate{

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
     @IBOutlet var imgGradient : UIImageView!
    
    @IBOutlet var collectOnBoard : UICollectionView!
    @IBOutlet var pageControl : UIPageControl!
    
     @IBOutlet var ViewSkip : UIView!
     @IBOutlet var ViewNext : UIView!
    
    @IBOutlet var btnSkip : UIButton!
    @IBOutlet var btnNext : UIButton!
    
     @IBOutlet var btnFinish : UIButton!
    @IBOutlet var bottomFinishconstnat : NSLayoutConstraint!

    
    var indexed:NSInteger!

    let arrayData=[
        ["image": "ic_birthday_card.png", "title": appConstants.appDelegate.languageSelectedStringForKey(key: "welcome") as String],
        ["image": "present.png", "title":  appConstants.appDelegate.languageSelectedStringForKey(key: "welcome1") as String],
        ["image": "todo.png", "title": appConstants.appDelegate.languageSelectedStringForKey(key: "welcome2") as String]
        ] as NSArray

   
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let animatedGradient = AnimatedGradientView(frame: UIScreen.main.bounds)
        animatedGradient.direction = .up
        animatedGradient.animationValues = [(colors: ["#2BC0E4", "#EAECC6"], .up, .axial),
                                            (colors: ["#833AB4", "#F09090", "#FCB045"], .right, .axial),
                                            (colors: ["#003973", "#E5E5BE"], .down, .axial),
                                            (colors: ["#D6E077", "#FFF200", "#FF0000"], .left, .axial)]
        imgGradient.addSubview(animatedGradient)
        
        
        indexed=0
        
        ViewSkip.layer.cornerRadius = ViewSkip.frame.size.width/2
        ViewSkip.clipsToBounds = true
        
        ViewNext.layer.cornerRadius = ViewNext.frame.size.width/2
        ViewNext.clipsToBounds = true
        
        btnFinish.layer.cornerRadius = 20
        btnFinish.layer.shadowColor = UIColor.darkGray.cgColor
        btnFinish.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        btnFinish.layer.shadowOpacity = 1.0
        btnFinish.layer.shadowRadius = 1.0
        btnFinish.layer.masksToBounds = false

        //btnFinish.clipsToBounds = true
        
        
        let nibName = UINib(nibName: "OnBoardingCollectionViewCell", bundle:nil)
        
        collectOnBoard.register(nibName, forCellWithReuseIdentifier: "OnBoardingCollectionViewCell")
        
        
        
       btnFinish.setTitle(appConstants.appDelegate.languageSelectedStringForKey(key: "finish_text") as String, for: .normal)
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool)
    {
        if flag {

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBActions
    

    
    
  override func viewDidDisappear(_ animated: Bool)
  {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled =  false
    }
    
    func pushViewController(viewController:UIViewController, animated:Bool)
    {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled =  false
    }
    
    
    
    
   
    
    
    override func viewWillAppear(_ animated: Bool)
    {
       // UIApplication.shared.statusBarStyle=UIStatusBarStyle.lightContent
      // self.navigationController?.interactivePopGestureRecognizer?.delegate = self


        

    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled =  false

        
        
    }
    
    @IBAction func FinishClick(sender: AnyObject)
    {
      
       
         DispatchQueue.main.async { [weak self] in
            let objController = LoginVC()
            self?.navigationController?.pushViewController(objController, animated: true)
        }
       
    }
        
    
    @IBAction func Next(sender: AnyObject)
    {
        
        if sender as! NSObject == btnSkip
        {
            
           // let objController = HomeViewController()
           //self.navigationController?.pushViewController(objController, animated: true)
            
             indexed=indexed-1
        }
        else
        {
            
            indexed=indexed+1
        }
        
        
       /* if indexed >= arrayData.count
        {
            
            // let objController = HomeViewController()
            //self.navigationController?.pushViewController(objController, animated: true)
            UIView.animate(withDuration: 0.5, animations: {
                
                // self.btnSkip.alpha = 1
                self.btnFinish.alpha = 1
                self.bottomFinishconstnat.constant = 17
                
            }, completion: { finished in
                
            })
            
            
        }
        else
        {*/
            if indexed == 0
            {
                UIView.animate(withDuration: 0.5, animations: {
                    
                    // self.btnSkip.alpha = 1
                    self.ViewSkip.alpha = 0
                    self.ViewNext.alpha = 1
                    
                    self.btnFinish.alpha = 0
                    self.bottomFinishconstnat.constant = -63
                    
                }, completion: { finished in
                    
                })
            }
                
            else if indexed == arrayData.count-1
            {
                
                UIView.animate(withDuration: 0.5, animations: {
                    
                    //self.btnSkip.alpha = 0
                    self.ViewNext.alpha = 0
                    self.ViewSkip.alpha = 1
                    
                   
                    
                }, completion: { finished in
                    
                })
                
                // btnSkip.isHidden=true
                //btnNext.setTitle("Got It", for: UIControl.State.normal)
                
                self.btnFinish.alpha = 1
                self.bottomFinishconstnat.constant = 17
            }
            else
            {
                
                
                UIView.animate(withDuration: 0.5, animations: {
                    
                    // self.btnSkip.alpha = 1
                    self.ViewSkip.alpha = 1
                    self.ViewNext.alpha = 1
                    
                    self.btnFinish.alpha = 0
                    self.bottomFinishconstnat.constant = -63
                    
                }, completion: { finished in
                    
                })
                
                // btnSkip.isHidden=false
                //btnNext.setTitle("Next", for: UIControl.State.normal)
            }
            
            
            collectOnBoard.scrollToItem(at: NSIndexPath.init(item: indexed, section: 0) as IndexPath, at: .right, animated: true)
            pageControl.currentPage = indexed
            
            // UpdateBackgroundImage()
            
       // }
        
    }
    
    

    
    //MARK: - Collection View Delegates
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return arrayData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell: OnBoardingCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnBoardingCollectionViewCell", for: indexPath as IndexPath) as! OnBoardingCollectionViewCell
        
        
        let dict=arrayData.object(at: indexPath.item) as! NSDictionary
        
        cell.lblTitle.text=dict["title"]! as? String
        
        let img = UIImage.init(named: (dict["image"]! as? String)!)
        
      //  cell.HeightConst.constant = (img?.size.height)!
        cell.imgonboard.image = img
        
       // UIImage img = [UIImage imageNamed:@"myImage.jpg"];
       // [imageView setImage:img];
      //  imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y,
                                  //   img.size.width, img.size.height);
        
        
       // cell.imgonboard.image=UIImage.init(named: (dict["image"]! as? String)!)
        
        //NSLog("indexfdsf %d", indexPath.item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width  , height: collectionView.frame.size.height)
        
    }
    
    
 
    
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
        for var cell in collectOnBoard.visibleCells
        {
            let indexPath:NSIndexPath = collectOnBoard.indexPath(for: cell)! as NSIndexPath
            
            
            indexed=indexPath.item
            
            UpdatePageController()
            
            NSLog("index %d", indexed)
            
            if indexPath.item == 0
            {
                UIView.animate(withDuration: 0.5, animations: {
                    
                    // self.btnSkip.alpha = 1
                    self.ViewSkip.alpha = 0
                    self.ViewNext.alpha = 1
                    
                    self.btnFinish.alpha = 0
                    self.bottomFinishconstnat.constant = -63
                    
                }, completion: { finished in
                    
                })
            }
            
           else if indexPath.item>=arrayData.count-1
            {
                
                UIView.animate(withDuration: 0.5, animations: {
                    
                   // self.btnSkip.alpha = 0
                    self.ViewNext.alpha = 0
                     self.ViewSkip.alpha = 1
                    
                   
                    
                }, completion: { finished in
                    
                })
                // btnSkip.isHidden=true
               // btnNext.setTitle("Got It", for: UIControl.State.normal)
                
                self.btnFinish.alpha = 1
                self.bottomFinishconstnat.constant = 17
                
            }
            else
            {
                
                UIView.animate(withDuration: 0.5, animations: {
                    
                   // self.btnSkip.alpha = 1
                    self.ViewSkip.alpha = 1
                      self.ViewNext.alpha = 1
                    
                    self.btnFinish.alpha = 0
                    self.bottomFinishconstnat.constant = -63
                    
                }, completion: { finished in
                    
                })
                // btnSkip.isHidden=false
               // btnNext.setTitle("Next", for: UIControl.State.normal)
            }
            
            break
        }
        
        
    }
    
    
    
    
    func UpdatePageController()
    {
        let pageWidth = collectOnBoard.frame.size.width
        let currentPage = collectOnBoard.contentOffset.x / pageWidth
        if Float(0.0) != fmodf(Float(currentPage), Float(1.0))
        {
            pageControl.currentPage = Int(currentPage) + 1
            
        }
        else
        {
            pageControl.currentPage = Int(currentPage)
        }
        
        
        print("finishPage = \(pageControl.currentPage)")
    }
    
    

}
