//
//  GUOCommitModel.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/27.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit

class GUOCommitModel: NSObject {
    var content:String!
    var login:String!
    var id:NSNumber!
    var icon:String?{
            didSet{
                if icon != ""{
                    let str = "\(id)" as NSString
                    let str1 = str.substringWithRange(NSRange.init(location: 0, length: 4))
                    let imageStr = String.init(format: "http://pic.qiushibaike.com/system/avtnew/%@/%@/thumb/%@", str1,"\(id)",icon!)
                    usericon = imageStr
                }else{
                    usericon = nil
                }
            }
    }
    var usericon:String?
}
