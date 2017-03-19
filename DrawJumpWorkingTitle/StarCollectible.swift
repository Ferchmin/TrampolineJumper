//
//  StarCollectible.swift
//  DrawJumpThree
//
//  Created by Pawel on 19.03.2017.
//  Copyright © 2017 PawelLearning. All rights reserved.
//

import Foundation
import SpriteKit

class StarCollectible:Collectible{
    
    var star: SKShapeNode!
    var stars:[StarCollectible] = []
    
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
    
    
    func loadAppearance(size:CGSize){
        star=SKShapeNode(circleOfRadius:size.width/2 )
        star.fillColor = .clear //UIColor(colorLiteralRed: 214/255, green: 252/255, blue: 99/255, alpha: 1)
        star.strokeColor=UIColor.clear
        texture = SKTexture(image: #imageLiteral(resourceName: "starTexture"))
        star.position = CGPoint(x: 0,y: 0)
        
        //texture = SKTexture(image: #imageLiteral(resourceName: "starTexture"))
        
        addChild(star)
    }
    
    
    func loadPhysicsBody(size: CGSize){
        self.physicsBody = SKPhysicsBody(circleOfRadius:size.width/2)
        physicsBody?.categoryBitMask = collectibleCategory
        physicsBody?.contactTestBitMask = heroCategory
        physicsBody?.affectedByGravity = false
        physicsBody?.restitution = 1
        physicsBody?.isDynamic = false
    }

    
    

}
