//
//  PlatformFactory.swift
//  panda
//
//  Created by apple on 2019/12/1.
//  Copyright © 2019 apple. All rights reserved.
//

import SpriteKit

//
//音符的运动状态
enum Status:Int {
    case run = 1,jump,jump2
}


//音符节点
class Quaver : SKSpriteNode{
    
    //加载跑步素材
    let runAtlas = SKTextureAtlas(named:Atlas.QuaverRun)
    var runFrames = [SKTexture]()
    
    //加载跳跃素材
    let jumpAtlas = SKTextureAtlas(named:Atlas.QuaverRun)
    var jumpFrames = [SKTexture]()
    
    var status = Status.run
    
    //初始化
    init(){
        
        let texture = runAtlas.textureNamed(ImageName.Quaver)
        let size = texture.size()
    super.init(texture:texture,color:UIColor.white,size:size)
        
        //设置音符的物理信息
        self.physicsBody = SKPhysicsBody(rectangleOf: texture.size())
        
        //设置Dynamic 为true
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0
        
        //设置碰撞检测相关的信息
        self.physicsBody?.categoryBitMask = BitMaskType.quaver
        
        self.physicsBody?.contactTestBitMask = BitMaskType.scene | BitMaskType.platform | BitMaskType.flag
        
        self.physicsBody?.collisionBitMask = BitMaskType.platform | BitMaskType.flag
        
        
        runFrames.append(texture)
        jumpFrames.append(texture)
        run()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    //音符跑步的状态
    func run(){
        
        self.removeAllActions()
        status = .run
        self.run(SKAction.animate(with: runFrames, timePerFrame: 0.05))
    }
    
    
    //音符跳跃分为普通跳跃和二段跳
    func jump(speed:Double){
        
        self.removeAllActions()
        
        if status != .jump2{
            //二段跳
            self.run(SKAction.animate(with: jumpFrames, timePerFrame: 0.05))
            self.physicsBody?.velocity = CGVector(dx: 0,dy: speed)
            if status == .jump{
                status = .jump2
            } else {
                status = .jump
            }
        }
        
    }
    
    
    //音符向前移动
    func move(speed:Double){
        self.position.x += CGFloat(speed)
    }
}
