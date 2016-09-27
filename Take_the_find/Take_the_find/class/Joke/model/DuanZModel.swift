//
//  DuanZModel.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/26.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import Foundation
class DuanZModel: NSObject {
    ///cell的高度
    var cellH:CGFloat?
    ///文本内容
    var content:String!{
        didSet{
            let text = content as NSString
            let textheight = text.boundingRectWithSize(CGSizeMake(SCREEN_W - 10, 99999), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15)], context: nil).height
            contentH = textheight
        }
    }
    ///文本帖子高度
    var contentH:CGFloat!
    var id:NSNumber!
    ///带图片拼接字符串
    var image:String?{
        didSet{
            if image != nil{
                let str = "\(id)" as NSString
                let str1 = str.substringWithRange(NSRange.init(location: 0, length: 5))
                let imageStr = String.init(format: "http://pic.qiushibaike.com/system/pictures/%@/%@/medium/%@", str1,id,image!)
                iconStr = imageStr
            }
        }
    }
    ///发帖图片
    var iconStr:String?
    ///帖子图片高度
    var picHeight:CGFloat?
    ///帖子图片宽度
    var picWidth:CGFloat?
    ///用户模型
    var DuanUserM:DuanUserModel?
    static func modelWithDict(dict:[String:AnyObject])->DuanZModel{
        let model = DuanZModel()
        model.id = dict["id"] as! NSNumber
        model.setValuesForKeysWithDictionary(dict)
        if model.image != nil{
            let array = dict["image_size"]!["m"] as! NSArray
            model.picWidth = (array[0] as! CGFloat)
            model.picHeight = (array[1] as! CGFloat)
        }
        if let userdict = dict["user"] {
            if userdict as! NSObject == NSNull.init(){
            }else{
                model.DuanUserM = DuanUserModel.modelWithDict(userdict as! NSDictionary)
            }
        }
       
        return model
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
class DuanUserModel: NSObject {
    ///发帖时间
    var created_at:NSNumber!
    ///用户id
    var id:NSNumber!
    ///用户名称
    var login:String!
    ///带拼接的用户头像
    var icon:String!{
        didSet{
            if icon != ""{
                let str = "\(id)" as NSString
                let str1 = str.substringWithRange(NSRange.init(location: 0, length: 4))
                let imageStr = String.init(format: "http://pic.qiushibaike.com/system/avtnew/%@/%@/thumb/%@", str1,"\(id)",icon!)
                DuanUsericonStr = imageStr
            }else{
                DuanUsericonStr = nil
            }
        }
    }
    ///用户头像
    var DuanUsericonStr:String?
    static func modelWithDict(dict:NSDictionary)->DuanUserModel{
        let model = DuanUserModel()
         model.id = dict["id"] as! NSNumber
         model.created_at = dict["created_at"] as! NSNumber
        model.setValuesForKeysWithDictionary(dict as! [String : AnyObject])
        return model
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
extension DuanZModel{
        ///发送网络请求，获取笑话模型
        static func requestJokeData(page:Int,callBack:(array:[DuanZModel]?,error:NSError?)->Void){
            let url = String.init(format: "http://m2.qiushibaike.com/article/list/imgrank?page=%d&count=20&readarticles=[115327863]&rqcnt=13&r=5732e7d01456830368558",page)
            let manger = AFHTTPSessionManager()
            manger.responseSerializer = AFHTTPResponseSerializer()
            manger.GET(url, parameters: nil, progress: nil, success: { (task, data) in
                let obj = try! NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                var dataArr = [DuanZModel]()
                if let dicts = obj["items"] as? NSArray {
                    for dict in dicts {
                        let model = DuanZModel.modelWithDict(dict as! [String : AnyObject])
                        dataArr.append(model)
                    }
                    callBack(array: dataArr, error: nil)
                }else{
                    SVProgressHUD.showErrorWithStatus("请求失败")
                    return
                }
            }) { (task, error) in
                SVProgressHUD.showErrorWithStatus("网络连接失败")
                callBack(array: nil, error: error)
            }
        }
    ///发送网络请求，获取段子模型
    static func requestDJokeData(page:Int,callBack:(array:[DuanZModel]?,error:NSError?)->Void){
        let url = String.init(format: "http://m2.qiushibaike.com/article/list/text?page=%d&count=30",page)
        let manger = AFHTTPSessionManager()
        manger.responseSerializer = AFHTTPResponseSerializer()
        manger.GET(url, parameters: nil, progress: nil, success: { (task, data) in
            let obj = try! NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            var dataArr = [DuanZModel]()
            if let dicts = obj["items"] as? NSArray {
                for dict in dicts {
                    let model = DuanZModel.modelWithDict(dict as! [String : AnyObject])
                    dataArr.append(model)
                }
                callBack(array: dataArr, error: nil)
            }else{
                SVProgressHUD.showErrorWithStatus("请求失败")
                return
            }
        }) { (task, error) in
            SVProgressHUD.showErrorWithStatus("网络连接失败")
            callBack(array: nil, error: error)
        }
    }
    ///发送网络请求，获取评论信息
    static func requestcommitData(modelID:NSNumber,page:Int,callBack:(array:[GUOCommitModel]?,error:NSError?)->Void){
        let url = String.init(format: "http://m2.qiushibaike.com/article/%@/comments?page=%d&count=50&rqcnt=49&r=5732e7d01457095228054",modelID,page)
        let manger = AFHTTPSessionManager()
        manger.responseSerializer = AFHTTPResponseSerializer()
        manger.GET(url, parameters: nil, progress: nil, success: { (task, data) in
            let obj = try! NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            var dataArr = [GUOCommitModel]()
            if let dicts = obj["items"] as? NSArray {
                for dict in dicts {
                    let model = GUOCommitModel()
                    model.content = dict["content"] as! String
                    model.id = dict["user"]!!["id"] as! NSNumber
                    model.icon = dict["user"]!!["icon"] as? String
                    model.login = dict["user"]!!["login"]  as? String
                    dataArr.append(model)
                }
                callBack(array: dataArr, error: nil)
            }else{
                SVProgressHUD.showErrorWithStatus("请求失败")
                return
            }
        }) { (task, error) in
            SVProgressHUD.showErrorWithStatus("网络连接失败")
            callBack(array: nil, error: error)
        }
    }


}