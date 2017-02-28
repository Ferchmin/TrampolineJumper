//
//  GameViewController.swift
//  DrawJumpWorkingTitle
//
//  Created by Pawel on 19.08.2016.
//  Copyright (c) 2016 PawelLearning. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    
    var scene:GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        skView.isMultipleTouchEnabled=false
        
        scene=GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}

