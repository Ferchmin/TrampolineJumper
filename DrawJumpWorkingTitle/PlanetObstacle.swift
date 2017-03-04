//
//  PlanetObstacle.swift
//  DrawJumpThree
//
//  Created by Pawel on 02.03.2017.
//  Copyright © 2017 PawelLearning. All rights reserved.
//

import Foundation
import SpriteKit

class PlanetObstacle:Obstacle{
    
    var ball: SKShapeNode!
    var planetRings: SKSpriteNode!
    var planetShape:SKSpriteNode!
    
    override init() {
        super.init()
        loadAppearance(size:size)
        loadPhysicsBody(size:size)
        
    }
    
    override init(size:CGSize){
        super.init(size:CGSize(width: size.width*2.06, height: size.height))
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
    
    override func pulseAtContact(){
        let zoomInAnimation = SKAction.scale(to: 1.07, duration: 0.04)
        let zoomOutAnimation = SKAction.scale(to: 1, duration: 0.04)
        let animationSequence = SKAction.sequence([zoomInAnimation,zoomOutAnimation])
        planetShape.run(animationSequence)
    }
    
    func loadAppearance(size:CGSize){
        ball=SKShapeNode(circleOfRadius:size.width/2 )
        ball.fillColor = .clear
        ball.strokeColor=UIColor.clear
        ball.position = CGPoint(x: 0,y: 0)
        addChild(ball)
        
        let random = arc4random_uniform(2)
        if(random == 0){
            planetShape = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "onlyPlanetSqureBlueSmall")))
            let blueGlow = UIColor(colorLiteralRed: 36/255, green: 254/255, blue: 223/255, alpha: 1)
            addGlow(radius: 10, color: blueGlow,size:size)
        }else{
            planetShape = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "onlyPlanetSquareYellowSmall")))
            let yellowGlow = UIColor(colorLiteralRed: 255/255, green: 213/255, blue: 128/255, alpha: 1)
            addGlow(radius: 10, color:yellowGlow ,size:size)
        }
        
        planetShape.size = size
        planetShape.position=CGPoint.zero
        planetShape.zPosition = (-1)
        addChild(planetShape)
        
        texture = SKTexture(image: #imageLiteral(resourceName: "onlyRingsSmall"))
        
        self.zRotation = CGFloat(M_PI_2/3)
    }
    
    func addGlow(radius:CGFloat, color:UIColor, size:CGSize){
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        effectNode.zPosition = -1
        addChild(effectNode)
        let blurShape = SKShapeNode(circleOfRadius: size.width/2)
        blurShape.fillColor = color
        effectNode.addChild(blurShape)
        effectNode.filter = CIFilter(name: "CIGaussianBlur", withInputParameters: ["inputRadius":radius])
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
