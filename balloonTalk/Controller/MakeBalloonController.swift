//
//  MakeBalloonController.swift
//  balloonTalk
//
//  Created by 和田継嗣 on 2017/06/04.
//  Copyright © 2017年 和田　継嗣. All rights reserved.
//

import Foundation
import UIKit
import SocketIO

class MakeBalloonController:UIViewController,UITextFieldDelegate{
    
    
    //テキスト欄
    var titleTextField:UITextField!
    var sendButton:UIButton!
    
    var balloonType:BalloonTypeEnum = BalloonTypeEnum.Chat
    
    let balloons = BalloonTypeEnum.getAllBalloon()
    
    //バルーン
    var balloonPreView:UIImageView!
    var balloonBackImage:UIImageView!
    
    //ソケット
    var socket:SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureObserver()
        self.view.backgroundColor = UIColor.white
        setBalloonPreView()
        setBalloonList()
        setTextView()
        setBackButton()
    }
    
    
    
    
    
    func setBalloonList(){
        var i:Int = 0
        var x = (self.view.frame.size.width/2+10)
        var y = self.view.frame.size.height/2-50
        let buttonWidth = self.view.frame.size.width/4-20
        let buttonHeight = CGFloat(40.0)
        
        for i in 0...balloons.count-1{
            let keisu = (CGFloat)(i % 2)
            let warizan = (CGFloat(i/2))
            var balloonButton:UIButton!
            balloonButton = UIButton(frame:CGRect(
                    x:x+keisu*(buttonWidth+10),
                    y:y+warizan*(buttonHeight+10),
                    width:buttonWidth,height:CGFloat(buttonHeight))
            )
            balloonButton.tag = i
            balloonButton.setTitle(balloons[i].getTypeJapanese, for: .normal)
            balloonButton.layer.cornerRadius = 10.0
            balloonButton.addTarget(self, action: #selector(self.changeBalloonType(_:)), for: .touchUpInside)
            balloonButton.backgroundColor = balloons[i].balloonColor
            self.view.addSubview(balloonButton)
        }
    }
    
    
    func setBalloonPreView(){
        //balloon背景
        balloonBackImage = UIImageView(frame:self.view.frame)
        balloonBackImage.image = balloonType.backImage
        self.view.addSubview(balloonBackImage)
        
        //balloonPreview
        balloonPreView = UIImageView(frame:CGRect(x:30,y:self.view.frame.size.height/2-50,width:self.view.frame.size.width/2-60,height:self.view.frame.size.width/2-60))
        balloonPreView.image = balloonType.image
        self.view.addSubview(balloonPreView)
        
    }
    func setTextView(){
        //タイトル入力欄
        titleTextField =  UITextField(frame:CGRect(x:30,y:self.view.frame.size.height-60,width:self.view.frame.size.width-150,height:50))
        titleTextField.text = ""
        titleTextField.layer.cornerRadius = 10.0
        titleTextField.delegate = self
        titleTextField.backgroundColor = UIColor.white
        self.view.addSubview(titleTextField)
        //入力ボタン
        sendButton = UIButton(frame:CGRect(x:self.view.frame.size.width-100,y:self.view.frame.size.height-60,width:80,height:50))
        sendButton.layer.cornerRadius = 10.0
        sendButton.addTarget(self, action: "confirmOk", for: .touchUpInside)
        sendButton.backgroundColor = UIColorFromRGB(0x3333FF)
        self.view.addSubview(sendButton)

    }
    
    func setBackButton(){
        var backButton = UIButton(frame:CGRect(x:40,y:40,width:40,height:40))
        backButton.setImage(UIImage(named:"previous.png"), for: .normal)
        backButton.addTarget(self, action: "back", for: .touchUpInside)
        self.view.addSubview(backButton)
    }
    
    func back(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func confirmOk(){
        var text = titleTextField.text
        titleTextField.resignFirstResponder()
        let appearance = SCLAlertView.SCLAppearance(
            showCircularIcon: true
        )
        var alertView = SCLAlertView(appearance:appearance)
        alertView.checkCircleIconImage(balloonType.image, defaultImage: balloonType.image)
        alertView.appearance.showCloseButton = true
        alertView.title = "バルーンを飛ばしますか？"
        alertView.addButton("射出", backgroundColor: self.balloonType.balloonColor) {
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            self.socket = appDelegate.socket
            self.socket.emit("createRoomInfo", ["title":text,"type":self.balloonType.getTypeString])
            self.back()
        }
        alertView.appearance.circleBackgroundColor = UIColorFromRGB(0xFF3399)
        alertView.appearance.contentViewColor = UIColorFromRGB(0xFF3399)
        alertView.viewColor = self.balloonType.balloonColor
        alertView.showEdit("\(self.balloonType.getTypeJapanese)のバルーンを飛ばしますか？", subTitle: "タイトル：\(text!)", circleIconImage: self.balloonType.image)
    }
    
    func changeBalloonType(_ sender: AnyObject){
        let button = sender as! UIButton
        let balloon = balloons[button.tag]
        self.balloonType = balloon
        self.balloonPreView.image = balloon.image
        self.balloonBackImage.image = balloon.backImage
        
    }
    
    
    
}

extension MakeBalloonController{
    
    // Notificationを設定
    func configureObserver() {
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Notificationを削除
    func removeObserver() {
        
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
    func keyboardWillShow(notification: Notification?) {
        
        let rect = (notification?.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            let transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
            self.view.transform = transform
            
        })
    }
    
    // キーボードが消えたときに、画面を戻す
    func keyboardWillHide(notification: Notification?) {
        
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            
            self.view.transform = CGAffineTransform.identity
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.removeObserver() // Notificationを画面が消えるときに削除
    }

}

