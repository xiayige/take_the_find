//
//  GUOMessageViewController.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/22.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit

class GUOMessageViewController: UIViewController,STPickerDateDelegate{

    @IBOutlet weak var qianMingBtn: UIButton!
    @IBOutlet weak var nickB: UIButton!
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
        setTheAlert()
    }
    func setTheUserModel(){
        if isLogin {
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
            if UserModel.shareUser.uname != nil{
                nickB.setTitle(UserModel.shareUser.uname!, forState: .Normal)
            }
            if UserModel.shareUser.info != nil{
                qianMingBtn.setTitle(UserModel.shareUser.info!, forState: .Normal)
            }
            if UserModel.shareUser.birth != nil{
                brithdayBtn.setTitle(UserModel.shareUser.birth!, forState: .Normal)
            }
        }
        
    }
    func setTheAlert(){
        if alertTag != nil{
            if alertTag == "0"{
                sexB.setTitle("男", forState: UIControlState.Normal)
            }else{
                sexB.setTitle("女", forState: UIControlState.Normal)
            }
        }
        if alertNick != nil{
            nickB.setTitle(alertNick!, forState: .Normal)
        }
        if alertSignature != nil{
            qianMingBtn.titleLabel?.numberOfLines = 0
            qianMingBtn.setTitle(alertSignature!, forState: .Normal)
        }
    }
    @IBAction func popBtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    ///点击退出
    func tuichuBtnClick(){
         //单例清空
        isLogin = false
        SVProgressHUD.showSuccessWithStatus("退出登录成功")
        self.navigationController?.popViewControllerAnimated(true)
    }
    ///头像
    @IBAction func iconBtn(sender: AnyObject) {
        let message = GUOmessageDetailViewController()
        message.hidesBottomBarWhenPushed = true
        message.str = "头像"
        self.navigationController?.pushViewController(message, animated: true)
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
        //修改性别  做转场动画
        let alertSex = GUOalertSexViewController()
        weak var weakSelf = self
        alertSex.transitioningDelegate = self
        alertSex.block = {(alertname) in
            if alertTag == "0"{
                weakSelf!.sexB.setTitle("男", forState: UIControlState.Normal)
            }else{
                weakSelf!.sexB.setTitle("女", forState: UIControlState.Normal)
            }
        }
        alertSex.modalPresentationStyle = .Custom
        self.presentViewController(alertSex, animated: true, completion: nil)
    }
    ///生日
    @IBAction func brithdayBtn(sender: AnyObject) {
        let pickDate = STPickerDate()
        pickDate.delegate = self
        pickDate.show()
    }
    ///签名
    @IBAction func qianMingBtn(sender: AnyObject) {
        let message = GUOmessageDetailViewController()
        message.hidesBottomBarWhenPushed = true
        message.str = "签名"
        self.navigationController?.pushViewController(message, animated: true)
    }
    ///安全
    @IBAction func anQuanBtn(sender: AnyObject) {
        let message = GUOmessageDetailViewController()
        message.hidesBottomBarWhenPushed = true
        message.str = "安全"
        self.navigationController?.pushViewController(message, animated: true)
    }
    
}
extension GUOMessageViewController:UIViewControllerTransitioningDelegate{
    //控制弹出视图
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?{
        return MyPresententContrller(presentedViewController: presented, presentingViewController: presenting)
    }
    //负责弹出动画 不从下方弹出
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        return PresentAnimation()
    }
    
    //负责消失的动画
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        return DisMissAnimation()
    }
    ///修改生日
    func pickerDate(pickerDate: STPickerDate, year: Int, month: Int, day: Int) {
        let text = String.init(format: "%d-%d-%d",year, month, day)
        weak var WeakSelf = self
        if isLogin{
            UserModel.alterBirthrequestData(UserModel.shareUser.id!, birth: text, calback: { (error) in
                if error == nil{
                    UserModel.shareUser.birth = text
                    WeakSelf!.brithdayBtn.setTitle(text, forState: UIControlState.Normal)
                }else{
                    
                }
            })
        }else{
            SVProgressHUD.showErrorWithStatus("骚年还是去登录吧")
        }
        
    }
}
