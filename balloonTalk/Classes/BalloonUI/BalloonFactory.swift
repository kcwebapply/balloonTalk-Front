//
//  File.swift
//  balloonTalk
//
//  Created by 和田　継嗣 on 2017/05/31.
//  Copyright © 2017年 和田　継嗣. All rights reserved.
//

import Foundation

class BalloonFactory{
    static func generateBalloon(balloonType:String,balloonCode:String!,balloonSize:Int!,baloonTitle:String!) -> Balloon{
        
        var balloonEnum = BalloonTypeEnum.getType(name: balloonType)
        return Balloon(
            image: balloonEnum.image,
            balloonType: balloonEnum.getTypeString,
            balloonCode: balloonCode,
            balloonSize: balloonSize,
            baloonTitle:baloonTitle
        )
    }
}
