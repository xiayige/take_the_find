//
//  GUOCommitViewController.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/27.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit

class GUOCommitViewController: UITableViewController,GUODZDetailviewDelegate {
    var model:DuanZModel!
    var shareText:String?
    var page = 1
    var dataArr = [GUOCommitModel]()
    var height:CGFloat = 10
    var headVH:CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 120
        self.tableView.registerNib(UINib.init(nibName: "GUOCommitCell", bundle: nil), forCellReuseIdentifier: "GUOCommitCell")
        loadTheCommit()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadTheHeadV()
    }
    func loadTheHeadV(){
        GUODZDetailview.setThecell(model) { (headV, height) in
            headV.frame = CGRectMake(0, 20, SCREEN_W, height + 30)
            self.tableView.tableHeaderView = headV
            headV.sharedelegate = self
            self.tableView.reloadData()
        }
        shareText = model.content
    }
    func loadTheCommit(){
            DuanZModel.requestcommitData(self.model.id, page: 1, callBack: { (array, error) in
                if error == nil{
                    self.dataArr.removeAll()
                    self.page = 1
                    self.dataArr = array!
                    self.tableView.reloadData()
                    self.page += 1
                }
                self.tableView.mj_footer.endRefreshing()
            })
        self.tableView.mj_footer = MJRefreshBackGifFooter(refreshingBlock: { 
            DuanZModel.requestcommitData(self.model.id, page: self.page, callBack: { (array, error) in
                if error == nil{
                    let arrays = self.dataArr + array!
                    self.dataArr = arrays
                    self.tableView.reloadData()
                    self.page += 1
                }
                self.tableView.mj_footer.endRefreshing()
            })

        })
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("GUOCommitCell", forIndexPath: indexPath) as! GUOCommitCell
            let model = dataArr[indexPath.row]
            cell.setTheCell(model, Index: indexPath.row + 1)
            return cell
        
    }
    ///点击分享按钮
    func sharebtnClick() {
        UMSocialDataService.defaultDataService().postSNSWithTypes([UMShareToWechatSession], content: shareText, image: UIImage.init(named: "2.jpg"), location: nil, urlResource: UMSocialUrlResource.init(snsResourceType: UMSocialUrlResourceTypeWeb, url: "http://www.baidu.com"), presentedController: self) { (response) in
            //分享结束后返回当前应用的回调闭包
            if response.responseCode == UMSResponseCodeSuccess{
                print("自定义分享成功")
            }else if response.responseCode == UMSResponseCodeCancel{
                print("用户取消分享")
            }else if response.responseCode == UMSResponseCodeFaild{
                print("分享失败")
            }
        }
    }
}
