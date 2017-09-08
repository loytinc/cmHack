//
//  GameScene.swift
//  cmHack
//
//  Created by Brice Prather on 9/7/17.
//  Copyright © 2017 Life On Your Terms, Inc. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var Player = SKSpriteNode(imageNamed: "Spaceship.png")
    
    var possibleAsteroids = ["asteroid-small.png", "asteroid-icon.png"]
    
    var possibleCargo = ["cargo.png", "cargo2.png"]
    
    let asteroidCategory:UInt32 = 0x1 << 1
    
    let bulletCategory:UInt32 = 0x1 << 0

    let cargoCategory:UInt32 = 0x1 << 1
    
    override func didMove(to view: SKView) {
        
        Player.position = CGPoint(x: self.size.width / 2,y: self.size.height / 5) // (x: CGFloat, y: CGFloat)
        
        var Btr = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(spawnBullets), userInfo: nil, repeats: true)
        var Atr = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(addAsteroid), userInfo: nil, repeats: true)
        var Ctr = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(addCargo), userInfo: nil, repeats: true)

        self.addChild(Player)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
    }
    
    func spawnBullets() {
        let Bullet = SKSpriteNode(imageNamed: "silverBullet.png")
        Bullet.zPosition = -5
        Bullet.position = CGPoint(x: Player.position.x, y: Player.position.y)
        let action = SKAction.moveTo(y: self.size.height + 100, duration: 1.0)
        Bullet.run(SKAction.repeatForever(action))
        self.addChild(Bullet)
    }
    
    func addAsteroid () {
        
        possibleAsteroids = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAsteroids) as! [String]
        let asteroid = SKSpriteNode(imageNamed: possibleAsteroids[0])
        let randomAsteroidPosition = GKRandomDistribution(lowestValue: -100, highestValue: 500)
        let position = CGFloat(randomAsteroidPosition.nextInt())
        asteroid.position = CGPoint(x: position, y: self.frame.size.height + asteroid.size.height)
        asteroid.physicsBody = SKPhysicsBody(rectangleOf: asteroid.size)
        asteroid.physicsBody?.isDynamic = true
        asteroid.physicsBody?.categoryBitMask = asteroidCategory
        asteroid.physicsBody?.contactTestBitMask = bulletCategory
        asteroid.physicsBody?.collisionBitMask = 0
        self.addChild(asteroid)
        let animationDuration:TimeInterval = 5
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -asteroid.size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        asteroid.run(SKAction.sequence(actionArray))
        
    }
    
    func addCargo () {
        
        possibleCargo = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleCargo) as! [String]
        let Cargo = SKSpriteNode(imageNamed: possibleCargo[0])
        Cargo.zPosition = 0
        let randomCargoPosition = GKRandomDistribution(lowestValue: -100, highestValue: 500)
        let position = CGFloat(randomCargoPosition.nextInt())
        Cargo.position = CGPoint(x: position, y: self.frame.size.height + Cargo.size.height)
        Cargo.physicsBody = SKPhysicsBody(rectangleOf: Cargo.size)
        Cargo.physicsBody?.isDynamic = true
        Cargo.physicsBody?.categoryBitMask = asteroidCategory
        Cargo.physicsBody?.contactTestBitMask = bulletCategory
        Cargo.physicsBody?.collisionBitMask = 1
        self.addChild(Cargo)
        let animationDuration:TimeInterval = 15
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -Cargo.size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        Cargo.run(SKAction.sequence(actionArray))
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
