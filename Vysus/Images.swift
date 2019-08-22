//
//  Images.swift
//  Vysus
//
//  Created by Abshir Mohamed on 7/26/19.
//  Copyright © 2019 Jacinda Eng. All rights reserved.
//

import UIKit

class Images{
    var url: String;
    var caption: String;
    var isDescribed:Bool;
    var apiCaption:String;
    var referenceID : Int;
    var alredyChecked: Bool = false
    
    init(_ link: String,_ cap: String,_ apicap:String,_ isDes:String,_ id: Int)
    {
        url = link
        
        caption = cap
        
        apiCaption = apicap
        
        isDescribed = isDes.lowercased() == "false" ? false : true
        
        referenceID = id
    }
}
