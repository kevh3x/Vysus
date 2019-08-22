//
//  FirstTutorialScreenViewController.swift
//  Vysus Welcome version 3
//
//  Created by Jacinda Eng on 7/17/19.
//  Copyright © 2019 Jacinda Eng. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Speech
import Lottie
import CoreImage

class FirstTutorialScreenViewController: SpeechControls, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var upAnimationView: AnimationView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var downAnimationView: AnimationView!
    @IBOutlet weak var showButton: UIButton!
    
    //create variable that will call the likeHeartAnimation and DescribedCheck3 lottie file
    var animateview = AnimationView(name: "likeHeartAnimation")
    var checkView = AnimationView(name: "DescribedCheck3")

    var displayInfo: DisplayInfo!

    //variable that has the original image before a filter is applied
    private var originalImage: UIImage?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startAudioEngine()
        

        if let passedDelegate = UIApplication.shared.delegate as? AppDelegate {
            displayInfo = passedDelegate.display
            displayInfo.populateImage(imageView)
            
            var timer = Timer.scheduledTimer(withTimeInterval: 2.1, repeats: false) { timer in
                self.speakDescription(self.displayInfo.display(true))
                self.checkView.contentMode = .scaleAspectFit
                self.checkView.frame.size = CGSize(width: 80, height: 80)
                self.view.addSubview(self.checkView)
                
                //Wait for notification when description is changed to play the check animation
                NotificationCenter.default.addObserver(self, selector: #selector(self.playCheckAnimation), name: NSNotification.Name(rawValue: "DescriptionChanged"), object: nil)
                
                self.playCheckAnimation()
            }
            //add this code later
            timer = Timer.scheduledTimer(withTimeInterval: 35, repeats: true) { timer in
                print("RUNNING *********************************")
                self.resetEngine()
                print("Finished *********************************")
            }
        }

        //Add tap view recognizer to the first tutorial view cotroller
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTap(gesture:)))
        //enable user to make a double tap
        tapGesture.numberOfTapsRequired = 2

        view.addGestureRecognizer(tapGesture)

        let upSwipe =  UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))

        upSwipe.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(upSwipe)

        //create a function called swipegesture that can be called everytime a gesture is made
        let leftSwipe =  UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))

        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(leftSwipe)

        let rightSwipe =  UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))

        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipe)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)

        startAnimation(theAniView: upAnimationView,
                       animationName: "swipeUp",
                       width: 100,
                       height: 100,
                       repeatNumber: .loop,
                       iPhone6x: 135, iPhone6y: 105,
                       iPhone7x: 160, iPhone7y: 145,
                       iPhoneXx: 135, iPhoneXy: 175,
                       iPhoneXSMaxx: 155, iPhoneXSMaxy: 220,
                       controller: self)
        startAnimation(theAniView: upAnimationView,
                       animationName: "swipeDown",
                       width: 100,
                       height: 100,
                       repeatNumber: .loop,
                       iPhone6x: 135, iPhone6y: 465,
                       iPhone7x: 160, iPhone7y: 500,
                       iPhoneXx: 135, iPhoneXy: 530,
                       iPhoneXSMaxx: 155, iPhoneXSMaxy: 575,
                       controller: self)

        view.setGradientBackground(colorOne: #colorLiteral(red: 0.160969913, green: 0.2091391683, blue: 0.2607246339, alpha: 1), colorTwo: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    @objc func playCheckAnimation(){
        //change location of check in case image is of diferrent size
        let imageSize = imageView.contentClippingRect
        checkView.frame.origin = imageSize.origin
        var widthOffSet: CGFloat = 0
        var heightOffSet: CGFloat = 0
        //Set offset of the check based on iphone types because some dimesions are different
        if(DeviceType.isiPhoneX){
            widthOffSet = 20
            heightOffSet = 130
        }
        if(DeviceType.isiPhone7Plus){
            widthOffSet = 0
            heightOffSet = 170
        }
        if(DeviceType.isiPhone6){
            widthOffSet = 20
            heightOffSet = 200
        }
        checkView.frame = checkView.frame.offsetBy(dx: imageView.frame.width - widthOffSet, dy: imageView.frame.height - heightOffSet)

        if(displayInfo.retrieveImage().isDescribed){
        
            if(!displayInfo.retrieveImage().alredyChecked){
                //Play the animation and make sure it is not hidden
                checkView.play(fromProgress: 0, toProgress: 1, loopMode: .playOnce, completion: nil)
                displayInfo.retrieveImage().alredyChecked = true
                checkView.isHidden = false
            }else{
                //if it has been checked before just make sure it is still not hidden
                checkView.isHidden = false
            }
        }else{
            //The image is not described so don't show a check
            checkView.isHidden = true
        }
    }

    //apply chrome contrast feature
    @IBAction func applyChrome(_ sender: Any) {
        imageView.image = imageView.image?.addFilter(filter: .Chrome)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "feedToShare" {
            let controller = segue.destination as! ShareViewController
            controller.img = self.displayInfo.retrieveImage()
        }
    }

    //Create dictionary that will incorporate both swipe and voice command when user action is performed
    @objc func swipeAction(swipe:UISwipeGestureRecognizer){
        //swipe codes up:4 down:8 left:2
        //switch statement to implement swipe up once the gesture is made
        var swipeActions: [Int: String] = [2: "next", 4: "comment", 8: "share", 1: "previous"]
        let swipeChoice = Int (swipe.direction.rawValue)
        choiceHandler(swipeActions[swipeChoice] ?? "none")

    }


    override func choiceHandler(_ choice: String) {
        switch choice{
            //TODO: Connect the SEGUES here:
        // Replace the print statements with the SEGUES
        case "share":
            self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            self.keyWordUsed = false
            self.stopAudioEngine()
            confirmationEffect2.play()
            performSegue(withIdentifier: "feedToShare", sender: self)
        case "comment":
            self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            self.keyWordUsed = false
            self.stopAudioEngine()
            confirmationEffect2.play()
            performSegue(withIdentifier: "feedToComments", sender: self)
        case "next":
            self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            self.speakDescription(self.displayInfo.display(true))
            self.keyWordUsed = false
            confirmationEffect2.play()
            playCheckAnimation()
        case "previous":
            self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            self.keyWordUsed = false
            self.speakDescription(self.displayInfo.display(false))
            confirmationEffect2.play()
            playCheckAnimation()
        default:
            print("Nothing done")
        }
    }

    @IBAction func showPopoverButtonAction(_ sender: Any) {
        //Change description popover
        let button = sender as? UIButton
        let buttonFrame = button?.frame ?? CGRect.zero

        //Configure the presentation controller
        let popoverContentController = self.storyboard?.instantiateViewController(withIdentifier: "PopoverContentController") as? PopoverContentController
        popoverContentController?.modalPresentationStyle = .popover
        
        //Initial setup for popover to set its location on the view
        if let popoverPresentationController = popoverContentController?.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .up
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = buttonFrame
            popoverContentController?.preferredContentSize = CGSize(width: 300, height: 340)
            popoverPresentationController.delegate = self
            if let popoverController = popoverContentController {
                present(popoverController, animated: true, completion: nil)
            }
        }

        //Make sure to pass the image description to the popover so that it can be changed
        popoverContentController?.displayInfo = self.displayInfo
        popoverContentController?.TextView.text = self.displayInfo.retrieveImage().caption
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        //Add any functionallity after the popover is dissmised
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    //create function to call likeHeartAnimation json file
    func heartAnimation(){
        
        //enable heart animation to pop up on every image
        self.animateview.isHidden = false

        animateview.frame = view.bounds

        animateview.contentMode = .scaleAspectFit

        self.view.addSubview(animateview)

        animateview.play(completion: { (finished: Bool ) in
            //enable heart animation to disappear once it appears on a image
            self.animateview.isHidden = true
        })
    }

    //extension to enable the double tap feature to be executed
    @objc func doubleTap(gesture: UITapGestureRecognizer) {
        speakDescription("You've liked this image")
        //call the heart animation function so it can print on the screen once the screen is double tapped
        self.heartAnimation()
    }
}
