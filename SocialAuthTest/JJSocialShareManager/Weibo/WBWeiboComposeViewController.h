//
//  WBWeiboComposeViewController.h
//  SocialAuthTest
//
//  Created by Jin Jin on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthController.h"

@interface WBWeiboComposeViewController : UIViewController<OAuthControllerDelegate>

-(void)setInitialText:(NSString*)text;
-(void)addImage:(UIImage*)image;

-(void)show;

@end
