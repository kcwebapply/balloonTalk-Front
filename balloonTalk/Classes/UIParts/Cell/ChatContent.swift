//
//  ChatContent.swift
//  balloonTalk
//
//  Created by 和田継嗣 on 2017/07/09.
//  Copyright © 2017年 和田　継嗣. All rights reserved.
//

import Foundation
import UIKit

class ChatContent:NSObject{
    var authorFlg = 1
    var text = ""
    var responseNumber = 0
    
    init(authorFlg:Int!,text:String!){
       self.authorFlg = authorFlg
       self.text = text
    }
}
