//
//  PictureViewController.swift
//  targetApp
//
//  Created by qianfeng on 16/9/18.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit
class PictureViewController: GUOBaseViewController {
    var topBtnView = UIView()
    var BottomView = UIScrollView()
    var preBtn:UIButton?
    var selectefIndex:Int!
    var cateArray:[String]?
    let btnArr = ["美女","设计","壁纸","搞笑","宠物","摄影"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backColor
        setTheSubView()
        setChildVC()
        setTheTopBtn()
        setTheBottomScroolView()
        setupNav()
    }
    //MARK:设置子视图
    func setTheSubView(){
        topBtnView.frame = CGRectMake(0, NAV_H, SCREEN_W, topBtn_H)
        BottomView.frame = self.view.bounds
        self.view.addSubview(topBtnView)
        self.view.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.insertSubview(BottomView, atIndex: 0)
        
    }
    /// 设置导航栏
    func setupNav() {
        view.backgroundColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_ios_search"), style: .Plain, target: self, action: #selector(PicturerightBtnClick))
    }
    
    func PicturerightBtnClick() {
        let searchBarVC = PictureSearchViewController()
        searchBarVC.type = btnArr[selectefIndex]
        searchBarVC.hotSeatchArray = cateArray
        searchBarVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchBarVC, animated: true)
    }
     //MARK:添加子控制器
    func setChildVC(){
        for str in btnArr{
            let pictureVC = PictureCollectionController.loadTheVC()
            pictureVC.type = str
            self.addChildViewController(pictureVC)
        }
    }
    //MARK:设置顶部视图
    func setTheTopBtn(){
        let btnW = SCREEN_W / CGFloat(btnArr.count)
        for i in 0..<btnArr.count{
            let btn = UIButton(type: .System)
            btn.frame = CGRectMake(CGFloat(i) * btnW, 0, btnW, topBtn_H)
            btn.setTitle(btnArr[i], forState: .Normal)
            btn.tag = 100 + i
            btn.addTarget(self, action: #selector(self.btnClick(_:)), forControlEvents: .TouchUpInside)
            btn.setBackgroundImage(UIImage.init(named: "cell-button-line"), forState: .Normal)
            btn.setBackgroundImage(UIImage.init(named: "cell-button-line"), forState: .Selected)
             btn.setBackgroundImage(UIImage.init(named: "cell-button-line"), forState: .Highlighted)
            btn.titleLabel?.font = UIFont.systemFontOfSize(15)
            btn.setTitleColor(UIColor.grayColor(), forState: .Normal)
            btn.setTitleColor(UIColor.blackColor(), forState: .Selected)
            topBtnView.addSubview(btn)
            if i == 0{
                btnClick(btn)
            }
        }
    }
    //MARK:设置底部视图
    func setTheBottomScroolView(){
        BottomView.bounces = false
        BottomView.delegate = self
        BottomView.contentSize = CGSizeMake(CGFloat(btnArr.count) * SCREEN_W, 0)
        BottomView.showsHorizontalScrollIndicator = false
        BottomView.pagingEnabled = true
        BottomView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    //MARK:按钮点击事件
    func btnClick(btn:UIButton){
        preBtn?.selected = false
        btn.selected = true
        selectefIndex = btn.tag - 100
        preBtn = btn
        let coffsetx = CGFloat(btn.tag - 100) * SCREEN_W
        BottomView.setContentOffset(CGPointMake(coffsetx, 0), animated: true)
        scrollViewDidEndScrollingAnimation(BottomView)
    }
}
//MARK:scrollView 的协议方法
extension PictureViewController:UIScrollViewDelegate{
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / SCREEN_W)
        let childVC = self.childViewControllers[page] as! PictureCollectionController
        var rect = self.view.bounds
        rect.origin.x = scrollView.contentOffset.x
        childVC.view.frame = rect
        childVC.block = {
            array in
            self.cateArray = array
        }
        BottomView.addSubview(childVC.view)
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / SCREEN_W)
        let btn = topBtnView.viewWithTag(100 + page) as! UIButton
        self.btnClick(btn)
        scrollViewDidEndScrollingAnimation(scrollView)
    }
}