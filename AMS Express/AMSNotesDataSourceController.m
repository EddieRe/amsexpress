//
//  AMSNotesDataSourceController.m
//  AMS Express
//
//  Created by Colin on 7/30/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import "AMSNotesDataSourceController.h"

#import "AMSNotesWebViewController.h"

@implementation AMSNotesDataSourceController

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

@end
