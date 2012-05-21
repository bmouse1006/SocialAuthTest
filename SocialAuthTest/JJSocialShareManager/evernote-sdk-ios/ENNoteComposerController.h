//
//  ENNoteComposerController.h
//  SocialAuthTest
//
//  Created by 金 津 on 12-5-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ENNoteComposerController : UITableViewController

@property (nonatomic, retain) IBOutlet UITableViewCell* titleCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* messageCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* urlCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* notebookCell;

@property (nonatomic, retain) IBOutlet UIBarButtonItem* sendButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* cancelButton;

-(IBAction)cancelButtonClicked:(id)sender;
-(IBAction)sendButtonClicked:(id)sender;

@end
