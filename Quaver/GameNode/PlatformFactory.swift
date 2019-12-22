//
//  PlatformFactory.swift
//  panda
//
//  Created by apple on 2019/12/1.
//  Copyright © 2019 apple. All rights reserved.
//

import SpriteKit


//平台工厂类
class PlatformFactory:SKNode{
    
    //左边平台
    let textureLeft = SKTexture(imageNamed: ImageName.Platform_L)
    //中间平台加载
    let textureMid = SKTexture(imageNamed: ImageName.Platform_M)
    //右边平台加载
    let textureRight = SKTexture(imageNamed: ImageName.Platform_R)
    
    //平台数组
    var platforms = [Platform]()
    var sceneWidth :CGFloat = 0
    
    //以创建平台数
    var numOfPlatform = 0
    //获胜目标数目
    let flagPlatform = 5
    //目标旗帜
    let flag = Flag()
    var delegate:ProtocalMainScene?
    
    
    //移除所有的平台
    func didFinish(){
        
        for p in platforms{
            p.removeFromParent()
        }
        flag.removeFromParent()
        //平台产生数目清零
        numOfPlatform = 0
    }
    
    
    //随机生成平台，平台的长度随机，位置随机
    func createPlatformRandom(){
        
        //随机生成中间平台数目
        let midNum:CGFloat = CGFloat(arc4random()%2 + 1)
        //随机生成间隔
        let gap:CGFloat = CGFloat(arc4random()%8 + 1)
        
        
        //根据间隔生成平台x坐标，并随机生成y坐标
        let x:CGFloat = self.sceneWidth + gap*10 + 50
        let y:CGFloat = CGFloat(arc4random()%200) - 135
        
        
        createPlatform(midNum: UInt32(midNum), x: x, y: y)
    }
    
    
    //根据中间节点的数目以及坐标创建新的平台
    func createPlatform(midNum:UInt32,x:CGFloat,y:CGFloat){
        
        let platform = Platform()
        let platform_left = SKSpriteNode(texture: textureLeft)
        platform_left.anchorPoint = CGPoint(x: 0,y: 0.9)
        
        let platform_right = SKSpriteNode(texture: textureRight)
        platform_right.anchorPoint = CGPoint(x:0,y:0.9)
        
        var arrPlatform = [SKSpriteNode]()
        
        arrPlatform.append(platform_left)
        platform.position = CGPoint(x:x,y:y)
        
        //已生成平台数目++
        numOfPlatform += 1;
        
        //判断是否到终点平台，此时将中间节点的数目设置为8，足够长
        var num = midNum
        if numOfPlatform == flagPlatform{
            num = 8
        }
        
        //根据中间节点的数目创建平台
        for _ in 1...num{
            let platform_mid = SKSpriteNode(texture: textureMid)
            platform_mid.anchorPoint = CGPoint(x:0,y:0.9)
            arrPlatform.append(platform_mid)
        }
        
        arrPlatform.append(platform_right)
        platform.onCreate(arrSprite: arrPlatform)
        self.addChild(platform)
        print(platform.position)
        
        //当到达终点旗帜，创建旗帜
        if numOfPlatform == flagPlatform{
            //旗帜的横纵坐标取决于最后一个平台的位置。
            flag.position = CGPoint(x:x + CGFloat(200),y:y + CGFloat(35))
            self.addChild(flag)
            print("create flag")
        }
        platforms.append(platform)
        //用来o判断，平台的长度+x坐标 - 主场景宽度
        delegate?.onGetData(dist: CGFloat(platform.width)+x-sceneWidth)
    }
    
    
    //平台移动
    func move(speed:CGFloat)->Bool{
        //标志flag是否进入视野
        var winFlag = false
        
        if numOfPlatform >= flagPlatform{
            if flag.position.x >= 235{
                //旗帜还未进入视野，此时旗帜随平台一起移动
                flag.position.x -= speed
            }else{
                //旗帜进入视野
                winFlag = true
            }
        }
        
        if !winFlag{
            //旗帜还没有进入视野，所有平台移动
            for p in platforms{
                p.position.x -= speed
            }
        }
        //进入视野后平台和旗帜不再移动
        
        
        //移除移出了视线的平台和旗帜
        if Int(flag.position.x) < -Int(platforms[0].width)-400{
            flag.removeFromParent()
        }
        
        
        if Int(platforms[0].position.x) < -Int(platforms[0].width)-400{
            platforms[0].removeFromParent()
            platforms.remove(at: 0)
        }
        return winFlag
    }
}
