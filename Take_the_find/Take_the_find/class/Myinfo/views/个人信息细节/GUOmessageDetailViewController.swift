//
//  GUOmessageDetailViewController.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/22.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit
///昵称
var alertNick:String?
///个性签名
var alertSignature:String?
class GUOmessageDetailViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var nextPassw: UITextField!
    @IBOutlet weak var newPassW: UITextField!
    @IBOutlet weak var oldPassW: UITextField!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var SignatureTextF: UITextView!
    var iconM:UIImage?
    var imagePicker:UIImagePickerController!
    var str:String!
    @IBOutlet weak var nickL: UITextField!
    override func loadView() {
        if str == "昵称"{
            view = NSBundle.mainBundle().loadNibNamed("NickViewxib", owner: self, options: nil).last as! UIView
            if isLogin{
                if UserModel.shareUser.uname != nil{
                    nickL.placeholder = UserModel.shareUser.uname!
                }
            }
        }else if str == "签名"{
            view = NSBundle.mainBundle().loadNibNamed("SignatureView", owner: self, options: nil).last as! UIView
            if isLogin{
                if UserModel.shareUser.info != nil{
                    SignatureTextF.text = UserModel.shareUser.info!
                }
            }
        }else if str == "头像"{
            view = NSBundle.mainBundle().loadNibNamed("alterPicview", owner: self, options: nil).last as! UIView
        }else if str == "安全"{
            view = NSBundle.mainBundle().loadNibNamed("alterPassword", owner: self, options: nil).last as! UIView
        }
    }
     ///修改个性签名
    @IBAction func SignatureBtn(sender: AnyObject) {
        //修改个性签名
        let text = self.SignatureTextF?.text!
        if text != ""{
            if isLogin{
                let ID = UserModel.shareUser.id
                UserModel.alterSignaturerequestData(ID!, signature: text!) { (error) in
                    if error != nil{
                        print("修改个性签名-\(error)")
                    }else{
                        UserModel.shareUser.info = text!
                        alertSignature = text!
                    }
                }
            }else{
                SVProgressHUD.showErrorWithStatus("不登录就想修改个性签名，你咋不上天")
            }
        }else{
            SVProgressHUD.showErrorWithStatus("个性签名不能为空啊，宝贝")
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    ///修改昵称
    @IBAction func alertNickBtn(sender: AnyObject) {
        //点击提交
        let text = self.nickL?.text!
        if text != ""{
            if isLogin{
                let ID = UserModel.shareUser.id
                UserModel.alterNickrequestData(ID!, nick: text!) { (error) in
                    print(error)
                    if error != nil{
                        print("修改昵称-\(error)")
                    }else{
                        UserModel.shareUser.uname = text!
                        alertNick = text!
                    }
                }
            }else{
                SVProgressHUD.showErrorWithStatus("不登录就想改名，你咋不上天")
            }
        }else{
            SVProgressHUD.showErrorWithStatus("昵称不能为空啊，宝贝")
        }

    }
    ///拍照
    @IBAction func TakingPBtn(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate  = self
         imagePicker.allowsEditing = true
         imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.allowsEditing = true
        presentViewController(self.imagePicker, animated: true, completion: nil)
    }
    ///打开图片库
    @IBAction func PBaseBtn(sender: AnyObject) {
       self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(self.imagePicker, animated: true, completion: nil)
    }
    ///确定上传
    @IBAction func commitPBtn(sender: AnyObject) {
        if isLogin{
            if iconM != nil{
                UserModel.alertpicRequest(iconM!, userID: UserModel.shareUser.id, pic: "headimage")
            }
        }else{
            SVProgressHUD.showSuccessWithStatus("骚年还是去登录吧")
        }
        
    }
    ///修改密码
    @IBAction func alertPassBtn(sender: AnyObject) {
        //点击修改密码
        if newPassW.text != nextPassw.text{
            SVProgressHUD.showErrorWithStatus("俩次密码输入不一致")
        }else if  newPassW.text == "" {
            SVProgressHUD.showErrorWithStatus("密码不能为空")
        }else{
            let text = self.newPassW?.text!
            if text != ""{
                if isLogin{
                    let ID = UserModel.shareUser.id
                    UserModel.alterPasswordrequestData(ID!, password: text!) { (error) in
                        print(error)
                        if error != nil{
                             print("修改密码-\(error)")
                        }else{
                        }
                    }
                }else{
                    SVProgressHUD.showErrorWithStatus("不登录就想修改密码，你咋不上天")
                }
            }else{
                SVProgressHUD.showErrorWithStatus("密码不能为空啊，宝贝")
            }

        }
    }
    //定义两个图片获取方法
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.iconImage.image = image
            iconM = image
        }
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
   
}
