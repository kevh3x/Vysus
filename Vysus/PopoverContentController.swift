//
//  PopoverContentController.swift
//  Vysus
//
//  Created by Rashad Jaraysa on 7/29/19.
//  Copyright © 2019 Jacinda Eng. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class PopoverContentController: UIViewController {
    
    @IBOutlet weak var TextView: UITextView!
    
    var displayInfo: DisplayInfo!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func SubmitBtnAction(_ sender: UIButton) {
        
        //Setup up connection to database so that description is updated with the new one
        let ref = Database.database().reference()
        
        //Only update the description of the current image being displayed
        let currentImage = self.displayInfo.retrieveImage()
        currentImage.caption = TextView.text
        currentImage.isDescribed = true
        
        print("New caption is: \(currentImage.caption)")
        let updates = ["\(currentImage.referenceID)/caption": currentImage.caption,"\(currentImage.referenceID)/isDescribed": "true"] as [String : Any]
        
        ref.updateChildValues(updates)
        
        self.dismiss(animated: true, completion: {NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DescriptionChanged"), object: nil)})
    }
}

