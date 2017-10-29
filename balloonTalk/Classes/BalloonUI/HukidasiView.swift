//
//  HukidasiView.swift
//  balloonTalk
//
//  Created by 和田　継嗣 on 2017/06/08.
//  Copyright © 2017年 和田　継嗣. All rights reserved.
//

import Foundation
import UIKit

class HukidasiView:UITextView{
    
    let triangleSideLength: CGFloat = 20
    let triangleHeight: CGFloat = 20
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(UIColor.green.cgColor)
        contextBalloonPath(context: context!, rect: rect)
    }
    
    func contextBalloonPath(context: CGContext, rect: CGRect) {
      /*  let triangleRightCorner = (x: (rect.size.width + triangleSideLength) / 2, y: rect.maxY - triangleHeight)
        let triangleBottomCorner = (x: rect.size.width / 2, y: rect.maxY)
        let triangleLeftCorner = (x: (rect.size.width - triangleSideLength) / 2, y: rect.maxY - triangleHeight)*/
        
        let triangleRightCorner = (x: triangleSideLength, y: (rect.size.height - triangleHeight)/2)
        let triangleBottomCorner = (x:triangleSideLength, y: (rect.size.height + triangleSideLength)/2)
        let triangleLeftCorner = (x: CGFloat(0), y: rect.size.height/2)

        
        // 塗りつぶし
        context.addRect(CGRect(x:triangleSideLength, y:0, width:rect.size.width-triangleSideLength, height:rect.size.height))
        context.fillPath()
        context.move(to: CGPoint(x:triangleLeftCorner.x, y:triangleLeftCorner.y))
        context.addLine(to:CGPoint(x:triangleBottomCorner.x, y:triangleBottomCorner.y))
        context.addLine(to:CGPoint(x:triangleRightCorner.x, y:triangleRightCorner.y))
        context.fillPath()

    }
    
    
}
