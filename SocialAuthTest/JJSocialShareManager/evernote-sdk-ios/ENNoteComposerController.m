//
//  ENNoteComposerController.m
//  SocialAuthTest
//
//  Created by 金 津 on 12-5-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "EvernoteCommonDefine.h"
#import "ENNoteComposerController.h"
#import "ENNotebookListViewController.h"
#import "EvernoteSDK.h"
#import "BaseActivityLabel.h"
#import "BaseAlertView.h"
#import "RegexKitLite.h"

@interface ENNoteComposerController (){
    BOOL _saveURLOnly;
}

@property (nonatomic, retain) NSArray* cells;
@property (nonatomic, copy) NSString* ENTitle;
@property (nonatomic, copy) NSString* ENContent;
@property (nonatomic, copy) NSString* ENURLString;

@end

@implementation ENNoteComposerController

static BOOL _startHandleOpenURL;

@synthesize titleCell = _titleCell, contentCell = _contentCell, urlCell = _urlCell, notebookCell = _notebookCell, urlStringCell = _urlStringCell;
@synthesize cells = _cells;
@synthesize sendButton = _sendButton, cancelButton = _cancelButton;
@synthesize titleField = _titleField, contentView = _contentView;
@synthesize ENTitle = _ENTitle, ENContent = _ENContent, ENURLString = _ENURLString;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.titleCell = nil;
    self.contentCell = nil;
    self.urlCell = nil;
    self.urlStringCell = nil;
    self.notebookCell = nil;
    self.cells = nil;
    self.sendButton = nil;
    self.cancelButton = nil;
    self.titleField = nil;
    self.contentView = nil;
    self.ENContent = nil;
    self.ENTitle = nil;
    self.ENURLString = nil;
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
    
    self.sendButton.title = EvernoteLocalizedString(@"title_send", nil);
    
    self.titleCell.textLabel.text = EvernoteLocalizedString(@"title_title", nil);
    self.titleField.placeholder = EvernoteLocalizedString(@"title_title", nil);
    self.titleField.text = self.ENTitle;
    self.contentCell.textLabel.text = EvernoteLocalizedString(@"title_message", nil);
    NSString* contentWithoutImages = [self.ENContent stringByReplacingOccurrencesOfRegex:@"<iframe\\s*[^>]*>" withString:@""];
    contentWithoutImages = [contentWithoutImages stringByReplacingOccurrencesOfRegex:@"<img\\s*[^>]*>" withString:@""];
    [self.contentView loadHTMLString:contentWithoutImages baseURL:nil];
    self.urlStringCell.textLabel.text = EvernoteLocalizedString(@"title_urlstring", nil);
    self.urlStringCell.detailTextLabel.text = self.ENURLString;
    self.urlCell.textLabel.text = EvernoteLocalizedString(@"title_saveurlonly", nil);
    self.notebookCell.textLabel.text = EvernoteLocalizedString(@"title_notebook", nil);
//    self.notebookCell.detailTextLabel.text = @"";
    
    self.navigationItem.rightBarButtonItem = self.sendButton;
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    
    self.cells = [NSArray arrayWithObjects:self.titleCell, self.contentCell, self.urlStringCell, self.urlCell, self.notebookCell, nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSBundle mainBundle] localizedStringForKey:@"" value:@"" table:nil];
    self.title = EvernoteLocalizedString(@"title_sendtoevernote", nil);
    
    [self commonInit];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    EvernoteSession *session = [EvernoteSession sharedSession];
    if (session.isAuthenticated == NO){
        BaseActivityLabel* activity = [BaseActivityLabel loadFromBundle];
        activity.message = EvernoteLocalizedString(@"message_verifyevernote", nil);
        [activity show];
        [session authenticateWithCompletionHandler:^(NSError *error) {
            if (error || !session.isAuthenticated) {
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:EvernoteLocalizedString(@"title_error", nil)
                                                                 message:EvernoteLocalizedString(@"message_couldnotauthenticate", nil)
                                                                delegate:nil 
                                                       cancelButtonTitle:EvernoteLocalizedString(@"title_ok", nil) 
                                                       otherButtonTitles:nil] autorelease];
                [alert show];
                [self dismissViewControllerAnimated:YES completion:NULL];
                [activity setFinished:NO];
            } else {
                //success
                [activity setFinished:YES];
                [self updateUI];
            } 
            _startHandleOpenURL = NO;
        }];
    }
    
    [self updateUI];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)updateUI{
    BOOL authenticated = [EvernoteSession sharedSession].isAuthenticated;
    self.sendButton.enabled = authenticated;
    self.notebookCell.userInteractionEnabled = authenticated;
    //fetch stored or default notebook guid and name
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* noteBookName = [defaults objectForKey:kUserDefinedNotebookName];
    if (noteBookName.length == 0 && authenticated){
        //fetch default notebook
        BaseActivityLabel* activityLabel = [BaseActivityLabel loadFromBundle];
        activityLabel.message = EvernoteLocalizedString(@"message_fetchdefaultnotebook", nil);
        [activityLabel show];
        EvernoteNoteStore* store = [EvernoteNoteStore noteStore];
        [store getDefaultNotebookWithSuccess:^(EDAMNotebook* notebook){
            [defaults setObject:notebook.name forKey:kUserDefinedNotebookName];
            [defaults setObject:notebook.guid forKey:kUserDefinedNotebookGUID];
            [defaults synchronize];
            
            self.notebookCell.detailTextLabel.text = notebook.name;
            [self.notebookCell setNeedsLayout];
            [activityLabel setFinished:YES];
        } failure:^(NSError* error){
            [activityLabel setFinished:NO];
        }];
    }else{
        NSLog(@"%@", noteBookName);
        self.notebookCell.detailTextLabel.text = noteBookName;
        [self.notebookCell setNeedsLayout];
    }
}

-(void)setENContent:(NSString*)content{
    if (_ENContent != content){
        [_ENContent release];
        _ENContent = [content copy];
    }
//    self.contentTextView.text = content;
}

-(void)setENTitle:(NSString*)title{
    if (_ENTitle != title){
        [_ENTitle release];
        _ENTitle = [title copy];
    }
    self.titleField.text = title;
}

-(void)setENURLString:(NSString*)urlString{
    if (_ENURLString != urlString){
        [_ENURLString release];
        _ENURLString = [urlString copy];
    }
}

+(void)setStartHandleOpenURL:(BOOL)started{
    _startHandleOpenURL = started;
}

#pragma mark - notification call back
-(void)becomeActive:(NSNotification*)notification{
    if (_startHandleOpenURL == NO){
        BaseActivityLabel* activity = [BaseActivityLabel currentView];
        [activity dismiss];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark - action call back
-(void)cancelButtonClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(IBAction)saveURLOnlyChanged:(id)sender{
    UISwitch* switcher = (UISwitch*)sender;
    _saveURLOnly = switcher.on;
    if (_saveURLOnly){
        self.cells = [NSArray arrayWithObjects:self.titleCell, self.urlStringCell, self.urlCell, self.notebookCell, nil];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        self.cells = [NSArray arrayWithObjects:self.titleCell, self.contentCell, self.urlStringCell, self.urlCell, self.notebookCell, nil];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(IBAction)sendButtonClicked:(id)sender{
    
//    EDAMNoteFilter* filter = [[[EDAMNoteFilter alloc] init] autorelease];
//    filter.notebookGuid = @"b3eec62d-b007-4571-9b1e-c92d9a3d922d";
//    
//    EvernoteNoteStore* store = [EvernoteNoteStore noteStore];
//    [store findNotesWithFilter:filter offset:0 maxNotes:10 success:^(EDAMNoteList* list){
//        for (EDAMNote* note in list.notes){
//            NSLog(@"+++++++%@", note.content);
//            [store getNoteContentWithGuid:note.guid success:^(NSString* note){
//                NSLog(@"------content is %@", note);
//            }failure:^(NSError* error){
//                
//            }];
//        }
//    }
//                       failure:^(NSError* error){
//                           
//                       }];
//    
//    return;
    
    NSString* noteTemplate = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kENNoteContentTemplateName ofType:@"xml"] 
                                                       encoding:NSUTF8StringEncoding 
                                                          error:NULL];
    NSString* contentText =[self.ENContent stringByReplacingOccurrencesOfRegex:@"<iframe\\s*[^>]*>" withString:@""];
    contentText = [contentText stringByReplacingOccurrencesOfRegex:@"<img\\s*[^>]*>" withString:@""];
    contentText = [contentText stringByReplacingOccurrencesOfString:@"<br>" withString:@"<br/>"];
    
    if (_saveURLOnly){
        contentText = @"";
    }

    NSString* formattedContent = [NSString stringWithFormat:noteTemplate, contentText];
    NSLog(@"%@", formattedContent);
    
    EvernoteNoteStore* noteStore = [EvernoteNoteStore noteStore];

    EDAMNoteAttributes * attributes = [[[EDAMNoteAttributes alloc] init] autorelease];
    attributes.sourceURL = self.ENURLString;
    
    EDAMNote* note = [[[EDAMNote alloc] init] autorelease];
    note.title = self.titleField.text;
    
    note.content = formattedContent;
    note.notebookGuid = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefinedNotebookGUID];
    note.attributes = attributes;
    
    [noteStore createNote:note success:^(EDAMNote* note){
        NSLog(@"create success %@", note);
        BaseAlertView* alertView = [BaseAlertView loadFromBundle];
        alertView.message = EvernoteLocalizedString(@"message_sendtoevernoteok", nil);
        [alertView show];
    } failure:^(NSError* error){
        NSLog(@"create failed %@", [error description]);
        BaseAlertView* alertView = [BaseAlertView loadFromBundle];
        alertView.message = EvernoteLocalizedString(@"message_sendtoevernoteerror", nil);
        [alertView show];
    }];
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView cellForRowAtIndexPath:indexPath] == self.notebookCell){
        //show note book list
        ENNotebookListViewController* notebookList = [[[ENNotebookListViewController alloc] initWithNibName:@"ENNotebookListViewController" bundle:nil] autorelease];
        [self.navigationController pushViewController:notebookList animated:YES];
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return EvernoteLocalizedString(@"title_imageswillnotbecopiedtoevernote", nil);
}

@end
