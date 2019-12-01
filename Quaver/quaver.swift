import SpriteKit

class Quaver : SKSpriteNode{
    let runAtlas = SKTextureAtlas(named:"run.atlas")
    let runFrames = [SKTexture]()
    init(){
        let texture = runAtlas.textureNamed("quaver")
        let size = texture.size()
        super.init(texture:texture,color:UIColor.white,size:size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
