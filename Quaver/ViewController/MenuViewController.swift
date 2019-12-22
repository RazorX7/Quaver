//
//  MenuViewController.swift
//  Quaver
//
//  Created by apple on 2019/12/1.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import AVFoundation



class MenuViewController: UIViewController {
    
    //var audioPlayer : AVAudioPlayer!
    //var soundUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //此处开启播放背景音乐的准备工作
        let session = AVAudioSession.sharedInstance()
        
        do {
            
            //启动音频会话的管理，此时会阻断后台音乐的播放
            try session.setActive(true)
            //设置音频操作类别，标示该应用仅支持音频的播放
            //try session.setCategory(AVAudioSession.Category.playback)
            try session.setCategory(AVAudioSession.Category.playback, mode: session.mode, options: AVAudioSession.CategoryOptions.allowAirPlay)
            //设置应用程序支持接受远程控制事件
            UIApplication.shared.beginReceivingRemoteControlEvents()
            
            //定义一个字符常量，描述声音文件的路经
            let path = Bundle.main.path(forResource: "background", ofType: "mp3")
            //将字符串路径，转换为网址路径
            //print(path)
            let soundUrl = URL(fileURLWithPath: path!)
            //soundUrl = URL(fileURLWithPath: path!)
            //print(soundUrl)
            
            do{
                try audioPlayer = AVAudioPlayer(contentsOf: soundUrl)
                audioPlayer.prepareToPlay()
                audioPlayer.volume = 1.0
                audioPlayer.numberOfLoops = -1
                audioPlayer.play()
            } catch {
                print("Load error.")
            }
            
            //对音频播放对象进行初始化，并加载指定的音频文件
            /*do{
                audioPlayer = try AVAudioPlayer(contentsOf: soundUrl)

            }
            catch{
                
            }*/
            //if (audioPlayer != nil){
            //audioPlayer.prepareToPlay()
            //设置音频播放对象的音量大小/
            //audioPlayer.volume = 1.0
            //设置音频的播放次数，-1为无限循环
            //audioPlayer.numberOfLoops = -1
            //开始播放
            //audioPlayer.play()
            //} else {
            //    print("Failed to find background music.")
            //}
            
        } catch {
            print("Failed to load background music.")
        }
        
    }
    
    
    //退出程序
    @IBAction func exitAtNow(_ sender: Any) {
        exit(0)
    }
    
    /*@IBAction func exitToHere(segue: UIStoryboardSegue){
        
        if (!audioPlayer.isPlaying){
            audioPlayer.play()
        }
        
    }*/
    
    /*@IBAction func ModeExitToHere(_ sender: Any) {
        
        if (!audioPlayer.isPlaying){
            audioPlayer.play()
        }
        
    }*/
    
    
    
    //从模式选择界面跳到该界面
    @IBAction func exitToHere(segue: UIStoryboardSegue){
        
        if (!audioPlayer.isPlaying){
            audioPlayer.play()
        }
        
    }
    
    /*@IBAction func TouchModeExitToHere(_ sender: Any) {
        
        if (!audioPlayer.isPlaying){
            audioPlayer.play()
        }
        
    }*/
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
