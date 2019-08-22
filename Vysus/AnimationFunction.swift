//
//  AnimationFunction.swift
//  Vysus
//
//  Created by Jacinda Eng on 7/30/19.
//  Copyright © 2019 Jacinda Eng. All rights reserved.
//

import Foundation
import UIKit
import Lottie

extension UIViewController {
    
    func startAnimation(theAniView: AnimationView,
                        animationName: String,
                        width: Int,
                        height: Int,
                        repeatNumber: LottieLoopMode,
                        iPhone6x: Int, iPhone6y: Int,
                        iPhone7x: Int, iPhone7y: Int,
                        iPhoneXx: Int, iPhoneXy: Int,
                        iPhoneXSMaxx: Int, iPhoneXSMaxy: Int,
                        controller: UIViewController) {
        
        let animationView = AnimationView(name: animationName)
        animationView.frame = controller.view.bounds
        animationView.contentMode = .scaleAspectFit
        controller.view.addSubview(animationView)
        animationView.play(fromProgress: animationView.currentProgress, toProgress: 1, loopMode: repeatNumber)
        animationView.frame.size =  CGSize(width: width, height: height)
        if animationName == "swipeDown" {
            //code to rotate the swipeUp animation to swipeDown
            let rotationDegrees =  180.0
             let rotationAngle = CGFloat(rotationDegrees * M_PI / 180.0)
            animationView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        }
        //create segue identifer for the loading animation
        if animationName == "loading" {
            animationView.play { (success : Bool) in
                /// Animation stopped
                self.performSegue(withIdentifier: "loadAnimationToHomeScreen", sender: self)
            }
        }
        if animationName == "check" {
           animationView.play { (success : Bool) in
                /// Animation stopped
                self.performSegue(withIdentifier: "personalizationToLoadAnimation", sender: self)
            }
        }
        //code for the constraints of the swipe up and swipe down animation depending on the iPhone model
        if DeviceType.isiPhone6 {
            animationView.frame.origin = CGPoint(x: iPhone6x, y: iPhone6y)
        } else if DeviceType.isiPhoneX {
            animationView.frame.origin = CGPoint(x: iPhoneXx, y: iPhoneXy)
        } else if DeviceType.isiPhone7Plus {
            animationView.frame.origin = CGPoint(x: iPhone7x, y:  iPhone7y)
        } else if DeviceType.isiPhoneXSMax {
            animationView.frame.origin = CGPoint(x: iPhoneXSMaxx, y:  iPhoneXSMaxy)
        }
    }
    
}

extension UIImageView{
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }
        
        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }
        
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0
        
        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}
