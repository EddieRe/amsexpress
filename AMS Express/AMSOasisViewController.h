//
//  AMSOasisViewController.h
//  AMS Express
//
//  Created by Eddie Re on 7/30/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMSOasisViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stopButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;

@property (weak, nonatomic) IBOutlet UILabel *pageTitle;
@property (weak,nonatomic) NSString *currentURL;

- (void)loadRequestFromString:(NSString*)urlString;
- (IBAction)homeAction:(id)sender;
@end
