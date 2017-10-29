//
//  SocketController.swift
//  balloonTalk
//
//  Created by 和田　継嗣 on 2017/05/28.
//  Copyright © 2017年 和田　継嗣. All rights reserved.
//

import Foundation
import UIKit
import SocketIO
import SwiftyJSON
import KRProgressHUD

class SocketController: UIViewController{
    
    var socket: SocketIOClient!
    var balloons:[Balloon] = []
    
  //  var balloonViews:[UIButton] = []
    var balloonViews:[BalloonButton] = []

    
    /* UI周辺  */
    //背景画像
    //var backView:UIImageView!
    var backView:UIImageView!
    var pushButton:UIButton!
    //風船一覧
    var balloonList:[UIImage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        KRProgressHUD.show(withMessage: "バルーンを取得中")
        setBackView()
        generateBalloons()
        setPushButton()
    }
    
    
}

//画面系
extension SocketController{
    
    func setBackView(){
        backView = UIImageView(frame:self.view.frame)
        backView.image = UIImage(named:"skyback.jpg")
        self.view.addSubview(backView)
    }
    
    /* バルーンを生成し、Viewを配列にセットする。*/
    func generateBalloons(){
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        socket = appDelegate.socket
        socket.on("sendAllRoomInfo") { (resdata, emitter) in
            let dic = resdata[0] as! NSDictionary
            dic.forEach{key,value in
                
                let obj  = value as! NSDictionary
                let chatList = obj["chatList"] as! NSArray
                let title = obj["title"] as! String
                let type = obj["type"] as! String
                
                let balloonObj =  BalloonFactory.generateBalloon(
                    balloonType: type, balloonCode: key as! String,
                    balloonSize: chatList.count,baloonTitle: title
                )
                self.balloons.append(balloonObj)
            }
            self.setBalloons()
            self.moveBalloons()

        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            //3秒後にバルーン取得メソッド実行
            self.socket.emit("getAllRoomInfo",[])
        }
    }
    
    func setPushButton(){
        pushButton = UIButton(frame:CGRect(x:self.view.frame.size.width-90,y:self.view.frame.size.height-90,width:60,height:60))
        pushButton.addTarget(self, action: #selector(SocketController.openPushController), for: .touchUpInside)
        pushButton.setImage(UIImage(named:"balloonPush.png"), for: .normal)
        let titleLabel = UILabel(frame:CGRect(x:self.view.frame.size.width-90,y:self.view.frame.size.height-30,width:70,height:20))
        titleLabel.text = "バルーン作成"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 10.0)
        titleLabel.backgroundColor = UIColor.clear
        self.view.addSubview(titleLabel)
        self.view.addSubview(pushButton)
    }
    
}

extension SocketController{

        //バルーンのビューを画面に追加
    func setBalloons(){
        var index:Int = 0
        balloons.forEach{
            let balloonI = $0
            let randomX = (Int)(arc4random() % 5)+1
            let randomY = (Int)(arc4random() % 5)+1
            let baloonView = BalloonButton(frame:CGRect(x:randomX*50,y:randomY*100,width:30+balloonI.baloonSize*3,height:30+balloonI.baloonSize*3))
            baloonView.setImage(balloonI.image,for:.normal)
            baloonView.tag = index
            baloonView.setBalloonTitle(title:$0.baloonTitle)
            baloonView.setBalloonType(type: BalloonTypeEnum.getType(name: $0.balloonType))
            balloonViews.append(baloonView)
            baloonView.addTarget(self, action: #selector(self.openChatRoom(_:)), for: .touchUpInside)
            index += 1
            self.view.addSubview(baloonView)
        }
        KRProgressHUD.dismiss()
        
    }
    
    //定期的にバルーンを動かす
    func moveBalloons(){
        //バルーンを上に動かす
        balloonViews[0].layer.position = CGPoint(x: 100, y: 100)
        
        // アニメーション処理
        UIView.animate(withDuration: TimeInterval(CGFloat(3.0)),
                       animations: {() -> Void in
                        
                        // 移動先の座標を指定する.
                        self.balloonViews[0].center = CGPoint(x: self.view.frame.width/2,y: self.view.frame.height/2);
                        
        }, completion: {(Bool) -> Void in
        })
    }
    
    //チャットルームを開く
    func openChatRoom(_ sender: AnyObject){
        let buttonView = sender as! UIButton
        guard let balloon:Balloon = balloons[buttonView.tag]  else{
            return
        }
    
        let chatController = ChatShowerController()
        chatController.roomId = balloon.balloonCode
        chatController.balloonTitle = balloon.baloonTitle
        chatController.balloonType = balloon.balloonType
        self.present(chatController,animated: true,completion: nil)
    }
    
    func openPushController(){
        self.present(MakeBalloonController(), animated: true, completion: nil)
    }

}




