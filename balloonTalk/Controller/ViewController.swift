//
//  ViewController.swift
//  balloonTalk
//
//  Created by 和田　継嗣 on 2017/05/26.
//  Copyright © 2017年 和田　継嗣. All rights reserved.
//

import UIKit
import KRProgressHUD
import SocketIO
import SwiftyJSON

class ViewController: UIViewController, UITextFieldDelegate {
    var socket: SocketIOClient!
    
    var chatTextArea:UITextView!
    
    var chatTextField:UITextField!
    
    var button:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextField()
        setSocket()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func setTextField(){
        button = UIButton(frame:CGRect(x:self.view.frame.size.width-100,y:50,width:80,height:50))
        button.addTarget(self, action: "send", for: .touchUpInside)
        button.backgroundColor = UIColor.blue
        self.view.addSubview(button)
        
        chatTextField = UITextField(frame:CGRect(x:50,y:50,width:self.view.frame.size.width-150,height:50))
        chatTextField.backgroundColor = UIColor.yellow
        // 表示する文字を代入する.
        chatTextField.text = ""
        // Delegateを設定する.
         chatTextField.delegate = self
        
        // Viewに追加する.
        self.view.addSubview(chatTextField)
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
        var text = chatTextField.text
        chatTextField.resignFirstResponder()
        socket.emit("from_client",["text": text])
    }
    
    func setSocket(){
        chatTextArea = UITextView(frame:CGRect(x:self.view.frame.size.width/2-100,y:self.view.frame.size.height/2-200,width:200,height:400))
        chatTextArea.isUserInteractionEnabled = false
        chatTextArea.backgroundColor = UIColor.brown
        self.view.addSubview(chatTextArea)
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        socket = appDelegate.socket
        socket.on("from_server") { (resdata, emitter) in
            if let message = resdata as? [[String:String]] {
                print(message[0]["value"]!)
               self.chatTextArea.text = self.chatTextArea.text.appending(message[0]["value"]!)
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

