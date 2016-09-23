//
//  GUOalertSexViewController.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/23.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit
var alertTag:String?
class GUOalertSexViewController: UIViewController {
    var block:((String)->Void)!
    var preBtn:UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
    }
    override func loadView() {
        view = NSBundle.mainBundle().loadNibNamed("alertSex", owner: self, options: nil).last as! UIView
    }
    @IBAction func manB(sender: UIButton) {
        sender.backgroundColor = backColor
        if preBtn != nil{
            preBtn!.backgroundColor = UIColor.whiteColor()
        }
        if sender.tag == 0{
            alertTag = "0"
        }else{
            alertTag = "1"
        }
        preBtn = sender
    }
    @IBAction func alertSexBtn(sender: AnyObject) {
        //修改性别
        weak var WeakSelf = self
        if alertTag != nil{
            if isLogin{
                 let ID = UserModel.shareUser.id
                UserModel.alterSexrequestData(ID!, sex: alertTag!, calback: { (error) in
                    if error == nil{
                         UserModel.shareUser.sex = alertTag!
                        WeakSelf!.block(alertTag!)
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                })
            }else{
                SVProgressHUD.showErrorWithStatus("登录后进行操作")
            }
        }else{
            SVProgressHUD.showErrorWithStatus("请选择后确认")
        }
        
    }
}
