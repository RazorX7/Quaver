//
//  Flag.swift
//  Quaver
//
//  Created by apple on 2019/12/17.
//  Copyright © 2019 apple. All rights reserved.
//

import SpriteKit


//旗帜类，出现在场景的最后，标志着胜利
class Flag: SKSpriteNode{
    
    let runAtlas = SKTextureAtlas(named:Atlas.FlagStand)
    
    
    init(){
        
        let texture = runAtlas.textureNamed(ImageName.Flag)
        let size = texture.size()
        super.init(texture:texture,color:UIColor.white,size:size)
        
        //初始化旗帜的物理信息
        self.physicsBody = SKPhysicsBody(rectangleOf: texture.size())
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0
        
        //设置为我们定义的数值
        self.physicsBody?.categoryBitMask = BitMaskType.flag
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
