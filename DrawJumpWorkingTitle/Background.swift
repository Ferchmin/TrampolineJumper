//
//  Background.swift
//  DrawJumpThree
//
//  Created by Pawel on 12.02.2017.
//  Copyright © 2017 PawelLearning. All rights reserved.
//

import Foundation
import GameKit

class Background:SKSpriteNode {
    
    var backgrounds:[SKSpriteNode]!
    
    var bottomBackground:SKSpriteNode!
    var middleBackground:SKSpriteNode!
    var topBackground:SKSpriteNode!
    
    
    init(size:CGSize, starCount: Int){
        backgrounds=[]
        super.init(texture: nil, color: .clear, size: size)
        
        createBackgrounds(size: size, starCount: starCount)
    }
    
    func createBackgrounds(size:CGSize, starCount: Int){
        
        bottomBackground=SKSpriteNode(texture: nil, color: .clear, size: size)
        bottomBackground.position = CGPoint(x: 0, y: 0)
        bottomBackground.texture = SKTexture(imageNamed: "background")
        
        middleBackground=SKSpriteNode(texture: nil, color: .clear, size: size)
        middleBackground.position = CGPoint(x: 0, y: size.height)
        middleBackground.texture = SKTexture(imageNamed: "background")
        
        topBackground=SKSpriteNode(texture: nil, color: .clear, size: size)
        topBackground.position=CGPoint(x: 0, y: 2*size.height)
        topBackground.texture = SKTexture(imageNamed: "background")
        
        backgrounds.append(bottomBackground)
        backgrounds.append(middleBackground)
        backgrounds.append(topBackground)
        
        for background in backgrounds{
            populate(background: background, starCount: starCount)
            addChild(background)
        }
        
    }
    
    func populate(background:SKSpriteNode, starCount:Int){
        
        generateRandomPositions(background: background, starCount: starCount/2)
        generateGaussPositions(background: background, starCount: starCount/2)
        
    }
    
    func generateRandomPositions(background:SKSpriteNode, starCount:Int){
        for _ in 0  ..< starCount  {
            var starSize:CGFloat = CGFloat((arc4random_uniform(8)+12)/5)
            starSize=starSize/2
            let star=SKSpriteNode(color: UIColor.white, size: CGSize(width: starSize,height: starSize))
            let alpha:Float = Float(arc4random_uniform(10))/10
            
            star.color = UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 255/255, alpha: alpha)
            star.zRotation=CGFloat(M_PI_2/2)
            
            let x=CGFloat(arc4random_uniform(UInt32(size.width-40))) - size.width/2 + 20
            let y=CGFloat(arc4random_uniform(UInt32(size.height))) - size.height/2
            
            star.position=CGPoint(x: x,y: y)
            background.addChild(star)
        }

    }
    
    func generateGaussPositions(background:SKSpriteNode, starCount:Int){
        for _ in 0  ..< starCount  {
            var starSize:CGFloat = CGFloat((arc4random_uniform(8)+12)/5)
            starSize=starSize/2
            let star=SKSpriteNode(color: UIColor.white, size: CGSize(width: starSize,height: starSize))
            let alpha:Float = Float(arc4random_uniform(10))/10
            
            star.color = UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 255/255, alpha: alpha)
            star.zRotation=CGFloat(M_PI_2/2)
            
            let guassianDistributionForX = GKGaussianDistribution(lowestValue: -Int(size.width/4), highestValue: Int(size.width/4))
            
            let x=CGFloat(guassianDistributionForX.nextInt())
            let y=CGFloat(arc4random_uniform(UInt32(size.height))) - size.height/2
            
            star.position=CGPoint(x: x,y: y)
            background.addChild(star)
        }
    }
    
    func moveBottomBackground(){
        backgrounds.first?.position.y = backgrounds.last!.position.y + size.height
        let bottomBackground = backgrounds.removeFirst()
        backgrounds.append(bottomBackground)
    }
    
    func restoreStartingPosition(starCount:Int){
        for background in backgrounds{
            background.position.y = size.height*CGFloat(backgrounds.index(of: background)!)
            background.removeAllChildren()
            populate(background: background, starCount: starCount)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
