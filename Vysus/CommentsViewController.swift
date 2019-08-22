//
//  CommentsViewController.swift
//  Vysus Welcome version 3
//
//  Created by Jacinda Eng on 7/23/19.
//  Copyright © 2019 Jacinda Eng. All rights reserved.
//

import UIKit
import Speech
class CommentsViewController: SpeechControls {
    @IBOutlet weak var firstComment: UITextView!
    @IBOutlet weak var secondComment: UITextView!
    @IBOutlet weak var thirdComment: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //code getting notified whether to show or hide keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //makes the comments textView uneditable
        firstComment.isEditable = false
        secondComment.isEditable = false
        thirdComment.isEditable = false
        
        speakDescription("This is the comments page. If you would like to read comments say read comments. If you would like to add a comment say add comment")
        
        let timer = Timer.scheduledTimer(withTimeInterval: 9, repeats: false) { timer in
            if (!self.synthesizer.isSpeaking)
            {
                self.startAudioEngine()
            }
        }
        
        //create a function called swipegesture that can be called everytime a gesture is made
        let downSwipeTwo =  UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        
        downSwipeTwo.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(downSwipeTwo)
        
        
        
    }
    
    //code to show/hide keyboard and moving the UITextField up when the keyboard shows so the user can see what they are typing
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    override func keyWordChecker(_ audio: String,_ choice: String) {
        if (!self.synthesizer.isSpeaking) {
            self.choiceHandler(choice)
        }
    }
    
    //Create dictionary that will incorporate both swipe and voice command when user action is performed
    @objc func swipeAction(swipe:UISwipeGestureRecognizer){
        var swipeActions: [Int: String] = [8: "home"]
        let swipeChoice = Int (swipe.direction.rawValue)
        choiceHandler(swipeActions[swipeChoice] ?? "none")
    }
    
    override func choiceHandler(_ choice: String) {
        switch choice {
            //create the case that will enable the user to return to home page after posting a comment via swipe
        case "home":
            self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            self.stopAudioEngine()
            speakDescription("You have returned to homepage")
            
            performSegue(withIdentifier: "commentsToFeed", sender: self)
        case "read":
            self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            //Run read comments Function Putting Reading comments decription there as place holder for future
            //features
            confirmationEffect2.play()
            speakDescription("Reading Comments")
            
            self.performSegue(withIdentifier: "commentsToFeed", sender: self)
            
        case "add":
            self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            //Run add comments Function Putting Reading comments decription there as place holder for future
            //features
            confirmationEffect2.play()
            speakDescription("Adding Comments")
            self.performSegue(withIdentifier: "commentsToFeed", sender: self)
        default:
            break
        }
    }
    
    
    
}
