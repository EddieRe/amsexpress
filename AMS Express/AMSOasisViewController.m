//
//  AMSOasisViewController.m
//  AMS Express
//
//  Created by Eddie Re on 7/30/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import "AMSOasisViewController.h"

@interface AMSOasisViewController ()

@end

@implementation AMSOasisViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadRequestFromString:@"https://oasis.med.brown.edu/student/schedule/index.html"];
}

- (void)loadRequestFromAddressField:(id)addressField
{
    NSString *urlString = [addressField text];
    [self loadRequestFromString:urlString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)homeAction:(id)sender {
    [self loadRequestFromString:@"https://oasis.med.brown.edu/student/schedule/index.html"];
}

- (void)loadRequestFromString:(NSString*)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

- (void)updateButtons
{
    self.forwardButton.enabled = self.webView.canGoForward;
    self.backButton.enabled = self.webView.canGoBack;
    self.stopButton.enabled = self.webView.loading;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.pageTitle.text = @"Loading";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString* pageTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.pageTitle.text = pageTitle;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
