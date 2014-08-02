//
//  AMSNotesHTMLParser.m
//  AMS Express
//
//  Created by Colin on 8/1/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import "AMSNotesHTMLParser.h"

@implementation AMSNotesHTMLParser

- (void)updateLinksArrayWithWebURL:(NSURL *)url
{
    NSStringEncoding encoding = NSASCIIStringEncoding;
    NSError *error = nil;
    
    NSString *rawHTML = [NSString stringWithContentsOfURL:url encoding:encoding error:&error];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<a[^>]+href=\\\"(.*?)\\\"[^>]*>.*?</a>" options:0 error:&error];
    
    NSArray *anchorRangeArray = [regex matchesInString:rawHTML options:0 range:NSMakeRange(0, rawHTML.length)];
    NSMutableArray *anchorArray = [[NSMutableArray alloc] init];
    
    for (NSTextCheckingResult *match in anchorRangeArray) {
        NSString *substringForMatch = [rawHTML substringWithRange:match.range];
        [anchorArray addObject:substringForMatch];
    }
    
    self.linksArray = [self anchorPartsWithAnchorArray:anchorArray];
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
        
        if (name.length >= 2 && [[name substringFromIndex:(name.length - 2)] isEqualToString:@"3)"]) {
            NSError *linkError = nil;
            NSRegularExpression *linkRegex = [NSRegularExpression regularExpressionWithPattern:@"href=\\\"(.*?)\\\"" options:0 error:&linkError];
            NSTextCheckingResult *linkSearchResult = [linkRegex firstMatchInString:anchor options:0 range:NSMakeRange(0, anchor.length)];
            
            NSString *link = [anchor substringWithRange:linkSearchResult.range];
            link = [link substringWithRange:NSMakeRange(6, (link.length - 7))];
            
            [anchorPartsArray addObject:@[name, link]];
        }
    }
    
    return anchorPartsArray;
}

@end
