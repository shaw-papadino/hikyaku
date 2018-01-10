//
//  userData.swift
//  Hikyaku
//
//  Created by 岡山将也 on 2018/01/04.
//  Copyright © 2018年 shouya.okayama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class userData: NSObject {
    var id : String?
    var name: String?
    var ido: Double?
    var keido: Double?
    var imageString: String?
    var image: UIImage?
    var friends: [String]? = []
    var send: [String]? = []
    var receve: [String]? = []
    
    init(snapshot: DataSnapshot, myId: String) {
        self.id = snapshot.key
        
        let valueDictionary = snapshot.value as! [String: AnyObject]
        
        //プロフィール画像
        imageString = valueDictionary["image"] as? String
        image = UIImage(data: NSData(base64Encoded: imageString!, options: .ignoreUnknownCharacters)! as Data)
        
        //名前
        self.name = valueDictionary["name"] as? String
        
        //緯度経度
        self.ido = valueDictionary["ido"] as? Double
        self.keido = valueDictionary["keido"] as? Double
        
        //友達
//        self.friends = valueDictionary["friends"] as? [String]
//        self.send = valueDictionary["send"] as? [String]
//        self.receve = valueDictionary["receve"] as? [String]
    }
}



