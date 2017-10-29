//
//  ChatShowerController.swift
//  balloonTalk
//
//  Created by 和田継嗣 on 2017/07/08.
//  Copyright © 2017年 和田　継嗣. All rights reserved.
//

import Foundation
import UIKit
import SocketIO

class ChatShowerController:UIViewController,UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate{
    
    var chatList = [String]()
    var chatContentList = [ChatContent]()
    
    var chatTable:UITableView!
    //webSocket
    var socket:SocketIOClient!
    //部屋情報
    var roomId:String!
    var balloonType:String!
    var balloonTitle:String!

    //realm
    var realmCheckRoom:Int!
    
    //著者チェック用
    var roomIdList = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setChat()
    }
}

//チャット周り
extension ChatShowerController{
    
    func setView(){
        self.view.backgroundColor = UIColor.white
        //テーブルセッティング
        chatTable = UITableView(frame:CGRect(x:0,y:self.view.frame.size.height/2,width:self.view.frame.size.width,height:self.view.frame.size.height))
        chatTable.delegate = self
        chatTable.dataSource = self
        let nib = UINib(nibName: "ChatContentCell",bundle: nil)
        chatTable.register(nib, forCellReuseIdentifier: "ChatContentCell")
        self.view.addSubview(chatTable)

    }
    
    func setChat(){
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        socket = appDelegate.socket
        socket.on("send_new_Message_List") { (resdata, emitter) in
            print(resdata)
            if let message = resdata as? [[String:String]] {
                print(message[0]["value"]!)
            }
        }
        
        socket.on("sendRoomInfo"){(resdata, emitter) in
            var index = 0
            let dic = resdata[0] as! NSDictionary
            let chatList = dic["chatList"] as! NSArray
            chatList.forEach{
                self.chatList.append($0 as! String)
                let flg = self.checkAuthorFlg(num: index)
                let chatContent = ChatContent(authorFlg: flg,text: $0 as! String)
                self.chatContentList.append(chatContent)
                index += 1
            }
            self.chatTable.reloadData()
        }
        
        socket.emit("getRoomText",["roomId":roomId])
    }
    
    func setRoomIdList(roomId:String!){
        roomIdList = roomAuthorTable.roomDB.getAllRoom(roomId: roomId)
    }
    func checkAuthorFlg(num:Int!) -> Int{
        if roomIdList.index(of: num) != nil{
            return 1
        }
        return 0
    }
    
    func saveAuthorChat(num:Int!){
        
    }

}


//テーブル周り
extension ChatShowerController{
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatContentList.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatContentCell", for: indexPath as IndexPath) as! ChatContentCell
        cell.setCell(chatContent: chatContentList[indexPath.row])
        return cell
    }
}
