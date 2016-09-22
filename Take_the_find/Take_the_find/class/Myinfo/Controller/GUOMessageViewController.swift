//
//  GUOMessageViewController.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/22.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit

class GUOMessageViewController: UIViewController {

    @IBOutlet weak var brithdayBtn: UIButton!
    @IBOutlet weak var sexB: UIButton!
    @IBOutlet weak var iconB: UIButton!
    @IBOutlet weak var tuichuBtn: UILabel!
    var userM:UserModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tuichuBtn.userInteractionEnabled = true
        self.tuichuBtn.addGestureRecognizer({
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tuichuBtnClick))
            return tap
            }())
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setTheUserModel()
    }
    func setTheUserModel(){
        if UserModel.shareUser.headpic != nil{
            let str = "http://cat666.com/" + UserModel.shareUser.headpic!
            self.iconB.sd_setImageWithURL(NSURL.init(string: str), forState: .Normal)
        }
        if UserModel.shareUser.sex != nil{
            let sex = UserModel.shareUser.sex!
            if sex == "0"{
                sexB.setTitle("男", forState: UIControlState.Normal)
            }else{
                sexB.setTitle("女", forState: UIControlState.Normal)
            }
        }
    }
    @IBAction func popBtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    ///点击退出
    func tuichuBtnClick(){
         print("点击退出")
    }
    ///头像
    @IBAction func iconBtn(sender: AnyObject) {
        print("点击头像")
    }
    ///昵称
    @IBAction func nickBtn(sender: AnyObject) {
        let message = GUOmessageDetailViewController()
        message.hidesBottomBarWhenPushed = true
        message.str = "昵称"
        self.navigationController?.pushViewController(message, animated: true)
    }
    ///性别
    @IBAction func sexBtn(sender: AnyObject) {
     
    }
    ///生日
    @IBAction func brithdayBtn(sender: AnyObject) {
        print("点击生日")
    }
    ///签名
    @IBAction func qianMingBtn(sender: AnyObject) {
        print("点击签名")
    }
    ///安全
    @IBAction func anQuanBtn(sender: AnyObject) {
        print("点击安全")
    }
    
    
    
}
