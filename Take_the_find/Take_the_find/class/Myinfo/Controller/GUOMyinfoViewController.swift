//
//  MyinfoViewController.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/20.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit
class GUOMyinfoViewController: GUOBaseViewController {
    
    var headImage :UIImageView! = nil
    var nameL:UILabel! = nil
    var  nickL:UILabel! = nil
    var headH:CGFloat = 240
    var ishidden = true
    lazy var tableView:UITableView = {
        
        let table = UITableView.init(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), style: UITableViewStyle.Grouped)
        table.showsVerticalScrollIndicator = false
        table.delegate = self
        
        table.dataSource = self
        return table
    }()
    //头部视图
    lazy var headerView:UIView = {
        let header = UIImageView.init(frame: CGRectMake(0, 0, self.view.frame.size.width, self.headH))
        header.image = UIImage.init(named: "beauty_consultant_showing_girl_256px_1081733_easyicon.net (1)")
        header.userInteractionEnabled = true
        let setBtn = UIButton.init(frame: CGRectMake(self.view.frame.size.width - 70, 35, 30, 30))
        setBtn.setImage(UIImage.init(named: "configure"), forState: UIControlState.Normal)
        setBtn.addTarget(self, action: #selector(self.settingBtnClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        header.addSubview(setBtn)
        let blackView = UIView.init(frame: CGRectMake(0, header.frame.size.height - 100, header.frame.size.width, 100))
        blackView.backgroundColor = UIColor.blackColor()
        blackView.alpha = 0.5
        header.addSubview(blackView)
        let imageH:CGFloat = 70
        self.headImage = UIImageView.init(frame: CGRectMake(20, blackView.frame.origin.y - imageH/2, imageH, imageH))
        self.nameL = UILabel.init(frame: CGRectMake(20 + imageH + 20, blackView.frame.origin.y - imageH/2 + 30, 100, imageH))
        
        self.nameL.textColor = UIColor.whiteColor()
        self.nameL.textAlignment = .Center
        self.nameL.numberOfLines = 0
        self.nameL.font = UIFont.boldSystemFontOfSize(15)
        header.addSubview(self.nameL)
        self.headImage.image = UIImage.init(named: "setup-head-default")
        self.headImage.userInteractionEnabled = true
        self.headImage.addGestureRecognizer({
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.headimageClick(_:)))
            return tap
            }())
        header.addSubview(self.headImage)
        self.nickL = UILabel.init(frame: CGRectMake(imageH/2, imageH + self.headImage.mj_y + 10, self.view.frame.size.width - imageH, 30))
        self.nickL.textColor = UIColor.whiteColor()
        self.nickL.font = UIFont.systemFontOfSize(12)
        self.nickL.text = "快去登录吧，发现更多精彩世界"
        header.addSubview(self.nickL)
        
        return header
    }()
    //数据源
    lazy var dataArray: NSMutableArray = {
        let path = NSBundle.mainBundle().pathForResource("Mine", ofType: "plist")
        let array = NSMutableArray.init(contentsOfFile: path!)
        return array!
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.tableView)
        self.tableView.tableHeaderView = self.headerView
        tableView.bounces = false
        self.headImage.layer.cornerRadius = 35
        self.headImage.layer.masksToBounds = true
        //添加监听头像通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.alertSucess(_:)), name: "alertIconsucess", object: nil)
    }
    ///头像上传成功
    func alertSucess(noti:NSNotification){
        let image = noti.object as! UIImage
        headImage.image = image
    }
    deinit{
         NSNotificationCenter.defaultCenter().removeObserver(self, name: "alertIconsucess", object: nil)
    }
    func headimageClick(tap:UITapGestureRecognizer){
        let login = GUOLoginViewController()
        self.navigationItem.hidesBackButton = true
        login.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(login, animated: true)
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        setTheHeadView()
    }
    override func viewWillDisappear(animated: Bool) {
         self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    ///判断用户状态
    func setTheHeadView(){
        if isLogin {
            //登录
            self.nameL.hidden = false
            if UserModel.shareUser.uname == nil{
                self.nameL.text = UserModel.shareUser.email
            }else{
                self.nameL.text = UserModel.shareUser.uname
            }
            
            if UserModel.shareUser.info == ""{
                self.nickL.text = "这个人太懒了，没有签名,设置个人信息吧"
            }else{
                self.nickL.text = UserModel.shareUser.info
            }
            self.nickL.textColor = UIColor.whiteColor()
            if UserModel.shareUser.headpic != nil{
                let str = "http://cat666.com/" + UserModel.shareUser.headpic!
                self.headImage.sd_setImageWithURL(NSURL.init(string: str))
            }
            self.tableView.reloadData()
        }else{
            self.headImage.image = UIImage.init(named: "setup-head-default")
            self.nameL.hidden = true
            self.nickL.text = "快去登录吧，发现更多精彩世界"
            self.nickL.textColor = UIColor.whiteColor()
            self.tableView.reloadData()
        }
    }
    ///点击登录
    func settingBtnClicked(button:UIButton)->Void
    {
        let loginVC = NewUserController.init()
        loginVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    ///点击个人消息
    func PersonMessage(){
        let message = GUOMessageViewController()
        message.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(message, animated: true)
    }
}
// MARK: - UITableView协议方法
extension GUOMyinfoViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let array = self.dataArray.objectAtIndex(section) as! NSArray
        
        return array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "Identify"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil
        {
            cell = UITableViewCell.init(style: UITableViewCellStyle.Value1, reuseIdentifier: cellId)
            cell?.textLabel?.textColor = UIColor.blackColor()
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell?.textLabel?.font = UIFont.systemFontOfSize(15)
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
        }
        let array = self.dataArray.objectAtIndex(indexPath.section) as! NSArray
        cell?.textLabel?.text = array.objectAtIndex(indexPath.row) as? String
        
        if indexPath.section == 1 && indexPath.row == 1
        {
            let hotPack = UIImageView.init(frame: CGRectMake(self.view.frame.size.width - 100, 0, 75, 50))
            hotPack.image = UIImage.init(named: "hotpack.jpg")
            cell?.contentView .addSubview(hotPack)
        }
        if indexPath.section == 2 && indexPath.row == 0
        {
            cell?.detailTextLabel?.textColor = UIColor.lightGrayColor()
            
            cell?.detailTextLabel?.text = "登录后可查看收藏"
            cell?.detailTextLabel?.font = UIFont.systemFontOfSize(14)
            
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 50
    }
    //组头视图的高度
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 9
    }
    //组尾视图的高度
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 1
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  view = UIView.init(frame: CGRectMake(0, 0, self.view.frame.size.width, 5))
        view.backgroundColor = UIColor.init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        //        view.backgroundColor = UIColor.redColor()
        return view
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let  view = UIView.init(frame: CGRectMake(0, 0, self.view.frame.size.width, 1))
        view.backgroundColor = UIColor.init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        return view
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let array = dataArray[indexPath.section] as! NSArray
        if array[indexPath.row] as! String == "个人信息"{
            PersonMessage()
        }
    }

}

