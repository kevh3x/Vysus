//
//  LoadingViewController.swift
//  Vysus
//
//  Created by Jacinda Eng on 7/29/19.
//  Copyright © 2019 Jacinda Eng. All rights reserved.
//

import UIKit
import Lottie

class LoadingViewController: SpeechControls {

  
    @IBOutlet weak var loadingAnimationView: AnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        speakDescription("Personalizing your images. Please hold on.")
        startAnimation(theAniView: loadingAnimationView,
                       animationName: "loading",
                       width: 300,
                       height: 300,
                       repeatNumber: .repeat(2),
                       iPhone6x: 37, iPhone6y: 170,
                       iPhone7x: 55, iPhone7y: 200,
                       iPhoneXx: 37, iPhoneXy: 260,
                       iPhoneXSMaxx: 60, iPhoneXSMaxy: 260,
                       controller: self)
       view.setGradientBackground(colorOne: #colorLiteral(red: 0.160969913, green: 0.2091391683, blue: 0.2607246339, alpha: 1), colorTwo: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }

}
