//
//  RealmDB.swift
//  balloonTalk
//
//  Created by 和田　継嗣 on 2017/06/11.
//  Copyright © 2017年 和田　継嗣. All rights reserved.
//

import Foundation
import RealmSwift

class roomTable:Object{
    static let realm = try! Realm()
    static let roomDB = roomTable()
    dynamic var id = 0
    dynamic var roomID = ""
    
    override class func primaryKey() -> String{
        return "id"
    }
    
    func saveRoom(roomId:String){
        let room = roomTable()
        room.roomID = roomId
        try! roomTable.realm.write {
            roomTable.realm.add(room)
        }
        
    }
}

class roomAuthorTable:Object{
    static let realm = try! Realm()
    static let roomDB = roomAuthorTable()
    dynamic var id = 0
    dynamic var roomID = ""
    dynamic var textID = 0
    
    
    func saveRoomText(roomId:String!,num:Int!){
        let roomObj = roomAuthorTable()
        roomObj.roomID = roomId
        roomObj.textID = num
        try! roomAuthorTable.realm.write {
            roomAuthorTable.realm.add(roomObj)
        }
    }
    
    
    func getAllRoom(roomId:String!) -> [Int]{
        let roomInfoList = roomAuthorTable.realm.objects(roomAuthorTable).filter("roomId == \(roomId)")
        var myTextList = [Int]()
        for ind in 0...roomInfoList.count{
            myTextList.append(roomInfoList[ind].textID)
            
        }
        return myTextList
    }

}
