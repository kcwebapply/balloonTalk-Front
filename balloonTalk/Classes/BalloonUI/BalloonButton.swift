//
//  BalloonButton.swift
//  balloonTalk
//
//  Created by 和田継嗣 on 2017/06/04.
//  Copyright © 2017年 和田　継嗣. All rights reserved.
//

import Foundation
import UIKit


class BalloonButton:UIButton{
    
    var balloonTitle:String!
    var balloonType:BalloonTypeEnum!
    
    var textView:UITextView!
    
    var touchChecker:Int = 0
    
    override init(frame:CGRect){
        super.init(frame:frame)
        //textView
        let commentXPos = self.frame.size.width/2
        let commentYPos =  self.frame.size.height
        textView = UITextView(frame:CGRect(x:commentXPos,y:commentYPos,width:150,height:30))
        textView.layer.cornerRadius = 10.0
        textView.isEditable = false
        textView.text = balloonTitle
    }
    
    func setBalloonTitle(title:String!){
        balloonTitle = title
        self.textView.text = title
    }
    
    func setBalloonType(type:BalloonTypeEnum){
        self.balloonType = type
        textView.backgroundColor = self.balloonType.balloonColor
        textView.textColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchChecker += 1
        if(touchChecker == 1){
            self.addSubview(textView)
        }else if(touchChecker > 1){
            textView.removeFromSuperview()
            super.touchesBegan(touches, with: event)
            touchChecker = 0
        }
    }
  }
