//
//  Platform.swift
//  panda
//
//  Created by apple on 2019/12/1.
//  Copyright © 2019 apple. All rights reserved.
//

import SpriteKit


//平台类
class Platform: SKNode {
    
    var width = 0.0
    var height = 10
    
    
    //一个平台是由很多的平台节点构成。
    //用一个数组存放了构成该平台节点的所有平台
    
    func onCreate(arrSprite:[SKSpriteNode]){
        
        for platform in arrSprite{
            platform.position.x = CGFloat(self.width)
            self.addChild(platform)
            self.width += Double(platform.size.width)
        }
        
        //设置平台的物理信息
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: CGFloat(self.width), height: CGFloat(self.height)), center: CGPoint(x:CGFloat(self.width/2),y:CGFloat(0)))
        
        //设置为特定的数值
        self.physicsBody?.categoryBitMask = BitMaskType.platform
        //需要设置Dynamic = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0
        
    }
}
