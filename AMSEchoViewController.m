//
//  AMSEchoViewController.m
//  AMS Express
//
//  Created by Eddie Re on 7/31/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import "AMSEchoViewController.h"

@interface AMSEchoViewController ()
@property BOOL isLoading;
@property NSString *echoURL;

@end

@implementation AMSEchoViewController

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
    [self setEchoURL];
    [self loadRequestFromString:self.echoURL];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//
//}

- (void)loadRequestFromString:(NSString*)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)echoHomeAction:(id)sender {
    [self setEchoURL];
    [self loadRequestFromString:self.echoURL];
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
    self.isLoading = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString* pageTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.pageTitle.text = pageTitle;
    self.isLoading = NO;
    
}

- (void)setEchoURL
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSNumber *indexNumber = [settings objectForKey:@"year"];
    NSUInteger index = [indexNumber integerValue];
    switch (index) {
        case 0:
            self.echoURL = @"https://mediacapture.brown.edu:8443/ess/portal/section/faacc089-888f-47df-9f29-966dc6e65f9e";
            break;
        case 1:
            self.echoURL = @"https://mediacapture.brown.edu:8443/ess/portal/section/faacc089-888f-47df-9f29-966dc6e65f9e";
            break;
        case 2:
            self.echoURL = @"https://mediacapture.brown.edu:8443/ess/portal/section/58fba009-efd8-43d4-ab2c-65ba80b7198d";
            break;
        case 3:
            self.echoURL = @"https://mediacapture.brown.edu:8443/ess/portal/section/faacc089-888f-47df-9f29-966dc6e65f9e";
            break;
        default:
            break;
    }
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

- (IBAction)homeAction:(id)sender {
}
@end