//
// VideoModel.swift
//  MyFMDB
//
//  Created by qianfeng on 16/8/31.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

import UIKit
/**拼接在主目录后的子目录*/
/**追加路径*/
private let PREPATH = "/Documents/videomodel.db"
/**字符串*/
private let STRING = "varchar(256)"
/**整型*/
private let INTERGER = "integer"
/**二进制*/
private let BLOB = "blob"
/**表名*/
private let TABLENAME = "pictureM"
class PictureModelManger: NSObject {
   
    /**数据库指针*/
    let FMDB:FMDatabase
    static let manger = PictureModelManger()
    override init() {
        //数据库路径 path
        let path = NSHomeDirectory() + PREPATH
        self.FMDB = FMDatabase(path: path)
        //判断打开是否成功
        if !FMDB.open(){
            print("数据库打开失败--\(FMDB.lastErrorMessage())")
        }
        print("数据库连接打开成功-\(path)")
        //创建表
        let creatSq = "create table if not exists %@(id varchar(256) primary key ,str varchar(256),page integer,type varchar(256))"
        let creatSql = String.init(format: creatSq, TABLENAME)
        do {
            try FMDB.executeUpdate(creatSql, values: nil)
            print("数据库表创建成功")
        }catch{
            print("数据库表创建失败-\(FMDB.lastErrorMessage())")
        }

    }
    /**插入语句*/
    func insertSql(id:String,str:NSString,page:Int,type:String){
       
        let insertSq = "insert into %@(id, str,page,type) values(?,?,?,?)"
        let insertSql = String.init(format: insertSq, TABLENAME)
        do {
            try FMDB.executeUpdate(insertSql, values: [id,str,page,type])
            print("数据插入成功")
        } catch {
            print("数据插入失败-\(FMDB.lastErrorMessage())")
        }
    }
    /**根据ID查出数据*/
    func searchSqlForID(forId type: NSString,page:Int) -> [String]? {
        //字符串添加引号
        let types = "\"\(type)\""
        let selectSq = "select * from %@ where type = %@ and page = %d"
        let selectSql = String.init(format: selectSq, TABLENAME,types,page)
        print(selectSql)
        var dictstr = [String]()
        do {
            let rs = try FMDB.executeQuery(selectSql, values: nil)
            while rs.next() {
                //这个循环内部，rs会依次代表所有查询出来的数据
                let str = rs.stringForColumn("str")
                dictstr.append(str)
            }
            if dictstr.count == 0{
                print("数据库没有图片\(type)第\(page)数据")
            }else{
                print("根据ID查询语句成功")
            }
            return dictstr
        } catch {
            print("根据ID查询语句失败-\(FMDB.lastErrorMessage())")
            return nil
        }
        
    }
}
