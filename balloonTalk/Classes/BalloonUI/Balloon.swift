//
//  Balloon.swift
//  balloonTalk
//
//  Created by 和田　継嗣 on 2017/05/31.
//  Copyright © 2017年 和田　継嗣. All rights reserved.
//

import Foundation
import UIKit

class Balloon:NSObject{
    var image:UIImage!
    var balloonType:String!
    var balloonCode:String!
    var baloonSize:Int!
    
    var baloonTitle:String!
    
    init(image:UIImage!,balloonType:String!,balloonCode:String!,balloonSize:Int!,baloonTitle:String!){
        self.image = image
        self.balloonType = balloonType
        self.balloonCode = balloonCode
        self.baloonSize = balloonSize
        self.baloonTitle = baloonTitle
    }
}
