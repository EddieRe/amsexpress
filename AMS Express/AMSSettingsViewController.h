//
//  AMSSettingsViewController.h
//  AMS Express
//
//  Created by Eddie Re on 7/31/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMSSettingsViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UITextField *oasisUsernameField;
@property (weak, nonatomic) IBOutlet UITextField *oasisPasswordField;
- (IBAction)oasisSaveAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *canvasUsernameField;
@property (weak, nonatomic) IBOutlet UITextField *canvasPasswordField;
- (IBAction)canvasSaveAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *canvasCheckmark;
@property (weak, nonatomic) IBOutlet UIImageView *oasisCheckmark;

- (IBAction)deleteDataAction:(id)sender;

@property (nonatomic, strong) NSMutableDictionary *settings;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@end
