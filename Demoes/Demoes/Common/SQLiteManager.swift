//
//  SQLiteManager.swift
//  Demoes
//
//  Created by 张丽明 on 2017/3/12.
//  Copyright © 2017年 xpming. All rights reserved.
//

import UIKit
import FMDB
class SQLiteManager: NSObject {
//    工具单例子
    static let SQManager:SQLiteManager = SQLiteManager()
    var DB:FMDatabase?
    var DBQ:FMDatabaseQueue?
    
    override init() {
        super.init()
        openDB("Demoes_MyNote.sqlite")
    }
//    打开数据库
    func openDB(_ name:String?){
        let path = getCachePath(name!)
        print(path)
        DB = FMDatabase(path: path)
        DBQ = FMDatabaseQueue(path: path)
        guard let db = DB else {print("数据库对象创建失败")
            return}
        if !db.open(){
            print("打开数据库失败")
            return
        }
        
        if creatTable() {
            print("创表成功！！！！")
        }
        
    }
//    创建数据库
    func creatTable() -> Bool{
        let sqlit1 = "CREATE TABLE IF NOT EXISTS T_MyNote( \n" +
            "stateid INTEGER PRIMARY KEY AUTOINCREMENT, \n" +
            "id TEXT, \n" +
            "title TEXT, \n" +
            "desc TEXT, \n" +
            "creatTime TEXT \n" +
        ");"
        //执行语句
        return DB!.executeUpdate(sqlit1, withArgumentsIn: nil)
    }
    //MARK:-- 拼接路径
    func getCachePath(_ fileName:String) -> String{
        let path1 = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory
            , FileManager.SearchPathDomainMask.userDomainMask, true).first
        let path2 = path1! + "/" + fileName
        return path2
    }
}
