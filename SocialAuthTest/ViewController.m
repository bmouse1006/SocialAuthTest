//
//  ViewController.m
//  SocialAuthTest
//
//  Created by Jin Jin on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "JJSocialShareManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

-(IBAction)testSendToTwitter{
    [[JJSocialShareManager sharedManager] sendToTwitterWithText:@"test" urlString:@"test" image:nil];
}

-(IBAction)testSendToWeibo{
    [[JJSocialShareManager sharedManager] sendToWeiboWithMessage:@"aaaaaa" urlString:@"www.google.com" image:nil];
}

-(IBAction)testSendToReadItLater:(id)sender{
    [[JJSocialShareManager sharedManager] sendToReadItLaterWithTitle:@"title" message:@"read it later" urlString:@"url"];
}

-(IBAction)testSendToInstapaper:(id)sender{
    [[JJSocialShareManager sharedManager] sendToInstapaperWithTitle:@"title" message:@"message" urlString:@"www.google.com"];
}

-(IBAction)testSendToMail:(id)sender{
    [[JJSocialShareManager sharedManager] sendToMailWithTitle:@"title" message:@"message" urlString:@"www.google.com"];
}

-(IBAction)testSendToFacebook:(id)sender{
    [[JJSocialShareManager sharedManager] sendToFacebookWithTitle:@"test" message:@"test"];
}

-(IBAction)testSendToEvernote:(id)sender{
    [[JJSocialShareManager sharedManager] sendToEvernoteWithTitle:@"test" message:@"message" urlString:@"www.evernote.com"];
}

@end
