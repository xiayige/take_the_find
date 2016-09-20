//
//  PictureSearchViewController.swift
//  targetApp
//
//  Created by qianfeng on 16/9/19.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit

class PictureSearchViewController: UIViewController {
    var type:String!
    var hotSeatchArray:[String]?
    var hisToryArray:[String]?
     lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "搜索对应类别下的图片"
        return searchBar
    }()
    lazy var tabView:UITableView = {
        let tabView = UITableView()
        tabView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H)
        tabView.contentInset = UIEdgeInsetsMake(NAV_H, 0,0, 0)
        tabView.dataSource = self
        tabView.delegate = self
        tabView.registerClass(GUOPictureSearchCell.self, forCellReuseIdentifier: "GUOPictureSearchCell")
        self.view.addSubview(tabView)
        return tabView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backColor
        self.automaticallyAdjustsScrollViewInsets = false
        if hotSeatchArray?.count != 0{
             self.tabView.reloadData()
        }
        setupNav()
       
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        readUserSearchDefaults()
    }
       override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }
    // 设置导航栏
    func setupNav() {
        self.navigationItem.titleView = self.searchBar
        searchBar.delegate = self
        let button = UIButton(type: .System)
        button.setTitle("清空历史记录", forState: .Normal)
        button.setTitleColor(UIColor.redColor(), forState: .Normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(self.cancelBtn), forControlEvents: .TouchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: #selector(navigationBackClick))
    }
   
}
extension PictureSearchViewController: UISearchBarDelegate{
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        /// 设置collectionView
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    /// 搜索按钮点击
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        /// 根据搜索条件进行搜索
        let keyword = searchBar.text
       //发送网络请求
        if keyword != ""{
            loadDetailData(keyword!)
        }else{
            SVProgressHUD.showWithStatus("请求参数不正确")
            SVProgressHUD.dismissWithDelay(1.0)
        }
    }
    ///清空按钮
    func cancelBtn(){
        alertCon("确定要清空历史记录吗?")
    }
    ///弹出框
    func alertCon(message:String){
        let alertCon = UIAlertController(title: "提示", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "好", style: UIAlertActionStyle.Default) { (alert) in
            self.deleteSearchHistory()
            self.tabView.reloadData()
        }
        let action1 = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: nil)
        alertCon.addAction(action)
        alertCon.addAction(action1)
        self.presentViewController(alertCon, animated: true, completion: nil)
    }
    /// 返回按钮、取消按钮点击
    func navigationBackClick() {
        navigationController?.popViewControllerAnimated(true)
    }
    ///加载数据
    func loadDetailData(keyword:String){
       //点击搜索加载数据传递内容和keyboard
        let detail = GUOSerachDetailViewController()
        detail.keyword = keyword
        detail.type = self.type
        detail.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detail, animated: true)
    }
    ///读取历史记录
    func readUserSearchDefaults(){
        let user = NSUserDefaults.standardUserDefaults()
        let array = user.arrayForKey("history") as? [String]
        self.hisToryArray = array
        self.tabView.reloadData()
    }
    ///删除历史记录
    func deleteSearchHistory(){
        let user = NSUserDefaults.standardUserDefaults()
        user.removeObjectForKey("history")
        user.synchronize()
    }
 }

//MARK:UITableViewDataSource 协议方法
extension PictureSearchViewController:UITableViewDataSource,UITableViewDelegate,GUOPictureSearchCelldelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            if hotSeatchArray?.count == nil{
                return 0
            }else{
                 return 1
            }
        }else{
            if hisToryArray?.count == nil{
                return 0
            }else{
                return (hisToryArray?.count)!
            }
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        if indexPath.section == 0{
                let cell = tableView.dequeueReusableCellWithIdentifier("GUOPictureSearchCell", forIndexPath: indexPath) as! GUOPictureSearchCell
                cell.cellClickdelegate = self
                cell.setTheContent(hotSeatchArray!)
                return cell
        }else{
            var cell = tableView.dequeueReusableCellWithIdentifier("cell")
            if cell == nil{
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")
            }
            cell?.imageView?.image = UIImage.init(named: "cm2_list_icn_recent")
            cell?.textLabel?.text = hisToryArray![indexPath.row]
            return cell!
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "热门搜索"
        }else{
            return "历史记录"
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 99
        }else{
            return 40
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("tab点击")
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
    func cellDidSelected(indexpath:NSIndexPath){
        loadDetailData(hotSeatchArray![indexpath.row])
    }
}
