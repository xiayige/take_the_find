//
//  GUOJokeSuperViewController.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/26.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit

class GUOJokeSuperViewController: UIViewController {
    var dataArr = [DuanZModel]()
    var page = 1
    var type:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        setThetabView()
        if type == "段子"{
            addDTabHeadAndfotter()
        }else{
            addTabHeadAndfotter()
        }
    }
    lazy var tabView:UITableView = {
        var rect = self.view.bounds
        let tableView = UITableView.init(frame: rect)
        return tableView
    }()
    func setThetabView(){
        tabView.dataSource = self
        tabView.delegate = self
        tabView.backgroundColor = backColor
        tabView.contentInset = UIEdgeInsetsMake(NAV_H, 0, TAB_H, 0)
        tabView.backgroundColor = backColor
        tabView.registerNib(UINib.init(nibName: "GUODuanZiTableViewCell", bundle: nil), forCellReuseIdentifier: "GUODuanZiTableViewCell")
        self.view.addSubview(tabView)
    }
    ///段子添加上拉和下拉
    func addDTabHeadAndfotter(){
        tabView.mj_header = MJRefreshGifHeader(refreshingBlock: {
            DuanZModel.requestDJokeData(1) { (array, error) in
                if error == nil{
                    self.dataArr.removeAll()
                    self.page = 1
                    self.dataArr = array!
                    self.tabView.reloadData()
                    self.page += 1
                }
                self.tabView.mj_footer.endRefreshing()
                self.tabView.mj_header.endRefreshing()
            }
        })
        tabView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            DuanZModel.requestDJokeData(self.page) { (array, error) in
                if error == nil{
                    self.dataArr.appendContentsOf(array!)
                    self.tabView.reloadData()
                    self.page += 1
                }
            }
            self.tabView.mj_footer.endRefreshing()
            self.tabView.mj_header.endRefreshing()
        })
        tabView.mj_header.beginRefreshing()
    }

    ///趣图添加上拉和下拉
    func addTabHeadAndfotter(){
        tabView.mj_header = MJRefreshGifHeader(refreshingBlock: {
            DuanZModel.requestJokeData(1) { (array, error) in
                if error == nil{
                    self.dataArr.removeAll()
                    self.page = 1
                    self.dataArr = array!
                    self.tabView.reloadData()
                    self.page += 1
                }
                self.tabView.mj_footer.endRefreshing()
                self.tabView.mj_header.endRefreshing()
            }
        })
        tabView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            DuanZModel.requestJokeData(self.page) { (array, error) in
                if error == nil{
                    self.dataArr.appendContentsOf(array!)
                    self.tabView.reloadData()
                    self.page += 1
                }
            }
            self.tabView.mj_footer.endRefreshing()
            self.tabView.mj_header.endRefreshing()
        })
        tabView.mj_header.beginRefreshing()
    }
}
extension GUOJokeSuperViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataArr.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("GUODuanZiTableViewCell", forIndexPath: indexPath) as! GUODuanZiTableViewCell
            let model = dataArr[indexPath.row]
            cell.btndelegate = self
            cell.setThecellWithModel(model)
            return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            let model = dataArr[indexPath.row]
            if model.cellH == nil{
                return  100
            }else{
                return model.cellH!
            }
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = dataArr[indexPath.row]
        print(model.id)
    }
}
extension GUOJokeSuperViewController:GUODuanZiTableViewCellDelegate{
    func moreBtnClick(models: String) {
        let next = GUODNextViewController()
        next.strUrl = models
        self.presentViewController(next, animated: true, completion: nil)
    }
}
