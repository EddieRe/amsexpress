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


- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    UINavigationItem *navItem = [self.detailNavigationVC.topViewController navigationItem];
    [navItem setLeftBarButtonItem:nil animated:YES];
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}

@end