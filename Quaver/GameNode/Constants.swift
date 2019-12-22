//
//  Constants.swift
//  Quaver
//
//  Created by apple on 2019/12/22.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation

import AVFoundation


//音乐播放器
var audioPlayer : AVAudioPlayer!

//当前游戏所在关卡
var stage_num = 1

//是否是游客玩家
var isVisitor = true
//游戏玩家
var userGaming:UserInfo?

//首次通关记录

//Sound mode，记录是否通关该关卡
//每当一下数据发生改变的时候，随时修改本地存储的账号内容
var soundstage_flagone = false{
    didSet{
        if !isVisitor{
            if let user = userGaming{
                user.soundStage1 = soundstage_flagone
                UserDefaults.standard.saveCustomObject(customObject: user, key: user.userName!)
                UserDefaults.standard.synchronize()
            }
        }
        
    }
}
var soundstage_flagtwo = false{
    didSet{
        if !isVisitor{
            if let user = userGaming{
                user.soundStage2 = soundstage_flagtwo
                UserDefaults.standard.saveCustomObject(customObject: user, key: user.userName!)
                UserDefaults.standard.synchronize()
            }
        }
        
    }
}
var soundstage_flagthree = false{
    didSet{
        if !isVisitor{
            if let user = userGaming{
                user.soundStage3 = soundstage_flagthree
                UserDefaults.standard.saveCustomObject(customObject: user, key: user.userName!)
                UserDefaults.standard.synchronize()
            }
        }
        
    }
}
var soundstage_flagfour = false{
    didSet{
        if !isVisitor{
            if let user = userGaming{
                user.soundStage4 = soundstage_flagfour
                UserDefaults.standard.saveCustomObject(customObject: user, key: user.userName!)
                UserDefaults.standard.synchronize()
            }
        }
        
    }
}

//Touch mode
var touchstage_flagone = false{
    didSet{
        if !isVisitor{
            if let user = userGaming{
                user.touchStage1 = touchstage_flagone
                UserDefaults.standard.saveCustomObject(customObject: user, key: user.userName!)
                UserDefaults.standard.synchronize()
            }
        }
        
    }
}
var touchstage_flagtwo = false{
    didSet{
        if !isVisitor{
            if let user = userGaming{
                user.touchStage2 = touchstage_flagtwo
                UserDefaults.standard.saveCustomObject(customObject: user, key: user.userName!)
                UserDefaults.standard.synchronize()
            }
        }
        
    }
}
var touchstage_flagthree = false{
     didSet{
           if !isVisitor{
               if let user = userGaming{
                   user.touchStage3 = touchstage_flagthree
                   UserDefaults.standard.saveCustomObject(customObject: user, key: user.userName!)
                   UserDefaults.standard.synchronize()
               }
           }
           
       }
}
var touchstage_flagfour = false{
     didSet{
           if !isVisitor{
               if let user = userGaming{
                   user.touchStage4 = touchstage_flagfour
                   UserDefaults.standard.saveCustomObject(customObject: user, key: user.userName!)
                   UserDefaults.standard.synchronize()
               }
           }
           
       }
}


//图片文件常量
struct ImageName{
    static let Flag = "flag"
    static let Quaver = "quaver"
    static let Win = "youWin"
    static let GameOver = "gameOver"
    static let Restart = "restart"
    static let Platform_L = "platform_l"
    static let Platform_M = "platform_m"
    static let Platform_R = "platform_r"
}


//声音文件常量
struct SoundFile {
    static let BackgroundMusic = "background.mp3"
    static let FallDownMusic = "fallDown.wav"
    static let WinMusic = "win.mp3"
    static let GameStartMusic = "gameStart.mp3"
}


//Atlas文件常量
struct Atlas {
    static let QuaverRun = "run.atlas"
    static let FlagStand = "flag.atlas"
}


//特效文件常量
struct EffectFile{
    static let GameOverEffect = "death"
    static let WinEffect = "CollectNormal"
}


//有关速度的常量设置
struct Speed{
    static let MoveSpeed = 6.0
    static let JumpSpeed = 550.0
}


