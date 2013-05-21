#import "LevelSelect.h"
#import "LoopingMenu.h"
#import "InputController.h"

#import "HelloWorldLayer.h"
#import "SBJson.h"


@implementation LevelSelect

- (id) init {
    
	self = [super init];
	if (self != nil) {
		
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        // Setup a background for the scene - dependent on device type
		if (winSize.width == 568) {
            CCLOG(@"Doing iPhone 5 placement");
            CCSprite * bg = [CCSprite spriteWithFile:@"credits-bg-ip5.png"];
            [bg setPosition:ccp(winSize.width/2, winSize.height/2)];
            [self addChild:bg z:0];
        }
        else
        {
            CCLOG(@"Is not iPhone 5");
            if( CC_CONTENT_SCALE_FACTOR() == 2 || (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
            {
                CCLOG(@"Doing iPhone 4 / iPad placement");
                CCSprite * bg = [CCSprite spriteWithFile:@"credits-bg-ip4.png"];
                [bg setPosition:ccp(winSize.width/2, winSize.height/2)];
                [self addChild:bg z:0];
                
            }
            else
            {
                CCLOG(@"Doing iPhone 3G and older placement");
                CCSprite * bg = [CCSprite spriteWithFile:@"credits-bg.png"];
                [bg setPosition:ccp(winSize.width/2, winSize.height/2)];
                [self addChild:bg z:0];
            }
            
        }
        
        [self addChild:[LevelSelectLayer node] z:1];
		
    }
    return self;
	
}

@end

@implementation LevelSelectLayer

// Define the JSON feed that we will be getting our objects from.
// We are aiming to create the following structure
//
// Array
//   [0] - Object0
//   [1] - Object1
//   [2] - Object2
// etc...
//
// The index.php linked to below on my own personal site generates a list of my own apps in an array called "iosapps"
// In this array, each app is represented by an object with 6 properties (id, name, description, appurl, screenshot, promotion)
// These are read into the code below and used to generate the cocos2d objects to display an app browsing menu

#define appsjsonfeedURL @"http://www.shogan.co.uk/iosapps/index.php"

@synthesize responseData = _responseData;

- (id) init {
    
	self = [super init];
    if (self != nil) {
        
		self.touchEnabled = YES;
        
        // Retrieve the JSON
        [self loadData];
    }
    return self;
}

-(void)loadData
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    self.responseData = [NSMutableData data];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:appsjsonfeedURL]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_spinner.layer setValue:[NSNumber numberWithFloat:1.0f] forKeyPath:@"transform.scale"];
    _spinner.center = ccp(winSize.width/2, winSize.height/2);
    
    _spinner.hidesWhenStopped = YES;
    [_spinner startAnimating];
    [[CCDirector sharedDirector].view addSubview:_spinner];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [_responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [connection release];
    self.responseData = nil;
}

#pragma mark -
#pragma mark Process loan data
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [connection release];
    
    NSString *responseString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    self.responseData = nil;
    
    NSArray* iosapps = [(NSDictionary*)[responseString JSONValue] objectForKey:@"iosapps"];
    [responseString release];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    NSMutableArray *menuArray = [NSMutableArray new];
    //Iterate through our iOS apps array
    
    for (int i=0; i<=([iosapps count]-1); i++) {
        NSDictionary* iosapp = [iosapps objectAtIndex:i];
        
        //fetch the data
        NSString* name = [iosapp objectForKey:@"name"];
        NSString* description = [iosapp objectForKey:@"description"];
        NSString* appURL = [iosapp objectForKey:@"appurl"];
        NSString* screenshotURL = [iosapp objectForKey:@"screenshot"];
        
        CCLOG(@"%d",i);
        CCLOG(@"Name: %@ Desc: %@ AppURL: %@", name, description, appURL);
        CCLOG(@"\n");
        
        UIImage *imagefromURL = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:screenshotURL]]];
        
        NSString *key = [NSString stringWithFormat:@"key%d", i];
        CCSprite *webSprite = [CCSprite spriteWithCGImage:imagefromURL.CGImage key:key];
        
        CCMenuItemImage *currentApp = [CCMenuItemImage itemWithNormalSprite:webSprite selectedSprite:nil target:self selector:@selector(openApp:)]; //To do: Pass in a URL to the app on appstore so that method uses right URL
        // Every CCNode has a userData property - we can assign an NSObject to this
        currentApp.userData = appURL; // Assign the App URL retrieved to the userdata
        
        CCLabelTTF *nameLabel = [CCLabelTTF labelWithString:name fontName:@"Helvetica-Bold" fontSize:18];
        nameLabel.color = ccBLACK;
        nameLabel.position = ccp(currentApp.contentSize.width/2, currentApp.contentSize.height + 20);
        
        CCLabelTTF *descLabel = [CCLabelTTF labelWithString:description fontName:@"Helvetica-Bold" fontSize:12 dimensions:CGSizeMake(180,60) hAlignment:kCCTextAlignmentCenter lineBreakMode:kCCLineBreakModeWordWrap];
        descLabel.color = ccBLACK;
        descLabel.position = ccp(currentApp.contentSize.width/2, - 30);
        
        [currentApp addChild:nameLabel];
        [currentApp addChild:descLabel];
        
        [menuArray addObject:currentApp];
    }
    
    // Stop our progress spinner from animating and hide it
    [_spinner stopAnimating];
    
    // Populate our Looping Menu with our custom app menu item objects that were generated from our JSON feed
    LoopingMenu *menu = [LoopingMenu menuWithArray:menuArray];
    menu.position = ccp(winSize.width/2, winSize.height/2 + 20);
    [menu alignItemsHorizontallyWithPadding:40];
    // Add the menu to our layer
    [self addChild:menu];
    
    // Add a back button to get back
    CCMenuItem *back = [CCMenuItemImage itemWithNormalImage:@"back-up.png" selectedImage:@"back-down.png" target:self selector:@selector(back:)];
    
    back.scale = 0.5;
    back.position = ccp(winSize.width/2, 40);
    
    CCMenu *menuback = [CCMenu menuWithItems:back, nil];
    [menuback alignItemsVertically];
    menuback.position = ccp(winSize.width/2, 40);
    [self addChild:menuback];
    
    _responseData = nil;
    
}

-(void)back: (id)sender {
	CCLOG(@"back");
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
}

-(void)openApp:(CCMenuItemImage*)sender {
    NSString *theURL = (NSString*)sender.userData; // Cast the userData as a string from the sending CCMenuItemImage
	CCLOG(@"URL for this app is: %@", theURL);
    // Do something here like open the app in the app store...
    // Note that this will only do something on an actual device (not in the sim)
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:theURL]];
}

- (void) dealloc
{
    [_responseData release];
	[super dealloc];
}

@end