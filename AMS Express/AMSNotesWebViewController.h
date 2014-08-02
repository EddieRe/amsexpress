//
//  AMSNotesWebViewController.h
//  AMS Express
//
//  Created by Colin on 7/30/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMSNotesHTMLParser;

@interface AMSNotesWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) AMSNotesHTMLParser *htmlParser;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (void)loadRequestFromString:(NSString *)urlString;

@end
