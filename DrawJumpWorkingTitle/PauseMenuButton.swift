//
//  PauseMenuButton.swift
//  DrawJumpThree
//
//  Created by Pawel on 26.02.2017.
//  Copyright © 2017 PawelLearning. All rights reserved.
//

import Foundation
import GameKit

class PauseMenuButton:SKSpriteNode{
    
    var buttonRect:CGRect!
    var buttonShape:SKShapeNode!
    var label:SKLabelNode!
    
    init(size:CGSize, text:String){
        
        super.init(texture: nil, color: .clear, size: CGSize(width: size.width-40, height: 50))
        setupButton(size: size)
        setupLabel(text: text)
        
        buttonShape.addChild(label)
        addChild(buttonShape)
        
    }

    func setupButton(size:CGSize){
        buttonRect = CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height)
        buttonShape = SKShapeNode(rect: buttonRect, cornerRadius: 5)
        buttonShape.fillColor = .red
        buttonShape.strokeColor = .clear
        
    }
    
    func setupLabel(text:String){
        label = SKLabelNode(fontNamed:"Helvetica Neue Thin")
        label.text = text
        label.fontSize = 30
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x:0, y:0)
        label.fontColor = UIColor.white

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
