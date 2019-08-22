//
//  PersonalizationViewController.swift
//  Vysus Welcome version 3
//
//  Created by Jacinda Eng on 7/16/19.
//  Copyright © 2019 Jacinda Eng. All rights reserved.
//

import UIKit
import Speech
import Lottie

class PersonalizationViewController: SpeechControls {
    @IBOutlet weak var checkMarkAnimationView: AnimationView!
    var listOfChoices: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        
        speakDescription("Please tell us at least five things you like.")
        startAudioEngine()
        
        //create a function called swipegesture that can be called everytime a gesture is made
        let leftSwipe =  UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(leftSwipe)
        
        view.setGradientBackground(colorOne: #colorLiteral(red: 0.160969913, green: 0.2091391683, blue: 0.2607246339, alpha: 1), colorTwo: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        
    }
    
    //Create dictionary that will incorporate both swipe and voice command when user action is performed
    @objc func swipeAction(swipe:UISwipeGestureRecognizer){
        var swipeActions: [Int: String] = [2: "next", 1: "previous"]
        let swipeChoice = Int (swipe.direction.rawValue)
        choiceHandler(swipeActions[swipeChoice] ?? "none")
        
    }
        
        
        
    override func keyWordChecker(_ audio: String,_ choice: String) {
        if(!self.synthesizer.isSpeaking) {
            self.choiceHandler(choice)
        }
    }
    

    
        override func choiceHandler(_ choice: String) {
            self.listOfChoices.append(choice)
            // TODO:Create a set that holds all our tags to check if given tags are part of set.
            if(self.listOfChoices.count == 12 || choice == "next" ) {
                confirmationEffect2.play()
                self.stopAudioEngine()
                self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
                startAnimation(theAniView: checkMarkAnimationView,
                                    animationName: "check",
                                    width: 200,
                                    height: 200,
                                    repeatNumber: .repeat(1),
                                    iPhone6x: 90, iPhone6y: 425,
                                    iPhone7x: 110, iPhone7y: 470,
                                    iPhoneXx: 85, iPhoneXy: 525,
                                    iPhoneXSMaxx: 110, iPhoneXSMaxy: 555,
                                    controller: self)
            }
        }
        
        
}
