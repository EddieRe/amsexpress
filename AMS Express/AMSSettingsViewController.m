//
//  AMSSettingsViewController.m
//  AMS Express
//
//  Created by Eddie Re on 7/31/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import "AMSSettingsViewController.h"

#import "AMSSettingsFileManager.h"
#import "SavedPDF.h"

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
    NSString *path = [AMSSettingsFileManager settingsPath];
    self.settings = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    // Do any additional setup after loading the view.
    
    self.canvasCheckmark.alpha = 0;
    self.oasisCheckmark.alpha = 0;
    
    self.oasisUsernameField.text = [self.settings objectForKey:@"oasisUsername"];
    self.oasisPasswordField.text = [self.settings objectForKey:@"oasisPassword"];
    self.canvasUsernameField.text = [self.settings objectForKey:@"canvasUsername"];
    self.canvasPasswordField.text = [self.settings objectForKey:@"canvasPassword"];
    
    NSNumber *indexNumber = [self.settings objectForKey:@"year"];
    self.segmentedControl.selectedSegmentIndex = [indexNumber integerValue];
    [self.segmentedControl addTarget:self
                         action:@selector(pickOne:)
               forControlEvents:UIControlEventValueChanged];
}

- (void)pickOne:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSUInteger index = [segmentedControl selectedSegmentIndex];
    self.yearLabel.text = [segmentedControl titleForSegmentAtIndex:index];
    [self.settings setObject:[NSNumber numberWithUnsignedInteger:index] forKey:@"year"];
    NSLog(@"%lu", (unsigned long)index);
    NSString *path = [AMSSettingsFileManager settingsPath];
    [self.settings writeToFile:path atomically:YES];
}

- (IBAction)oasisSaveAction:(id)sender {
    NSString *oasisUsernameString = self.oasisUsernameField.text;
    [self.settings setObject:oasisUsernameString forKey:@"oasisUsername"];
    
    NSString *oasisPasswordString = self.oasisPasswordField.text;
    [self.settings setObject:oasisPasswordString forKey:@"oasisPassword"];
    
    NSString *path = [AMSSettingsFileManager settingsPath];
    [self.settings writeToFile:path atomically:YES];
    
    self.oasisCheckmark.alpha = 1;
    [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.oasisCheckmark.alpha = 0;
    }completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.canvasUsernameField) {
        [self.canvasPasswordField becomeFirstResponder];
    } else if (textField == self.oasisUsernameField) {
        [self.oasisPasswordField becomeFirstResponder];
    } else if (textField == self.canvasPasswordField){
        [self canvasSaveAction:self];
        [self.canvasPasswordField resignFirstResponder];
    } else {
        [self oasisSaveAction:self];
        [self.oasisPasswordField resignFirstResponder];
    }return YES;
}

- (IBAction)canvasSaveAction:(id)sender {
    NSString *canvasUsernameString = self.canvasUsernameField.text;
    [self.settings setObject:canvasUsernameString forKey:@"canvasUsername"];
    
    NSString *canvasPasswordString = self.canvasPasswordField.text;
    [self.settings setObject:canvasPasswordString forKey:@"canvasPassword"];
    
    NSString *path = [AMSSettingsFileManager settingsPath];
    [self.settings writeToFile:path atomically:YES];
    
    self.canvasCheckmark.alpha = 1;
    [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.canvasCheckmark.alpha = 0;
    } completion:nil];
}

- (IBAction)deleteDataAction:(id)sender {
    UIAlertView *downloadAlert = [[UIAlertView alloc] initWithTitle:@"Delete all notes!"
        message:[[NSString alloc] initWithFormat:@"Are you sure you want to delete all your notes?"]
            delegate:self
            cancelButtonTitle:@"Cancel"
            otherButtonTitles:@"OK", nil];
    [downloadAlert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSManagedObjectContext *context = self.managedObjectContext;
        
        NSFetchRequest *savedPDFsRequest = [[NSFetchRequest alloc] init];
        [savedPDFsRequest setEntity:[NSEntityDescription entityForName:@"SavedPDF" inManagedObjectContext:context]];
        [savedPDFsRequest setIncludesPropertyValues:NO];
        
        NSError *error = nil;
        NSArray *savedPDFs = [context executeFetchRequest:savedPDFsRequest error:&error];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            for (SavedPDF *savedPDF in savedPDFs) {
                [context deleteObject:savedPDF];
            }
            NSError *saveError = nil;
            [context save:&saveError];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self deletedAlert];
            });
        });
    }
}

- (void)deletedAlert
{
    UIAlertView *deletedAlert = [[UIAlertView alloc] initWithTitle:nil
                                                          message:[[NSString alloc] initWithFormat:@"Your notes have been deleted."]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
    [deletedAlert show];
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
