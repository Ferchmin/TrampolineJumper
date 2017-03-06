//
//  MainMenu.swift
//  DrawJumpThree
//
//  Created by Pawel on 04.03.2017.
//  Copyright © 2017 PawelLearning. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    
    var mainMenu:MainMenu!
    
    
    override func didMove(to view: SKView){
        
        mainMenu = MainMenu(size: frame.size)
        mainMenu.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(mainMenu)
        
        self.backgroundColor = .blue
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches{
            
            if(mainMenu.continueButton.contains(t.location(in: self))){
                print("mhm")                
            }

            
            
        }
    }

}
