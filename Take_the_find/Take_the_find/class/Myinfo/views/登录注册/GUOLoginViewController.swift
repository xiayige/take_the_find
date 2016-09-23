//
//  GUOLoginViewController.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/22.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit

class GUOLoginViewController: UIViewController {

    @IBOutlet weak var loginBtnC: UIButton!
    @IBOutlet weak var passWL: UITextField!
    @IBOutlet weak var nameL: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "loginBackgroundImage")!)
    }
    @IBAction func loginBtn(sender: AnyObject) {
        if passWL.text == nil || nameL.text == nil {
            SVProgressHUD.showErrorWithStatus("账号或密码为空")
        }else{
            UserModel.checkRequestData(nameL.text!, password: passWL.text!, callBack: { (dict, error) in
                if error == nil{
                    //登录成功
                    SVProgressHUD.showSuccessWithStatus("登录成功")
                    userDict = dict as! [String:String]
                    isLogin = true
                    self.navigationController?.popViewControllerAnimated(true)
                }else{
                    SVProgressHUD.showErrorWithStatus("网络请求失败")
                }
            })
        }

    }
    @IBAction func PopBtnClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
