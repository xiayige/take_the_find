//
//  PictureModel.swift
//  targetApp
//
//  Created by qianfeng on 16/9/18.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit

class PictureModel: NSObject {
    var imageUrl:String!
    var objTag:String!
    var imageWidth:CGFloat!
    var imageHeight:CGFloat!
    static func modelWithDict(dict:[String:AnyObject])->PictureModel{
        let model = PictureModel()
        if dict.count == 0{
            return model
        }
         model.imageWidth = dict["imageWidth"] as! CGFloat
         model.imageHeight = dict["imageHeight"] as! CGFloat
        model.objTag = dict["objTag"] as! String
        model.imageUrl = dict["imageUrl"] as! String
        return model
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
extension PictureModel{
    ///发送网络请求，获取图片模型
    static func requestData(type:String,page:Int,callBack:(array:[PictureModel]?,error:NSError?)->Void){
        let url = String.init(format: "http://image.baidu.com/data/imgs?col=%@&tag=全部&sort=1&pn=%d&rn=21&p=channel&from=1", type,page * 21)
        let url1 = url.stringByAddingPercentEncodingWithAllowedCharacters(.URLFragmentAllowedCharacterSet())!
        let manger = AFHTTPSessionManager()
        manger.responseSerializer = AFHTTPResponseSerializer()
        manger.GET(url1, parameters: nil, progress: nil, success: { (task, data) in
            var dataArr = [PictureModel]()
            let obj = try? NSJSONSerialization.JSONObjectWithData((data! as? NSData)!, options: .AllowFragments)
            let arrays = obj!["imgs"] as! [[String:AnyObject]]
            for dict in arrays{
                let model = PictureModel.modelWithDict(dict)
                dataArr.append(model)
            }
            
            callBack(array: dataArr, error: nil)
        }) { (task, error) in
            SVProgressHUD.showErrorWithStatus("请求失败")
            callBack(array: nil, error: error)
        }
    }
    static func requestCategaryData(type:String,tag:String,page:Int,callBack:(array:[PictureModel]?,error:NSError?)->Void){
        let url = String.init(format: "http://image.baidu.com/data/imgs?col=%@&tag=%@&sort=1&pn=%d&rn=21&p=channel&from=1",type,tag,page * 21)
        let url1 = url.stringByAddingPercentEncodingWithAllowedCharacters(.URLFragmentAllowedCharacterSet())!
        let manger = AFHTTPSessionManager()
        manger.responseSerializer = AFHTTPResponseSerializer()
        manger.GET(url1, parameters: nil, progress: nil, success: { (task, data) in
            var dataArr = [PictureModel]()
            let obj = try? NSJSONSerialization.JSONObjectWithData((data! as? NSData)!, options: .AllowFragments)
            let arrays = obj!["imgs"] as! [[String:AnyObject]]
            for dict in arrays{
                let model = PictureModel.modelWithDict(dict)
                dataArr.append(model)
            }
            callBack(array: dataArr, error: nil)
        }) { (task, error) in
            SVProgressHUD.showErrorWithStatus("请求失败")
            callBack(array: nil, error: error)
        }
    }

}