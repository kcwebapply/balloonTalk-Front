//
//  ChatContentCell.swift
//  balloonTalk
//
//  Created by 和田継嗣 on 2017/07/08.
//  Copyright © 2017年 和田　継嗣. All rights reserved.
//

import Foundation
import UIKit

class ChatContentCell:UITableViewCell{
    
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var respButton: UIButton!
    
    let imageArray = ["cy.png","balloons.png"]
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    func setCell(chatContent:ChatContent){
        self.authorImageView.image = setIconImage(authorflg: chatContent.authorFlg)
        self.contentTextView.isUserInteractionEnabled = false
        self.contentTextView.text = chatContent.text
        self.respButton.setImage(UIImage(named:"back.png"), for: .normal)
    }
    
    func setIconImage(authorflg:Int!) -> UIImage{
        return UIImage(named:"cy.png")!//UIImage(named:imageArray[userId])!
    }
    
    
    
}
