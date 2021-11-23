//
//  GameScene.swift
//  FlappyBird
//
//  Created by Mac on 2021/11/23.
//

import SpriteKit

class GameScene: SKScene {

    var scrollNode: SKNode!
    var wallNode: SKNode!
    var bird: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: -4)
        
        backgroundColor = UIColor(red: 0.15, green: 0.75, blue: 0.90, alpha: 1)
        
        scrollNode = SKNode()
        addChild(scrollNode)
        
        wallNode = SKNode()
        scrollNode.addChild(wallNode)
        
        setUpGround()
        setUpCloud()
        setUpWall()
        setUpBird()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        bird.physicsBody?.velocity = CGVector.zero
        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 15))
    }
    
    func setUpGround() {
        let groundTexture = SKTexture(imageNamed: "ground")
        groundTexture.filteringMode = .nearest
        
        let needNumber = Int(self.frame.size.width / groundTexture.size().width) + 2
        
        let moveGround = SKAction.moveBy(x: -groundTexture.size().width, y: 0, duration: 5)
        
        let resetGround = SKAction.moveBy(x: groundTexture.size().width, y: 0, duration: 0)
        
        let repeatScrollGround = SKAction.repeatForever(SKAction.sequence([moveGround, resetGround]))
        
        for i in 0..<needNumber {
            let sprite = SKSpriteNode(texture: groundTexture)
            
            sprite.position = CGPoint(
                x: groundTexture.size().width / 2 + groundTexture.size().width * CGFloat(i),    y: groundTexture.size().height / 2
            )
            
            sprite.run(repeatScrollGround)
            sprite.physicsBody = SKPhysicsBody(rectangleOf: groundTexture.size())
            sprite.physicsBody?.isDynamic = false
            scrollNode.addChild(sprite)
        }
        
        let groundSprite = SKSpriteNode(texture: groundTexture)
        
        groundSprite.position = CGPoint(
            x: groundTexture.size().width / 2,
            y: groundTexture.size().height / 2
        )
        
        addChild(groundSprite)
    }
    
    func setUpCloud() {
        let cloudTexture = SKTexture(imageNamed: "cloud")
        cloudTexture.filteringMode = .nearest
        
        let needCloudNumber = Int(self.frame.size.width / cloudTexture.size().width) + 2
        
        let moveCloud = SKAction.moveBy(x: -cloudTexture.size().width, y: 0, duration: 20)
        
        let resetCloud = SKAction.moveBy(x: cloudTexture.size().width, y: 0, duration: 0)
        
        let repeatScrollCloud = SKAction.repeatForever(SKAction.sequence([moveCloud, resetCloud]))
        
        for i in 0..<needCloudNumber {
            let sprite = SKSpriteNode(texture: cloudTexture)
            sprite.zPosition = -100
            
            sprite.position = CGPoint(
                x: cloudTexture.size().width / 2 + cloudTexture.size().width * CGFloat(i),
                y: self.size.height - cloudTexture.size().height / 2
            )
            
            sprite.run(repeatScrollCloud)
            
            scrollNode.addChild(sprite)
        }
    }
    
    func setUpWall() {
        let wallTexture = SKTexture(imageNamed: "wall")
        wallTexture.filteringMode = .linear
        
        let movingDistance = self.frame.size.width + wallTexture.size().width
        let moveWall = SKAction.moveBy(x: -movingDistance, y: 0, duration: 4)
        let removeWall = SKAction.removeFromParent()
        let wallAnimation = SKAction.sequence([moveWall, removeWall])
        let birdSize = SKTexture(imageNamed: "bird_a").size()
        let slit_length = birdSize.height * 4
        let random_y_range: CGFloat = 60
        let groundSize = SKTexture(imageNamed: "ground").size()
        let sky_center_y = groundSize.height + (self.frame.size.height - groundSize.height) / 2
        let under_wall_center_y = sky_center_y - slit_length / 2 - wallTexture.size().height / 2
        let createWallAnimation = SKAction.run({
            let wall = SKNode()
            wall.position = CGPoint(x: self.frame.size.width + wallTexture.size().width / 2, y: 0)
            wall.zPosition = -50
            let random_y = CGFloat.random(in: -random_y_range...random_y_range)
            let under_wall_y = under_wall_center_y + random_y
            let under = SKSpriteNode(texture: wallTexture)
            under.position = CGPoint(x: 0, y: under_wall_y)
            under.physicsBody = SKPhysicsBody(rectangleOf: wallTexture.size())
            under.physicsBody?.isDynamic = false
            wall.addChild(under)
            let upper = SKSpriteNode(texture: wallTexture)
            upper.position = CGPoint(x: 0, y: under_wall_y + wallTexture.size().height + slit_length)
            upper.physicsBody = SKPhysicsBody(rectangleOf: wallTexture.size())
            upper.physicsBody?.isDynamic = false
            wall.addChild(upper)
            wall.run(wallAnimation)
            self.wallNode.addChild(wall)
        })
        let waitAnimation = SKAction.wait(forDuration: 2)
        let repeatForeverAnimation = SKAction.repeatForever(SKAction.sequence([createWallAnimation, waitAnimation]))
        wallNode.run(repeatForeverAnimation)
    }
    
    func setUpBird() {
        let birdTextureA = SKTexture(imageNamed: "bird_a")
        birdTextureA.filteringMode = .linear
        let birdTextureB = SKTexture(imageNamed: "bird_b")
        birdTextureB.filteringMode = .linear
        
        let textureAnimation = SKAction.animate(with: [birdTextureA, birdTextureB], timePerFrame: 0.2)
        let flap = SKAction.repeatForever(textureAnimation)
        
        bird = SKSpriteNode(texture: birdTextureA)
        bird.position = CGPoint(x: self.frame.size.width * 0.2, y: self.frame.size.height * 0.7)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2)
        
        bird.run(flap)
        
        addChild(bird)
    }
}
