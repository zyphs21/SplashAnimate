//
//  AdViewController.swift
//  SplashAnimate
//
//  Created by Hanson on 2017/12/6.
//  Copyright © 2017年 HansonStudio. All rights reserved.
//

import UIKit

class AdViewController: UIViewController {

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var completion: (() -> Void)?
    
    var adImage: UIImage?
    
    var adView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var adViewHeight = (1040 / 720) * screenWidth
        var imageName = "start_page"
        if UIDevice.isiPhoneX() {
            adViewHeight = (1920 / 1124) * screenWidth
            imageName = "start_page_x"
        }
        adView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: adViewHeight))
        adView?.image = UIImage(named: imageName)
        adView?.contentMode = .scaleAspectFill
        self.view.addSubview(adView!)
        
        let bottomHolderView = UIView(frame: CGRect(x: 0, y: screenHeight-120, width: screenWidth, height: 120))
        self.view.addSubview(bottomHolderView)
            

        let logo = UIImageView(frame: CGRect(x: (screenWidth-120)/2, y: (120-50)/2, width: 120, height: 50))
        logo.image = UIImage(named: "start_logo")
        bottomHolderView.addSubview(logo)
        
        let time: TimeInterval = 1.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            self.dismissAdView()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func dismissAdView() {
        self.view.removeFromSuperview()
        self.completion?()
    }
}

extension UIDevice {
    public static func isiPhoneX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        return false
    }
}
