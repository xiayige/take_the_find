//
//  LoginAndResgiest.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/22.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import Foundation
var isLogin = false
var userDict:[String:String] = (NSDictionary() as? [String : String])!
class UserModel: NSObject {
    ///邮箱
    var email:String?
    ///用户ID
    var id:String?
    ///用户地址
    var address:String! = ""
    var sex:String?
    var birth:String?
    class var shareUser : UserModel {
        get {
            struct Static {
                static let instance : UserModel = UserModel.modelWithDict(userDict)
            }
            return Static.instance
        }set{
            self.shareUser = newValue
        }
       
    }
    var uname:String?
    /// 用户介绍
    var info:String?
    ///待拼接的头像
    var headpic:String?{
        didSet{
            let str = "http://www.cat666.com/" + headpic!
            iconStr = str
        }
    }
    ///头像地址
    var iconStr:String?
    ///vip等级
    var ulevel:String!
    ///性别
    static func modelWithDict(dict:[String:String])->UserModel{
        let user = UserModel()
        user.setValuesForKeysWithDictionary(dict)
        return user
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
extension UserModel{
    ///注册
    static func registRequestData(user:String,password:String,callBack:(dict:NSDictionary?,error:NSError?)->Void){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
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
            }else{
                SVProgressHUD.showSuccessWithStatus("注册成功")
                callBack(dict: obj, error: nil)
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }) { (task, error) in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                SVProgressHUD.showErrorWithStatus("网络失败")
               callBack(dict: nil, error: error)
        }
    }
    ///登录
    static func checkRequestData(user:String,password:String,callBack:(dict:NSDictionary?,error:NSError?)->Void){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
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
                SVProgressHUD.showSuccessWithStatus("登录成功")
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }) { (task, error) in
            SVProgressHUD.showErrorWithStatus("网络失败")
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }

    }
    ///修改昵称
    static func alterNickrequestData(userid:String,nick:String,calback:(error:NSError?)->Void){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = "http://cat666.com/cat666-interface/index.php/index/alterNick"
        let manger = AFHTTPSessionManager()
        manger.responseSerializer = AFHTTPResponseSerializer()
        let para = ["userid":userid,"nick":nick]
        manger.POST(url, parameters: para, progress: nil, success: { (task, data) in
              print((NSString.init(data: data as! NSData, encoding: NSUTF8StringEncoding))!)
            let obj = try! NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            if obj["failed"] != nil{
                SVProgressHUD.showErrorWithStatus("修改昵称失败")
            }else{
                SVProgressHUD.showSuccessWithStatus("修改昵称成功")
                calback(error: nil)
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }) { (task, error) in
            SVProgressHUD.showErrorWithStatus("网络失败")
            calback(error: error)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }

    }
    
    ///修改性别
    static func alterSexrequestData(userid:String,sex:String,calback:(error:NSError?)->Void){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = "http://cat666.com/cat666-interface/index.php/index/alterSex"
        let manger = AFHTTPSessionManager()
        manger.responseSerializer = AFHTTPResponseSerializer()
        let para = ["userid":userid,"sex":sex]
        manger.POST(url, parameters: para, progress: nil, success: { (task, data) in
            let obj = try! NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            if obj["failed"] != nil{
                SVProgressHUD.showErrorWithStatus("修改性别失败")
            }else{
                SVProgressHUD.showSuccessWithStatus("修改性别成功")
                calback(error: nil)
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }) { (task, error) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.showErrorWithStatus("网络失败")
            calback(error: error)
        }
    }
    ///修改生日
    static func alterBirthrequestData(userid:String,birth:String,calback:(error:NSError?)->Void){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = "http://cat666.com/cat666-interface/index.php/index/alterBirth"
        let manger = AFHTTPSessionManager()
        manger.responseSerializer = AFHTTPResponseSerializer()
        let para = ["userid":userid,"birth":birth]
        manger.POST(url, parameters: para, progress: nil, success: { (task, data) in
            let obj = try! NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            if obj["failed"] != nil{
                SVProgressHUD.showErrorWithStatus("修改生日失败")
            }else{
                SVProgressHUD.showSuccessWithStatus("修改生日成功")
                calback(error: nil)
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }) { (task, error) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.showErrorWithStatus("网络失败")
            calback(error: error)
        }
    }
    ///修改个性签名
    static func alterSignaturerequestData(userid:String,signature:String,calback:(error:NSError?)->Void){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = "http://cat666.com/cat666-interface/index.php/index/alterSignature"
        let manger = AFHTTPSessionManager()
        manger.responseSerializer = AFHTTPResponseSerializer()
        let para = ["userid":userid,"signature":signature]
        manger.POST(url, parameters: para, progress: nil, success: { (task, data) in
            let obj = try! NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            if obj["failed"] != nil{
                SVProgressHUD.showErrorWithStatus("修改个性签名失败")
            }else{
                SVProgressHUD.showSuccessWithStatus("修改个性签名成功")
                calback(error: nil)
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }) { (task, error) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.showErrorWithStatus("网络失败")
            calback(error: error)
        }
    }
    ///修改密码
    static func alterPasswordrequestData(userid:String,password:String,calback:(error:NSError?)->Void){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = "http://cat666.com/cat666-interface/index.php/index/alterPassword"
        let manger = AFHTTPSessionManager()
        manger.responseSerializer = AFHTTPResponseSerializer()
        let para = ["userid":userid,"password":password]
        manger.POST(url, parameters: para, progress: nil, success: { (task, data) in
            let obj = try! NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            if obj["failed"] != nil{
                SVProgressHUD.showErrorWithStatus("修改密码失败")
            }else{
                SVProgressHUD.showSuccessWithStatus("修改密码成功")
                calback(error: nil)
            }
             UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }) { (task, error) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.showErrorWithStatus("网络失败")
            calback(error: error)
        }
    }
    ///上传头像
    static func alertpicRequest(image:UIImage!,userID:String!,pic:String!){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = "http://cat666.com/cat666-interface/index.php/index/alterPic"
        let para = ["userid":userID,"pic":pic]
        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.POST(url, parameters: para, constructingBodyWithBlock: { (formData) in
            let imageData = UIImagePNGRepresentation(image)!
            formData.appendPartWithFileData(imageData, name: "headimage", fileName: "1.png", mimeType: "image/png")
            }, progress: nil, success: { (task, data ) in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                let dic = try! NSJSONSerialization.JSONObjectWithData(data as! NSData, options: .AllowFragments) as! NSDictionary
                printData(data as! NSData)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }) { (task, error) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            print("上传头像时网络错误")
        }

    }
}