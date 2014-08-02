//
//  AMSNotesHTMLParser.h
//  AMS Express
//
//  Created by Colin on 8/1/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMSNotesHTMLParser;

@protocol AMSNotesHTMLParserDelegate <NSObject>

@required
- (void)htmlParser:(AMSNotesHTMLParser *)htmlParser didFinishParsingWithLinks:(NSArray *)links;

@end

@interface AMSNotesHTMLParser : NSObject

@property id <AMSNotesHTMLParserDelegate> delegate;

- (void)updateLinksArrayWithHTML:(NSString *)html;

@end
