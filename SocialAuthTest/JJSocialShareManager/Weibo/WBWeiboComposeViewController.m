//
//  WBWeiboComposeViewController.m
//  SocialAuthTest
//
//  Created by Jin Jin on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WBWeiboComposeViewController.h"
#import "Draft.h"
#import "WeiboClient.h"
#import "OAuthEngine.h"
#import "OAuthController.h"

#define kWeiboOAuthConsumerKey      @"899283629" //replace
#define kWeiboOAuthConsumerSecret   @"fd35ec9563f631cd5ecfb2a1dda8cc9c" //replace
#define kWeiboOAuthStoreKey @"kWeiboOAuthStoreKey"

@interface WBWeiboComposeViewController ()

@end

@implementation WBWeiboComposeViewController

@synthesize composeDialog = _composeDialog, backgroundView = _backgroundView;
@synthesize toolBar = _toolbar;
@synthesize sepertorLine = _sepertorLine, titleLabel = _titleLabel;

-(void)dealloc{
    self.composeDialog = nil;
    self.backgroundView = nil;
    self.toolBar = nil;
    self.sepertorLine = nil;
    self.titleLabel = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleLabel.text = NSLocalizedString(@"Weibo", nil);
    CGRect frame = self.sepertorLine.frame;
    frame.origin.x = 5;
    frame.origin.y = 40;
    frame.size.height = 0.5f;
    frame.size.width = 295;
    self.sepertorLine.frame = frame;
    self.sepertorLine.backgroundColor = [UIColor lightGrayColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    if ([OAuthController credentialEntryRequiredWithEngine:[self weiboOAuthEngine]]){
//        OAuthController* controller = [OAuthController controllerToEnterCredentialsWithEngine:[self weiboOAuthEngine] delegate:self];
//        
//        [self presentViewController:controller animated:YES completion:NULL];
//    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)setInitialText:(NSString*)text{
    
}

-(void)addImage:(UIImage*)image{
    
}

-(void)show{
    UIViewController* controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    controller.modalPresentationStyle = UIModalPresentationCurrentContext;  
    [controller presentViewController:self animated:YES completion:NULL];
}
#pragma mark - weibo API
#pragma mark - weibo api
-(OAuthEngine*)weiboOAuthEngine{
    static dispatch_once_t pred;
    __strong static OAuthEngine* _engine = nil;
    
    dispatch_once(&pred, ^{
        _engine = [[OAuthEngine alloc] initOAuthWithDelegate:self];
        _engine.consumerKey = kWeiboOAuthConsumerKey;
		_engine.consumerSecret = kWeiboOAuthConsumerSecret;
    });
    
    return _engine;
}

-(void)postWeiboMessage:(NSString*)message urlString:(NSString*)urlString image:(UIImage*)image{
    WeiboClient *client = [[WeiboClient alloc] initWithTarget:self 
													   engine:[self weiboOAuthEngine]
													   action:@selector(postStatusDidSucceed:obj:)];
    NSString* composedText = [NSString stringWithFormat:@"%@ %@", message, urlString];
    if (image){
        NSData* jpegImage = UIImageJPEGRepresentation(image, 0.7);
        [client upload:jpegImage status:composedText];
    }else{
        [client post:composedText];
    }
}

- (void)postStatusDidSucceed:(WeiboClient*)sender obj:(NSObject*)obj{
    //weibo call back
}


#pragma mark OAuthEngineDelegate
- (void) storeCachedOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: data forKey: kWeiboOAuthStoreKey];
	[defaults synchronize];
}

- (NSString *) cachedOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey:kWeiboOAuthStoreKey];
}

- (void)removeCachedOAuthDataForUsername:(NSString *) username{
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults removeObjectForKey:kWeiboOAuthStoreKey];
	[defaults synchronize];
}
//=============================================================================================================================
#pragma mark OAuthSinaWeiboControllerDelegate
- (void) OAuthController: (OAuthController *) controller authenticatedWithUsername: (NSString *) username {
	NSLog(@"Authenicated for %@", username);
}

- (void) OAuthControllerFailed: (OAuthController *) controller {
	NSLog(@"Authentication Failed!");
	
}

- (void) OAuthControllerCanceled: (OAuthController *) controller {
	NSLog(@"Authentication Canceled.");
	
}


@end
