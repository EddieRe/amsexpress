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
    self.dataSourceController = [[AMSNotesDataSourceController alloc] init];
    
    self.splitVCDelegate.masterVC = self;
    self.dataSourceController.tableView = self.tableView;
    self.dataSourceController.managedObjectContext = self.managedObjectContext;
    
    UINavigationController *detailNavigationVC = [self.splitViewController.viewControllers lastObject];
    self.splitVCDelegate.detailNavigationVC = detailNavigationVC;
    self.dataSourceController.detailNavigationVC = detailNavigationVC;
    
    self.splitViewController.delegate = self.splitVCDelegate;
    self.tableView.dataSource = self.dataSourceController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
