//
//  SavedPDF.h
//  AMS Express
//
//  Created by Colin on 7/31/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SavedPDF : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * dateSaved;
@property (nonatomic, retain) NSString * localURL;
@property (nonatomic, retain) NSString * webURL;

@end
