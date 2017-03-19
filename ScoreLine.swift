//
//  ScoreLine.swift
//  DrawJumpThree
//
//  Created by Pawel on 17.03.2017.
//  Copyright © 2017 PawelLearning. All rights reserved.
//

import Foundation
import GameKit

class ScoreLine:SKSpriteNode{
    
    var line:SKShapeNode!
    var pointsFlag:SKShapeNode!
    var pointsLabel:SKLabelNode!
    
    init(size:CGSize, points:Int, color:UIColor){
        super.init(texture: nil, color: .clear, size: size)
        
        let position = calucalatePosition(size: size, points: points)
        
        setupLine(position: position, color:color)
        setupPointsFlag(size: size, position: position, color:color)
        setupPointsLabel(points: points)
        
        self.zPosition = -1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLine(position:CGPoint, color:UIColor){
        line = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: 3))
        line.strokeColor = .clear
        line.fillColor = color
        line.position = position
        addChild(line)
    }
    
    func setupPointsFlag(size:CGSize, position:CGPoint, color:UIColor){
        let rect = CGRect(x: 0, y: 0, width: 50, height: 25)
        pointsFlag = SKShapeNode(rect: rect, cornerRadius: 5)
        pointsFlag.strokeColor = .clear
        pointsFlag.fillColor = color
        pointsFlag.position = CGPoint(x: size.width - 60, y: position.y - 22)
        addChild(pointsFlag)
    }
    
    func setupPointsLabel(points:Int){
        pointsLabel = SKLabelNode(fontNamed:"Helvetica Neue Thin")
        pointsLabel?.text = String(points)
        pointsLabel?.fontSize = 15
        pointsLabel?.horizontalAlignmentMode = .center
        pointsLabel?.fontColor = UIColor.white
        pointsLabel?.position = CGPoint(x: 25, y: 5)
        
        pointsFlag.addChild(pointsLabel!)
    }
    
    func calucalatePosition(size:CGSize,points:Int) -> CGPoint {

        let pointsTen = 10*points
        let halfWidth = size.height/2
        
        let posY = CGFloat(halfWidth + CGFloat(pointsTen) + 50)
        
        return CGPoint(x:0,y:posY)
    }
}
