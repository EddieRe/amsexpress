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
    
    [self loadRequestFromString:@"http://canvas.brown.edu"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRequestFromString:(NSString*)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"load request firing");
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

#pragma mark - Web View delegate methods

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSMutableString *html = [NSMutableString stringWithString:[webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"]];
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)html, NULL, transform, YES);
    
    [self.htmlParser updateLinksArrayWithHTML:html];
}

@end
