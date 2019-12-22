//
//  ModeViewController.swift
//  Quaver
//
//  Created by apple on 2019/12/7.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit


//模式选择类：可以选择触控或者声音控制

class ModeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //在转入关卡选择界面时候的预处理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowTouch" {
            //key code ！！！
            //如果是触摸模式
            //修改参数
            let data = 1
            let contactVC = segue.destination as! TouchStageViewController
            contactVC.OperateMode = data
            
        } else if segue.identifier == "ShowSound" {
            
            //如果是声控模式
            //修改参数
            let data = 2
            let contactVC = segue.destination as! SoundStageViewController
            contactVC.OperateMode = data
        }
    }
    
    //游戏过程中终止游戏，返回到该界面
    @IBAction func TouchSceneUnwindToSegue (segue : UIStoryboardSegue) {
        
        //继续播放背景音乐
        if (!audioPlayer.isPlaying){
                   audioPlayer.play()
               }
        
    }
    
    
    //游戏过程中终止游戏，返回到该界面
    @IBAction func SoundSceneUnwindToSegue (segue : UIStoryboardSegue) {
        
        //继续播放背景音乐
        if (!audioPlayer.isPlaying){
                   audioPlayer.play()
               }
       
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
