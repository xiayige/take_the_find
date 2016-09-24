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
        btn1.tag = 101
        danmV?.addSubview(btn2)
        danmV?.addSubview(btn1)
        danmV!.backgroundColor = backColor
        self.view.addSubview(danmV!)
    }
    ///发送弹幕
    func FSDBtnClick(btn:UIButton){
        if btn.tag == 100{
            //点击发送弹幕
            print("点击发送弹幕")
        }else{
            //点击关闭弹幕
             print("点击关闭弹幕")
        }
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
        if player != nil{
            if player?.state != .StateFailed {
                player?.pause()
            }
            player?.removeFromSuperview()
            danmV?.removeFromSuperview()
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
///wmplaer的协议方法
extension GUONextVideoViewController:WMPlayerDelegate{
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
    func wmplayer(wmplayer: WMPlayer!, clickedCloseButton closeBtn: UIButton!) {
        if player?.state != .StateFailed{
           player?.pause()
        }
        player?.removeFromSuperview()
        danmV?.removeFromSuperview()
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
        if state == .StateFailed{
            player?.removeFromSuperview()
            danmV?.removeFromSuperview()
        }
    }
    func wmplayerReadyToPlay(wmplayer: WMPlayer!, WMPlayerStatus state: WMPlayerState) {
        //将要播放
        if state == .StatusReadyToPlay{
            if damuArr.count != 0{
                print("添加弹幕")
                addDanMu()
            }
            
        }
    }
    ///添加弹幕
    func addDanMu(){
    }
    
}
