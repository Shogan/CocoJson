#import "cocos2d.h"
#import "HelloWorldLayer.h"

@interface LevelSelect : CCScene
{
	LevelSelect *_layer;
}

@end

@interface LevelSelectLayer : CCLayer
{
    NSMutableData *_responseData;
    UIActivityIndicatorView *_spinner;
}

@property (nonatomic, retain) NSMutableData *responseData;

-(void)back: (id)sender;
-(void)openApp:(id)sender;

@end