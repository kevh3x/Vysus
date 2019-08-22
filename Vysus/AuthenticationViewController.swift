//
//  AuthenticationViewController.swift
//  Vysus
//
//  Created by Keneisha Wiggan on 7/25/19.
//  Copyright © 2019 Jacinda Eng. All rights reserved.
//

import UIKit
import Speech

class AuthenticationViewController: SpeechControls {
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        speakDescription("How would you like to sign up? Say Email, Google, Facebook, or Instagram to log in.")
        startAudioEngine()
        
        //create a function called swipegesture that can be called everytime a gesture is made
        let leftSwipe =  UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(leftSwipe)
        
        
        //right feature to go back to home screen
        let rightSwipeOne =  UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        
        rightSwipeOne.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipeOne)
        view.setGradientBackground(colorOne: #colorLiteral(red: 0.160969913, green: 0.2091391683, blue: 0.2607246339, alpha: 1), colorTwo: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        
       
    }
    
    override func keyWordChecker(_ audio: String,_ choice: String) {
        if (!self.synthesizer.isSpeaking) {
            self.choiceHandler(choice)
        }
    }
    
    //Create dictionary that will incorporate both swipe and voice command when user action is performed
    @objc func swipeAction(swipe:UISwipeGestureRecognizer){
        var swipeActions: [Int: String] = [2: "next", 1: "previous"]
        let swipeChoice = Int (swipe.direction.rawValue)
        choiceHandler(swipeActions[swipeChoice] ?? "none")
        
        
        
    }
    
    override func choiceHandler(_ choice: String) {
        
        switch choice {
        case "email":
            confirmationEffect2.play()
            self.stopAudioEngine()
            self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            performSegue(withIdentifier: "authToLikes", sender: self)
        case "facebook":
            confirmationEffect2.play()
            self.stopAudioEngine()
            self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            performSegue(withIdentifier: "authToLikes", sender: self)
        case "instagram":
            confirmationEffect2.play()
            self.stopAudioEngine()
            self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            performSegue(withIdentifier: "authToLikes", sender: self)
        case "next":
            confirmationEffect2.play()
            self.stopAudioEngine()
            speakDescription("You have skipped log in")
            self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            performSegue(withIdentifier: "authToLikes", sender: self)
        case "previous":
            self.keyWordUsed = false
            self.stopAudioEngine()
            confirmationEffect2.play()
            self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            //enable user to swipe right back to main view controller
            performSegue(withIdentifier: "RightSwipeBackToMainPage", sender: self)
        default:
            print("AuthenticationViewController: User speaking")
        }
    }
    
    
    
}

