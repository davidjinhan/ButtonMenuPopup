//
//  ButtonsBackgroundView.swift
//  ButtonMenuPopup
//
//  Created by HanJin on 2017. 3. 27..
//  Copyright © 2017년 DavidJinHan. All rights reserved.
//

import UIKit

class ButtonsBackgroundView: UIView {

    private var numberOfCircles: Int!
    private var columns: Int!
    private var borderCircleSize: CGFloat!
    private var cellWidth: CGFloat!
    private var cellHeight: CGFloat!
    
    private var circleLayer: CAShapeLayer?
    
    private var circleContainerHeight: CGFloat = 0
    private var iconCircleSize: CGFloat = 0
    
    init(numberOfCircles: Int, columns: Int, borderCircleSize: CGFloat, cellWidth: CGFloat, cellHeight: CGFloat) {
        super.init(frame: CGRect.zero)
        
        self.numberOfCircles = numberOfCircles
        self.columns = columns
        self.borderCircleSize = borderCircleSize
        self.cellWidth = cellWidth
        self.cellHeight = cellHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawBorderCircle(withCircleContainerHeight circleContainerHeight: CGFloat, iconCircleSize: CGFloat) {
        if self.circleContainerHeight != circleContainerHeight || self.iconCircleSize != iconCircleSize {
            self.circleContainerHeight = circleContainerHeight
            self.iconCircleSize = iconCircleSize
            
            circleLayer?.removeFromSuperlayer()
            circleLayer = CAShapeLayer()
            let radius = borderCircleSize / 2
            var circleCenterY = (cellHeight - circleContainerHeight) / 2 + iconCircleSize / 2
            let path = UIBezierPath()
            for index in 0..<numberOfCircles {
                let columnIndex = index % columns
                let center = CGPoint(x: cellWidth * CGFloat(columnIndex) + cellWidth / 2, y: circleCenterY)
                var circleStart = center
                circleStart.x += radius
                path.move(to: circleStart)
                path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
                if columnIndex == columns - 1 {
                    circleCenterY += cellHeight
                }
            }
            circleLayer?.path = path.cgPath
            circleLayer?.strokeColor = UIColor.lightGray.cgColor
            circleLayer?.lineWidth = 1
            circleLayer?.fillColor = UIColor.clear.cgColor
            circleLayer?.lineDashPattern = [4, 4]
            layer.addSublayer(circleLayer!)
        }
    }
}
