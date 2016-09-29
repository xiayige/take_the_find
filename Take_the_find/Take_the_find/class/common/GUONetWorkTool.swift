//
//  GUONetWorkTool.swift
//  NetWorkTool
//
//  Created by qianfeng on 16/9/29.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import Foundation
class GUONetWorkTool: NSObject {
    //网址里面出现汉字
    //let url1 = url.stringByAddingPercentEncodingWithAllowedCharacters(.URLFragmentAllowedCharacterSet())!
    ///加载网络请求
    static func netWorkToolGetWithUrl(url:String,parameters:NSDictionary?,netWorkingCallBack:(data:NSData?,error:NSError?)->()){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        AFNetworkReachabilityManager.sharedManager().startMonitoring()
        AFNetworkReachabilityManager.sharedManager().setReachabilityStatusChangeBlock { (status) in
            if status == AFNetworkReachabilityStatus.init(rawValue: 0) || status == AFNetworkReachabilityStatus.init(rawValue: -1){
                SVProgressHUD.setBackgroundColor(UIColor.blackColor().colorWithAlphaComponent(0.6))
                SVProgressHUD.setFont(UIFont.boldSystemFontOfSize(15))
                SVProgressHUD.showErrorWithStatus("没有网络了")
            }else{
                SVProgressHUD.setFont(UIFont.boldSystemFontOfSize(15))
                SVProgressHUD.showWithStatus("正在加载中...")
                //加载数据
                let manger = AFHTTPSessionManager()
                manger.responseSerializer = AFHTTPResponseSerializer()
                manger.GET(url, parameters: parameters, progress: nil, success: { (task, data) in
                    netWorkingCallBack(data: (data as! NSData), error: nil)
                    SVProgressHUD.dismiss()
                    }, failure: { (task, error) in
                    netWorkingCallBack(data: nil, error: error)
                        SVProgressHUD.setFont(UIFont.boldSystemFontOfSize(15))
                        SVProgressHUD.showErrorWithStatus("加载失败")
                        SVProgressHUD.dismiss()
                })
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
}
