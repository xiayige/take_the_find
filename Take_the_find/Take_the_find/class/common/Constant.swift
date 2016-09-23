//
//  Constant.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/20.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import Foundation
let SCREEN_W:CGFloat = UIScreen.mainScreen().bounds.width
let SCREEN_H:CGFloat = UIScreen.mainScreen().bounds.height
let NAV_H:CGFloat = 64
let TAB_H:CGFloat = 49
/************图片模块*/
///图片上方label高度
let topBtn_H:CGFloat = 40
//图片详情label之间间隔
let space:CGFloat = 10
//全局背景颜色
let backColor = UIColor.init(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
// 图片详情label的高度
let labelH:CGFloat = 23
/************视频模块*/
///上方广告条高度
let adviewH:CGFloat = 150
///视频的间隔
let videoSpace:CGFloat = 5
///视频cell高度
let videoH:CGFloat = 248
///视频cell宽度
let videoW:CGFloat = (SCREEN_W - 3 * videoSpace)*0.5
///视频内容label的宽度
let videoContentLH:CGFloat = 150
///动画时长
let videoLength:Double = 0.25
///圆角半径
let videoConr:CGFloat = 10
///打印网络数据
func printData(data:NSData){
    let str = NSString.init(data:data, encoding: NSUTF8StringEncoding)
    print(str!)
}
