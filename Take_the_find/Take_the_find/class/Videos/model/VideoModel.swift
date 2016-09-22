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
    ///描述
    var fname:String!
    ///观看数量
    var viewcounts:String!
    ///视频时间
    var videotime:String!
    ///视频地址
    var videourl:String!
    ///大图
    var bigpic:String!
    ///弹幕数量
    var videodanmu:String!
    ///cell的高度
    var cellH:CGFloat = 245
    var fnameH:CGFloat!{
        let str = self.fname as NSString
        let height = str.boundingRectWithSize(CGSizeMake(videoContentLH, 9999), options: [.UsesLineFragmentOrigin,.UsesFontLeading], attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15)], context: nil).height
        return height
    }
    static func modelwithDict(dict:[String:String])->VideoModel{
        let model = VideoModel()
        model.setValuesForKeysWithDictionary(dict)
        return model
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
extension VideoModel{
    static func requestgetRecommendVideoData(callBack:(bannarArray:[VideoModel]?,cateArray:[String]?,modelsArray:NSMutableArray?,error:NSError?)->Void){
        let url = "http://cat666.com/cat666-interface/index.php/index/getRecommend"
        let manger = AFHTTPSessionManager()
        manger.responseSerializer = AFHTTPResponseSerializer()
        manger.GET(url, parameters: nil, progress: nil, success: { (task, data) in
            let dict = try! NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            var cateArray = [String]()
            let modelsArray = NSMutableArray()
            var bannarArray = [VideoModel]()
            for (key , _) in dict {
                let str = key as! String
                let dictArr = dict[str] as! [[String:String]]
                let str1 = str.stringByReplacingOccurrencesOfString("!@#$%^&*", withString: "")
                if str1 == "体育"{
                    continue
                }
                if str1 == "0"{
                    for modeldict in dictArr{
                        let model = VideoModel.modelwithDict(modeldict)
                        bannarArray.append(model)
                    }
                    continue
                }
                let modelArray = NSMutableArray()
                for modeldict in dictArr{
                    let model = VideoModel.modelwithDict(modeldict)
                    modelArray.addObject(model)
                }
                cateArray.append(str1)
                modelsArray.addObject(modelArray)
            }
            callBack(bannarArray: bannarArray, cateArray: cateArray, modelsArray: modelsArray, error: nil)
            }) { (task, error) in
                callBack(bannarArray: nil, cateArray: nil, modelsArray: nil, error: error)
        }
    }
}