//
//  ENNotebookListViewController.m
//  SocialAuthTest
//
//  Created by 金 津 on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ENNotebookListViewController.h"
#import "EvernoteSDK.h"

#define JJSSMLocalizedString(key, comment) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:@"JJSocialShareManager"]

@interface ENNotebookListViewController ()

@property (nonatomic, retain) NSArray* notebookList;

@end

@implementation ENNotebookListViewController

@synthesize notebookList = _notebookList;

-(void)dealloc{
    self.notebookList = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = JJSSMLocalizedString(@"title_notebooklist", nil);

    EvernoteNoteStore* noteStore = [EvernoteNoteStore noteStore];
    
    @try {
        [noteStore listNotebooksWithSuccess:^(NSArray* notebooks){
            self.notebookList = notebooks;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        } failure:^(NSError* error){
            
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.notebookList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    EDAMNotebook* notebook = [self.notebookList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = notebook.name;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
