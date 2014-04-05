//
//  MyScene.m
//  SpriteKitSimpleGame
//
//  Created by K on 2/23/14.
//  Copyright (c) 2014 K. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene {
    SKSpriteNode *ball;
    SKSpriteNode *frontRim;
    SKSpriteNode *backRim;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        // 2
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        
        // 3
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        self.physicsWorld.gravity = CGVectorMake(0,-2.4);
        self.physicsWorld.contactDelegate = self;
        // 4
        [self addBall];
        [self addFrontRim];
        [self addBackRim];
    }
    return self;
}

-(void)addBall {
    ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    ball.position = CGPointMake(120,100);
    ball.name = @"ball";
    [ball setScale:0.5];
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.size.width/2];
    ball.physicsBody.affectedByGravity = false;
    //ball.physicsBody.dynamic = YES;
    
    [self addChild:ball];
}

-(void)addFrontRim {
    frontRim = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    frontRim.position = CGPointMake(410,100);
    frontRim.name = @"frontRim";
    [frontRim setScale:0.05];
    frontRim.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:frontRim.size.width/2];
    frontRim.physicsBody.affectedByGravity = false;
    frontRim.physicsBody.dynamic = NO;
   
    [self addChild:frontRim];
}

-(void)addBackRim {
    backRim = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    backRim.position = CGPointMake(440,100);
    backRim.name = @"backRim";
    [backRim setScale:0.05];
    backRim.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:backRim.size.width/2];
    backRim.physicsBody.affectedByGravity = false;
    backRim.physicsBody.dynamic = NO;
    
    [self addChild:backRim];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self];
        //SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:location];
        //NSLog(@"%@", touchedNode.name);
        NSLog(@"%@", NSStringFromCGPoint(location));
    /*
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    } */
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    NSLog(@"%@", NSStringFromCGPoint(location));
    
    SKShapeNode *line = [SKShapeNode node];
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, ball.position.x, ball.position.y);
    CGPathAddLineToPoint(pathToDraw, NULL, location.x, location.y);
    line.path = pathToDraw;
    [line setStrokeColor:[UIColor redColor]];
    //[self addChild:line];
    ball.physicsBody.affectedByGravity = true;
    ball.physicsBody.velocity = CGVectorMake(210.0,300.0);
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
