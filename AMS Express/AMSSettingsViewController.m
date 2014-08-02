//
//  AMSSettingsViewController.m
//  AMS Express
//
//  Created by Eddie Re on 7/31/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import "AMSSettingsViewController.h"

@interface AMSSettingsViewController ()



@end

@implementation AMSSettingsViewController

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
    // Do any additional setup after loading the view.
    
    // Load the plist file.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    self.settings = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    self.yearLabel = [[UILabel alloc] init];
    self.yearLabel.font = [UIFont fontWithName: @"Heiti TC Light" size:12.0];
    self.yearLabel.frame = CGRectMake(400, 640, 300, 40);
    [self.view addSubview:self.yearLabel];
    
    //Create the segmented control
    NSArray *itemArray = [NSArray arrayWithObjects: @"2015", @"2016", @"2017", @"2018", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(250, 685, 250, 50);
    segmentedControl.tintColor = [UIColor whiteColor];
    segmentedControl.backgroundColor = [UIColor blackColor];
    NSNumber *indexNumber = [self.settings objectForKey:@"year"];
    segmentedControl.selectedSegmentIndex = [indexNumber integerValue];
    [segmentedControl addTarget:self
                         action:@selector(pickOne:)
               forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
}

-(void) pickOne:(id)sender{
   
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSUInteger index = [segmentedControl selectedSegmentIndex];
    self.yearLabel.text = [segmentedControl titleForSegmentAtIndex:index];
    
    [self.settings setObject:[NSNumber numberWithUnsignedInteger:index] forKey:@"year"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    [self.settings writeToFile:path atomically:YES];
}

- (IBAction)oasisSaveAction:(id)sender {
    NSString *oasisUsernameString = self.oasisUsernameField.text;
    [self.settings setObject:oasisUsernameString forKey:@"oasisUsername"];
    
    NSString *oasisPasswordString = self.oasisPasswordField.text;
    [self.settings setObject:oasisPasswordString forKey:@"oasisPassword"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    [self.settings writeToFile:path atomically:YES];
}

- (IBAction)canvasSaveAction:(id)sender {
    NSString *canvasUsernameString = self.canvasUsernameField.text;
    [self.settings setObject:canvasUsernameString forKey:@"canvasUsername"];
    
    NSString *canvasPasswordString = self.canvasPasswordField.text;
    [self.settings setObject:canvasPasswordString forKey:@"canvasPassword"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    [self.settings writeToFile:path atomically:YES];
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

@end
