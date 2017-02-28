//
//  ScreenBorders.swift
//  DrawJumpWorkingTitle
//
//  Created by Pawel on 21.08.2016.
//  Copyright © 2016 PawelLearning. All rights reserved.
//

import Foundation
import SpriteKit


class SideBorder:SKSpriteNode {
    
    let BORDERWIDTH:CGFloat = 4
    let NUMBER_OF_SEGMENTS = 10
    let COLOR_ONE = UIColor(colorLiteralRed: 245/255, green: 249/255, blue: 254/255, alpha: 1)
    let COLOR_TWO = UIColor(colorLiteralRed: 216/255, green: 233/255, blue: 251/255, alpha: 1)
    
    init(size: CGSize){
        super.init(texture: nil, color: UIColor.clear, size: CGSize(width: BORDERWIDTH, height: size.height))
        
        for i in 0  ..< NUMBER_OF_SEGMENTS  {
            var segmentColor: UIColor!
            if i%2==0{
                segmentColor=COLOR_ONE
            }else{
                segmentColor=COLOR_TWO
            }
            
            let segment = SKSpriteNode(color: segmentColor, size: CGSize(width: BORDERWIDTH, height: self.size.height/CGFloat(NUMBER_OF_SEGMENTS)))
            segment.anchorPoint.y=0
            
            segment.position = CGPoint(x: 0,y: CGFloat(i)*segment.size.height - self.size.height/2)
            addChild(segment)
            
        }
        loadPhysicsBody(size)
    }
    
    func loadPhysicsBody(_ size: CGSize){
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: BORDERWIDTH, height: size.height))
        physicsBody?.collisionBitMask = heroCategory
        physicsBody?.categoryBitMask = borderCategory
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
        physicsBody?.restitution = 0.8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ScreenBorders: SKSpriteNode {
    
    let leftBottomBorder:SideBorder!
    let leftMiddleBorder:SideBorder!
    let leftTopBorder:SideBorder!
    
    let rightBottomBorder:SideBorder!
    let rightMiddleBorder:SideBorder!
    let rightTopBorder:SideBorder!
    
    var leftBorders=[SideBorder]()
    var rightBorders=[SideBorder]()
    
    init(size: CGSize){
        leftBottomBorder=SideBorder(size: size)
        leftMiddleBorder=SideBorder(size:size)
        leftTopBorder=SideBorder(size:size)
        
        rightBottomBorder=SideBorder(size: size)
        rightMiddleBorder=SideBorder(size:size)
        rightTopBorder=SideBorder(size: size)
        
        super.init(texture: nil, color: UIColor.clear, size: size)
        
        leftBottomBorder.position=CGPoint(x: -(size.width/2-2), y: 0)
        leftBorders.append(leftBottomBorder)
        leftMiddleBorder.position=CGPoint(x: -(size.width/2-2), y: size.height)
        leftBorders.append(leftMiddleBorder)
        leftTopBorder.position=CGPoint(x: -(size.width/2-2), y: 2*size.height)
        leftBorders.append(leftTopBorder)
        
        for border in leftBorders {
            addChild(border)
        }
        
        
        rightBottomBorder.position=CGPoint(x: size.width/2-2, y: 0)
        rightBorders.append(rightBottomBorder)
        rightMiddleBorder.position=CGPoint(x: size.width/2-2, y: size.height)
        rightBorders.append(rightMiddleBorder)
        rightTopBorder.position=CGPoint(x: size.width/2-2, y: 2*size.height)
        rightBorders.append(rightTopBorder)
        
        for border in rightBorders{
            addChild(border)
        }

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveBottomBorder(){
        leftBorders[0].position.y = leftBorders[2].position.y + size.height
        let leftBorder = leftBorders.removeFirst()
        leftBorders.append(leftBorder)
        rightBorders[0].position.y = rightBorders[2].position.y + size.height
        let rightBorder = rightBorders.removeFirst()
        rightBorders.append(rightBorder)
    }
    func restoreStartingPosition(){
        for border in leftBorders {
            border.position.y=size.height*CGFloat(leftBorders.index(of: border)!)
        }
        for border in rightBorders{
            border.position.y=size.height*CGFloat(rightBorders.index(of: border)!)
        }
    }
    
}
