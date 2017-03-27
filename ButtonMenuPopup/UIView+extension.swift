//
//  UIView+extension.swift
//  ButtonMenuPopup
//
//  Created by HanJin on 2017. 3. 27..
//  Copyright © 2017년 DavidJinHan. All rights reserved.
//

import UIKit

extension UIView {

    func pauseAnimation(delay: Double) {
        let time = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, time, 0, 0, 0, { [weak self] timer in
            if let layer = self?.layer {
                let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
                layer.speed = 0.0
                layer.timeOffset = pausedTime
            }
        })
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
    }
}
