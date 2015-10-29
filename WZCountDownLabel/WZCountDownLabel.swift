//
//  WZCountDownLabel.swift
//  WZCountDownLabel
//
//  Created by z on 15/10/28.
//  Copyright (c) 2015年 SatanWoo. All rights reserved.
//

import UIKit

enum WZCountDownStyle:Int {
    case EaseInOut = 0
    case EaseIn
    case EaseOut
    case Linear
};

protocol CountDownFeasible {
    var style:WZCountDownStyle {get}
}

typealias CountDownCompletion = (text:String) -> Void

class WZCountDownLabel : UILabel, CountDownFeasible {
    var style = WZCountDownStyle.EaseIn
    var completion:CountDownCompletion?
    
    var duration:NSTimeInterval = 2.5
    var startValue:Float = 0
    var endValue:Float = 0
    var progress:CFTimeInterval = 0
    var lastTime:CFTimeInterval = 0
    
    var counter:Interpolation!
    
    private var currentValue:Float {
        get {
            if (self.progress >= self.duration) {
                return self.endValue
            }
            
            let percent = self.progress / self.duration
            let newVal = self.counter.update(Float(percent))
            return self.startValue + newVal * (self.endValue - self.startValue)
        }
    }
    
    private lazy var displayLink:CADisplayLink = {
        let displayLink:CADisplayLink = CADisplayLink(
            target: self,
            selector: Selector("displayTick:")
        )
        
        return displayLink
    }()
    
    deinit {
        self.displayLink.invalidate()
    }
    
    @objc private func displayTick(time:CADisplayLink) {
        let now = self.displayLink.timestamp
        
        self.progress += now - lastTime
        self.lastTime = now
        
        self.text = "\(ceil(self.currentValue))"
        
        if (self.progress >= self.duration) {
            self.displayLink.invalidate()
            if let completion = self.completion {
                completion(text: "\(self.endValue)")
            }
        }
    }
    
    func countDown(from f:Float, to t:Float) {
        self.countDown(from: f, to: t, duration: self.duration)
    }

    func countToZero() {
        self.countDown(from: self.currentValue, to: 0, duration: self.duration)
    }
    
    func countDown(from f:Float, to t :Float, duration time:NSTimeInterval) {
        assert(f > t, "from value \(f) is smaller than \(t)")
        if (time == 0.0) {
            if let completion = self.completion {
                completion(text: "\(self.endValue)")
            }
        }
        
        self.duration = time
        self.startValue = f
        self.endValue = t
        self.progress = 0
        self.lastTime = 0
        
        switch self.style {
            case .EaseIn:
                self.counter = EaseIn()
            case .EaseOut:
                self.counter = EaseOut()
            case .Linear:
                self.counter = Linear()
            default:
                self.counter = EaseInOut()
        }
        
        self.lastTime = self.layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        
        displayLink.addToRunLoop(
            NSRunLoop.currentRunLoop(),
            forMode: NSRunLoopCommonModes
        )
    }
}
