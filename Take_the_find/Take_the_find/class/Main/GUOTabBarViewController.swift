//
//  GUOTabBarViewController.swift
//  MyChat
//
//  Created by qianfeng on 16/8/31.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

import UIKit
/*tabbar_home_highlighted - 视频
 tabbar_message_center_highlighted - 图片
 tabbar_discover_highlighted-- 段子
 tabbar_profile_highlighted - 个人
 */
class GUOTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setchildsVC()
    }
    func setchildsVC(){
        //第一个控制器 视频
        let video = GUOVideosViewController()
        setUpChildVC(video, tabtitle: "视频", navtitle: "视频", image: UIImage(named: "tabbar_home")!, selectedimage: UIImage(named: "tabbar_home_highlighted")!)
        //第二个控制器 图片
        let picture = PictureViewController()
        setUpChildVC(picture, tabtitle: "图片", navtitle: "图片", image: UIImage(named: "tabbar_message_center")!, selectedimage: UIImage(named: "tabbar_message_center_highlighted")!)
        //第三个控制器 段子
        let Joke = GUOJokeViewController()
        setUpChildVC(Joke, tabtitle: "段子", navtitle: "段子", image: UIImage(named: "tabbar_discover")!, selectedimage: UIImage(named: "tabbar_discover_highlighted")!)
        //第四个控制器 个人中心
        let Me = GUOMyinfoViewController()
        setUpChildVC(Me, tabtitle: "我", navtitle: "我", image: UIImage(named: "tabbar_profile")!, selectedimage: UIImage(named: "tabbar_profile_highlighted")!)
    }
    func setUpChildVC(VC:UIViewController,tabtitle:String,navtitle:String,image:UIImage,selectedimage:UIImage){
        let vc = VC
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = tabtitle
        nav.tabBarItem.image = image.imageWithRenderingMode(.AlwaysOriginal)
        nav.tabBarItem.selectedImage = selectedimage.imageWithRenderingMode(.AlwaysOriginal)
        //为tabbaritem添加属性
        var itemArr = [String:AnyObject]()
        itemArr[NSFontAttributeName] = UIFont.boldSystemFontOfSize(12)
        itemArr[NSForegroundColorAttributeName] = UIColor.grayColor()
        nav.tabBarItem.setTitleTextAttributes(itemArr, forState: .Normal)
        vc.navigationItem.title = navtitle
        self.addChildViewController(nav)
    }
}
