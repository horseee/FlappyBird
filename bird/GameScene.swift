//
//  GameScene.swift
//  bird
//
//  Created by horseee on 2017/9/27.
//  Copyright © 2017年 horseee. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    enum GameStatus {
         case start
         case idle
         case running
         case over
    }
    
    var gameStatus: GameStatus = .idle
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var floor1: SKSpriteNode!
    var floor2: SKSpriteNode!
    var floor3: SKSpriteNode!
    var floor4: SKSpriteNode!
    var bird: SKSpriteNode!
    var background: SKSpriteNode!
    let birdCategory: UInt32 = 0x1 << 0
    let pipeCategory: UInt32 = 0x1 << 1
    let floorCategory: UInt32 = 0x1 << 2
    
    var flappybirdlabel :SKSpriteNode!
    var beginlabel: SKSpriteNode!
    var taplabel: SKSpriteNode!
    var gameoverlabel: SKSpriteNode!
    var scorelabel: SKSpriteNode!
    var numberlabel: SKSpriteNode!

    
    var meters:UInt32 = 0
    var times :UInt32 = 0
    
    override func didMove(to view: SKView) {

        let backgroundTexture = SKTexture(imageNamed: "day")
        let background = SKSpriteNode(texture: backgroundTexture, size: CGSize(width:self.size.width,height:self.size.height))
        background.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        background.zPosition = 1
        addChild(background)
        
         //self.background
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsWorld.contactDelegate  = self
        
        floor1 = SKSpriteNode(imageNamed: "land")
        floor1.anchorPoint = CGPoint(x: 0, y: 0)
        floor1.position = CGPoint(x: 0, y: 0)
        floor1.zPosition = 2
        addChild(floor1)
        
        floor1.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: floor1.size.width, height: floor1.size.height))
        floor1.physicsBody?.categoryBitMask = floorCategory
        
        floor2 = SKSpriteNode(imageNamed: "land")
        floor2.anchorPoint = CGPoint(x: 0, y: 0)
        floor2.position = CGPoint(x: floor1.size.width, y: 0)
        floor2.zPosition = 2
        addChild(floor2)
        
        floor2.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: floor2.size.width, height: floor2.size.height))
        floor2.physicsBody?.categoryBitMask = floorCategory

        
        floor3 = SKSpriteNode(imageNamed: "land")
        floor3.anchorPoint = CGPoint(x: 0, y: 0)
        floor3.position = CGPoint(x: floor1.size.width+floor2.size.width, y: 0)
        floor3.zPosition = 2
        addChild(floor3)
        
        floor3.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: floor3.size.width, height: floor3.size.height))
        floor3.physicsBody?.categoryBitMask = floorCategory

        
        floor4 = SKSpriteNode(imageNamed: "land")
        floor4.anchorPoint = CGPoint(x: 0, y: 0)
        floor4.position = CGPoint(x: floor1.size.width+floor2.size.width+floor3.size.width, y: 0)
        floor4.zPosition = 2
        addChild(floor4)
        
        floor4.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: floor4.size.width, height: floor4.size.height))
        floor4.physicsBody?.categoryBitMask = floorCategory

        
        bird = SKSpriteNode(imageNamed: "bird0_0")
        bird.zPosition = 2
        addChild(bird)
        
        bird.physicsBody = SKPhysicsBody(texture: bird.texture!, size: bird.size)
        bird.physicsBody?.allowsRotation = false
        bird.physicsBody?.categoryBitMask = birdCategory //设置小鸟物理体标示
        bird.physicsBody?.contactTestBitMask = floorCategory | pipeCategory
        
        wait()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if gameStatus != .over {
            moveScene()
        }
        if gameStatus == .running {
            times += 1
            if times > 250{
                times = 50
                meters += 1
                DisplayNumber(number: meters)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameStatus {
            case .start:
                shuffle()
            case .idle:
                startGame()
            case .running:
                bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 13x))
            case .over:
                shuffle()
        }
    }
    
    func moveScene() {
        floor1.position = CGPoint(x: floor1.position.x - 1, y: floor1.position.y)
        floor2.position = CGPoint(x: floor2.position.x - 1, y: floor2.position.y)
        floor3.position = CGPoint(x: floor3.position.x - 1, y: floor3.position.y)
        floor4.position = CGPoint(x: floor4.position.x - 1, y: floor4.position.y)
        if floor1.position.x < -floor1.size.width  {
            floor1.position = CGPoint(x: floor4.position.x + floor4.size.width, y: floor1.position.y)
        }
        if floor2.position.x < -floor2.size.width {
            floor2.position = CGPoint(x: floor1.position.x + floor1.size.width, y: floor2.position.y)
        }
        if floor3.position.x < -floor3.size.width {
            floor3.position = CGPoint(x: floor2.position.x + floor2.size.width, y: floor3.position.y)
        }
        if floor4.position.x < -floor4.size.width {
            floor4.position = CGPoint(x: floor3.position.x + floor3.size.width, y: floor4.position.y)
        }
        for pipenode in self.children where pipenode.name == "pipe" {
            if let pipeSprite = pipenode as? SKSpriteNode {
                 pipeSprite.position = CGPoint(x: pipeSprite.position.x - 1, y: pipeSprite.position.y)
                if pipeSprite.position.x < -pipeSprite.size.width * 0.5 {
                    pipeSprite.removeFromParent()
                }
            }
        }
        for pipenodehead in self.children where pipenodehead.name == "pipehead" {
            if let pipeSprite = pipenodehead as? SKSpriteNode {
                pipeSprite.position = CGPoint(x: pipeSprite.position.x - 1, y: pipeSprite.position.y)
                if pipeSprite.position.x < -pipeSprite.size.width * 0.5 {
                    pipeSprite.removeFromParent()
                }
            }
        }

        
    }
    
    func birdStartFly() {
        let flyAction = SKAction.animate(with: [SKTexture(imageNamed: "bird0_0"),SKTexture(imageNamed: "bird0_1"),SKTexture(imageNamed: "bird0_2"),SKTexture(imageNamed: "bird0_1")],timePerFrame: 0.15)
        bird.run(SKAction.repeatForever(flyAction), withKey: "fly")
    }
    
    func birdStopFly() {
        bird.removeAction(forKey: "fly")
    }
    
    func startCreateRandomPipesAction() {
        let waitAct = SKAction.wait(forDuration: 3.5, withRange: 1.0)
        let generatePipeAct = SKAction.run {
            self.createRandomPipes()
        }
        run(SKAction.repeatForever(SKAction.sequence([waitAct, generatePipeAct])), withKey: "createPipe")
    }
    
    func stopCreateRandomPipesAction(){
        self.removeAction(forKey: "createPipe")
    }
    
    func createRandomPipes(){
        let height = self.size.height - self.floor1.size.height
        let pipeGap = CGFloat(arc4random_uniform(UInt32(bird.size.height))) + bird.size.height * 2.5
        let pipeWidth = CGFloat(60.0)
        let topPipeHeight = CGFloat(arc4random_uniform(UInt32(height - pipeGap - self.floor1.size.height)))
        let bottomPipeHeight = height - pipeGap - topPipeHeight
        
        addPipes(topSize: CGSize(width: pipeWidth, height: topPipeHeight), bottomSize: CGSize(width: pipeWidth, height: bottomPipeHeight), HeadSize: CGSize(width:60,height:20))
    }
    
    func removeAllPipesNode(){
        for pipe in self.children where pipe.name == "pipe" {
            pipe.removeFromParent()
        }
        for pipehead in self.children where pipehead.name == "pipehead" {
            pipehead.removeFromParent()
        }
        
    }
    
    func addPipes(topSize: CGSize, bottomSize: CGSize, HeadSize:CGSize) {
        let topTexture = SKTexture(imageNamed: "pip_down")
        let topPipe = SKSpriteNode(texture: topTexture, size: topSize)
        topPipe.name = "pipe"
        topPipe.zPosition = 2
        topPipe.position = CGPoint(x: self.size.width + topPipe.size.width * 0.5, y: self.size.height - topPipe.size.height*0.5) //设置上水管的垂直位置为顶部贴着屏幕顶部，水平位置在屏幕右侧之外
        
        topPipe.physicsBody = SKPhysicsBody(texture: topTexture, size: topPipe.size)
        topPipe.physicsBody?.isDynamic = false
        topPipe.physicsBody?.categoryBitMask = pipeCategory
        
        addChild(topPipe)

        
        if topPipe.size.height < 250 {
            let topPipeHeadTexture = SKTexture(imageNamed: "pip_down_head")
            let topPipeHead = SKSpriteNode(texture: topPipeHeadTexture, size: HeadSize)
            topPipeHead.name = "pipehead"
            topPipeHead.position = CGPoint(x: self.size.width + topPipe.size.width * 0.5, y: self.size.height - topPipe.size.height + topPipeHead.size.height*0.5)

            topPipeHead.physicsBody = SKPhysicsBody(texture: topPipeHeadTexture, size: HeadSize)
            topPipeHead.physicsBody?.isDynamic = false
            topPipeHead.physicsBody?.categoryBitMask = pipeCategory
            topPipeHead.zPosition = 3
            
            addChild(topPipeHead)
        }
        
        
        let bottomTexture = SKTexture(imageNamed: "pip_up")
        let bottomPipe = SKSpriteNode(texture: bottomTexture, size: bottomSize)
        bottomPipe.name = "pipe"
        bottomPipe.position = CGPoint(x: self.size.width + bottomPipe.size.width * 0.5, y: self.floor1.size.height + bottomPipe.size.height * 0.5) //设置下水管的垂直位置为底部贴着地面的顶部，水平位置在屏幕右侧之外
        bottomPipe.zPosition = 2
        
        bottomPipe.physicsBody = SKPhysicsBody(texture: bottomTexture, size: bottomPipe.size)
        bottomPipe.physicsBody?.isDynamic = false
        bottomPipe.physicsBody?.categoryBitMask = pipeCategory
        
        addChild(bottomPipe)
        
        if bottomPipe.size.height < 250 {
            let bottomPipeHeadTexture = SKTexture(imageNamed: "pip_up_head")
            let bottomPipeHead = SKSpriteNode(texture: bottomPipeHeadTexture, size: HeadSize)
            bottomPipeHead.name = "pipehead"
            bottomPipeHead.position = CGPoint(x: self.size.width + bottomPipe.size.width * 0.5, y: self.floor1.size.height + bottomPipe.size.height - bottomPipeHead.size.height*0.5)
            bottomPipeHead.zPosition = 3
            
            bottomPipeHead.physicsBody = SKPhysicsBody(texture: bottomPipeHeadTexture, size: HeadSize)
            bottomPipeHead.physicsBody?.isDynamic = false
            bottomPipeHead.physicsBody?.categoryBitMask = pipeCategory
            
            addChild(bottomPipeHead)
            
        }

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if gameStatus != .running {
            return
        }
        var bodyA : SKPhysicsBody
        var bodyB : SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            bodyA = contact.bodyA
            bodyB = contact.bodyB
        }
        else {
            bodyA = contact.bodyB
            bodyB = contact.bodyA
        }
        if bodyA.categoryBitMask == birdCategory && (bodyB.categoryBitMask == pipeCategory || bodyB.categoryBitMask == floorCategory) {
            gameOver()
        }
        
    }
    
    func wait(){
        gameStatus = .start
        bird.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        bird.physicsBody?.isDynamic = false
        birdStartFly()
        
        //flappybird
        let flappybird_Texture = SKTexture(imageNamed: "flappybird")
        flappybirdlabel = SKSpriteNode(texture: flappybird_Texture, size: CGSize(width:270,height:80))
        flappybirdlabel.position = CGPoint(x: self.size.width * 0.5 , y: self.size.height * 0.7)
        flappybirdlabel.zPosition = 4
        addChild(flappybirdlabel)
        
    }
    
    func shuffle()  {
        meters = 0
        times = 0
        gameStatus = .idle
        if flappybirdlabel != nil {
            flappybirdlabel.removeFromParent()
        }
        if gameoverlabel != nil {
            gameoverlabel.removeFromParent()
            scorelabel.removeFromParent()
            numberlabel.removeFromParent()
        }
        
        removeAllPipesNode()
        
        bird.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        bird.physicsBody?.isDynamic = false
        birdStartFly()
        
        let taplabel_Texture = SKTexture(imageNamed: "tutorial")
        taplabel = SKSpriteNode(texture: taplabel_Texture, size: CGSize(width:100,height:100))
        taplabel.position = CGPoint(x: self.size.width * 0.5 , y: self.size.height * 0.65)
        taplabel.zPosition = 4
        addChild(taplabel)
    }
    
    func startGame()  {
        taplabel.removeFromParent()
        
        let number_Texture = SKTexture(imageNamed: "0")
        numberlabel = SKSpriteNode(texture: number_Texture, size: CGSize(width:50,height:50))
        numberlabel.name = "gameover"
        numberlabel.position = CGPoint(x: self.size.width * 0.5 , y: self.size.height * 0.9)
        numberlabel.zPosition = 4
        addChild(numberlabel)
        
        gameStatus = .running
        startCreateRandomPipesAction()
        bird.physicsBody?.isDynamic = true
        
    }
    
    func gameOver()  {
        gameStatus = .over
        birdStopFly()
        stopCreateRandomPipesAction()
        numberlabel.removeFromParent()
        
        let game_over_Texture = SKTexture(imageNamed: "gameover")
        gameoverlabel = SKSpriteNode(texture: game_over_Texture, size: CGSize(width:240,height:70))
        gameoverlabel.name = "gameover"
        gameoverlabel.position = CGPoint(x: self.size.width * 0.5 , y: self.size.height * 0.77)
        gameoverlabel.zPosition = 4
        addChild(gameoverlabel)
        
        let score_Texture = SKTexture(imageNamed: "medal_table")
        scorelabel = SKSpriteNode(texture: score_Texture, size: CGSize(width:270,height:170))
        scorelabel.name = "gameover"
        scorelabel.position = CGPoint(x: self.size.width * 0.5 , y: self.size.height * 0.55)
        scorelabel.zPosition = 4
        addChild(scorelabel)
        
        DisplayScoreNumber(number: meters)
        
    }
    
    func DisplayScoreNumber(number : UInt32) {
        switch meters {
        case 0:
            let number_Texture = SKTexture(imageNamed: "0_1")
            numberlabel = SKSpriteNode(texture: number_Texture, size: CGSize(width:20,height:20))
            numberlabel.name = "gameover"
            numberlabel.position = CGPoint(x: self.size.width * 0.75 , y: self.size.height * 0.585)
            numberlabel.zPosition = 5
            addChild(numberlabel)
        case 1:
            let number_Texture = SKTexture(imageNamed: "1_1")
            numberlabel = SKSpriteNode(texture: number_Texture, size: CGSize(width:20,height:20))
            numberlabel.name = "gameover"
            numberlabel.position = CGPoint(x: self.size.width * 0.75 , y: self.size.height * 0.585)
            numberlabel.zPosition = 4
            addChild(numberlabel)
        case 2:
            let number_Texture = SKTexture(imageNamed: "2_1")
            numberlabel = SKSpriteNode(texture: number_Texture, size: CGSize(width:20,height:20))
            numberlabel.name = "gameover"
            numberlabel.position = CGPoint(x: self.size.width * 0.75 , y: self.size.height * 0.585)
            numberlabel.zPosition = 4
            addChild(numberlabel)
        case 3:
            let number_Texture = SKTexture(imageNamed: "3_1")
            numberlabel = SKSpriteNode(texture: number_Texture, size: CGSize(width:20,height:20))
            numberlabel.name = "gameover"
            numberlabel.position = CGPoint(x: self.size.width * 0.75 , y: self.size.height * 0.585)
            numberlabel.zPosition = 4
            addChild(numberlabel)
        case 4:
            let number_Texture = SKTexture(imageNamed: "4_1")
            numberlabel = SKSpriteNode(texture: number_Texture, size: CGSize(width:20,height:20))
            numberlabel.name = "gameover"
            numberlabel.position = CGPoint(x: self.size.width * 0.75 , y: self.size.height * 0.585)
            numberlabel.zPosition = 4
            addChild(numberlabel)
        default:
            numberlabel.removeFromParent()
            
        }
    }

    
    func DisplayNumber(number : UInt32) {
        numberlabel.removeFromParent()
        switch meters {
        case 0:
            let number_Texture = SKTexture(imageNamed: "0")
            numberlabel = SKSpriteNode(texture: number_Texture, size: CGSize(width:50,height:50))
            numberlabel.name = "gameover"
            numberlabel.position = CGPoint(x: self.size.width * 0.5 , y: self.size.height * 0.9)
            numberlabel.zPosition = 4
            addChild(numberlabel)
        case 1:
            let number_Texture = SKTexture(imageNamed: "1")
            numberlabel = SKSpriteNode(texture: number_Texture, size: CGSize(width:50,height:50))
            numberlabel.name = "gameover"
            numberlabel.position = CGPoint(x: self.size.width * 0.5 , y: self.size.height * 0.9)
            numberlabel.zPosition = 4
            addChild(numberlabel)
        case 2:
            let number_Texture = SKTexture(imageNamed: "2")
            numberlabel = SKSpriteNode(texture: number_Texture, size: CGSize(width:50,height:50))
            numberlabel.name = "gameover"
            numberlabel.position = CGPoint(x: self.size.width * 0.5 , y: self.size.height * 0.9)
            numberlabel.zPosition = 4
            addChild(numberlabel)
        case 3:
            let number_Texture = SKTexture(imageNamed: "3")
            numberlabel = SKSpriteNode(texture: number_Texture, size: CGSize(width:50,height:50))
            numberlabel.name = "gameover"
            numberlabel.position = CGPoint(x: self.size.width * 0.5 , y: self.size.height * 0.9)
            numberlabel.zPosition = 4
            addChild(numberlabel)
        case 4:
            let number_Texture = SKTexture(imageNamed: "4")
            numberlabel = SKSpriteNode(texture: number_Texture, size: CGSize(width:50,height:50))
            numberlabel.name = "gameover"
            numberlabel.position = CGPoint(x: self.size.width * 0.5 , y: self.size.height * 0.9)
            numberlabel.zPosition = 4
            addChild(numberlabel)
        default:
            numberlabel.removeFromParent()
            
        }
    }
    
}
