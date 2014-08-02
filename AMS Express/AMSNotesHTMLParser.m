//
//  AMSNotesHTMLParser.m
//  AMS Express
//
//  Created by Colin on 8/1/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import "AMSNotesHTMLParser.h"

@implementation AMSNotesHTMLParser

- (void)updateLinksArrayWithHTML:(NSString *)html
{
    NSLog(@"%@", html);
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<a[^>]+href=\\\\\"(.*?)\\\\\"[^>]*>.*?</a>" options:NSRegularExpressionDotMatchesLineSeparators error:&error];
    NSArray *anchorRangeArray = [regex matchesInString:html options:0 range:NSMakeRange(0, html.length)];
    
    NSMutableArray *anchorArray = [[NSMutableArray alloc] init];
    for (NSTextCheckingResult *match in anchorRangeArray) {
        NSString *substringForMatch = [html substringWithRange:match.range];
        [anchorArray addObject:substringForMatch];
    }
    
    [self.delegate htmlParser:self didFinishParsingWithLinks:[self anchorPartsWithAnchorArray:anchorArray]];
}


#pragma mark - Private methods

- (NSArray *)anchorPartsWithAnchorArray:(NSArray *)anchorArray
{
    NSMutableArray *anchorPartsArray = [[NSMutableArray alloc] init];
    
    for (NSString *anchor in anchorArray) {
        NSError *nameError = nil;
        NSRegularExpression *nameRegex = [NSRegularExpression regularExpressionWithPattern:@">.*?<" options:0 error:&nameError];
        NSTextCheckingResult *nameSearchResult = [nameRegex firstMatchInString:anchor options:0 range:NSMakeRange(0, anchor.length)];
        
        NSString *name = [anchor substringWithRange:nameSearchResult.range];
        name = [name substringWithRange:NSMakeRange(1, (name.length - 2))];
        NSLog(@"%@", name);
        
        if (name.length >= 4 && [[name substringFromIndex:(name.length - 4)] isEqualToString:@".pdf"]) {
            NSError *linkError = nil;
            NSRegularExpression *linkRegex = [NSRegularExpression regularExpressionWithPattern:@"href=\\\\\"(.*?)\\\\\"" options:0 error:&linkError];
            NSTextCheckingResult *linkSearchResult = [linkRegex firstMatchInString:anchor options:0 range:NSMakeRange(0, anchor.length)];
            
            NSString *link = [anchor substringWithRange:linkSearchResult.range];
            link = [link substringWithRange:NSMakeRange(7, (link.length - 9))];
            
            [anchorPartsArray addObject:@[name, link]];
        }
    }
    
    return anchorPartsArray;
}

@end
