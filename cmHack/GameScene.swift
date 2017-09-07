//
//  GameScene.swift
//  cmHack
//
//  Created by Brice Prather on 9/7/17.
//  Copyright © 2017 Life On Your Terms, Inc. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var Player = SKSpriteNode(imageNamed: "Spaceship.png")
    
    override func didMove(to view: SKView) {
        
        Player.position = CGPoint(x: self.size.width / 2,y: self.size.height / 5) // (x: CGFloat, y: CGFloat)
        
        var Tr = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: Selector("spawnBullets"), userInfo: nil, repeats: true)

        
        self.addChild(Player)
        
        
        
    }
    
    
    
    
    func spawnBullets() {
        var Bullet = SKSpriteNode(imageNamed: "silverBullet-1")
        Bullet.zPosition = -5
        Bullet.position = CGPoint(x: Player.position.x, y: Player.position.y)
        let action = SKAction.moveTo(y: self.size.height, duration: 0.6)
        Bullet.run(SKAction.repeatForever(action))
        self.addChild(Bullet)
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
