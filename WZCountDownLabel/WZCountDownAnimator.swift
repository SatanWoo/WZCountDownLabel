//
//  WZCountDownAnimator.swift
//  WZCountDownLabel
//
//  Created by z on 15/10/28.
//  Copyright (c) 2015年 SatanWoo. All rights reserved.
//

import UIKit

let WZCountRate:Float = 3.0

protocol Interpolation {
    func update(val:Float) -> Float;
}

struct Linear:Interpolation {
    func update(val: Float) -> Float {
        return val
    }
}

struct EaseIn:Interpolation {
    func update(val: Float) -> Float {
        return powf(val, WZCountRate)
    }
}

struct EaseOut:Interpolation {
    func update(val: Float) -> Float {
        return 1 - powf((1 - val), WZCountRate)
    }
}

struct EaseInOut:Interpolation {
    func update(val: Float) -> Float {
        var sign:Float = 1
        let r = Int(WZCountRate)
        
        if (r % 2 == 0) {
           sign = -1
        }
        
        var t = val * 2
        if (t < 1) {
            return 0.5 * powf(t, WZCountRate)
        } else {
            return 0.5 * (powf(t - 2.0, WZCountRate) + sign * 2) * sign
        }
    }
}
