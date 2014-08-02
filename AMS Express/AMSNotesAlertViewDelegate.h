//
//  AMSNotesAlertViewDelegate.h
//  AMS Express
//
//  Created by Colin on 8/2/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMSNotesMasterViewController;

@interface AMSNotesAlertViewDelegate : NSObject <UIAlertViewDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) AMSNotesMasterViewController *masterVC;

@end
