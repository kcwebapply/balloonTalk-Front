//
//  BalloonTypeEnum.swift
//  balloonTalk
//
//  Created by 和田　継嗣 on 2017/05/31.
//  Copyright © 2017年 和田　継嗣. All rights reserved.
//

import Foundation
import UIKit

enum BalloonTypeEnum{
    case Angry
    case Complain
    case Chat
    case Opinion
    case News
    case Hobby
    
    
    static let values = [Angry, Complain, Chat,Opinion,News,Hobby]

    var image:UIImage{
        switch self{
            case .Angry:return UIImage(named:"balloons.png")!
            case .Complain:return UIImage(named:"heart-balloon.png")!
            case .Chat: return UIImage(named:"heart-balloon.png")!
            case .Opinion: return UIImage(named:"semi-balloon.png")!
            case .News: return UIImage(named:"balloon-button.png")!
            case .Hobby:return UIImage(named:"balloons.png")!
        }

    }
    
    var backImage:UIImage{
        switch self{
        case .Angry:return UIImage(named:"cat.jpg")!
        case .Complain:return UIImage(named:"cat.jpg")!
        case .Chat: return UIImage(named:"air.jpg")!
        case .Opinion: return UIImage(named:"air.jpg")!
        case .News: return UIImage(named:"space.jpg")!
        case .Hobby:return UIImage(named:"space.jpg")!
        }

    }
    
    var balloonColor:UIColor{
        switch self{
        case .Angry:return UIColorFromRGB(0xFF5A79)
        case .Complain:return UIColorFromRGB(0xFFABD8)
        case .Chat: return UIColorFromRGB(0xFFB881)
        case .Opinion: return UIColorFromRGB(0xFFE075)
        case .News: return UIColorFromRGB(0xFC9700)
        case .Hobby:return UIColorFromRGB(0xD7F589)
        }
        
    }

    
    var getTypeString:String{
        switch self{
            case .Angry:return "Angry"
            case .Complain:return "Complain"
            case .Chat: return "Chat"
            case .Opinion: return "Opinion"
            case .News: return "News"
            case .Hobby:return  "Hobby"
        }
    }
    
    var getTypeJapanese:String{
        switch self{
        case .Angry:return "怒り"
        case .Complain:return "不満"
        case .Chat: return "雑談"
        case .Opinion: return "意見"
        case .News: return "時事"
        case .Hobby:return  "趣味"
        }
    }

    
    static func getType(name:String) -> BalloonTypeEnum{
        return BalloonTypeEnum.values.filter{$0.getTypeString==name}.first!
    }
    
    static func getAllBalloon() -> [BalloonTypeEnum]{
        return values
    }
    
    func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }


}
