//
//  PlatformFactory.swift
//  panda
//
//  Created by apple on 2019/12/1.
//  Copyright © 2019 apple. All rights reserved.
//

import SpriteKit

class PlatformFactory:SKNode{
    let textureLeft = SKTexture(imageNamed: "platform_l")
    let textureMid = SKTexture(imageNamed: "platform_m")
    let textureRight = SKTexture(imageNamed: "platform_r")
    var platforms = [Platform]()
    var sceneWidth :CGFloat = 0
    var delegate:ProtocalMainScene?
    
    func createPlatformRandom(){
        //
        let midNum:CGFloat = CGFloat(arc4random()%2 + 1)
        //随机间隔
        let gap:CGFloat = CGFloat(arc4random()%8 + 1)
        
        //x
        let x:CGFloat = self.sceneWidth + gap*10 + 50
        let y:CGFloat = CGFloat(arc4random()%200) - 135
        createPlatform(midNum: UInt32(midNum), x: x, y: y)
    }
    
    func createPlatform(midNum:UInt32,x:CGFloat,y:CGFloat){
        let platform = Platform()
        let platform_left = SKSpriteNode(texture: textureLeft)
        platform_left.anchorPoint = CGPoint(x: 0,y: 0.9)
        
        let platform_right = SKSpriteNode(texture: textureRight)
        platform_right.anchorPoint = CGPoint(x:0,y:0.9)
        
        var arrPlatform = [SKSpriteNode]()
        
        arrPlatform.append(platform_left)
        platform.position = CGPoint(x:x,y:y)
        
        for _ in 1...midNum{
            let platform_mid = SKSpriteNode(texture: textureMid)
            platform_mid.anchorPoint = CGPoint(x:0,y:0.9)
            arrPlatform.append(platform_mid)
        }
        arrPlatform.append(platform_right)
        platform.onCreate(arrSprite: arrPlatform)
        self.addChild(platform)
        platforms.append(platform)
        //用来o判断，平台的长度+x坐标 - 主场景宽度
        delegate?.onGetData(dist: CGFloat(platform.width)+x-sceneWidth)
    }
    func move(speed:CGFloat){
        for p in platforms{
            p.position.x -= speed
        }
        if Int(platforms[0].position.x) < -Int(platforms[0].width)-400{
            platforms[0].removeFromParent()
            platforms.remove(at: 0)
        }
    }
}
