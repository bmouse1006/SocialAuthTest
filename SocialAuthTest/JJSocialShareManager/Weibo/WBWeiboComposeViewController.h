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

@property (nonatomic, retain) IBOutlet UIView* backgroundView;
@property (nonatomic, retain) IBOutlet UIView* composeDialog;
@property (nonatomic, retain) IBOutlet UIToolbar* toolBar;

@property (nonatomic, retain) IBOutlet UIView* sepertorLine;
@property (nonatomic, retain) IBOutlet UILabel* titleLabel;

-(void)setInitialText:(NSString*)text;
-(void)addImage:(UIImage*)image;

-(void)show;

@end
