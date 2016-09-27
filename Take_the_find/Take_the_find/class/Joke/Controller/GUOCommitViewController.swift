//
//  GUOCommitViewController.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/27.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit

class GUOCommitViewController: UITableViewController {
    var model:DuanZModel!
    var page = 1
    var dataArr = [GUOCommitModel]()
    var headVH:CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTheHeadV()
        loadTheCommit()
    }
    func loadTheHeadV(){
        let headV = GUODZDetailview.setThecell(model)
        self.tableView.tableHeaderView = headV
        self.tableView.registerNib(UINib.init(nibName: "GUOCommitCell", bundle: nil), forCellReuseIdentifier: "GUOCommitCell")
    }
    func loadTheCommit(){
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { 
            DuanZModel.requestcommitData(self.model.id, page: 1, callBack: { (array, error) in
                if error == nil{
                    self.dataArr.removeAll()
                    self.page = 1
                    self.dataArr = array!
                    self.tableView.reloadData()
                    self.page += 1
                }
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
            })
        })
        self.tableView.mj_footer = MJRefreshBackGifFooter(refreshingBlock: { 
            DuanZModel.requestcommitData(self.model.id, page: self.page, callBack: { (array, error) in
                if error == nil{
                    let arrays = self.dataArr + array!
                    self.dataArr = arrays
                    self.tableView.reloadData()
                    self.page += 1
                }
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
            })

        })
        self.tableView.mj_header.beginRefreshing()
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
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
}
