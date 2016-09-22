//
//  MyinfoViewController.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/20.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit

class NewUserController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var passAginField: UITextField!
    
    @IBOutlet weak var nickField: UITextField!
    
    var token:String! = ""
    var userId:NSInteger! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "loginBackgroundImage")!)
    }

    
    @IBAction func newUser(sender: AnyObject) {
        if passwordField.text != passAginField.text{
            SVProgressHUD.showErrorWithStatus("俩次密码不一致")
        }else{
            UserModel.registRequestData(nickField.text!, password: passAginField.text!, callBack: { (dict, error) in
                if error == nil{
                    //注册成功
                    SVProgressHUD.showSuccessWithStatus("注册成功,快去登录吧")
                    UserModel.shareUser.id = dict!["id"] as! String
                    UserModel.shareUser.email = dict!["email"] as? String
                   //登录
                    self.navigationController?.popViewControllerAnimated(true)
                }else{
                   SVProgressHUD.showErrorWithStatus("网络请求失败")
                }
            })
        }
    }
    
    @IBAction func backPreView(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
