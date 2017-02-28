//
//  FinnishLine.swift
//  DrawJumpThree
//
//  Created by Pawel on 16.02.2017.
//  Copyright © 2017 PawelLearning. All rights reserved.
//

import Foundation
import GameKit

class FinnishLine:SKSpriteNode {
    
    init(size: CGSize){
        super.init(texture: nil, color: UIColor.clear, size: CGSize(width: size.width, height: 4))
        loadPhysicsBody(size)
    }
    
    func loadPhysicsBody(_ size: CGSize){
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 4))
        physicsBody?.categoryBitMask = finnishCategory
        physicsBody?.contactTestBitMask = heroCategory
        physicsBody?.collisionBitMask = finnishCategory
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
        physicsBody?.restitution = 0.8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
