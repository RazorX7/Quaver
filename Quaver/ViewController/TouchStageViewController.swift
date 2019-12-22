//
//  TouchStageViewController.swift
//  Quaver
//
//  Created by 行杳 on 2019/12/11.
//  Copyright © 2019 apple. All rights reserved.
//


/*
 
 TouchStageViewController： 选择触控方式进行游戏后的关卡选择界面
 
 */


import UIKit


class TouchStageViewController: UIViewController {

    //操作模式传值 ———— 1: 触控， 2: 声控
    var OperateMode = 0
    
    //关卡一
    @IBOutlet weak var stageOne_button: UIButton!
    
    
    //关卡二
    
    @IBOutlet weak var stageTwo_button: UIButton!
    
    //关卡三
    
    @IBOutlet weak var stageThree_button: UIButton!
    
    //关卡四
    
    
    @IBOutlet weak var stageFour_button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /*for subview in view.subviews {
            let button = subview as! UIButton
            if button.currentTitle == "Stage 1" && touchstage_flagone == true {
                button.setTitle("Stage 1\nPass", for: UIControl.State.normal)
            }
        }*/
        
        //修改此时的button 显示
        //每一个状态代表这个关卡有没有通过
        //通过了则会修改Button 的title 为Pass
 
        //关卡一
        if touchstage_flagone {
                
            print("This happened. Flag 1")
    
            stageOne_button.setTitle("Stage 1: Pass", for: UIControl.State.normal)
        }
        
        //关卡二
        if touchstage_flagtwo {
            
            //print("This happened. Flag 2")
            stageTwo_button.setTitle("Stage 2: Pass", for: UIControl.State.normal)
        }
        
        //关卡三
        if touchstage_flagthree {
            
            //print("This happened. Flag 3")
            stageThree_button.setTitle("Stage 3: Pass", for: UIControl.State.normal)
        }
        
        
        //关卡四
        if touchstage_flagfour {
            
            //print("This happened. Flag 4")
            stageFour_button.setTitle("Stage 4: Pass", for: UIControl.State.normal)
        }
        
    }
    
    
    //Stage_num：关卡选择 1 2 3 4
    //data：     游戏操作模式传值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "TouchStageOne" {
            
            let data = 1
            let contactVC = segue.destination as! TouchGameViewController
            contactVC.OperateMode = data
            
            stage_num = 1
            
        } else if segue.identifier == "TouchStageTwo" {
            
            let data = 1
            let contactVC = segue.destination as! TouchGameViewController
            contactVC.OperateMode = data
            
            stage_num = 2
            
        } else if segue.identifier == "TouchStageThree" {
            
            let data = 1
            let contactVC = segue.destination as! TouchGameViewController
            contactVC.OperateMode = data
            
            stage_num = 3
            
        } else if segue.identifier == "TouchStageFour" {
            
            let data = 1
            let contactVC = segue.destination as! TouchGameViewController
            contactVC.OperateMode = data
            
            stage_num = 4
        }
        
    }
    
    
    //和SoundStageViewController里一样的丢人代码。
    
    /*@IBAction func TouchstageOne(_ sender: Any) {
        
        if touch_stage_num >= 1 {
            self.performSegue(withIdentifier: "TouchStageOne", sender: self)
        }
    }
    
    @IBAction func TouchstageTwo(_ sender: Any) {
        
        if touch_stage_num >= 2 {
            self.performSegue(withIdentifier: "TouchStageTwo", sender: self)
        }
    }
    
    @IBAction func TouchstageThree(_ sender: Any) {
        
        if touch_stage_num >= 3 {
            self.performSegue(withIdentifier: "TouchStageThree", sender: self)
        }
    }
    
    @IBAction func TouchstageFour(_ sender: Any) {
        if touch_stage_num >= 4 {
            self.performSegue(withIdentifier: "TouchStageFour", sender: self)
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
