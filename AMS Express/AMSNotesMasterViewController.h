//
//  AMSNotesMasterViewController.h
//  AMS Express
//
//  Created by Colin on 7/29/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMSNotesDataSourceController, AMSNotesSplitVCDelegate, AMSNotesWebViewController;

@interface AMSNotesMasterViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) AMSNotesSplitVCDelegate *splitVCDelegate;
@property (nonatomic, strong) AMSNotesDataSourceController *dataSourceController;
@property (nonatomic, weak) AMSNotesWebViewController *webVC;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *canvasButton;

- (IBAction)canvasAction:(id)sender;

@property (nonatomic, strong) NSString *theString;


@end
