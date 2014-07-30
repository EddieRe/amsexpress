//
//  AMSTabBarController.m
//  AMS Express
//
//  Created by Colin on 7/17/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import "AMSTabBarController.h"

@interface AMSTabBarController ()

@end

@implementation AMSTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self customizeTabBarItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)customizeTabBarItems
{
    NSArray *imageNames = @[@"NotesTabSelected", @"EchoTabSelected", @"CalendarTabSelected", @"OasisTabSelected", @"SettingsTabSelected"];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (NSString *imageName in imageNames) {
        UIImage *image = [UIImage imageNamed:imageName];
        [images addObject:image];
    }
    
    NSUInteger i = 0;
    for (UIViewController *vc in self.viewControllers) {
        UITabBarItem *tabBarItem = vc.tabBarItem;
        [tabBarItem setSelectedImage:images[i]];
        i = i + 1;
    }
}

@end
