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
    var id:String!
    static func modelWithDict(dict:[String:AnyObject])->PictureModel{
        let model = PictureModel()
        if dict.count == 0{
            return model
        }
         model.imageWidth = dict["imageWidth"] as! CGFloat
         model.imageHeight = dict["imageHeight"] as! CGFloat
        model.objTag = dict["objTag"] as! String
        model.imageUrl = dict["imageUrl"] as! String
        model.id = dict["id"] as! String
        return model
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
extension PictureModel{
   

    ///发送网络请求，获取图片模型
    static func requestData(type:String,page:Int,callBack:(array:[PictureModel]?,error:NSError?)->Void){
        if let dict = readTheDict(type, page: page){
            let arrays = dict as![[String:AnyObject]]
            dataDetail(arrays, page: page, type: type, istrue: false, callBack: { (array) in
                callBack(array: array, error: nil)
            })
            return
        }
        let url = String.init(format: "http://image.baidu.com/data/imgs?col=%@&tag=全部&sort=1&pn=%d&rn=21&p=channel&from=1", type,page * 21)
        let url1 = url.stringByAddingPercentEncodingWithAllowedCharacters(.URLFragmentAllowedCharacterSet())!
        
        GUONetWorkTool.netWorkToolGetWithUrl(url1, parameters: nil) { (data, error) in
            if error == nil{
                let obj = try? NSJSONSerialization.JSONObjectWithData((data!), options: .AllowFragments) as! NSDictionary
                let arrays = obj!["imgs"] as! [[String:AnyObject]]
                 dataDetail(arrays, page: page, type: type, istrue: true, callBack: { (array) in
                    callBack(array: array, error: nil)
                })
            }else{
                 callBack(array: nil, error: error)
            }
        }
    }
    ///获取分类数据
    static func requestCategaryData(type:String,tag:String,page:Int,callBack:(array:[PictureModel]?,error:NSError?)->Void){
        let url = String.init(format: "http://image.baidu.com/data/imgs?col=%@&tag=%@&sort=1&pn=%d&rn=21&p=channel&from=1",type,tag,page * 21)
        let url1 = url.stringByAddingPercentEncodingWithAllowedCharacters(.URLFragmentAllowedCharacterSet())!
        GUONetWorkTool.netWorkToolGetWithUrl(url1, parameters: nil) { (data, error) in
            if error == nil{
                var dataArr = [PictureModel]()
                let obj = try? NSJSONSerialization.JSONObjectWithData((data!), options: .AllowFragments)
                let arrays = obj!["imgs"] as! [[String:AnyObject]]
                for dict in arrays{
                    let model = PictureModel.modelWithDict(dict)
                    dataArr.append(model)
                }
                callBack(array: dataArr, error: nil)
            }else{
                callBack(array: nil, error: error)
            }
        }
    }
    ///对数据进行处理
    static func dataDetail(arrays:[[String:AnyObject]],page:Int,type:String,istrue:Bool,callBack:([PictureModel])->()){
        var dataArr = [PictureModel]()
        let count = arrays.count
        var i = 1
        dispatch_async(dispatch_queue_create("任务", DISPATCH_QUEUE_SERIAL)) {
            for dict in arrays{
                if i == count{
                    break
                }
                let model = PictureModel.modelWithDict(dict)
                dataArr.append(model)
                //是否保存到数据库
                if istrue{
                    saveThepicDict(model.id, dict: dict, page: page, type: type)
                }
                i += 1
            }
            dispatch_async(dispatch_get_main_queue(), {
                callBack(dataArr)
            })
        }
    }
//MARK:数据库处理
    ///数据库存储字典
    static func saveThepicDict(ID:String,dict:NSDictionary,page:Int,type:String){
        print("存图片数据--\(NSThread.currentThread())")
        //创建异步串行队列缓存数据
            let data = try! NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted)
            let str = NSString.init(data: data, encoding: NSUTF8StringEncoding)
            PictureModelManger.manger.insertSql(ID, str: str!, page: page, type: type)
    }
    ///读取数据字典,返回字典数组
    static func readTheDict(type:String,page:Int)->[NSDictionary]?{
        print("读图片数据")
        let arrays = NSMutableArray()
        let dictstr = PictureModelManger.manger.searchSqlForID(forId: type, page: page)
        if dictstr?.count == 0{
            return nil
        }
        for str in dictstr!{
            let data = str.dataUsingEncoding(NSUTF8StringEncoding)
            let dict = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
            arrays.addObject(dict)
        }
        let array = NSArray.init(array: arrays) as! [NSDictionary]
        return (array)
    }
}