//
//  AMSOasisViewController.m
//  AMS Express
//
//  Created by Eddie Re on 7/30/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import "AMSOasisViewController.h"

#import "AMSSettingsFileManager.h"

@interface AMSOasisViewController ()
@property BOOL isLoading;
@property BOOL isLoggedIn;

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
    [self loadRequestFromString:@"https://oasis.med.brown.edu/index.html"];
    [self.webView setBackgroundColor:[UIColor darkGrayColor]];
    self.webView.scalesPageToFit = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.pageTitle.text isEqualToString:@"Home"] || [self.pageTitle.text isEqualToString:@"OASIS"])
    {
        [self insertCredentialsWithWebView:self.webView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)homeAction:(id)sender {
        if ([self.pageTitle.text isEqualToString:@"Home"]){
        [self insertCredentialsWithWebView:self.webView];
    } else {
        [self loadRequestFromString:@"https://oasis.med.brown.edu/student/schedule/index.html"];
    }
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
    self.isLoading = YES;
    self.currentURL = [webView.request.URL absoluteString];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString* pageTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.pageTitle.text = pageTitle;
    self.isLoading = NO;
    
    if ([self.pageTitle.text isEqualToString:@"Oasis"]){
        self.isLoggedIn = NO;
    }
        if (!self.isLoggedIn) {
        [self insertCredentialsWithWebView:webView];
        self.isLoggedIn = YES;
    }
}

#pragma mark - Private methods

- (void)insertCredentialsWithWebView:(UIWebView *)webView
{
    NSString *path = [AMSSettingsFileManager settingsPath];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSString* userId = [settings objectForKey:@"oasisUsername"];
    NSString* password =  [settings objectForKey:@"oasisPassword"];
    
    if(userId != nil && password != nil ){
        
        NSString*  jScriptString1 = [NSString  stringWithFormat:@"document.getElementById('username').value='%@'", userId];
        NSString*  jScriptString2 = [NSString stringWithFormat:@"document.getElementsByName('password')[0].value='%@'", password];
        
        [webView stringByEvaluatingJavaScriptFromString:jScriptString1];
        [webView stringByEvaluatingJavaScriptFromString:jScriptString2];
        [webView stringByEvaluatingJavaScriptFromString:@"document.forms['login'].submit();"];
        
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

@end
