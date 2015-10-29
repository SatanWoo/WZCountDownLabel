//
//  ViewController.swift
//  WZCountDownLabel
//
//  Created by z on 15/10/28.
//  Copyright (c) 2015年 SatanWoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var label:WZCountDownLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.label = WZCountDownLabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        self.label.backgroundColor = UIColor.redColor()
        self.view.addSubview(self.label!)
        self.label.textAlignment = .Center
        
        self.label.text = "\(5)"
        self.label.countDown(from: 40, to: 2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

