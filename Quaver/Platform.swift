//
//  Platform.swift
//  panda
//
//  Created by apple on 2019/12/1.
//  Copyright © 2019 apple. All rights reserved.
//

import SpriteKit
class Platform: SKNode {
    var width = 0.0
    var height = 10
    func onCreate(arrSprite:[SKSpriteNode]){
        for platform in arrSprite{
            platform.position.x = CGFloat(self.width)
            self.addChild(platform)
            self.width += Double(platform.size.width)
        }
    }
}
