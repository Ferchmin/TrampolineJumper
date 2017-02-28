//
//  Trampoline.swift
//  DrawJumpWorkingTitle
//
//  Created by Pawel on 22.08.2016.
//  Copyright © 2016 PawelLearning. All rights reserved.
//

import Foundation
import SpriteKit
import Darwin

class Trampoline:SKSpriteNode{
    
    let constMax:CGFloat = 35
    let constMin:CGFloat = 15
    
    var jumpforce:CGVector!
    var pathtmp: CGPath!
    var lenght:CGFloat!
    
    var stroke:SKShapeNode!
    
    
    init?(begin:CGPoint, end: CGPoint, color: UIColor) {
        
        lenght=sqrt(pow((begin.x - end.x),2) + pow((begin.y - end.y),2))
        
        if abs(begin.x - end.x)<20 {
            return nil
        }

        super.init(texture: nil, color: .clear, size: CGSize(width: lenght, height:6))
        
        let path = CGMutablePath()
    
        path.move(to: begin)
        path.addLine(to: end)
        path.closeSubpath()
        
        stroke = SKShapeNode(path: path)
        
        loadAppearance(begin:begin,end:end,color:color)
        loadPhysicsBody()
        
        //bounce force
       jumpforce = calculateImpulse(begin: begin, end: end)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func calculateImpulse(begin:CGPoint, end:CGPoint)-> CGVector {
        
        let deltaX = begin.x - end.x
        let deltaY = begin.y - end.y

        if abs(deltaX) < 20 {
            return CGVector(dx:0,dy:0)
        }
        
        lenght=sqrt(pow((deltaX),2) + pow((deltaY),2))
      
        var const = (-1.5/10)*lenght + 42
        if const > constMax{
            const = 35
        }else if const < constMin {
            const = 15
        }

        
        let vectorY = const * sqrt(pow(deltaX,2)/(pow(deltaX,2)+pow(deltaY,2)))
        let vectorX =  -vectorY * (deltaY/deltaX)
        //print("trampoline vector: \(sqrt(pow(vectorX,2)+pow(vectorY,2)))")
        
        return CGVector(dx: vectorX, dy: vectorY)
    }
    
    
    func loadAppearance(begin:CGPoint,end:CGPoint,color:UIColor) {
        
        let color2 = color.withAlphaComponent(1)
        
        let tip1=SKShapeNode(circleOfRadius: 3)
        tip1.fillColor = color2
        tip1.strokeColor = .clear
        tip1.position=begin
        addChild(tip1)
        
        let tip2=SKShapeNode(circleOfRadius: 3)
        tip2.fillColor = color2
        tip2.strokeColor = .clear
        tip2.position=end
        addChild(tip2)
        
        stroke.strokeColor = color2
        stroke.lineWidth = 4
        addChild(stroke)
        
        self.zPosition = 2
    }
    
    
    func loadPhysicsBody(){
        self.physicsBody = SKPhysicsBody(edgeChainFrom: stroke.path!)
        physicsBody?.categoryBitMask = trampolineCategory
        physicsBody?.contactTestBitMask = heroCategory
        physicsBody?.collisionBitMask = heroCategory
        
        physicsBody?.restitution = 1
        physicsBody?.friction = 1
    }
    
    
}
