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
#import "AMSNotesAlertViewDelegate.h"

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
    [self.tableView setSeparatorColor:[UIColor grayColor]];
    [self.tableView setBackgroundColor:[UIColor lightGrayColor]];
    
    self.dataSourceController = [[AMSNotesDataSourceController alloc] init];
    
    self.dataSourceController.managedObjectContext = self.managedObjectContext;
    self.dataSourceController.tableView = self.tableView;
    self.dataSourceController.delegate = self;
    UINavigationController *detailNavigationVC = [self.splitViewController.viewControllers lastObject];
    self.dataSourceController.detailNavigationVC = detailNavigationVC;
    self.tableView.dataSource = self.dataSourceController;
    
    self.alertViewDelegate = [[AMSNotesAlertViewDelegate alloc] init];
    self.alertViewDelegate.masterVC = self;
    self.alertViewDelegate.managedObjectContext = self.managedObjectContext;
    
    self.selectedLinks = [[NSMutableArray alloc] init];
    
    self.webVC = (AMSNotesWebViewController *)[(UINavigationController *)[self.splitViewController.viewControllers lastObject] topViewController];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)getPDFAction:(id)sender {
    if (self.webVC.teachImage.alpha > 0.0f) {
        self.webVC.teachImage.alpha = 0.0f;
    }
    if (self.webVC.attentionImage.alpha > 0.0f) {
        self.webVC.attentionImage.alpha = 0.0f;
    }
    if (self.dataSourceController.hasParsedLinks) {
        if ([self.selectedLinks isEqualToArray:@[]]) {
            [self noSelectionsAlert];
        } else {
            [self confirmAlert];
        }
    } else {
        [self.webVC loadRequestFromString:@"http://canvas.brown.edu"];
    }
}

#pragma mark - UIAlerts

- (void)confirmAlert
{
    NSString *message = [NSString stringWithFormat:@"Are you sure you want to download %lu PDFs?", (unsigned long)self.selectedLinks.count];
    UIAlertView *confirmAlert = [[UIAlertView alloc] initWithTitle:@"Confirm Your Download"
                                                           message:message
                                                          delegate:self.alertViewDelegate
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"OK", nil];
    [confirmAlert show];
}

- (void)noSelectionsAlert
{
    UIAlertView *noSelectionsAlert = [[UIAlertView alloc] initWithTitle:@"No Selections"
                                                                message:@"Please select PDFs from the \"PDFs on this page\" section before downloading."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
    [noSelectionsAlert show];
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
        SavedPDF *savedPDF = [self.dataSourceController fetchedResultObjectAtIndexPath:indexPath];
        NSURL *fileURL = [NSURL fileURLWithPath:savedPDF.localURL];
        NSURLRequest *fileURLRequest = [[NSURLRequest alloc] initWithURL:fileURL];
        [self.webVC.webView loadRequest:fileURLRequest];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Data Source Controller delegate

- (void)dataSourceController:(AMSNotesDataSourceController *)dataSourceController didResetLinksWithResult:(BOOL)result
{
    if (result) {
        self.getPDFButton.title = @"Download Selected";
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.dataSourceController.fetchedResultsController sections] objectAtIndex:0];
        if ([sectionInfo numberOfObjects] == 0) {
            [self.webVC.attentionImage setAlpha:(1.0f)];
        } else {
            [self.webVC.attentionImage setAlpha:(0.0f)];
        }
    } else {
        self.getPDFButton.title = @"Go to Canvas";
    }
}

- (BOOL)dataSourceController:(AMSNotesDataSourceController *)dataSourceController shouldMarkCellForAnchorParts:(NSArray *)anchorParts
{
    if ([self.selectedLinks containsObject:anchorParts]) return YES;
    else return NO;
}

#pragma mark - Web view controller delegate

- (void)webViewControllerDidFinishLoading:(AMSNotesWebViewController *)webViewController
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.dataSourceController.fetchedResultsController sections] objectAtIndex:0];
    if ([sectionInfo numberOfObjects] == 0) {
        [webViewController.teachImage setAlpha:(1.0f)];
    } else {
        [webViewController.teachImage setAlpha:(0.0f)];
    }
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
