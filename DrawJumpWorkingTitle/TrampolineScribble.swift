//
//  TrampolineScribble.swift
//  DrawJumpThree
//
//  Created by Pawel on 12.02.2017.
//  Copyright © 2017 PawelLearning. All rights reserved.
//

import Foundation
import GameKit

class TrampolineScribble:SKShapeNode {
    
    init(path:CGPath){
        super.init()
        self.strokeColor = .cyan
        self.lineWidth = 4
        self.path = path
    }
    
    override init(){
        super.init()
        self.strokeColor = .cyan
        self.lineWidth = 5
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changePath(path:CGPath){
        self.path = path
    }
}
