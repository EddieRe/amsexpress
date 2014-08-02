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
@property (nonatomic, strong) UIDocumentInteractionController *interactionController;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property UINavigationController *masterNav;
@property UIBarButtonItem *organizeBarButtonItem;
@property UIBarButtonItem *rewindBarButtonItem;
@property UIBarButtonItem *composeBarButtonItem;
@property UIBarButtonItem *forwardBarButtonItem;
@property UIBarButtonItem *stopBarButtonItem;
@property UIBarButtonItem *refreshBarButtonItem;
@property UILabel *pageTitle;
@property (weak,nonatomic) NSString *currentURL;

- (void)loadRequestFromString:(NSString *)urlString;

@end
