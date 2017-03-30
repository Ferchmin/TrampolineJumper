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
    
    var topColor:CIColor!
    var bottomColor:CIColor!
    
    let color1 = CIColor(red: 52/255, green: 70/255, blue: 147/255)
    let color2 = CIColor(red: 63/255, green: 51/255, blue: 101/255)
    let color3 = CIColor(red: 104/255, green: 56/255, blue: 112/255)
    
    var colors:[CIColor]!
    
    init(size:CGSize, starCount: Int){
        backgrounds=[]
        super.init(texture: nil, color: .clear, size: size)

        colors = [color1,color2,color3]
        
        bottomColor = colors.removeFirst()
        colors.append(bottomColor)
        topColor = colors.removeFirst()
        colors.append(topColor)
        
        
        createBackgrounds(size: size, starCount: starCount)
    }
    
    func createBackgrounds(size:CGSize, starCount: Int){
        
        bottomBackground=SKSpriteNode(texture: nil, color: .clear, size: size)
        bottomBackground.position = CGPoint(x: 0, y: 0)
        bottomBackground.texture = generateGradient()
        
        middleBackground=SKSpriteNode(texture: nil, color: .clear, size: size)
        middleBackground.position = CGPoint(x: 0, y: size.height)
        middleBackground.texture = generateGradient()
        
        topBackground=SKSpriteNode(texture: nil, color: .clear, size: size)
        topBackground.position=CGPoint(x: 0, y: 2*size.height)
        topBackground.texture = generateGradient()
        
        backgrounds.append(bottomBackground)
        backgrounds.append(middleBackground)
        backgrounds.append(topBackground)
        
        for background in backgrounds{
            populate(background: background, starCount: starCount)
            addChild(background)
        }
        
    }
    
    func generateGradient() -> SKTexture{
        
        bottomColor = topColor
        topColor = colors.removeFirst()
        colors.append(topColor)
        
        let texture = SKTexture(size: CGSize(width:200,height: 200), color1: bottomColor, color2: topColor, direction: .Up)
        texture.filteringMode = .nearest
        
        return texture
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
            star.zRotation = CGFloat.pi/4
            
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
            star.zRotation=CGFloat.pi/4
            
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
        bottomBackground.texture = generateGradient()
        backgrounds.append(bottomBackground)
    }
    
    func moveTopBackground(){
        backgrounds.last?.position.y = backgrounds.last!.position.y - size.height
        let topBackground = backgrounds.removeLast()
        topBackground.texture = generateGradient()
        backgrounds.insert(topBackground, at: 0)
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
