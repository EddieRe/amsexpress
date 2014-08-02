//
//  AMSSettingsFileManager.h
//  AMS Express
//
//  Created by Colin on 8/2/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMSSettingsFileManager : NSObject

+ (void)instantiateSettingsPlist;
+ (NSString *)settingsPath;

@end
