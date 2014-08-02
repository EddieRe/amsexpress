//
//  AMSNotesWebViewController.m
//  AMS Express
//
//  Created by Colin on 7/30/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import "AMSNotesWebViewController.h"

#import "AMSNotesHTMLParser.h"
#import "AMSNotesMasterViewController.h"
#import "AMSNotesDataSourceController.h"

@interface AMSNotesWebViewController ()

@end

@implementation AMSNotesWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.htmlParser = [[AMSNotesHTMLParser alloc] init];
    UINavigationController *masterNav = (UINavigationController *)[self.splitViewController.viewControllers firstObject];
    AMSNotesMasterViewController *masterVC = (AMSNotesMasterViewController *)[masterNav topViewController];
    self.htmlParser.delegate = masterVC.dataSourceController;
    
    NSLog(@"datasourcecontroller: %@\nhtmlparser: %@\ndelegate: %@", masterVC.dataSourceController, self.htmlParser, self.htmlParser.delegate);
    
    
    NSURL *url = [NSURL URLWithString:@"http://canvas.brown.edu"];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRequestFromString:(NSString*)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

#pragma mark - Web View delegate methods

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.htmlParser updateLinksArrayWithHTML:[webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"]];
}

@end
