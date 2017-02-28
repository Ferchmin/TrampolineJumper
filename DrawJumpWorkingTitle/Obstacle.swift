//
//  Obstacle.swift
//  DrawJumpTwo
//
//  Created by Pawel on 14.10.2016.
//  Copyright © 2016 PawelLearning. All rights reserved.
//

import Foundation
import GameKit

class Obstacle:SKSpriteNode {
    
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
    
}
