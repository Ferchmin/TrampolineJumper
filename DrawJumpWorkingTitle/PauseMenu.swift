//
//  PauseMenu.swift
//  DrawJumpThree
//
//  Created by Pawel on 26.02.2017.
//  Copyright © 2017 PawelLearning. All rights reserved.
//

import Foundation
import GameKit

class PauseMenu:SKSpriteNode{
    
    var pauseMenuShape:SKShapeNode!
    var pauseMenuShapeRect:CGRect!
    
    //Point counter
    var pointsLabel:SKLabelNode!
    var points:Int = 0{
        didSet{
            if points < 0 {
                points = oldValue
            }
            pointsLabel.text = "\(points) pts"
        }
    }
    
    //Buttons
    var resumeButton:PauseMenuButton!
    var restartButton:PauseMenuButton!
    var resetButton:PauseMenuButton!
    
    
    init(size:CGSize){
        super.init(texture: nil, color: .clear, size: CGSize(width: size.width - 100, height: size.height - 250))
        
        setupPointsLabel()
        setupPauseMenuShape(size: size)
        
        self.zPosition = 5
        self.alpha = 0
    }
    
    func setupPointsLabel(){
        pointsLabel = SKLabelNode(fontNamed:"Helvetica Neue Thin")
        pointsLabel.text = "\(points) pts"
        pointsLabel.fontSize = 30
        pointsLabel.verticalAlignmentMode = .center
        pointsLabel.position = CGPoint(x: 0, y: self.size.height/2 - 50)
        pointsLabel.fontColor = UIColor.darkText
        
        pointsLabel.zPosition = 3
        
        addChild(pointsLabel)
    
    }
    
    func setupPauseMenuShape(size:CGSize){
        
        pauseMenuShapeRect = CGRect(x: 0, y: 0, width: size.width-100, height: size.height - 250)
        
        pauseMenuShape = SKShapeNode(rect: pauseMenuShapeRect, cornerRadius: 5)
        pauseMenuShape.position = CGPoint(x: -self.size.width/2, y: -self.size.height/2)
        pauseMenuShape.fillColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.98)
        pauseMenuShape.strokeColor = .clear
        
        addChild(pauseMenuShape)
        
        setupResumeButton(size: self.size)
        setupRestartButton(size: self.size)
        setupMainMenuButton(size: self.size)
        
    }
    
    func setupResumeButton(size:CGSize){
        resumeButton = PauseMenuButton(size: size, text: "Resume")
        resumeButton.position = CGPoint(x: 0, y: 90)
        addChild(resumeButton)
        
    }
    
    func setupRestartButton(size:CGSize){
        restartButton = PauseMenuButton(size:size, text: "Restart")
        restartButton.position = CGPoint(x: 0, y: 20)
        addChild(restartButton)
    }
    
    func setupMainMenuButton(size:CGSize){
        resetButton = PauseMenuButton(size: size, text: "Reset high score")
        resetButton.position = CGPoint(x: 0, y: -50)
        addChild(resetButton)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
