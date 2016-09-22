//
//  GUOmessageDetailViewController.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/22.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit

class GUOmessageDetailViewController: UIViewController {
    var str:String!
    var textF:UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheSubviews()
        self.view.backgroundColor = backColor
    }
    func setTheSubviews(){
        if str == "昵称"{
            self.textF = UITextField(frame: CGRectMake(100, 80, 200, 40))
           self.textF!.placeholder = "输入昵称"
            self.view.addSubview(self.textF!)
            let commitbtn = UIButton(type: .Custom)
            commitbtn.setTitle("提交", forState: .Normal)
            commitbtn.frame = CGRectMake(310, 80, 50, 40)
            commitbtn.addTarget(self, action: #selector(self.rightBtn), forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(commitbtn)
        }
        
    }
    func rightBtn(){
        //点击提交
        let id = UserModel.shareUser.id
        let text = self.textF?.text!
        if text != ""{
            UserModel.alterNickrequestData(id, nick: text!) { (error) in
                print(error)
                if error != nil{
                    SVProgressHUD.showErrorWithStatus("请求失败")
                }else{
                    SVProgressHUD.showErrorWithStatus("修改成功")
                }
            }
        }else{
            SVProgressHUD.showErrorWithStatus("昵称不能为空啊，宝贝")
        }
        
    }
    
}
