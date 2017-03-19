//
//  MainMenu.swift
//  DrawJumpThree
//
//  Created by Pawel on 04.03.2017.
//  Copyright © 2017 PawelLearning. All rights reserved.
//

import Foundation
import GameKit

class MainMenu:SKSpriteNode{
    
    var pauseMenuShape:SKShapeNode!
    var pauseMenuShapeRect:CGRect!
    
    //Point counter
    var nameLabel:SKLabelNode!
    var playerName:String = "Gracz1"
    
    //Buttons
    var continueButton:PauseMenuButton!
    var startButton:PauseMenuButton!
    var resetStatsButton:PauseMenuButton!
    
    
    init(size:CGSize){
        super.init(texture: nil, color: .clear, size: CGSize(width: size.width - 50, height: size.height - 100))
        
        setupNameLabel()
        setupMainMenuShape(size: size)
        
        self.zPosition = 5
        self.alpha = 0
    }
    
    func setupNameLabel(){
        nameLabel = SKLabelNode(fontNamed:"Helvetica Neue Thin")
        nameLabel.text = "\(playerName)"
        nameLabel.fontSize = 30
        nameLabel.verticalAlignmentMode = .center
        nameLabel.position = CGPoint(x: 0, y: self.size.height/2 - 50)
        nameLabel.fontColor = UIColor.darkText
        
        nameLabel.zPosition = 3
        
        addChild(nameLabel)
        
    }
    
    func setupMainMenuShape(size:CGSize){
        
        pauseMenuShapeRect = CGRect(x: 0, y: 0, width: size.width-50, height: size.height - 100)
        
        pauseMenuShape = SKShapeNode(rect: pauseMenuShapeRect, cornerRadius: 5)
        pauseMenuShape.position = CGPoint(x: -self.size.width/2, y: -self.size.height/2)
        pauseMenuShape.fillColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1)
        pauseMenuShape.strokeColor = .clear
        
        addChild(pauseMenuShape)
        
        setupContinueButton(size: self.size)
        setupStartButton(size: self.size)
        setupResetStatsButton(size: self.size)
        
    }
    
    func setupContinueButton(size:CGSize){
        continueButton = PauseMenuButton(size: size, text: "Continue")
        continueButton.position = CGPoint(x: 0, y: 90)
        addChild(continueButton)
        
    }
    
    func setupStartButton(size:CGSize){
        startButton = PauseMenuButton(size:size, text: "Start")
        startButton.position = CGPoint(x: 0, y: 20)
        addChild(startButton)
    }
    
    func setupResetStatsButton(size:CGSize){
        resetStatsButton = PauseMenuButton(size: size, text: "Reset Stats")
        resetStatsButton.position = CGPoint(x: 0, y: -50)
        addChild(resetStatsButton)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
