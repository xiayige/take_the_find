//
//  JokeViewController.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/20.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit

class GUOJokeViewController: GUOBaseViewController,UIScrollViewDelegate {
    var segment:UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
         setTheChildVC()
        setTheNav()
    }
    ///添加子控制器
    func setTheChildVC(){
        let array = ["段子","趣图笑话"]
        var i:CGFloat = 0
        for str in array{
            let DzVC = GUOJokeSuperViewController()
            DzVC.type = str
            self.addChildViewController(DzVC)
            i += 1
        }
    }
    ///设置顶部导航条
    func setTheNav(){
        TopscrollView.contentSize = CGSizeMake(2 * SCREEN_W, 0)
        TopscrollView.pagingEnabled = true
        TopscrollView.delegate = self
        TopscrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(TopscrollView)
        segment = UISegmentedControl(frame: CGRectMake(50, 5, 200, 30))
        segment.insertSegmentWithTitle("段子", atIndex: 0, animated: true)
        segment.insertSegmentWithTitle("趣图笑话", atIndex: 1, animated: true)
        segment.tintColor = UIColor.orangeColor()
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(self.segmentChange(_:)), forControlEvents: .ValueChanged)
        self.navigationItem.titleView = segment
        scrollViewDidEndScrollingAnimation(TopscrollView)
    }
    func segmentChange(segment: UISegmentedControl){
        let index = segment.selectedSegmentIndex
        //选中段
        self.TopscrollView.setContentOffset(CGPointMake(CGFloat(index) * SCREEN_W, 0), animated: true)
    }

    lazy var TopscrollView:UIScrollView = {
        let rect = self.view.bounds
        let top = UIScrollView.init(frame: rect)
        return top
    }()
}
extension GUOJokeViewController{
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / SCREEN_W
        segment.selectedSegmentIndex = Int(page)
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / SCREEN_W
        let VC = self.childViewControllers[Int(page)] as! GUOJokeSuperViewController
        var rect = self.view.bounds
        rect.origin.x = page * SCREEN_W
        VC.view.frame = rect
        TopscrollView.addSubview(VC.view)
    }
}