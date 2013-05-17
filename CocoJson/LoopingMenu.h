/*
 *  LoopingMenu.h
 *  Banzai
 *
 *  Created by João Caxaria on 5/29/09.
 *  Copyright 2009 Imaginary Factory. All rights reserved.
 *
 */
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface LoopingMenu : CCMenu
{	
	float hPadding;
	float lowerBound;
	float yOffset;
	bool moving;
	bool touchDown;
	float accelerometerVelocity;
	//int state;
	//CCMenuItem *selectedItem;
	
    CGSize winSize;
	
	//tCCMenuState state_;
	//CCMenuItem	*selectedItem_;
	//GLubyte		opacity_;
	//ccColor3B	color_;
}

@property float yOffset;

@end
