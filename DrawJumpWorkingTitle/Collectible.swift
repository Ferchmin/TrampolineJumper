//
//  Collectible.swift
//  DrawJumpThree
//
//  Created by Pawel on 19.03.2017.
//  Copyright © 2017 PawelLearning. All rights reserved.
//

import Foundation
import GameKit

class Collectible:SKSpriteNode {
    
    init() {
        let size = CGSize(width: 60, height: 60)
        super.init(texture:nil, color:UIColor.clear,size:size)
    }
    
    init(size:CGSize){
        super.init(texture:nil, color:UIColor.clear, size:size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pulseAtContact(){
        let zoomInAnimation = SKAction.scale(to: 1.07, duration: 0.04)
        let zoomOutAnimation = SKAction.scale(to: 1, duration: 0.04)
        let animationSequence = SKAction.sequence([zoomInAnimation,zoomOutAnimation])
        self.run(animationSequence)
    }
    
    func disapearAtContact(){
        let zoomInAnimation = SKAction.scale(to: 1.07, duration: 0.1)
        let fadeOutAnimation = SKAction.fadeOut(withDuration: 0.05)
        
        self.run(zoomInAnimation)
        self.run(fadeOutAnimation)
    }
    
}
