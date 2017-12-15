//
//  ViewController.swift
//  SplashAnimate
//
//  Created by Hanson on 2017/12/6.
//  Copyright © 2017年 HansonStudio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var advertiseView: UIView?
    var adView: UIView? {
        didSet {
            advertiseView = adView!
            advertiseView?.frame = self.view.bounds
            self.view.addSubview(advertiseView!)
            UIView.animate(withDuration: 1.5, animations: { [weak self] in
                self?.advertiseView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self?.advertiseView?.alpha = 0
            }) { [weak self] (isFinish) in
                self?.advertiseView?.removeFromSuperview()
                self?.advertiseView = nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

