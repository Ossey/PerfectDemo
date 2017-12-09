//
//  UIView+Animation.swift
//  PerfectiOS
//
//  Created by swae on 2017/12/9.
//  Copyright © 2017年 swae. All rights reserved.
//

import UIKit

let OSCircularAnimationHideWhenFinishedKey = "OSCircularAnimationHideWhenFinishedKey"

extension UIView: CAAnimationDelegate {
    
    //MARK: - Base animation methods
    class func animationFade(directionFade fade: Bool) -> CABasicAnimation {
        let animFade = CABasicAnimation(keyPath: "opacity")
        animFade.fromValue = fade ? 1.0 : 0.0
        animFade.toValue = fade ? 0.0 : 1.0
        animFade.duration = OSConstans.animationDuration
        return animFade
    }
    
    func animationMoveUp(_ directionUp: Bool, andHide hide: Bool) {
        let isCurrentlyHidden = self.alpha == 0
        
        guard hide != isCurrentlyHidden else {
            return
        }
        
        self.layer.removeAllAnimations()
        self.alpha = hide ? 0.0 : 1.0
        
        let animMove = CABasicAnimation(keyPath: "position.y")
        var newPosition = self.center.y
        if (directionUp) {
            newPosition -= 2 * self.frame.size.height
        } else {
            newPosition += 2 * self.frame.size.height
        }
        animMove.fromValue = hide ? self.center.y : newPosition
        animMove.toValue = hide ? newPosition : self.center.y
        
        let animGroup = CAAnimationGroup()
        animGroup.animations = [animMove, UIView.animationFade(directionFade:hide)]
        animGroup.duration = OSConstans.animationDuration
        self.layer.add(animGroup, forKey: nil)
    }
    
    func animationCircular(directionShow show: Bool, startPoint: CGPoint) {
        if show != isHidden {
            return
        }
        self.layer.removeAllAnimations()
        self.isHidden = false
        
        let initialRect = CGRect(x: startPoint.x, y: startPoint.y, width: 0, height: 0)
        let initialPath = UIBezierPath(ovalIn: initialRect).cgPath
        
        var h = self.frame.size.height - initialRect.maxY
        h = max(initialRect.maxY, h)
        
        var w = self.frame.size.width - initialRect.maxX
        w = max(initialRect.maxX, w)
        
        let radius = sqrt((h * h) + (w * w))
        let finalParh = UIBezierPath(ovalIn: initialRect.insetBy(dx: -radius, dy: -radius)).cgPath
        
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = (show ? initialPath : finalParh)
        maskLayerAnimation.toValue = (show ? finalParh : initialPath)
        maskLayerAnimation.duration = OSConstans.animationDuration
        
        if !show {
            maskLayerAnimation.delegate = self
            maskLayerAnimation.setValue(false, forKey: OSCircularAnimationHideWhenFinishedKey)
        }
        
        let maskLayer = CAShapeLayer()
        maskLayer.add(maskLayerAnimation, forKey: nil)
        
        maskLayer.path = (show ? finalParh : initialPath)
        self.layer.mask = maskLayer
    }
    
    //MARK: - Convenience methods
    
    func animationFade(directionFade fade:Bool) {
        self.layer.add(UIView.animationFade(directionFade:fade), forKey: nil)
        self.alpha = fade ? 0 : 1
    }
    
    func animationCircular(directionShow show: Bool) {
        self.animationCircular(directionShow: show, startTop: true)
    }
    
    /**
     * if startTop - false - animation begin from bottom
     */
    func animationCircular(directionShow show: Bool, startTop: Bool) {
        var startPoint = CGPoint(x: self.bounds.width/2.0, y: 0)
        if !startTop  {startPoint.y = self.bounds.height}
        self.animationCircular(directionShow: show, startPoint: startPoint)
    }
    
    //MARK: - CAAnimation Delegate
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if (anim.value(forKey: OSCircularAnimationHideWhenFinishedKey) != nil) {
            self.isHidden = true
        }
    }
}
