//
//  Player.swift
//  DrawJumpWorkingTitle
//
//  Created by Pawel on 22.08.2016.
//  Copyright © 2016 PawelLearning. All rights reserved.
//

import Foundation
import SpriteKit

import Foundation
import SpriteKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class Hero:SKSpriteNode{
    
    var body: SKShapeNode!
    var isFalling:Bool = false
    
    
    init(radius:CGFloat) {
        let size=CGSize(width: radius, height: radius)
        super.init(texture:nil, color:UIColor.clear,size:size)
        loadAppearance(radius)
        loadPhysicsBody(radius)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func loadAppearance(_ radius:CGFloat){
        body=SKShapeNode(circleOfRadius: radius)
        body.fillColor=UIColor.init(colorLiteralRed: 247/255, green: 217/255, blue: 188/255, alpha: 1)
        body.lineWidth=0
        body.position = CGPoint(x: 0,y: 0)
        
        let leftEye=SKShapeNode(circleOfRadius: radius/6)
        leftEye.fillColor = .blue
        leftEye.strokeColor = .white
        leftEye.lineWidth=3
        leftEye.position=CGPoint(x: -radius/2.5, y: radius/3)
        leftEye.zPosition=1
        addChild(leftEye)
        
        let rightEye=SKShapeNode(circleOfRadius: radius/6)
        rightEye.fillColor = .blue
        rightEye.strokeColor = .white
        rightEye.lineWidth=3
        rightEye.position=CGPoint(x: radius/2.5, y: radius/3)
        rightEye.zPosition=1
        addChild(rightEye)

        addChild(body)
     
    }
    
    
    func loadPhysicsBody(_ radius:CGFloat){
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.isDynamic=false
        physicsBody?.categoryBitMask = heroCategory
        physicsBody?.contactTestBitMask = borderCategory | trampolineCategory | obstacleCategory | finnishCategory | drawnTrampolineCategory
        physicsBody?.collisionBitMask = borderCategory | trampolineCategory | obstacleCategory | drawnTrampolineCategory
        physicsBody?.affectedByGravity = true
        physicsBody?.linearDamping=0.5
        physicsBody?.allowsRotation = false
        physicsBody?.friction = 0
        physicsBody?.restitution = 0
    }
    
    func update(){
        if physicsBody?.velocity.dy<0{
            physicsBody?.collisionBitMask = borderCategory | trampolineCategory | obstacleCategory | drawnTrampolineCategory | finnishCategory
            isFalling=true
            
        } else {
            physicsBody?.collisionBitMask = borderCategory | obstacleCategory
            isFalling=false
        }
    }
        
}
