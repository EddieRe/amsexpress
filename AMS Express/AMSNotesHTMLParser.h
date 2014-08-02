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

- (void)htmlParserDidFinishParsing:(AMSNotesHTMLParser *)htmlParser;

@end

@interface AMSNotesHTMLParser : NSObject

@property (nonatomic, strong) NSArray *linksArray;
@property id <AMSNotesHTMLParserDelegate> delegate;

- (void)updateLinksArrayWithWebURL:(NSURL *)url;

@end
