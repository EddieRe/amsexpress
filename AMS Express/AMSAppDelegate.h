//
//  AMSAppDelegate.h
//  AMS Express
//
//  Created by Colin on 7/14/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
