//
//  GUONextVideoViewController.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/24.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit
class GUONextVideoViewController:UIViewController{
    @IBOutlet weak var playSuperV: UIView!
    var player:WMPlayer?
    ///放置发送弹幕的父视图
    ///弹幕条数
     var i:Double = 0
    var danmV:UIView?
    var damuArr = [String]()
    var istrans = false
    ///视频信息
    @IBOutlet weak var userVH: NSLayoutConstraint!
    @IBOutlet weak var PLView: UIView!
    @IBOutlet weak var videoVH: NSLayoutConstraint!
    //播放
    @IBOutlet weak var BFBtn: UIButton!
    @IBOutlet weak var videoInfoL: UILabel!
    @IBOutlet weak var SZBtn: UIButton!
    @IBOutlet weak var DZBtn: UIButton!
    @IBOutlet weak var FXBtn: UIButton!
    @IBOutlet weak var videoP: UIImageView!
    @IBOutlet weak var videoL: UILabel!
    ///用户信息
    @IBOutlet weak var userP: UIImageView!
    @IBOutlet weak var userInfoL: UILabel!
    @IBOutlet weak var userVip: UIImageView!
    @IBOutlet weak var userNL: UILabel!
    var videoM:VideoModel?
    var userM:UserModel?
    ///弹幕视图
    lazy var danMuView:CFDanmakuView? = {
        let danmuV = CFDanmakuView()
        danmuV.frame = self.player!.bounds
        danmuV.duration = 6.5
        danmuV.centerDuration = 2.5
        danmuV.lineHeight = 25
        danmuV.maxShowLineCount = 15
        danmuV.delegate = self
        danmuV.maxCenterLineCount = 5
        return danmuV
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
         setThecontent()
    }
    override func loadView() {
       let  pview = NSBundle.mainBundle().loadNibNamed("GUOVideoHead", owner: self, options: nil).last as! UIView
        view = pview
    }
    func setThecontent(){
        //视频
        if videoM != nil{
            DZBtn.setTitle(videoM!.viewcounts + "人点赞", forState: .Normal)
            if videoM?.videodanmu != nil{
                FXBtn.setTitle(videoM!.videodanmu! + "人分享", forState: .Normal)
                loadIngDanMu()
            }
            videoP.sd_setImageWithURL(NSURL.init(string: videoM!.bigpicStr))
            videoL.text = videoM!.fname
            if videoM?.Description != nil{
                videoInfoL.text = videoM!.Description
            }
        }
        //用户
        if userM != nil{
            userP.layer.cornerRadius = 40
            userP.layer.masksToBounds = true
            userP.sd_setImageWithURL(NSURL.init(string: userM!.iconStr!))
            userInfoL.text = userM!.info!
            userNL.text = userM!.uname!
        }
        self.view.layoutIfNeeded()
        
        let getVmaxY = CGRectGetMaxY(self.PLView.frame)
        videoVH.constant = getVmaxY + 10
        let getUmaxY = CGRectGetMaxY(self.userInfoL.frame)
        userVH.constant = getUmaxY + 20
    }
    ///加载弹幕
    func loadIngDanMu(){
        VideoModel.requestgetDanmu(videoM!.id) { (danmuArr, error) in
            if error == nil{
                if danmuArr?.count != 0{
                    for str in danmuArr!{
                        self.danmuXX(str)
                    }
                }
            }
        }
    }
    func danmuXX(str:String){
        let array = str.componentsSeparatedByString("\",")
        let str = array[0]
        let str1 = str.stringByReplacingOccurrencesOfString("{ \"text\":\"", withString:"")
       damuArr.append(str1)
    }
    ///点击点赞
    @IBAction func DZBtnCllick(sender: AnyObject) {
        print("点击点赞")
    }
    ///点击分享
    @IBAction func FXBtnClick(sender: AnyObject) {
         print("点击分享")
    }
    ///点击播放视频
    @IBAction func videoBFClick(sender: AnyObject) {
        var rect = self.videoP.frame
        rect.origin.x = 28 + rect.origin.x
        rect.origin.y = 20 + rect.origin.y
        player = WMPlayer.init(frame: rect)
        player!.URLString = videoM!.videourl
        player!.delegate = self
        player?.closeBtnStyle = .Close
        player!.play()
        self.view.addSubview(player!)
        danmV = UIView.init(frame: CGRectMake(player!.frame.origin.x, player!.frame.origin.y + player!.frame.height, player!.frame.width, 44))
        let width = player!.frame.width / 2
        let btn1 = UIButton(type: .System)
        btn1.setTitle("发送弹幕", forState: .Normal)
        btn1.addTarget(self, action: #selector(self.FSDBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btn1.tag = 100
        btn1.frame = CGRectMake(0, 0, width, 44)
        btn1.backgroundColor = backColor
        let btn2 = UIButton(type: .System)
        btn2.setTitle("关闭弹幕", forState: .Normal)
        btn2.addTarget(self, action: #selector(self.FSDBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btn2.frame = CGRectMake(width,0 , width, 44)
        btn2.backgroundColor = backColor
        btn2.tag = 101
        danmV?.addSubview(btn2)
        danmV?.addSubview(btn1)
        danmV!.backgroundColor = backColor
        self.view.addSubview(danmV!)
    }
    
    ///点击收藏
    @IBAction func SCBtnClick(sender: AnyObject) {
         print("点击收藏")
    }
    ///点击关注
    @IBAction func GZBtnClick(sender: AnyObject) {
         print("点击关注")
    }
    
    @IBAction func popBtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    ///移除播放器
    func releasePlay(){
        player?.pause()
        player?.removeFromSuperview()
        player?.playerLayer.removeFromSuperlayer()
        player?.player.replaceCurrentItemWithPlayerItem(nil)
        player?.currentItem = nil
        player?.player = nil
        //player?.autoDismissTimer.invalidate()
        player?.autoDismissTimer = nil
        player?.playOrPauseBtn = nil
        player?.playerLayer = nil
        player = nil
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    deinit{
        self.releasePlay()
        danmV?.removeFromSuperview()
    }
}
///wmplaer的协议方法
extension GUONextVideoViewController:WMPlayerDelegate{
    ///双击屏幕
    func wmplayer(wmplayer: WMPlayer!, doubleTaped doubleTap: UITapGestureRecognizer!) {
        if !istrans{
            UIView.animateWithDuration(1.0) {
                self.player?.frame = CGRectMake(10, 100, SCREEN_W - 20, SCREEN_W - 20)
                var rect = self.player?.frame
                rect?.origin.y += (rect?.height)!
                rect?.size.height = 40
                self.danmV?.frame = rect!
            }
            player?.play()
        }else{
            var rect = self.videoP.frame
            rect.origin.x = 28 + rect.origin.x
            rect.origin.y = 20 + rect.origin.y
            UIView.animateWithDuration(1.0) {
                self.player?.frame = rect
                var danrect = self.player?.frame
                danrect?.origin.y += (danrect?.height)!
                danrect?.size.height = 40
                self.danmV?.frame = danrect!
            }
            player?.play()
        }
       istrans = !istrans
    }
    ///点击关闭按钮
    func wmplayer(wmplayer: WMPlayer!, clickedCloseButton closeBtn: UIButton!) {
        if player != nil{
        releasePlay()
        danmV?.removeFromSuperview()
        }
    }
    
    func wmplayer(wmplayer: WMPlayer!, clickedFullScreenButton fullScreenBtn: UIButton!) {
        if player != nil{
            if !istrans{
                UIView.animateWithDuration(1.0) {
                    self.player?.frame = CGRectMake(10, 100, SCREEN_W - 20, SCREEN_W - 20)
                    var rect = self.player?.frame
                    rect?.origin.y += (rect?.height)!
                    rect?.size.height = 40
                    self.danmV?.frame = rect!
                }
                
            }else{
                var rect = self.videoP.frame
                rect.origin.x = 28 + rect.origin.x
                rect.origin.y = 20 + rect.origin.y
                UIView.animateWithDuration(1.0) {
                    self.player?.frame = rect
                    var danrect = self.player?.frame
                    danrect?.origin.y += (danrect?.height)!
                    danrect?.size.height = 40
                    self.danmV?.frame = danrect!
                }
            }
            istrans = !istrans
        }
    }
    func wmplayerFailedPlay(wmplayer: WMPlayer!, WMPlayerStatus state: WMPlayerState) {
        if player != nil{
            releasePlay()
            danmV?.removeFromSuperview()
        }
    }
    func wmplayerReadyToPlay(wmplayer: WMPlayer!, WMPlayerStatus state: WMPlayerState) {
        //将要播放
        if state == .StatusReadyToPlay{
            if damuArr.count != 0{
                addDanMu()
            }
        }
    }
}
extension GUONextVideoViewController:CFDanmakuDelegate{
    ///添加弹幕
    func addDanMu(){
        addDanmuData()
        player?.addSubview(danMuView!)
        danMuView?.start()
    }
    ///添加弹幕数据
    func addDanmuData(){
        let array = NSMutableArray()
       
        for str in damuArr{
            let danMudata = CFDanmaku()
            let attrStr = NSMutableAttributedString.init(string: str, attributes: [NSFontAttributeName:UIFont.boldSystemFontOfSize(15),NSForegroundColorAttributeName:getranDomColor()])
            danMudata.contentStr = attrStr
            danMudata.timePoint = player!.currentTime() + 0.8*i
            array.addObject(danMudata)
            i += 1
        }
        danMuView?.prepareDanmakus(array as [AnyObject])
    }
    ///添加随机色
    func getranDomColor()->UIColor{
        let r = CGFloat(Double(arc4random_uniform(256))/255.0)
        let g = CGFloat(Double(arc4random_uniform(256))/255.0)
        let b = CGFloat(Double(arc4random_uniform(256))/255.0)
        let color = UIColor.init(red: r, green: g, blue: b, alpha: 1.0)
        return color
    }
    func danmakuViewIsBuffering(danmakuView: CFDanmakuView!) -> Bool {
        return false
    }
    func danmakuViewGetPlayTime(danmakuView: CFDanmakuView!) -> NSTimeInterval {
        let curritem = player?.currentTime()
        guard (player?.currentItem.duration) != nil else{
            return  20
        }
        let anyItem = CMTimeGetSeconds((player?.currentItem.duration)!)
        let value = curritem! / Double(anyItem)
        if value == 1{
            danMuView?.stop()
        }
        return value * 50
    }
    func addOneDanMu(str:String){
        let danMudata = CFDanmaku()
        let attrStr = NSMutableAttributedString.init(string: str, attributes: [NSFontAttributeName:UIFont.boldSystemFontOfSize(15),NSForegroundColorAttributeName:getranDomColor()])
        danMudata.contentStr = attrStr
        danMudata.timePoint = player!.currentTime() + 0.8 * i
        i += 1
        danMuView?.sendDanmakuSource(danMudata)
    }
    ///发送弹幕
    func FSDBtnClick(btn:UIButton){
        if btn.tag == 100{
            //点击发送弹幕
            addOneDanMu("-我是弹幕-我是弹幕-我是弹幕-我是弹幕")
        }else{
            //点击关闭弹幕
            danMuView?.hidden = btn.selected
            btn.selected = !btn.selected
        }
    }
}
