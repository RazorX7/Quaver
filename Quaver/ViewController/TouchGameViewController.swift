//
//  TouchGameViewController.swift
//  Quaver
//
//  Created by apple on 2019/12/15.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


//触摸控制的VC
class TouchGameViewController: UIViewController {

    var OperateMode = 0
    let myScene = GKScene(fileNamed: "GameScene")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        
       
        
        if let scene = myScene {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                sceneNode.OperateMode = OperateMode
                //print(OperateMode)
                // Present the scene
                
                if let view = self.view as! SKView? {
                    //视图显示界面
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    //显示画面帧
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }
    
    
    //在退出界面的时候所做出的准备，移除scene场景中的节点。
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "TouchBackToStart" {
            //key code ！！！
            //从触控游戏界面跳出
            if let scene = myScene {
                
                // Get the SKScene from the loaded GKScene
                if let sceneNode = scene.rootNode as! GameScene? {
                    sceneNode.didFinish()
                }
            }
        }
    }
    
    //判断是否可以旋转
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
