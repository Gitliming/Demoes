//
//  MyNote.swift
//  aha
//
//  Created by xpming on 16/9/2.
//  Copyright © 2016年 Ledong. All rights reserved.
//

import Foundation
//import ObjectMapper

class MyNote:NSObject  {
    var id: String = ""
    var title: String = ""
    var desc: String = ""
    var createTime: String = ""
//    var updateTime: NSTimeInterval = NSDate().timeIntervalSince1970

//    required init?(_ map: Map) {
//        
//    }
    
//    func mapping(map: Map) {
//        id <- map["id"]
//        title <- map["title"]
//        desc <- map["desc"]
//        createTime <- map["createTime"]
//        updateTime <- map["updateTime"]
//    }
    init(id:String, title:String, desc:String, createTime:String) {
        self.id = id
        self.title = title
        self.desc = desc
        self.createTime = createTime
    }


}
