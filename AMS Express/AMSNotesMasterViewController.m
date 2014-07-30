//
//  AMSNotesMasterViewController.m
//  AMS Express
//
//  Created by Colin on 7/29/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import "AMSNotesMasterViewController.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSourceController = [[AMSNotesDataSourceController alloc] init];
    self.dataSourceController.masterVC = self;
    self.dataSourceController.detailNavigationVC = [self.splitViewController.viewControllers lastObject];
    
    self.tableView.dataSource = self.dataSourceController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
