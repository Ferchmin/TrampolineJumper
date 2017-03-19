//
//  ScoreManager.swift
//  DrawJumpThree
//
//  Created by Pawel on 17.03.2017.
//  Copyright © 2017 PawelLearning. All rights reserved.
//

import Foundation
import GameKit

class ScoreManager{
    
    let highScoreKey = "HighScore"
    let lastScoreKey = "LastScore"
    
    var points:Int = 0
    var highScore:Int?
    var lastScore:Int?
    
   
    
    init(){
        points = 0
        highScore = getHighScore()
        lastScore = getLastScore()
    }
    
    func getHighScore() -> Int?{
        let userDataDefault = UserDefaults.standard
        highScore = userDataDefault.integer(forKey: highScoreKey)
        return highScore
    }
    
    func getLastScore() -> Int?{
        let userDataDefault = UserDefaults.standard
        lastScore = userDataDefault.integer(forKey: lastScoreKey)
        return lastScore
    }
    
    func saveHighScore(){
        let userDataDefault = UserDefaults.standard
        if (userDataDefault.integer(forKey: highScoreKey) != nil ){
            if(points > userDataDefault.integer(forKey: highScoreKey)){
                userDataDefault.set(points, forKey: highScoreKey)
            }
        }
    }
    
    func saveLastScore(){
        let userDataDefault = UserDefaults.standard
        userDataDefault.set(points, forKey: lastScoreKey)
    }
    
    func resetHighScore(){
        let userDataDefault = UserDefaults.standard
        userDataDefault.set(0, forKey: highScoreKey)
        userDataDefault.set(0, forKey: lastScoreKey)
        getLastScore()
        getHighScore()
    }
    
    func update(){
        
    }
    
}
