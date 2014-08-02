//
//  AMSSettingsFileManager.m
//  AMS Express
//
//  Created by Colin on 8/2/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import "AMSSettingsFileManager.h"

@implementation AMSSettingsFileManager

+ (void)instantiateSettingsPlist
{
    NSString *path = [AMSSettingsFileManager settingsPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSDictionary *defaultSettings = @{@"year": @0,
                                          @"canvasPassword": @"",
                                          @"canvasUsername": @"",
                                          @"oasisPassword": @"",
                                          @"oasisUsername": @""};
        [defaultSettings writeToFile:path atomically:NO];
    }
}

+ (NSString *)settingsPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths objectAtIndex:0];
    return [basePath stringByAppendingString:@"/Settings.plist"];
}

@end
