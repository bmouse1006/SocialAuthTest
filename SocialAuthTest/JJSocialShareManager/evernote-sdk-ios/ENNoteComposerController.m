//
//  ENNoteComposerController.m
//  SocialAuthTest
//
//  Created by 金 津 on 12-5-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ENNoteComposerController.h"
#import "EvernoteSDK.h"

#define JJSSMLocalizedString(key, comment) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:@"JJSocialShareManager"]

@interface ENNoteComposerController ()

@property (nonatomic, retain) NSArray* cells;

@end

@implementation ENNoteComposerController

@synthesize titleCell = _titleCell, messageCell = _messageCell, urlCell = _urlCell, notebookCell = _notebookCell;
@synthesize cells = _cells;
@synthesize sendButton = _sendButton, cancelButton = _cancelButton;

-(void)dealloc{
    self.titleCell = nil;
    self.messageCell = nil;
    self.urlCell = nil;
    self.notebookCell = nil;
    self.cells = nil;
    self.sendButton = nil;
    self.cancelButton = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style{
    [super initWithStyle:style];
    
    if (self){
        
    }
    
    return self;
}

-(void)commonInit{
    
    if (!self.titleCell){
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    }
    
    self.titleCell.textLabel.text = JJSSMLocalizedString(@"title_title", nil);
    self.messageCell.textLabel.text = JJSSMLocalizedString(@"title_message", nil);
    self.urlCell.textLabel.text = JJSSMLocalizedString(@"title_url", nil);
    self.notebookCell.textLabel.text = JJSSMLocalizedString(@"title_notebook", nil);
    
    self.navigationItem.rightBarButtonItem = self.sendButton;
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    
    self.cells = [NSArray arrayWithObjects:self.titleCell, self.messageCell, self.urlCell, self.notebookCell, nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSBundle mainBundle] localizedStringForKey:@"" value:@"" table:nil];
    self.title = JJSSMLocalizedString(@"title_sendtoevernote", nil);
    
    // Do any additional setup after loading the view from its nib.
    NSString *EVERNOTE_HOST = @"sandbox.evernote.com";
    
    // Fill in the consumer key and secret with the values that you received from Evernote
    // To get an API key, visit http://dev.evernote.com/documentation/cloud/
    NSString *CONSUMER_KEY = @"bmouse1006-3334";
    NSString *CONSUMER_SECRET = @"8efb9c47b2113834";
    
    // set up Evernote session singleton
    [EvernoteSession setSharedSessionHost:EVERNOTE_HOST 
                              consumerKey:CONSUMER_KEY 
                           consumerSecret:CONSUMER_SECRET];
    
    [self commonInit];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    EvernoteSession *session = [EvernoteSession sharedSession];
//    if (session.isAuthenticated == NO){
//        [session authenticateWithCompletionHandler:^(NSError *error) {
//            if (error || !session.isAuthenticated) {
//                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:JJSSMLocalizedString(@"title_error", nil)
//                                                                 message:JJSSMLocalizedString(@"message_couldnotauthenticate", nil)
//                                                                delegate:nil 
//                                                       cancelButtonTitle:JJSSMLocalizedString(@"title_ok", nil) 
//                                                       otherButtonTitles:nil] autorelease];
//                [alert show];
//                [self dismissViewControllerAnimated:YES completion:NULL];
//            } else {
//                [self updateUI];
//            } 
//        }];
//    }else{
//        [self updateUI];
//    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)updateUI{
    
}

#pragma mark - action call back
-(void)cancelButtonClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - table view datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{   
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.cells count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.cells objectAtIndex:indexPath.row];
}

#pragma mark - table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [self.cells objectAtIndex:indexPath.row];
    return cell.frame.size.height;
}

@end
