//
//  LoginAndResgiest.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/22.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import Foundation
let shareuser = UserModel()
class UserModel: NSObject {
    var email:String?
    var id:String!
    var address:String! = ""
    var headpic:String?
    var sex:String?
    var uname:String?
    class var shareUser:UserModel{
        return shareuser
    }
    
}
extension UserModel{
    ///注册
    static func registRequestData(user:String,password:String,callBack:(dict:NSDictionary?,error:NSError?)->Void){
        let url = "http://cat666.com/cat666-interface/index.php/index/register"
        let manger = AFHTTPSessionManager()
        manger.responseSerializer = AFHTTPResponseSerializer()
        let para = ["user":user,"password":password]
        manger.POST(url, parameters: para, progress: nil, success: { (task, data) in
            let obj = try! NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            if obj["exist"] != nil{
                SVProgressHUD.showErrorWithStatus("用户已经存在")
            }else if obj["error"] != nil{
                SVProgressHUD.showErrorWithStatus("不能为空")
            }else{callBack(dict: obj, error: nil)
            }
            }) { (task, error) in
               callBack(dict: nil, error: error)
        }
    }
    ///登录
    static func checkRequestData(user:String,password:String,callBack:(dict:NSDictionary?,error:NSError?)->Void){
        let url = "http://cat666.com/cat666-interface/index.php/index/check"
        let manger = AFHTTPSessionManager()
        manger.responseSerializer = AFHTTPResponseSerializer()
        let para = ["user":user,"password":password]
        manger.POST(url, parameters: para, progress: nil, success: { (task, data) in
            let obj = try! NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            if obj["error"] != nil{
                SVProgressHUD.showErrorWithStatus("登录失败")
            }else{
                callBack(dict: obj, error: nil)
            }
        }) { (task, error) in
            
        }

    }
    ///修改账户
    static func alterNickrequestData(userid:String,nick:String,calback:(error:NSError?)->Void){
        let url = "http://cat666.com/cat666-interface/index.php/index/alterNick"
        let manger = AFHTTPSessionManager()
        manger.responseSerializer = AFHTTPResponseSerializer()
        let para = ["userid":userid,"nick":nick]
        manger.POST(url, parameters: para, progress: nil, success: { (task, data) in
              print((NSString.init(data: data as! NSData, encoding: NSUTF8StringEncoding))!)
            let obj = try! NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            if obj["failed"] != nil{
                SVProgressHUD.showErrorWithStatus("修改失败")
            }else{
                SVProgressHUD.showErrorWithStatus("修改成功")
                calback(error: nil)
            }
        }) { (task, error) in
            calback(error: error)
        }

    }
    
    ///修改性别
    static func alterSexrequestData(userid:String,sex:String,calback:(error:NSError?)->Void){
        let url = "http://cat666.com/cat666-interface/index.php/index/alterSex"
        let manger = AFHTTPSessionManager()
        manger.responseSerializer = AFHTTPResponseSerializer()
        let para = ["userid":userid,"sex":sex]
        manger.POST(url, parameters: para, progress: nil, success: { (task, data) in
            print((NSString.init(data: data as! NSData, encoding: NSUTF8StringEncoding))!)
            let obj = try! NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            if obj["failed"] != nil{
                SVProgressHUD.showErrorWithStatus("修改失败")
            }else{
                SVProgressHUD.showErrorWithStatus("修改成功")
                calback(error: nil)
            }
        }) { (task, error) in
            calback(error: error)
        }
    }
}