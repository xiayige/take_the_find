//
//  MyPresententContrller.swift
//  微博试炼
//
//  Created by qianfeng on 16/9/11.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

import UIKit

class MyPresententContrller: UIPresentationController {
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
    override func containerViewWillLayoutSubviews(){
        super.containerViewWillLayoutSubviews()
        let widthX = (SCREEN_W - 232) / 2
        let heghtY = (SCREEN_H - 190) / 2
        presentedView()?.frame = CGRectMake(widthX, heghtY, 232, 190)
        //插入一个按钮当做蒙板
        let coverBtn = UIButton(frame: (self.containerView?.bounds)!)
        coverBtn.addTarget(self, action: #selector(self.coverBtn), forControlEvents: .TouchUpInside)
        self.containerView?.insertSubview(coverBtn, atIndex: 0)
    }
    func coverBtn(){
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
