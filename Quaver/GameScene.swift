//
//  GameScene.swift
//  Quaver
//
//  Created by apple on 2019/12/1.
//  Copyright © 2019 apple. All rights reserved.
//

import SpriteKit
import GameplayKit

import AVFoundation
import UIKit


protocol ProtocalMainScene {
    func onGetData(dist:CGFloat)
}



//游戏一共有三个状态
//正在游戏
//游戏结束
//游戏获胜
enum GameState{
    case play,over,win
}


class GameScene: SKScene,ProtocalMainScene,SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    //音符节点的初始化
    lazy var quaver = Quaver()
    //平台生成类的初始化
    lazy var platformFactory = PlatformFactory()
    //初始化游戏平台移动的速度和音符跳动的速度
    var moveSpeed = Speed.MoveSpeed
    var jumpSpeed = 0.0
    
    var lastDis = 0.0
    //初始化音符坐标
    let quaverPosX = -150
    let quaverPosY = -80
    
    //初始化游戏状态为play
    var gameState = GameState.play
    
    
    //Microphone time！
    //This is a recorder.
    var recorder: AVAudioRecorder?
    //Microphone access.
    var DoHaveMicAccess = true
    //定时器线程，循环监测录音的音量大小
    var volumeTimer:Timer!
    //录音器设置参数数组
    var recorderSeetingsDic:[String : Any]?
    //录音存储路径
    var aacPath:String?
    
    var OperateMode = 0 {
        
        //一旦检测到游戏模式发生改变做出如下动作
        didSet{
            if OperateMode == 1{
                //触控模式
                
                //jumpSpeed = Speed.JumpSpeed
                //moveSpeed = Speed.MoveSpeed
                
                //根据当前游戏关卡设置
                //1：平台移动速度
                //2:音符跳跃高度
                switch stage_num{
                case 1:
                    jumpSpeed = Speed.JumpSpeed - 5
                    moveSpeed = Speed.MoveSpeed + 3
                case 2:
                    jumpSpeed = Speed.JumpSpeed - 30
                    moveSpeed = Speed.MoveSpeed + 10
                case 3:
                    jumpSpeed = Speed.JumpSpeed - 50
                    moveSpeed = Speed.MoveSpeed + 15
                case 4:
                    jumpSpeed = Speed.JumpSpeed - 75
                    moveSpeed = Speed.MoveSpeed + 20
                default:
                    jumpSpeed = Speed.JumpSpeed
                    moveSpeed = Speed.MoveSpeed
                }
                
            }else if OperateMode == 2{
                
                //声控模式
                //Microphone Time!
                
                let session = AVAudioSession.sharedInstance()
                do {
                    //设置录音类型
                    //try session.setCategory(AVAudioSession.Category.playAndRecord, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
                    try session.setCategory(AVAudioSession.Category.playAndRecord, mode: session.mode, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
                    //设置支持后台
                    try session.setActive(true)
                    //检查麦克风权限
                    session.requestRecordPermission({ (isGranted: Bool) in
                        if isGranted {
                            self.DoHaveMicAccess = true
                        }else{
                            self.DoHaveMicAccess = false
                        }
                    })
                } catch let error as NSError {
                    print("AVAudioSession configuration error: \(error.localizedDescription)")
                }
                
                recorderSeetingsDic =
                [
                        AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),
                        AVNumberOfChannelsKey: 2, //录音的声道数，立体声为双声道
                        AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                        AVEncoderBitRateKey : 320000,
                        AVSampleRateKey : 44100.0 //录音器每秒采集的录音样本数
                ]
                
                let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                    
                //组合录音文件路径
                aacPath = docDir + "/play.aac"
                recorder = try! AVAudioRecorder(url: URL(string: aacPath!)!, settings: recorderSeetingsDic!)
                   
                //print(OperateMode)
                
                //if (OperateMode == 2){
                if recorder != nil {
                    //启用录音测量
                    recorder!.isMeteringEnabled = true
                    //准备录音
                    recorder!.prepareToRecord()
                    //开始录音
                    recorder!.record()
                    //启动定时器，定时更新录音音量
                    volumeTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.levelTimer),userInfo: nil, repeats: true)
                }
            }
        }
    }//1:touch   2:sound
    
    
    //Background Music
    func initBgMusic(){
        let bgMusic = SKAudioNode(fileNamed: SoundFile.GameStartMusic)
        bgMusic.name = "bgMusic"
        bgMusic.autoplayLooped = true
        addChild(bgMusic)
        
        audioPlayer.pause()
    }
    
    //移除背景音乐
    func removeBgMusic(){
        if let bgMusic = self.childNode(withName: "bgMusic"){
            self.removeChildren(in: [bgMusic])
        }
    }
    
    //fall down music
    //插入音符坠落的声音
    func initFallMusic(){
        let fallMusic = SKAudioNode(fileNamed: SoundFile.FallDownMusic)
        fallMusic.name = "fallMusic"
        fallMusic.autoplayLooped = true
        
        addChild(fallMusic)
        fallMusic.run(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(2.0)),SKAction.removeFromParent(),]))
        
    }
    
    //移除音符坠落的声音
    func removeFallMusic(){
        if let fallMusic = self.childNode(withName: "fallMusic"){
            self.removeChildren(in: [fallMusic])
        }
    }
    
    //win music
    
    //插入胜利的音效
    func initWinMusic(){
        let winMusic = SKAudioNode(fileNamed: SoundFile.WinMusic)
        winMusic.name = "winMusic"
        winMusic.autoplayLooped = true
        addChild(winMusic)
        winMusic.run(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(2.0)),SKAction.removeFromParent(),]))
    }
    
    //移除胜利的音效
    func removeWinMusic(){
        if let winMusic = self.childNode(withName: "winMusic"){
            self.removeChildren(in: [winMusic])
        }
    }
    
    //init gameOver Node
    //游戏结束的图标初始化
    func initLoseNode(){
        let loseNode = SKSpriteNode(imageNamed: "gameOver")
        loseNode.name = "loseNode"
        loseNode.setScale(0.7)
        loseNode.zPosition = 6
        loseNode.position = CGPoint(x: 0, y: 30)
        self.addChild(loseNode)
    }
    
    //游戏结束的图标的移除
    func removeLoseNode(){
        if let loseNode = self.childNode(withName: "loseNode"){
            self.removeChildren(in: [loseNode])
        }
    }
    
    
    //init restart node
    //游戏重新启动节点的初始化
    func initRestartNode(){
        
        let restartNode = SKSpriteNode(imageNamed: "restart")
        restartNode.name = "restart"
        restartNode.position = CGPoint(x: 10, y: -75)
        restartNode.setScale(0.7)
        restartNode.zPosition = 6
        self.addChild(restartNode)
    }
    
    //游戏节点移除的初始化
    func removeRestartNode(){
        if let restartNode = self.childNode(withName: "restart"){
            self.removeChildren(in: [restartNode])
        }
    }
    
    // init win node
    func initWinNode(){
        
        let winNode = SKSpriteNode(imageNamed: "youWin")
        winNode.name = "winNode"
        winNode.setScale(0.7)
        winNode.zPosition = 6
        winNode.position = CGPoint(x: 0, y: 30)
        self.addChild(winNode)
    }
    
    func removeWinNode(){
        if let winNode = self.childNode(withName: "winNode"){
            self.removeChildren(in: [winNode])
        }
    }
    
    
    //实时监控音量改变移动速度和跳跃速度
    @objc func levelTimer(){
        recorder!.updateMeters() // 刷新音量数据
        //let averageV:Float = recorder!.averagePower(forChannel: 0) //获取音量的平均值
        let maxV:Float = recorder!.peakPower(forChannel: 0) //获取音量最大值
        
        //let lowPassResult:Double = pow(Double(10), Double(0.05*maxV))
        var lowPassResult:Double = pow(Double(10), Double(0.05*maxV))
        
        //print(OperateMode)
        
        switch stage_num{
        case 1:
            moveSpeed = Speed.MoveSpeed + 2
            lowPassResult = lowPassResult - 15
        case 2:
            moveSpeed = Speed.MoveSpeed - 1
            lowPassResult = lowPassResult - 20
        case 3:
            moveSpeed = Speed.MoveSpeed - 2
            lowPassResult = lowPassResult - 30
        case 4:
            moveSpeed = Speed.MoveSpeed - 3
            lowPassResult = lowPassResult - 50
        default:
            moveSpeed = Speed.MoveSpeed
            lowPassResult = lowPassResult - 10
        }
        
        if (OperateMode == 2){
            if (maxV > -20){
                moveSpeed = Speed.MoveSpeed
            }else{
                moveSpeed = 0
            }
            if (lowPassResult * 250 > 200){
                jumpSpeed = min(750, lowPassResult * 600)
                quaver.jump(speed: jumpSpeed)
            }else{
                jumpSpeed = 0
            }
            print("maxV: \(maxV), jumpspeed: \(jumpSpeed)")
        } else {
            moveSpeed = Speed.MoveSpeed
        }
    }
    
    
    
    //碰撞检测函数
    func didBegin(_ contact: SKPhysicsContact) {
        
        //当检测到平台和音符的碰撞
        if(contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (BitMaskType.platform | BitMaskType.quaver){
            quaver.run()
        }
        
        //当检测到音符和场景的碰撞，游戏结束
        if(contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (BitMaskType.scene | BitMaskType.quaver){
            //音符坠落
            print("game over")
            print(OperateMode)
            
            //关闭背景音乐
            removeBgMusic()
            //插入坠落声效
            initFallMusic()
            
            //关闭录音
            if (OperateMode == 2){
                if (DoHaveMicAccess){
                    print("Do have access.")
                }
                //停止录音
                recorder?.stop()
                //录音器释放
                recorder = nil
                //暂停定时器
                volumeTimer.invalidate()
                volumeTimer = nil
            }
            
            //画面停止
            moveSpeed = 0
            gameState = GameState.over
            
            

            //移除场景中的音符和平台
            self.removeChildren(in: [quaver,platformFactory])
            platformFactory.didFinish()
            platformFactory.removeAllChildren()

            //在场景中插入游戏失败和重新开始的图标
            initLoseNode()
            initRestartNode()
            
            //插入特效
            let loseNode = SKNode()
            loseNode.position.x = quaver.position.x
            loseNode.position.y = CGFloat(quaverPosY)
            loseNode.name = "loseEffect"
            self.addChild(loseNode)
            
            if let loseEmitter = SKEmitterNode(fileNamed: EffectFile.GameOverEffect){
                print("sdd")
                loseEmitter.targetNode = loseNode
                loseNode.addChild(loseEmitter)
                quaver.removeFromParent()
                loseEmitter.run(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(2.0)),SKAction.removeFromParent(),]))
            }
            
            self.label?.isHidden = true
        }
        
        //当检测到音符和旗帜的碰撞，胜利
        if(contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (BitMaskType.flag | BitMaskType.quaver){
            //音符碰到了旗帜获胜
            print("you win")
            
            print(OperateMode)
            
            if OperateMode == 1{
                
                if stage_num == 1{
                    touchstage_flagone = true
                } else if stage_num == 2{
                    touchstage_flagtwo = true
                } else if stage_num == 3{
                    touchstage_flagthree = true
                } else if stage_num == 4{
                    touchstage_flagfour = true
                }
                
            } else if OperateMode == 2{
                
                if stage_num == 1{
                    soundstage_flagone = true
                } else if stage_num == 2{
                    soundstage_flagtwo = true
                } else if stage_num == 3{
                    soundstage_flagthree = true
                } else if stage_num == 4{
                    soundstage_flagfour = true
                }
                
            }
            
            //关闭背景音乐
            removeBgMusic()
            //插入获胜音效
            initWinMusic()
            
            //关闭录音
            if (OperateMode == 2){
                if (DoHaveMicAccess){
                    print("Do have access.")
                }
                //停止录音
                recorder?.stop()
                //录音器释放
                recorder = nil
                //暂停定时器
                volumeTimer.invalidate()
                volumeTimer = nil
            }
            
            moveSpeed = 0
            gameState = GameState.win
            
            
            //winNode.removeFromParent()
            
            //移除场景中的音符和平台
            self.removeChildren(in: [platformFactory])
            platformFactory.didFinish()
            platformFactory.removeAllChildren()
            
            //场景显示获胜和重新开始
            initWinNode()
            initRestartNode()
            
            //插入特效
            let winNode = SKNode()
            winNode.position = quaver.position
            winNode.name = "winEffect"
            self.addChild(winNode)
            
            if let winEmitter = SKEmitterNode(fileNamed: EffectFile.WinEffect){
                print("sdd")
                winEmitter.targetNode = winNode
                winNode.addChild(winEmitter)
                quaver.removeFromParent()
                winEmitter.run(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(2.0)),SKAction.removeFromParent(),]))
            }
            self.label?.isHidden = true
            
        }
    }
    
    
    
    //游戏场景加载
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        print(OperateMode)
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        
        //let skyColor = SKColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        //self.backgroundColor = skyColor
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0,dy: -9.8)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = BitMaskType.scene
        self.physicsBody?.isDynamic = false
        
        quaver.position = CGPoint(x: quaverPosX,y:quaverPosY )
        self.addChild(quaver)
        self.addChild(platformFactory)
        self.label?.isHidden = false
        platformFactory.delegate = self
        platformFactory.sceneWidth = self.frame.size.width
        platformFactory.createPlatform(midNum:8,x:-400,y:-135)
        
        gameState = GameState.play
        //moveSpeed = Speed.MoveSpeed
        
        if OperateMode == 1{
            
        switch stage_num{
        case 1:
            jumpSpeed = Speed.JumpSpeed - 5
            moveSpeed = Speed.MoveSpeed + 4
        case 2:
            jumpSpeed = Speed.JumpSpeed - 20
            moveSpeed = Speed.MoveSpeed + 10
        case 3:
            jumpSpeed = Speed.JumpSpeed - 40
            moveSpeed = Speed.MoveSpeed + 15
        case 4:
            jumpSpeed = Speed.JumpSpeed - 75
            moveSpeed = Speed.MoveSpeed + 20
        default:
            jumpSpeed = Speed.JumpSpeed
            moveSpeed = Speed.MoveSpeed
        }
            
        }
        
        initBgMusic()
        
        if (OperateMode == 2){
            
            //声控模式
            //Microphone Time!
            let session = AVAudioSession.sharedInstance()
            
            do {
                //设置录音类型
                //try session.setCategory(AVAudioSession.Category.playAndRecord, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
                try session.setCategory(AVAudioSession.Category.playAndRecord, mode: session.mode, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
                //设置支持后台
                try session.setActive(true)
                //检查麦克风权限
                session.requestRecordPermission({ (isGranted: Bool) in
                    if isGranted {
                        self.DoHaveMicAccess = true
                    }else{
                        self.DoHaveMicAccess = false
                    }
                })
            } catch let error as NSError {
                print("AVAudioSession configuration error: \(error.localizedDescription)")
            }
            
            recorderSeetingsDic =
            [
                    AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),
                    AVNumberOfChannelsKey: 2, //录音的声道数，立体声为双声道
                    AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                    AVEncoderBitRateKey : 320000,
                    AVSampleRateKey : 44100.0 //录音器每秒采集的录音样本数
            ]
            
            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                
            //组合录音文件路径
            aacPath = docDir + "/play.aac"
            recorder = try! AVAudioRecorder(url: URL(string: aacPath!)!, settings: recorderSeetingsDic!)
               
            //print(OperateMode)
            
            if recorder != nil {
                //启用录音测量
                recorder!.isMeteringEnabled = true
                //准备录音
                recorder!.prepareToRecord()
                //开始录音
                recorder!.record()
                //启动定时器，定时更新录音音量
                volumeTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.levelTimer),userInfo: nil, repeats: true)
            }
        }
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    //检测到屏幕触摸事件
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        
         //获取点击的位置
        guard let touch = touches.first else{
            return
        }
        let touchLocation = touch.location(in: self)
        switch self.gameState {
        case GameState.play:
             if OperateMode == 1{
                quaver.jump(speed:jumpSpeed)
               }
        case GameState.over:
            if(touchLocation.x < 65 && touchLocation.x > -65 && touchLocation.y < -30 && touchLocation.y > -55){
                //当玩家点击重新开始游戏
                //移除场景节点
                print("restart!")
                self.removeFallMusic()
                self.removeLoseNode()
                self.removeRestartNode()
                if let loseEffect = self.childNode(withName: "loseEffect"){
                    loseEffect.removeFromParent()
                }
                //加载场景
                sceneDidLoad()
            }
//            if let restartTap = self.childNode(withName: "restart")?.calculateAccumulatedFrame(){
//
//                if restartTap.contains(touchLocation){
//                    print("restart!")
//                    self.removeChildren(in: [loseNode,restartNode])
//                    sceneDidLoad()
//                }
//            }
        case GameState.win:
            print("You win")
            if(touchLocation.x < 65 && touchLocation.x > -65 && touchLocation.y < -30 && touchLocation.y > -55){
                //当玩家点击重新开始游戏
                //移除场景节点
                print("restart!")
                self.removeWinMusic()
                self.removeWinNode()
                self.removeRestartNode()
                if let winEffect = self.childNode(withName: "winEffect"){
                    winEffect.removeFromParent()
                }
                //加载场景
                sceneDidLoad()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
        
        //有新的平台生成
        lastDis -= Double(moveSpeed)
        if(lastDis<=0){
            print("create new platform")
            platformFactory.createPlatformRandom()
        }
        //等遇到终点了，平台不移动，音符移动
        if platformFactory.move(speed: CGFloat(moveSpeed)){
            quaver.move(speed: moveSpeed)
        }
    }
    
    
    func onGetData(dist: CGFloat) {
        self.lastDis = Double(dist)
    }
    
    //游戏推出，场景退出
    func didFinish(){
        //移除场景的所有节点
        self.removeAllChildren()
        self.removeFromParent()
        
        //当为声音控制模式
        //关闭录音
        if (OperateMode == 2){
            if gameState == GameState.play{
                if (DoHaveMicAccess){
                    print("Do have access.")
                }
                //停止录音
                recorder?.stop()
                //录音器释放
                recorder = nil
                //暂停定时器
                volumeTimer.invalidate()
                volumeTimer = nil
            }
        }
    }
}
