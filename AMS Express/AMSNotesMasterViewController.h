//
//  AMSNotesMasterViewController.h
//  AMS Express
//
//  Created by Colin on 7/29/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AMSNotesDataSourceController.h"
#import "AMSNotesWebViewController.h"

@class AMSNotesSplitVCDelegate, AMSNotesWebViewController, AMSNotesAlertViewDelegate;

@interface AMSNotesMasterViewController : UITableViewController <AMSNotesDataSourceControllerDelegate, AMSNotesWebViewControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) AMSNotesSplitVCDelegate *splitVCDelegate;
@property (nonatomic, strong) AMSNotesDataSourceController *dataSourceController;
@property (nonatomic, weak) AMSNotesWebViewController *webVC;
@property (nonatomic, strong) AMSNotesAlertViewDelegate *alertViewDelegate;
@property (nonatomic, strong) NSMutableArray *selectedLinks;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *getPDFButton;

- (IBAction)getPDFAction:(id)sender;

@end
