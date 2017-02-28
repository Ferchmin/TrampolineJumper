//
//  BallObstacle.swift
//  DrawJumpTwo
//
//  Created by Pawel on 30.09.2016.
//  Copyright © 2016 PawelLearning. All rights reserved.
//

import Foundation
import SpriteKit

class BallObstacle:Obstacle{
    
    var ball: SKShapeNode!
    
    override init() {
        super.init()
        loadAppearance(size:size)
        loadPhysicsBody(size:size)
        
    }
    
    override init(size:CGSize){
        super.init(size:size)
        loadAppearance(size:size)
        loadPhysicsBody(size:size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generateForceVector(heroPosition:CGPoint, obstaclePosition:CGPoint) -> CGVector{
        let deltaX = heroPosition.x - obstaclePosition.x
        let deltaY = heroPosition.y - obstaclePosition.y
        
        let vectorX = deltaX/4
        let vectorY = deltaY/4
        
        if vectorY > 0{
            let vector = CGVector(dx: vectorX, dy: vectorY)
            
            print("wektor w gore: y: \(vectorY), x: \(vectorX)")
            return vector
        }else{
            let vector = CGVector(dx: 0, dy: 0)
            print("brak wektora")
            return vector
        }
    }
    
    
    func loadAppearance(size:CGSize){
        ball=SKShapeNode(circleOfRadius:size.width/2 )
        ball.fillColor = .clear //UIColor(colorLiteralRed: 214/255, green: 252/255, blue: 99/255, alpha: 1)
        ball.strokeColor=UIColor.clear
        texture = SKTexture(imageNamed: "ksiezyc")
        ball.position = CGPoint(x: 0,y: 0)
        addChild(ball)
    }
    
    
    func loadPhysicsBody(size: CGSize){
        self.physicsBody = SKPhysicsBody(circleOfRadius:size.width/2)
        physicsBody?.categoryBitMask = obstacleCategory
        physicsBody?.contactTestBitMask = heroCategory
        physicsBody?.collisionBitMask = heroCategory
        physicsBody?.affectedByGravity = false
        physicsBody?.restitution = 1
        physicsBody?.isDynamic = false
    }
    
    
}
