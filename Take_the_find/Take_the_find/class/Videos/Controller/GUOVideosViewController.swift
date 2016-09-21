//
//  VideosViewController.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/20.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit

class GUOVideosViewController: GUOBaseViewController,SDCycleScrollViewDelegate {
    var bannarArray:[VideoModel]?
    var cateArray:[String]?
    var modelsArray:NSMutableArray?
    var tabView = UITableView()
    lazy var adView:SDCycleScrollView = {
        let adView = SDCycleScrollView.init(frame:CGRectMake(0, 0, SCREEN_W, adviewH), delegate: self, placeholderImage: UIImage.init(named: ""))
        //是否启动轮播
        adView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        //是否显示pageControl
        adView.currentPageDotColor = UIColor.whiteColor()
        //pageControl显示的位置
        return adView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    func loadData(){
        VideoModel.requestgetRecommendVideoData { (bannarArray, cateArray, modelsArray, error) in
            if error == nil{
                self.bannarArray = bannarArray
                self.cateArray = cateArray
                self.modelsArray = modelsArray
                var titleArray = [String]()
                var imageArr = [String]()
                for model in bannarArray!{
                    let str = "http://www.cat666.com/" + model.bigpic
                    imageArr.append(str)
                    titleArray.append(model.fname)
                }
                //给轮播视图设置图片数组
                self.adView.imageURLStringsGroup = imageArr
                self.adView.titlesGroup = titleArray
                self.setThetabLeview()
            }else{
                print("视频请求出错-\(error)")
            }
        }
    }
    func setThetabLeview(){
        tabView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H)
        tabView.contentInset = UIEdgeInsetsMake(NAV_H, 0, TAB_H, 0)
        self.automaticallyAdjustsScrollViewInsets = false
        tabView.dataSource = self
        tabView.delegate = self
        tabView.sectionHeaderHeight = 20
        tabView.sectionFooterHeight = 20
        tabView.rowHeight = videoH
        tabView.allowsSelection = false
        tabView.backgroundColor = backColor
        tabView.tableHeaderView = adView
        tabView.registerClass(GUOVideoViewCell.self, forCellReuseIdentifier: "GUOVideoViewCell")
        self.view.insertSubview(tabView, atIndex: 0)
    }
  
}
extension GUOVideosViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return modelsArray!.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCellWithIdentifier("GUOVideoViewCell", forIndexPath: indexPath) as! GUOVideoViewCell
        cell.backgroundColor = backColor
        let modelArr = modelsArray![indexPath.section] as! [VideoModel]
        cell.dataArr = modelArr
        return cell
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let str = cateArray![section]
        let headV = GUOHeadView.headView(str)
        return headV
    }
}