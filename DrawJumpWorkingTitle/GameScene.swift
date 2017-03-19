//
//  GameScene.swift
//  DrawJumpWorkingTitle
//
//  Created by Pawel on 19.08.2016.
//  Copyright (c) 2016 PawelLearning. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var soundPlayer:AVAudioPlayer!
    var audioPlayer:AVAudioPlayer!
    
    var obstacles:[PlanetObstacle] = []
    var unusedObstales:[PlanetObstacle] = []
    
    var unusedStars:[Collectible] = []
    var stars:[Collectible] = []
    
    
    var starLabel:SKLabelNode?
    var starCounter:Int = 0{
        didSet{
            self.starLabel?.text = "\(starCounter)"
        }
    }
    
    //Starting the game
    var clickToStartLabel:SKLabelNode?
    var gameStarted:Bool = false
    var hasBounced:Bool = false
    var generated:Bool = false
    var gamePaused:Bool = false
    
    //Restarting the game
    var restartLabel:SKLabelNode?
    var pauseButton:SKSpriteNode!
    var pauseMenu:PauseMenu!
    
    var mainMenu:MainMenu!
    
    //Points
    var points:Int = 0
    var pointsOld:Int = 0
    var pointsLabel:SKLabelNode?
    var scoreManager:ScoreManager!
    var highScoreLines:[ScoreLine] = []
    
    //camera
    var mainCamera: SKCameraNode!
    
    //screen borders
    var screenBorders:ScreenBorders!
    var finnishLine:FinnishLine!
    
    //Background
    var background:Background!
    
    //Player
    var hero:Hero!
    
    //Trampolines
    var touchLocation:(begin:CGPoint,end:CGPoint)=(CGPoint(x: 0,y: 0),CGPoint(x: 0,y: 0))
    var trampolines=[Trampoline]()
    //var trampolineScribble:TrampolineScribble!
    
    var drawnTrampoline:Trampoline!
    var hasBouncedOnDrawn:Bool = false
    
    var rescueTrampoline:Trampoline!
    var rescueCount:Int!
    
    static var Count=0
    
    var countDownLabel:SKLabelNode?
    var countDownNumber:Int = 3
    var countDownTimer:Timer!
    
    
    
    override func didMove(to view: SKView) {
        
        /* Setup your scene here */
        
        
        setupView()
        setupCamera()
        setupStartLabel()
        setupCountDownLabel()
        setupRestartLabel()
        
        setupPauseMenu()
        setupPointsLabel()
        setupMainMenu()
        
        setupHero(15)
        //setupScreenBorders()
        setupBackground(numberOfStars: 400)
        setupRescueTrampoline()
        setupFinnishLine()
        setupPauseButton()
        
        createObstacles(count: 3)
        createStars(count: 3)
        setupStarLabel()
        
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity.dy = 3*physicsWorld.gravity.dy/4
        
        setupSideBorders()
        
        scoreManager = ScoreManager()
        setupScoreLines()
        
        playAudio()

        
    }
    
    func playAudio(){
        let path = Bundle.main.path(forResource: "music.mp3", ofType: nil)
        let url = URL(fileURLWithPath: path!)
        
        do{
            let sound = try AVAudioPlayer(contentsOf: url)
            audioPlayer = sound
            sound.numberOfLoops = -1
            sound.volume = 0.5
            sound.play()
        }catch{
            
        }
    }
    
    func setupScoreLines(){
        
        for line in highScoreLines{
            line.removeFromParent()
        }
        
        if let lastScore = scoreManager.getLastScore(){
            if(lastScore != 0){
                let lastScoreLine = ScoreLine(size: self.size, points: lastScore, color: .green)
                highScoreLines.append(lastScoreLine)
                addChild(lastScoreLine)
                print("last score: \(scoreManager.lastScore!)")
            }
        }
        
        if let highScore = scoreManager.getHighScore() {
            if(highScore != 0){
                let highScoreLine = ScoreLine(size: self.size, points: highScore, color: .red)
                highScoreLines.append(highScoreLine)
                addChild(highScoreLine)
                print("highScore: \(scoreManager.highScore!)")
            }
        }
    }
    
    func createObstacles(count n:Int){
        let backgroundQueue = DispatchQueue(label: "com.app.queue", qos: .background, target: nil)
        
        backgroundQueue.async {
            for i in 1...n{
                let obstacleXPosition = CGFloat(arc4random_uniform(250) + 95)
                let obstacleSize = CGFloat(arc4random_uniform(50)+50)
                
                let obstacle = PlanetObstacle(size: CGSize(width:obstacleSize,height:obstacleSize))
                obstacle.position = CGPoint(x:obstacleXPosition,y:0)
                self.unusedObstales.append(obstacle)
            }
        }
    }
    
    func createStars(count n:Int){
        let backgroundQueue = DispatchQueue(label: "com.app.queue", qos: .background, target: nil)
        
        backgroundQueue.async {
            for i in 1...n{
                let starXposition = CGFloat(arc4random_uniform(250) + 95)
                let size = CGSize(width: 50, height: 50)
                
                let star = StarCollectible(size: size)
                star.position = CGPoint(x:starXposition,y:0)
                self.unusedStars.append(star)
            }
        }
    }
    
    func setupCountDownLabel(){
        countDownLabel = SKLabelNode(fontNamed:"Helvetica Neue Thin")
        countDownLabel?.text = "3"
        countDownLabel?.fontSize = 50
        countDownLabel?.position = CGPoint(x:0, y:0)
        countDownLabel?.fontColor = UIColor.white
        countDownLabel?.zPosition = 3
        countDownLabel?.isHidden = true
        mainCamera.addChild(countDownLabel!)
    }
    
    func setupPauseMenu(){
        pauseMenu = PauseMenu(size: frame.size)
        pauseMenu.position = CGPoint.zero
        mainCamera.addChild(pauseMenu)
    }
    
    func setupMainMenu(){
        mainMenu=MainMenu(size: frame.size)
        mainMenu.position = CGPoint.zero
        mainCamera.addChild(mainMenu)
    }
    
    func showPauseMenu(){
        let fadeIn = SKAction.fadeIn(withDuration: 0.1)
        let zoomIn = SKAction.scale(by: 1.05, duration: 0.1)
        
        pauseMenu.run(fadeIn)
        pauseMenu.run(zoomIn)
    }
    
    func hidePauseMenu(completion:@escaping ()->Void){
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let zoomIn = SKAction.scale(by: 1.05, duration: 0.1)
        
        pauseMenu.run(fadeOut)
        pauseMenu.run(zoomIn.reversed(), completion: {
            completion()
        })
    }
    
    func setupFinnishLine(){
        finnishLine = FinnishLine(size: frame.size)
        finnishLine.position.x = 0
        finnishLine.position.y = -frame.height/2 - 10
        mainCamera.addChild(finnishLine)
    }
    
    func setupSideBorders(){
        let screenRect = CGRect(x: -self.frame.width/2, y: -self.frame.height*0.75, width: self.frame.width, height: self.frame.height * 1.5)
        let screenBoundries = SKPhysicsBody(edgeLoopFrom: screenRect)
        mainCamera.physicsBody = screenBoundries
        mainCamera.physicsBody?.collisionBitMask = heroCategory
        mainCamera.physicsBody?.categoryBitMask = borderCategory
        mainCamera.physicsBody?.restitution = 0.8
    }
    
    func setupRescueTrampoline(){
        rescueTrampoline=Trampoline(begin: CGPoint(x: -self.frame.width/2 + 15, y: -self.frame.height/2 + 15), end: CGPoint(x: self.frame.width/2 - 15, y: -self.frame.height/2 + 15),color: .white)
        rescueTrampoline.physicsBody?.restitution=1
        rescueTrampoline.stroke.strokeColor = UIColor.white
        mainCamera.addChild(rescueTrampoline)
    }
    
    func setupStartLabel(){
        
        clickToStartLabel = SKLabelNode(fontNamed:"Helvetica Neue Thin")
        clickToStartLabel?.text = "Tap to start"
        clickToStartLabel?.fontSize = 20
        clickToStartLabel?.position = CGPoint(x:0, y:0)
        clickToStartLabel?.fontColor = UIColor.white
        
        mainCamera.addChild(clickToStartLabel!)
    }
    
    func setupPointsLabel(){
        pointsLabel = SKLabelNode(fontNamed:"Helvetica Neue Thin")
        pointsLabel?.text = "0 pts"
        pointsLabel?.fontSize = 15
        pointsLabel?.horizontalAlignmentMode = .left
        pointsLabel?.fontColor = UIColor.white
        pointsLabel?.position = CGPoint(x: -frame.width/2 + 10, y: frame.height/2-25)
        
        mainCamera.addChild(pointsLabel!)
    }
    
    func setupStarLabel(){
        starLabel = SKLabelNode(fontNamed:"Helvetica Neue Light")
        starLabel?.text = "\(starCounter)"
        starLabel?.fontSize = 20
        starLabel?.horizontalAlignmentMode = .center
        starLabel?.fontColor = UIColor.yellow
        starLabel?.position = CGPoint(x: 0, y: frame.height/2-25)
        
        mainCamera.addChild(starLabel!)
    }
    
    func setupRestartLabel(){
        restartLabel = SKLabelNode(fontNamed:"Helvetica Neue Thin")
        restartLabel?.text = "restart"
        restartLabel?.fontSize = 15
        restartLabel?.position = CGPoint(x: 0, y: frame.height/2 - 25)
        restartLabel?.fontColor = UIColor.white
        
        //mainCamera.addChild(restartLabel!)
    }
    
    func setupPauseButton(){
        pauseButton = SKSpriteNode(texture: nil, color: .clear, size: CGSize(width: 30, height: 30))
        pauseButton.position = CGPoint(x: frame.width/2 - 20, y: frame.height/2 - 20)
        let pauseImage = SKSpriteNode(texture: SKTexture(imageNamed: "pause"), color: .clear, size: CGSize(width: 20, height: 20))
        pauseImage.position = CGPoint(x: 0, y: 0)
        pauseImage.zPosition = 2
        pauseButton.addChild(pauseImage)
        mainCamera.addChild(pauseButton)
    }
    
    func setupHero(_ radius:CGFloat){
        hero=Hero(radius:radius)
        hero.position = CGPoint(x: view!.center.x, y: view!.center.y-50)
        addChild(hero)
    }
    
    func setupBackground(numberOfStars num:Int) {
        background = Background(size: size, starCount: num)
        background.position = view!.center
        background.zPosition = (-1)
        
        addChild(background)
        
        //trampolineScribble = TrampolineScribble()
        //mainCamera.addChild(trampolineScribble)
    }
    
    
    func setupScreenBorders() {
        screenBorders=ScreenBorders(size: CGSize(width: frame.width, height: frame.height))
        screenBorders.position = view!.center
        screenBorders.zPosition = 1
        addChild(screenBorders)
    }

    func setupView(){
        backgroundColor = UIColor(colorLiteralRed: 38/255, green: 38/255, blue: 46/255, alpha: 1)
    }
    
    func setupCamera(){
        
        mainCamera = SKCameraNode()
        mainCamera?.setScale(1)
        
        self.camera = mainCamera
        mainCamera!.position = view!.center
        addChild(mainCamera)
    }
    
    
    func startGame() {
        gameStarted=true
        clickToStartLabel?.isHidden = true
        hero.physicsBody!.isDynamic = true
        hero.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 20/1.5))
        
    }
    
    func stopGame(){
        gameStarted=false
        clickToStartLabel?.isHidden = false
        hero.physicsBody!.isDynamic = false
    }
    
    func restartGame(){
        
        for obstacle in obstacles {
            obstacle.removeFromParent()
        }
        obstacles.removeAll()
        
        stopGame()
        points = 0
        pointsOld = -1
        pointsLabel?.text = "0 pts"
        pauseMenu.points = 0
        for trampoline in trampolines {
            trampoline.removeFromParent()
        }
        trampolines.removeAll()
        hero.position = CGPoint(x: view!.center.x, y: view!.center.y-50)
        hero.zRotation=0
        hasBounced=false
        mainCamera.position=view!.center
        background.restoreStartingPosition(starCount: 300)
        setupRescueTrampoline()
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        
        if gameStarted {
            for t in touches{
                //Get trampoline starting point in VIEW (relative to the scene center)
                removeTrampoline()
                touchLocation.begin = t.location(in: mainCamera)
                hasBouncedOnDrawn = false
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted {
            for t in touches {
                touchLocation.end = t.location(in: mainCamera)
                let path = CGMutablePath()
                path.move(to: touchLocation.begin)
                path.addLine(to: touchLocation.end)
                path.closeSubpath()
                
                //trampolineScribble.path = path
                
                if(!hasBouncedOnDrawn){
                        createDrawnTrampoline(begin: touchLocation.begin, end: touchLocation.end)
                }
                
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameStarted {
            for t in touches{
                
                //trampolineScribble.path = nil
                
                if (drawnTrampoline) != nil {
                    drawnTrampoline.removeFromParent()
                    drawnTrampoline = nil
                }
                
                // Creating actual trampolines
                if(!hasBouncedOnDrawn){
                    touchLocation.end = t.location(in: self)
                    removeTrampoline()
                    createTrampoline()
                }
              
            }
            
        } else {
            if(!(pauseButton?.contains((touches.first?.location(in: mainCamera))!))!){
                startGame()
            }
        }
        
        let touch = touches.first?.location(in: mainCamera)
        
        if (pauseButton?.contains(touch!))! {
            
            if(!gamePaused){
                pauseGame()
            }
            
        }
        
        if(gamePaused){
            if (pauseMenu.restartButton.contains(touch!)){
                restartGame()
                hidePauseMenu(completion: {})
                gamePaused = false
                physicsWorld.speed = 1
            }
            if (pauseMenu.resumeButton.contains(touch!)){
                resumeGame()
            }
            if (pauseMenu.resetButton.contains(touch!)){
                print("reseting stats")
                scoreManager.resetHighScore()
                setupScoreLines()
            }
        }
        
    }
    
    func showMainMenu(){
        showPauseMenu()
        physicsWorld.speed = 0
        gamePaused = true
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.1)
        let zoomIn = SKAction.scale(by: 1.05, duration: 0.1)
        
        mainMenu.run(fadeIn)
        mainMenu.run(zoomIn)
    }

    
    func hideMainMenu(){
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let zoomIn = SKAction.scale(by: 1.05, duration: 0.1)
        
        mainMenu.run(fadeOut)
        mainMenu.run(zoomIn.reversed())
    }
    
    func pauseGame(){
        pauseMenu.points = points
        showPauseMenu()
        physicsWorld.speed = 0
        gamePaused = true
    }
    
    func resumeGame(){
        hidePauseMenu(completion: {})
        startCountDown()
    }
    
    func startCountDown(){
        countDownNumber = 3
        countDownLabel?.text = "\(countDownNumber)"
        countDownLabel?.isHidden = false
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
    }
    
    func countDown(){
        print("robie tu countDwon \(countDownNumber)")
        if(countDownNumber > 1){
            countDownNumber -= 1
            countDownLabel?.text = "\(countDownNumber)"
        }else{
            //countDownNumber = 3
            countDownLabel?.isHidden = true
            countDownTimer.invalidate()
            gamePaused = false
            physicsWorld.speed = 1
        }
    }

    func createDrawnTrampoline(begin:CGPoint, end: CGPoint){
        
        if(!gamePaused){
            if drawnTrampoline != nil{
                drawnTrampoline.removeFromParent()
                drawnTrampoline = nil
            }
            if let tmpDrawnTrampoline = Trampoline(begin: begin, end: end, color: .cyan){
                drawnTrampoline = tmpDrawnTrampoline
                drawnTrampoline.physicsBody?.categoryBitMask = drawnTrampolineCategory
                mainCamera.addChild(drawnTrampoline)
                hasBouncedOnDrawn = false
            }
        }
   
    }
    
    func createTrampoline(){
        if(!gamePaused){
            touchLocation.begin = convert(touchLocation.begin, from: mainCamera)
            if touchLocation.begin.y < hero.position.y{
                if let trampoline = Trampoline(begin: touchLocation.begin, end: touchLocation.end,color: .cyan) {
                    trampolines.append(trampoline)
                    addChild(trampoline)
                }
            }
        }
    }
    
    
    func removeTrampoline(){
        if trampolines.count>0{
            trampolines.first!.removeFromParent()
            trampolines.removeFirst()
        }
    }
    
    func playCollectSound(){
        let path = Bundle.main.path(forResource: "collect.mp3", ofType: nil)
        let url = URL(fileURLWithPath: path!)
        
        do{
            let sound = try AVAudioPlayer(contentsOf: url)
            soundPlayer = sound
            sound.numberOfLoops = 1
            sound.play()
        }catch{
            
        }

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyB.node?.physicsBody?.categoryBitMask == collectibleCategory{
            let star = contact.bodyB.node as! StarCollectible
            star.disapearAtContact()
            star.removeFromParent()
            starCounter += 1
            
            playCollectSound()
            
            
        }
        
        if contact.bodyA.node?.physicsBody?.categoryBitMask == trampolineCategory {
            for trampoline in trampolines {
                if trampoline==contact.bodyA.node!{

                    hero.physicsBody?.applyImpulse(trampoline.jumpforce)
                    
                    trampoline.removeFromParent()
                    generated = false
                    trampolines.remove(at: trampolines.index(of: trampoline)!)
                    if hasBounced == false {
                        hasBounced = true
                    }
                }
            }
        }
        
        if contact.bodyA.node == rescueTrampoline || contact.bodyB.node == rescueTrampoline{
            
            hero.physicsBody?.applyImpulse(rescueTrampoline.jumpforce)
            rescueTrampoline.removeFromParent()
            if (!trampolines.isEmpty){
                let tmpTramp = trampolines.removeLast()
                tmpTramp.removeFromParent()
            }
            generated = false
            if hasBounced == false {
                hasBounced = true
            }
        }
        
        if contact.bodyA.categoryBitMask == drawnTrampolineCategory {
            
            hasBouncedOnDrawn = true
            hero.physicsBody?.applyImpulse(drawnTrampoline.jumpforce)
            drawnTrampoline.removeFromParent()
            drawnTrampoline = nil
            
            generated = false
            if hasBounced == false {
                hasBounced = true
            }
        }
        
        
        
        if contact.bodyB.node?.physicsBody?.categoryBitMask == obstacleCategory {
            let obstacle = contact.bodyB.node as! PlanetObstacle
            obstacle.pulseAtContact()
            let vector = obstacle.generateForceVector(heroPosition: hero.position, obstaclePosition: obstacle.position)
            hero.physicsBody?.applyImpulse(vector)
        }
        
        if contact.bodyA.categoryBitMask == finnishCategory{
            restartGameAfterLosing(completion:{
                self.scoreManager.saveHighScore()
                self.scoreManager.saveLastScore()
                self.setupScoreLines()
            })
        }
    }
    
    func restartGameAfterLosing(completion:@escaping ()->Void){
        
        finnishLine.physicsBody?.contactTestBitMask = 0
        let heroAction = SKAction.move(to: CGPoint(x: view!.center.x, y: view!.center.y-50),duration: 0)
        let camAction = SKAction.move(to: view!.center, duration: 0.8)
        hero.run(heroAction, completion: {
            self.hero.physicsBody?.isDynamic=false
        })
        mainCamera.run(camAction, completion: {
            self.restartGame()
            self.finnishLine.physicsBody?.contactTestBitMask = heroCategory
            completion()
        })

    }
    
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        if(!gamePaused){
            
        
        hero.update()
        
        //print(hero.physicsBody?.velocity.dy)
        
        points = Int((hero.position.y - (view!.center.y+50))/10)
    
        if points > pointsOld {
            pointsLabel?.text = "\(points) pts"
            pointsOld = points
            scoreManager.points = points
            
            GameScene.Count = Int(points/2000) + 2
        }
    
        if (!mainCamera.contains(background.backgrounds[0])) {
            background.moveBottomBackground()
        }
        
        if (!generated) {
            if(hasBounced){
                if (hero.physicsBody?.velocity.dy)! < 500 {
                    if obstacles.count>0{
                        if hero.position.y - (obstacles.last?.position.y)! > 250 && hero.position.y - (stars.last?.position.y)! > 250 {
                            let starOrObstacle = CGFloat(arc4random_uniform(5))
                            if(starOrObstacle < 2){
                                let obstacle = unusedObstales.removeFirst()
                                obstacle.position.y = hero.position.y + 350
                                obstacles.append(obstacle)
                                addChild(obstacle)
                                createObstacles(count: 1)
                            }else{
                                let star = unusedStars.removeFirst()
                                star.position.y = hero.position.y + 350
                                stars.append(star)
                                addChild(star)
                                createStars(count: 1)
                            }
                            
                            generated = true
                            
                        }
                    }else {
                        let obstacle = unusedObstales.removeFirst()
                        obstacle.position.y = hero.position.y + 350
                        obstacles.append(obstacle)
                        addChild(obstacle)
                        
                        let star = unusedStars.removeFirst()
                        star.position.y = hero.position.y + 350
                        stars.append(star)
                        
                        createStars(count: 1)
                        createObstacles(count: 1)
                        generated = true
                    }
                }

            }
        }
            
        }//gamepaused
    }
    
    override func didFinishUpdate() {
        if(!gamePaused){
            if hasBounced && hero.position.y > mainCamera.position.y + self.frame.height/2 - 325 && (hero.physicsBody?.velocity.dy)! > 0 {
                mainCamera.position.y=hero.position.y - frame.height/2 + 325
            }
        }
    }
    
    
}
