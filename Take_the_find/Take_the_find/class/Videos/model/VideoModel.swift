//
//  VideoModel.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/21.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import Foundation
class VideoModel: NSObject {
    ///微型图
    var thumb:String!
    ///大图
    var picmark:String!{
        didSet{
            let str = "http://www.cat666.com/" + picmark
            self.picmarkStr = str
        }
    }
    var Description:String?
    ///中图路径
    var picmarkStr:String!
    ///描述
    var fname:String!
    ///视频ID
    var id:String!
    ///观看数量
    var viewcounts:String!
    ///视频时间
    var videotime:String!
    ///视频地址
    var videourl:String!
    ///大图
    var bigpic:String!{
        didSet{
            let str = "http://www.cat666.com/" + bigpic
            bigpicStr = str
        }
    }
    ///大图路径
    var bigpicStr:String!
    ///收藏数
    var sword:String!
    ///弹幕数量
    var videodanmu:String? = "0"
    ///cell的高度
    var cellH:CGFloat = 245
    ///观察属性
    var fnameH:CGFloat!{
        let str = self.fname as NSString
        let height = str.boundingRectWithSize(CGSizeMake(videoContentLH, 9999), options: [.UsesLineFragmentOrigin,.UsesFontLeading], attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15)], context: nil).height
        return height
    }
    static func modelwithDict(dict:[String:String])->VideoModel{
        let model = VideoModel()
        model.setValuesForKeysWithDictionary(dict)
        if dict["description"] != nil{
            model.Description = dict["description"]
        }
        return model
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}

extension VideoModel{
    ///获取首页视频
    static func requestgetRecommendVideoData(callBack:(bannarArray:[VideoModel]?,cateArray:[String]?,modelsArray:NSMutableArray?,error:NSError?)->Void){
        print("11111")
        if let dicts = readTheDict(){
            let dict = dicts
            let dicts = detailDict(dict)
            callBack(bannarArray: dicts.2, cateArray: dicts.0, modelsArray: dicts.1, error: nil)
            return
        }
        let url = "http://cat666.com/cat666-interface/index.php/index/getRecommend"
        let manger = AFHTTPSessionManager()
        manger.responseSerializer = AFHTTPResponseSerializer()
        manger.GET(url, parameters: nil, progress: nil, success: { (task, data) in
            let dict = try! NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            let dicts = detailDict(dict)
            let id = dicts.2[0].id
            saveTheDict(id, dict: dict)
            callBack(bannarArray: dicts.2, cateArray: dicts.0, modelsArray: dicts.1, error: nil)
            }) { (task, error) in
                SVProgressHUD.showErrorWithStatus("获取首页视频请求失败")
                callBack(bannarArray: nil, cateArray: nil, modelsArray: nil, error: error)
        }
    }
    ///将数据进行处理
  static func detailDict(dict:NSDictionary)->([String],NSMutableArray,[VideoModel]){
        var cateArray = [String]()
        let modelsArray = NSMutableArray()
        var bannarArray = [VideoModel]()
        for (key , value ) in dict {
            let str = key as! NSString
            let dictvalue = value as! [[String:AnyObject]]
            let str1 = str.stringByReplacingOccurrencesOfString("!@#$%^&*", withString: "")
            if str1 == "体育"{
                continue
            }
            if str1 == "0"{
                for modeldict in dictvalue{
                    let model = VideoModel.modelwithDict(modeldict as! [String : String])
                    bannarArray.append(model)
                }
                continue
            }
            let modelArray = NSMutableArray()
            for modeldict in dictvalue{
                let model = VideoModel.modelwithDict(modeldict as! [String : String])
                modelArray.addObject(model)
            }
            cateArray.append(str1)
            modelsArray.addObject(modelArray)
        }
        return(cateArray,modelsArray,bannarArray)
    }
    ///数据库存储字典
    static func saveTheDict(ID:String,dict:NSDictionary){
        print("存储视频数据")
        let data = try! NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted)
        let str = NSString.init(data: data, encoding: NSUTF8StringEncoding)
        VideoModelManger.manger.insertSql(ID, str: str!)
    }
    ///读取数据字典,返回字典数组
    static func readTheDict()->NSDictionary?{
         print("读取视频数据")
        let str = VideoModelManger.manger.searchSql()
        if str == nil{
            return nil
        }
        let data = str!.dataUsingEncoding(NSUTF8StringEncoding)
        let dict = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
        return dict
    }
    ///获取视频详细信息
    static func requestgetVideoInfoData(videoID:String,callBack:(usermodel:UserModel?,videomodel:VideoModel?,error:NSError?)->Void){
        let url = "http://cat666.com/cat666-interface/index.php/index/getVideoInfo"
        let manger = AFHTTPSessionManager()
        manger.responseSerializer = AFHTTPResponseSerializer()
        let para = NSMutableDictionary()
        para["videoid"] = videoID
        manger.POST(url, parameters: para, progress: nil, success: { (task, data) in
                let obj = try! NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            let videoM = VideoModel.modelwithDict(obj["video"] as! [String:String])
            let userM = UserModel.modelWithDict(obj["user"] as! [String:String])
            callBack(usermodel: userM, videomodel: videoM, error:nil)
            }) { (task, error) in
                SVProgressHUD.showErrorWithStatus("获取视频详细信息请求失败")
                callBack(usermodel:nil, videomodel: nil, error: error)
        }
    }
    ///获取弹幕
    static func requestgetDanmu(videoID:String,callBack:(danmuArr:[String]?,error:NSError?)->Void){
        let url = "http://cat666.com/cat666-interface/index.php/index/getDanmu"
        let manger = AFHTTPSessionManager()
        manger.responseSerializer = AFHTTPResponseSerializer()
        let para = NSMutableDictionary()
        para["id"] = videoID
        manger.POST(url, parameters: para, progress: nil, success: { (task, data) in
           var strArr = [String]()
                let obj = try! NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments) as! NSArray
                for dict in obj{
                    let str = dict["danmu"] as! String
                    strArr.append(str)
                }
            callBack(danmuArr: strArr, error: nil)
            
        }) { (task, error) in
            SVProgressHUD.showErrorWithStatus("获取弹幕请求失败")
           callBack(danmuArr: nil, error: error)
        }
    }
}