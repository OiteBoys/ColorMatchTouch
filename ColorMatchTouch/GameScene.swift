//
//  GameScene.swift
//  ColorMatchTouch
//
//  Created by damingdan on 14-6-11.
//  Copyright (c) 2014年 damingdan. All rights reserved.
//

import SpriteKit

enum Order:CGFloat {
    case Background = 1, Balls, Particles, Foreground
}

func runOneShotEmitter(emitter: SKEmitterNode, duration:CGFloat ) {
    emitter.runAction(SKAction.sequence([SKAction.waitForDuration(duration),
        SKAction.waitForDuration(emitter.particleLifetime + emitter.particleLifetimeRange),
        SKAction.removeFromParent()]))
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var ballList:(Array<Ball>) = []
    var boundRect:(CGRect) = CGRect(x: 68*2, y: 34*2, width: 430*2, height: 500*2)
    var ticks:(Int) = 0
    
    override func didMoveToView(view: SKView) {
        // setup physics
        self.physicsWorld.gravity = CGVectorMake( 0.0, -10.0 )
        self.physicsWorld.contactDelegate = self
        
        // Set up background color
        var background:(SKSpriteNode) = SKSpriteNode(imageNamed: "Background-hd")
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.zPosition = Order.Background.toRaw()
        self.addChild(background)
        
        // Set up foreground
        var foreground:(SKSpriteNode) = SKSpriteNode(imageNamed: "Foreground-hd")
        foreground.anchorPoint = CGPoint(x:0, y:0)
        foreground.zPosition = Order.Foreground.toRaw()
        self.addChild(foreground)
        
        // Set the physics border
        var border:(SKSpriteNode) = SKSpriteNode()
        var borderBody = SKPhysicsBody(edgeLoopFromRect: boundRect)
        border.anchorPoint = CGPoint(x: boundRect.origin.x + boundRect.size.width/2, y:boundRect.origin.y + boundRect.size.height/2)
        border.physicsBody = borderBody
        self.addChild(border)

    }
    
    func removeBall(ball: Ball) {
        var explodeEffect = SKEmitterNode.unarchiveFromFile("spark", type: "sks")
        explodeEffect.zPosition = Order.Particles.toRaw()
        explodeEffect.position = ball.position
        self.addChild(explodeEffect)
        runOneShotEmitter(explodeEffect, 0)
        
        ball.removeFromParent()
        var i = 0
        for i=0; i<self.ballList.count; i++ {
            if(self.ballList[i] == ball) {
                self.ballList.removeAtIndex(i);
            }
        }
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            for ball in self.ballList {
                if ball.isTouchInBall(location) {
                    self.removeBall(ball)
                }
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact!) {
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if self.ticks%6 == 0 && self.ballList.count < 100 {
            var ball:(Ball) = Ball()
            
            // Give the ball a random starting position.
            var xmin = CGFloat(self.boundRect.minX)
            var xmax = CGFloat(self.boundRect.maxX)
            var rand = CGFloat(random0_1()*0.8)
            ball.position = CGPoint(x:(xmin + xmax)/2.0 - (xmin - xmax)/2.0*rand, y:800.0);
            ball.physicsBody.velocity = CGVectorMake(100.0*random0_1(), 0)
            ball.physicsBody.angularVelocity = 5.0 * random0_1()
            ball.zPosition = Order.Balls.toRaw()
            
            self.ballList.append(ball)
            self.addChild(ball)
        }
        self.ticks += 1
    }
}
