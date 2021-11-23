//
//  GameScene.swift
//  FlappyBird
//
//  Created by Mac on 2021/11/23.
//

import SpriteKit

class GameScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 0.15, green: 0.75, blue: 0.90, alpha: 1)
        
        let groundTexture = SKTexture(imageNamed: "ground")
        groundTexture.filteringMode = .nearest
        
        let groundSprite = SKSpriteNode(texture: groundTexture)
        
        groundSprite.position = CGPoint(
            x: groundTexture.size().width / 2,
            y: groundTexture.size().height / 2
        )
        
        addChild(groundSprite)
    }
}
