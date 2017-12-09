//
//  OSGradientView.swift
//  PerfectiOS
//
//  Created by swae on 2017/12/9.
//  Copyright © 2017年 swae. All rights reserved.
//

import UIKit

@IBDesignable
class OSGradientView: UIView {

    @IBInspectable var topColor: UIColor = UIColor.black
    @IBInspectable var bottomColor: UIColor = UIColor.clear
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [topColor.cgColor, bottomColor.cgColor]
        let locations: [CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        let startPoint : CGPoint = CGPoint(x: rect.width/2.0, y: 0)
        let endPoint : CGPoint = CGPoint(x: rect.width/2.0,y: rect.height)
        context?.drawLinearGradient(gradient!,start: startPoint, end: endPoint, options: .drawsBeforeStartLocation);
    }
}
