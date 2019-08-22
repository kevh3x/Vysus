//
//  ShareViewController.swift
//  Vysus Welcome version 3
//
//  Created by Jacinda Eng on 7/23/19.
//  Copyright © 2019 Jacinda Eng. All rights reserved.
//

import UIKit
import Speech
import FirebaseDatabase

class ShareViewController: SpeechControls{
    
    @IBOutlet weak var imageView: UIImageView!
    
    var img:Images!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url:URL = URL(string:self.img.url)!
        
        let data = try? Data(contentsOf: url)
        
        if let imageData = data {
            let viewImage = UIImage(data: imageData)
            imageView.image = viewImage!
        }
        
        speakDescription("Would you like to share this image?")
        
        let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
            if (!self.synthesizer.isSpeaking)
            {
                self.startAudioEngine()
            }
        }
        
        //create a function called swipegesture that can be called everytime a gesture is made
        let upSwipeTwo =  UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        
        upSwipeTwo.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(upSwipeTwo)
    }
    
    override func keyWordChecker(_ audio: String,_ choice: String) {
        if (!self.synthesizer.isSpeaking) {
            self.choiceHandler(choice)
        }
    }
    
    //Create dictionary that will incorporate both swipe and voice command when user action is performed
    @objc func swipeAction(swipe:UISwipeGestureRecognizer){
        var swipeActions: [Int: String] = [4: "returnHomeFromShare"]
        let swipeChoice = Int (swipe.direction.rawValue)
        choiceHandler(swipeActions[swipeChoice] ?? "none")
        performSegue(withIdentifier: "shareToFeed", sender: self)
    }
      
    override func choiceHandler(_ choice: String){
        switch choice {
        
        case "returnHomeFromShare":
            self.stopAudioEngine()
            speakDescription("You have returned to homepage")
        case "yes":
            confirmationEffect2.play()
            speakDescription("Your image was shared.")
            performSegue(withIdentifier: "shareToFeed", sender: self)
        case "no":
            confirmationEffect2.play()
            speakDescription("Returning back to your feed")
            performSegue(withIdentifier: "shareToFeed", sender: self)
        default:
            break
        }
    }
    
}
