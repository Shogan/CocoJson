//
//  HelloWorldLayer.m
//  CocoJson
//
//  Created by Xtravirt Administrator on 17/05/2013.
//  Copyright Sean Duffy 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "LevelSelect.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer


// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"JSON iOS App loader" fontName:@"Helvetica" fontSize:24];
        CCLabelTTF *labelInstructions = [CCLabelTTF labelWithString:@"Tap the icon to load apps..." fontName:@"Helvetica" fontSize:14];

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
        labelInstructions.position =  ccp( size.width /2 , size.height/2 - 20 );
		
		// add the label as a child to this Layer
		[self addChild: label];
        [self addChild: labelInstructions];

		// Default font size will be 24 points.
		[CCMenuItemFont setFontSize:24];

        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCMenuItem *menuItem = [CCMenuItemImage itemWithNormalImage:@"Icon.png" selectedImage:@"Icon.png" target:self selector:@selector(openLevelSelect)];
        
        menuItem.position = ccp(winSize.width/2-50, winSize.height/2-80);
        
        CCMenu *menu = [CCMenu menuWithItems:menuItem, nil];
        menu.position = ccp(winSize.width/2, winSize.height/2);
				
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 80)];
		
		// Add the menu to the layer
		[self addChild:menu];

	}
	return self;
}

-(void)openLevelSelect
{
    LevelSelect * ls = [LevelSelect node];
	[[CCDirector sharedDirector] replaceScene:ls];
}



// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
