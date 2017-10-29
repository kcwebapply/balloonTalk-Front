//
//  ChatViewController.swift
//  balloonTalk
//
//  Created by 和田継嗣 on 2017/06/03.
//  Copyright © 2017年 和田　継嗣. All rights reserved.
//

import Foundation
import UIKit
import SocketIO
class ChatViewController:UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    //初期化時セット項目
    var roomId:String!
    var balloonType:String!
    var balloonTitle:String!
    
    var chatTextList:[String] = []
    
    //webSocket
    var socket:SocketIOClient!
    
    var backView:UIImageView!
    var chatTextField:UITextField!
    var sendButton:UIButton!
    var backScrollView:UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setView()
        setChat()
    }
    
    
    
}


extension ChatViewController{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // スクロール中の処理
        print("didScroll")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // ドラッグ開始時の処理
        print("beginDragging")
    }
    func setView(){
        
        //背景画像
        backView = UIImageView(frame:self.view.frame)
        backView.image = BalloonTypeEnum.getType(name: balloonType).backImage
        self.view.addSubview(backView)
        
        //scrollViewをセット
        backScrollView = UIScrollView(frame:CGRect(x:0,y:0,width:self.view.frame.size.width,height:self.view.frame.size.height-100))
        backScrollView.contentSize =  CGSize(width: self.view.frame.size.width , height: 1000)
        backScrollView.delegate = self
        self.view.addSubview(backScrollView)
        //戻るボタン
        var backButton = UIButton(frame:CGRect(x:20,y:20,width:40,height:40))
        backButton.addTarget(self, action: "back", for: .touchUpInside)
        // self.view.addSubview(backButton)
        backScrollView.addSubview(backButton)

        
        //テキストフィールド
        chatTextField = UITextField(frame:CGRect(x:30,y:self.view.frame.size.height-60,width:self.view.frame.size.width-150,height:50))
        chatTextField.text = ""
        chatTextField.layer.cornerRadius = 10.0
        chatTextField.delegate = self
        chatTextField.backgroundColor = UIColor.white
        self.view.addSubview(chatTextField)
        //送信ボタン
        sendButton = UIButton(frame:CGRect(x:self.view.frame.size.width-100,y:self.view.frame.size.height-60,width:80,height:50))
        sendButton.layer.cornerRadius = 10.0
        sendButton.addTarget(self, action: "send", for: .touchUpInside)
        
       
        sendButton.backgroundColor = BalloonTypeEnum.getType(name: self.balloonType).balloonColor
        self.view.addSubview(sendButton)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /*
     UITextFieldが編集終了する直前に呼ばれるデリゲートメソッド.
     */
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing:" + textField.text!)
        return true
    }
    
    //編集完了後（完了直後）
    private func textFieldDidEndEditing(textField: UITextField) -> Bool {
        print("textFieldDidEndEditing:" + textField.text!)
        return true
    }
    
    
    func send(){
        chatTextField.resignFirstResponder()
        socket.emit("push_Message", ["roomId":roomId,"text":chatTextField.text])
    }

}

extension ChatViewController{
    func setChat(){
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        socket = appDelegate.socket
        socket.on("send_new_Message_List") { (resdata, emitter) in
            if let message = resdata as? [[String:String]] {
                print(message[0]["value"]!)
            }
        }
        
        socket.on("sendRoomInfo"){(resdata, emitter) in
            var index = 0
            let dic = resdata[0] as! NSDictionary
            let chatList = dic["chatList"] as! NSArray
            chatList.forEach{
                self.chatTextList.append($0 as! String)
                let random = (Int)(arc4random() % 5)+1
                var chatTextView:UITextView!
                if(index % 2 == 0){
                    chatTextView = HukidasiView(frame:CGRect(x:50,y:50+index*110,width:200,height:100))
                }else{
                    
                    chatTextView = HukidasiView(frame:CGRect(x:Int(self.view.frame.size.width-250),y:50+index*110,width:200,height:100))
                    
                }
                chatTextView.font = UIFont.systemFont(ofSize: CGFloat(20))
                chatTextView.isEditable = false
                chatTextView.text = $0 as! String
                chatTextView.backgroundColor = UIColor.white
                chatTextView.layer.cornerRadius = 10.0
                // self.view.addSubview(chatTextView)
                self.backScrollView.addSubview(chatTextView)
                index += 1
            }
        }
        
        socket.emit("getRoomText",["roomId":roomId])
    }
    
    func back(){
        self.dismiss(animated: true, completion: nil)
    }
}
