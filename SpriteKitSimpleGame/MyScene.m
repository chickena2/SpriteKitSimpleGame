//
//  MyScene.m
//  SpriteKitSimpleGame
//
//  Created by K on 2/23/14.
//  Copyright (c) 2014 K. All rights reserved.
//

#import "MyScene.h"

//static const float screenWidth = 568;
//static const float screenHeight = 320;
static const float groundHeight = 10;
static const float gravity  = -4.8;

static const float rim_x = 650;
static const float rim_y = 500;
static const float rimWidth = 50;

static const float vel_x = 300;
static const float vel_y = 1000;

static const uint32_t groundCategory = 0x1 << 0;
static const uint32_t ballCategory   = 0x1 << 1;

static const float needle_x = 400;
static const float needle_y = 300;
static const float needle_l = 100;
static const float needle_w = 3;
//static const float needle_top_circle_radius = 15;




@implementation MyScene {
    SKSpriteNode *ball;
    SKSpriteNode *frontRim;
    SKSpriteNode *backRim;
    SKSpriteNode *ground;
    SKSpriteNode *needle;
    SKLabelNode *powerDisplay;
    SKSpriteNode *angleControl;
    BOOL userHold;

}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        // 2
       // NSLog(@"Size: %@", NSStringFromCGSize(size));
        
        // 3
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        self.physicsWorld.gravity = CGVectorMake(0,gravity);
        self.physicsWorld.contactDelegate = self;
        // 4
        [self addBall];
        [self addFrontRim];
        [self addBackRim];
        [self addGround];
        [self addText];
        //[self addCircle];
        [self addNeedle];
        userHold = NO;
    }
    return self;
}

/*
-(void)didMoveToView:(SKView *)view {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleLongPress:)];
    [view addGestureRecognizer:longPress];

}
*/
-(void)handleLongPress:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //NSLog(@"hold");
        powerDisplay.text = @"500";
        userHold = YES;
    }
    else {
        userHold = NO;
        ball.physicsBody.affectedByGravity = true;
        ball.physicsBody.velocity = CGVectorMake(vel_x,[powerDisplay.text intValue]);
    }
    
}

-(SKSpriteNode *)drawLineStart:(CGPoint)A withEnd:(CGPoint)B {
    SKShapeNode *line = [SKShapeNode node];
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, A.x, A.y);
    CGPathAddLineToPoint(pathToDraw, NULL, B.x, B.y);
    line.path = pathToDraw;
    [line setStrokeColor:[UIColor redColor]];
    [self addChild:line];
    return (SKSpriteNode *)line;
}

-(SKShapeNode *)drawCircle:(CGFloat)r {
    SKShapeNode *circle = [[SKShapeNode alloc] init];
    CGMutablePathRef myPath = CGPathCreateMutable();
    CGPathAddArc(myPath, NULL, needle_x + needle_l, needle_y, r, 0, M_PI*2, YES);
    circle.path = myPath;
    circle.lineWidth = 1.0;
    //circle.fillColor = [SKColor whiteColor];
    circle.strokeColor = [SKColor blackColor];
    //circle.glowWidth = 0.5;
    return circle;
}

-(void)addCircle {
    angleControl = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    angleControl.position = CGPointMake(needle_x+needle_l, needle_y);
    angleControl.name = @"angle_control";
    
    
    [self addChild:angleControl];
}

-(void)addNeedle {
    needle = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(needle_l,needle_w)];
    needle.position = CGPointMake(needle_x, needle_y);
    needle.anchorPoint = CGPointMake(0, 0);
    angleControl = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    angleControl.position = CGPointMake(needle_l,0);
    angleControl.name = @"angle_control";
    [needle addChild:angleControl];
    [self addChild:needle];
}

-(void)addGround {
    ground = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(1000,32)];
    ground.name = @"ground";
    ground.position = CGPointMake(ground.size.width/2,groundHeight);
    ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.size];
    ground.physicsBody.categoryBitMask = groundCategory;
    ground.physicsBody.contactTestBitMask = ballCategory;
    ground.physicsBody.dynamic = NO;
    
    [self addChild:ground];
   
}

-(void)addBall {
    ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    ball.position = CGPointMake(120,100);
    ball.name = @"ball";
    //[ball setScale:2.0];
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.size.width/2];
    ball.physicsBody.categoryBitMask = ballCategory;
    ball.physicsBody.contactTestBitMask= groundCategory;

    ball.physicsBody.affectedByGravity = false;
    //ball.physicsBody.dynamic = YES;
    
    [self addChild:ball];
}

-(void)addFrontRim {
    frontRim = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    frontRim.position = CGPointMake(rim_x,rim_y);
    frontRim.name = @"frontRim";
    [frontRim setScale:0.1];
    frontRim.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:frontRim.size.width/2];
    frontRim.physicsBody.dynamic = NO;
   
    [self addChild:frontRim];
}

-(void)addBackRim {
    backRim = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    backRim.position = CGPointMake(rim_x+rimWidth,rim_y);
    backRim.name = @"backRim";
    [backRim setScale:0.1];
    backRim.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:backRim.size.width/2];
    backRim.physicsBody.dynamic = NO;
    
    [self addChild:backRim];
}

-(void)addText {
    powerDisplay = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    powerDisplay.text = @"0";
    powerDisplay.fontSize = 42;
    powerDisplay.fontColor = [SKColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
    powerDisplay.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [self addChild:powerDisplay];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *touchedNode = [self nodeAtPoint:location];
    if (touchedNode.name == angleControl.name) {
        NSLog(@"touch begin");
    }
    /* Called when a touch begins */
        //UITouch *touch = [touches anyObject];
        //CGPoint location = [touch locationInNode:self];
        //SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:location];
        //NSLog(@"%@", touchedNode.name);
        //NSLog(@"%@", NSStringFromCGPoint(location));
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
    SKNode *touchedNode = [self nodeAtPoint:location];
    
    if (touchedNode.name == ball.name) {    
        ball.physicsBody.affectedByGravity = true;
        ball.physicsBody.velocity = CGVectorMake(vel_x,vel_y);
    }
    else if ([touchedNode.name  isEqual: @"angle_control"]) {
        //needle.zRotation = needle.zRotation + M_PI/90;
        //NSLog(@"%@", touchedNode.name);
        //NSLog(@"frame: %fx%f", touchedNode.size.height, touchedNode.size.width);
    }
    else {
        NSLog(@"touch nothing");
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    //NSLog(@"%@", contact.bodyA.node.name);
    if (contact.bodyA.node.name == ground.name) {
        [ball removeFromParent];
        [self addBall];
        //NSLog(@"move ball");
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (userHold == YES) {
        powerDisplay.text = [NSString stringWithFormat:@"%d",[powerDisplay.text intValue]+30];
    }
    if (ball.position.x > 800 || ball.position.y > 1000) {
        [ball removeFromParent];
        [self addBall];
    }

}

@end
