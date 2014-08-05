//
//  AMSNotesWebViewController.h
//  AMS Express
//
//  Created by Colin on 7/30/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMSNotesDataSourceController.h"

@class AMSNotesHTMLParser, AMSNotesWebViewController;

@protocol AMSNotesWebViewControllerDelegate <NSObject>

- (void)webViewControllerDidFinishLoading:(AMSNotesWebViewController *)webViewController;

@end

@interface AMSNotesWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) AMSNotesDataSourceController *dataSourceController;
@property (nonatomic, strong) AMSNotesHTMLParser *htmlParser;
@property (nonatomic, strong) UIDocumentInteractionController *interactionController;
@property id <AMSNotesWebViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property UINavigationController *masterNav;
@property UIBarButtonItem *organizeBarButtonItem;
@property UIBarButtonItem *rewindBarButtonItem;
@property UIBarButtonItem *homeBarButtonItem;
@property UIBarButtonItem *forwardBarButtonItem;
@property UIBarButtonItem *stopBarButtonItem;
@property UIBarButtonItem *refreshBarButtonItem;
@property (weak, nonatomic) IBOutlet UILabel *pageTitle;
@property (weak,nonatomic) NSString *currentURL;

@property (weak, nonatomic) IBOutlet UIImageView *teachImage;
@property (weak, nonatomic) IBOutlet UIImageView *attentionImage;


- (void)loadRequestFromString:(NSString *)urlString;

@end
