//
//  AMSNotesMasterViewController.m
//  AMS Express
//
//  Created by Colin on 7/29/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import "AMSNotesMasterViewController.h"

#import "AMSNotesSplitVCDelegate.h"
#import "AMSNotesDataSourceController.h"
#import "AMSNotesWebViewController.h"
#import "SavedPDF.h"

@interface AMSNotesMasterViewController ()

@end

@implementation AMSNotesMasterViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.splitVCDelegate = [[AMSNotesSplitVCDelegate alloc] init];
    
    self.splitVCDelegate.masterVC = self;
    UINavigationController *detailNavigationVC = [self.splitViewController.viewControllers lastObject];
    self.splitVCDelegate.detailNavigationVC = detailNavigationVC;
    self.splitViewController.delegate = self.splitVCDelegate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSourceController = [[AMSNotesDataSourceController alloc] init];
    
    self.dataSourceController.managedObjectContext = self.managedObjectContext;
    self.dataSourceController.tableView = self.tableView;
    
    self.selectedLinks = [[NSMutableArray alloc] init];
    
    UINavigationController *detailNavigationVC = [self.splitViewController.viewControllers lastObject];
    self.dataSourceController.detailNavigationVC = detailNavigationVC;
    
    self.tableView.dataSource = self.dataSourceController;
    
    self.webVC = (AMSNotesWebViewController *)[(UINavigationController *)[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)canvasAction:(id)sender {
    [self.webVC loadRequestFromString:@"http://canvas.brown.edu"];
}

#pragma mark - Table View delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.numberOfSections == 2 && indexPath.section == 0) {
        if ([self addOrRemoveAnchorPartsFromSelectedLinks:self.dataSourceController.links[indexPath.row]]) {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        } else {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        };
    } else {
        // load the stored PDF
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private methods

- (BOOL)addOrRemoveAnchorPartsFromSelectedLinks:(NSArray *)anchorParts
{
    if ([self.selectedLinks containsObject:anchorParts]) {
        [self.selectedLinks removeObject:anchorParts];
        return YES;
    } else {
        [self.selectedLinks addObject:anchorParts];
        return NO;
    }
}

@end
