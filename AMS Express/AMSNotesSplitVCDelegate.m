//
//  AMSNotesSplitVCDelegate.m
//  AMS Express
//
//  Created by Colin on 7/30/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import "AMSNotesSplitVCDelegate.h"

@implementation AMSNotesSplitVCDelegate

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"Notes";
    
    UINavigationItem *navItem = [self.detailNavigationVC.topViewController navigationItem];
    [navItem setLeftBarButtonItem:barButtonItem animated:YES];
}

@end