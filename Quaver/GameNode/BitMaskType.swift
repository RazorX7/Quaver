//
//  BitMaskType.swift
//  Quaver
//
//  Created by apple on 2019/12/7.
//  Copyright © 2019 apple. All rights reserved.
//


//用于碰撞检测
class BitMaskType{
    
    //音符
    class var quaver:UInt32{
        return 1<<0
    }
    
    //平台
    class var platform:UInt32{
        return 1<<1
    }
    
    //场景
    class var scene:UInt32{
        return 1<<2
    }
    
    //旗帜
    class var flag:UInt32{
        return 1<<3
    }
}
