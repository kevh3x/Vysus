//
//  DisplayInfo.swift
//  Vysus
//
//  Created by JAR2K on 7/26/19.
//  Copyright © 2019 All rights reserved.
//

import UIKit
import FirebaseDatabase
import Speech
class DisplayInfo{
    var imgs:[Images] = []
    
    let synthesizer = AVSpeechSynthesizer()
    
    var myUtterance = AVSpeechUtterance(string:"")
    
    static var currentImageIndex = 0
    
    var currentDescription = ""
    
    var viewController: ViewController = ViewController()
    
    var imageView: UIImageView!
    
    //var length accounts for the number of images in the database
    var length:Int = 10
    
    var initial:Bool = true
    
    //On construction of this object an image view is passed in so that we may have access to the ViewControllers image view
    init() {
        self.populateImgsArray()
    }

    
    func populateImage(_ imgView: UIImageView) {
        self.imageView = imgView
    }
    
    func retrieveImage()->Images{
        return self.imgs[DisplayInfo.currentImageIndex]
    }
    
    func populateImgsArray()
    {
        //retrieve data from db and store in image objects array
        for i in 1...length{
            let ref = Database.database().reference()
            
            ref.child(String(i)).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let caption = value?["caption"] as? String ?? ""
                let apiCaption = value?["apiCaption"] as? String ?? ""
                let url = value?["url"] as? String ?? ""
                let isDescribed = value?["isDescribed"] as? String ?? ""
                
                let referenceID = i
                
                self.addToImages(Images.init(url,caption,apiCaption,isDescribed,referenceID))
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func speakDescription(_ description:String) {
        self.myUtterance = AVSpeechUtterance(string:description)
        
        self.myUtterance.rate = 0.5
        
        self.myUtterance.volume = 1.0
        
        self.synthesizer.speak(self.myUtterance)
    }
    
    
    
    //Adds images to the the image object array
    func addToImages(_ image:Images)
    {
        self.imgs.append(image)
    }
    
    //This function will handle all of the view functionality as well as
    //having the machine read all of the information in the caption
    
    func display(_ swipe:Bool) -> String
    {
        //Sets image index so that swipe transition goes to the next or previous image in array
        //the intial variable is set to check if the image index is the intial starting point of the array.This
        //point is special because is has very important functionality. The swipe boolean is used to check to see if the swipe
        //is going left or right.
        
        if(!swipe)
        {
            DisplayInfo.currentImageIndex = DisplayInfo.currentImageIndex == 0 ? length-1 : DisplayInfo.currentImageIndex - 1
            self.initial = false
        }else{
            if(!initial)
            {
                DisplayInfo.currentImageIndex = DisplayInfo.currentImageIndex == length-1 ?  0 : DisplayInfo.currentImageIndex + 1
            }
        }
        
     
        
        let image:Images = self.imgs[DisplayInfo.currentImageIndex]
        
        let url:URL = URL(string:image.url)!
        
        let data = try? Data(contentsOf: url)
        
        if let imageData = data {
            
            let viewImage = UIImage(data: imageData)
            
            imageView.image = viewImage!
            
        }
        else{
            print("Error getting the image. Please make sure the url is correct!")
        }
        
        self.initial = false
        
        return image.caption
        
    }
    
    
}
