//
//  Ball.swift
//  ColorMatch
//
//  Created by damingdan on 14-6-10.
//  Copyright (c) 2014年 damingdan. All rights reserved.
//

import SpriteKit

func random0_1()->CGFloat {
    return CGFloat(random()) / CGFloat(0x7fffffff)
}

func distanceOfTwoPoint(location1:CGPoint, location2:CGPoint)->CGFloat {
    var deltaX = location1.x - location2.x
    var deltaY = location1.y - location2.y
    return sqrt(deltaX*deltaX + deltaY*deltaY)
}

class Ball : SKSpriteNode {
    
    init() {
        // set the ball's color
        let colors = ["red", "orange", "yellow", "green", "blue", "violet"]
        var color = colors[Int(arc4random()) % 6]
        super.init(imageNamed: "Ball_" + color + "-hd")
        
        // make the ball's size random
        self.setScale(0.5 + 0.15*random0_1())
        
        // set the ball's physical property
        var padding:(CGFloat) = 5.0
        var radius:(CGFloat) = 0.5*(self.frame.width - padding)
        var body:(SKPhysicsBody) = SKPhysicsBody(circleOfRadius: radius)
        body.dynamic = true
        body.density = 1.0
        body.friction = 0.5
        self.physicsBody = body
        self.userInteractionEnabled = true
    }
    
    init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    

    init(texture: SKTexture!) {
        super.init(texture: texture)
    }
    
    // Do not work
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        //var gameScene = self.scene
        if let gameScene = self.scene as? GameScene {
            gameScene.removeBall(self)
        }
    }
    
    func isTouchInBall(location: CGPoint)->Bool {
        var radius = self.frame.width/2
        var distance = distanceOfTwoPoint(location, self.position)
        if distance < radius {
            return true
        }else {
            return false
        }
    }
    
}
