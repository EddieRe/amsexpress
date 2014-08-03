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

#import "AMSSettingsFileManager.h"

@interface AMSNotesWebViewController ()

@property BOOL isLoading;
@property BOOL isLoggedIn;
@property NSString *canvasURL;
@property (nonatomic, strong) UIBarButtonItem *openInBarButtonItem;

@end

@implementation AMSNotesWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     //custom initializing.
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
    
    [self setCanvasURL];
    [self loadRequestFromString:self.canvasURL];
    
    self.htmlParser = [[AMSNotesHTMLParser alloc] init];
    UINavigationController *masterNav = (UINavigationController *)[self.splitViewController.viewControllers firstObject];
    AMSNotesMasterViewController *masterVC = (AMSNotesMasterViewController *)[masterNav topViewController];
    self.htmlParser.delegate = masterVC.dataSourceController;
    
    self.openInBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openInAction)];
    self.interactionController = [[UIDocumentInteractionController alloc] init];
    
    UIBarButtonItem *stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopAction)];
    UIBarButtonItem *refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction)];
    UIBarButtonItem *composeBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeAction)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *forwardBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(forwardAction)];
    UIBarButtonItem *rewindBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(rewindAction)];
    
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:stopBarButtonItem, refreshBarButtonItem, composeBarButtonItem, flexibleSpace, forwardBarButtonItem, rewindBarButtonItem, nil];
    
    NSURL *url = [NSURL URLWithString:@"http://canvas.brown.edu"];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:urlRequest];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.pageTitle.text isEqualToString:@"Brown University Authentication for Web-Based Services"])
    {
        [self insertCredentialsWithWebView:self.webView];
    }
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
    
    self.currentURL = [webView.request.URL absoluteString];
    
    self.interactionController.URL = [NSURL fileURLWithPath:self.currentURL];
    if ([[self.currentURL substringFromIndex:(self.currentURL.length - 4)] isEqualToString:@".pdf"]) {
        [self toggleOpenInButtonOn:YES];
    } else {
        NSLog(@"ispdf else fired");
        [self toggleOpenInButtonOn:NO];
    }
    
    if ([self.pageTitle.text isEqualToString:@"Canvas"]){
        self.isLoggedIn = NO;
    }
    if (!self.isLoggedIn) {
        [self insertCredentialsWithWebView:webView];
        self.isLoggedIn = YES;
    }
    
    NSMutableString *html = [NSMutableString stringWithString:[webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"]];
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)html, NULL, transform, YES);
    
    [self.htmlParser updateLinksArrayWithHTML:html];
}

-(void)rewindAction
{
    [self.webView goBack];
}

-(void)forwardAction
{
    [self.webView goForward];
}

-(void)openInAction
{
    [self.interactionController presentOpenInMenuFromBarButtonItem:self.openInBarButtonItem animated:YES];
}

-(void)composeAction
{
    [self setCanvasURL];
    [self loadRequestFromString:self.canvasURL];
}

-(void)refreshAction
{
    [self.webView reload];
}

-(void)stopAction
{
    [self.webView stopLoading];
}

#pragma mark - Private methods

- (void)toggleOpenInButtonOn:(BOOL)on;
{
    NSMutableArray *rightBarButtonItems = [NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
    
    if ([rightBarButtonItems containsObject:self.openInBarButtonItem] && !on) {
        [rightBarButtonItems removeObject:self.openInBarButtonItem];
        NSLog(@"containsobject fired");
    } else if (![rightBarButtonItems containsObject:self.openInBarButtonItem] && on) {
        [rightBarButtonItems insertObject:self.openInBarButtonItem atIndex:3];
    }
    
    [self.navigationItem setRightBarButtonItems:rightBarButtonItems animated:YES];
    NSLog(@"%@", self.navigationItem.rightBarButtonItems);
}

- (void)insertCredentialsWithWebView:(UIWebView *)webView
{
    NSString *path = [AMSSettingsFileManager settingsPath];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSString* userId = [settings objectForKey:@"canvasUsername"];
    NSString* password =  [settings objectForKey:@"canvasPassword"];
    
    if(userId != nil && password != nil ){
        
        NSString*  jScriptString1 = [NSString  stringWithFormat:@"document.getElementById('username').value='%@'", userId];
        NSString*  jScriptString2 = [NSString stringWithFormat:@"document.getElementById('password').value='%@'", password];
        
        [webView stringByEvaluatingJavaScriptFromString:jScriptString1];
        [webView stringByEvaluatingJavaScriptFromString:jScriptString2];
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('button')[0].click()"];
        
    }
}

- (void)setCanvasURL
{
    NSString *path = [AMSSettingsFileManager settingsPath];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSNumber *indexNumber = [settings objectForKey:@"year"];
    NSUInteger index = [indexNumber integerValue];
    switch (index) {
        case 0:
            self.canvasURL = @"https://canvas.brown.edu/courses/641699";
            break;
        case 1:
            self.canvasURL = @"https://canvas.brown.edu/courses/641699";
            break;
        case 2:
            self.canvasURL = @"https://canvas.brown.edu/courses/801524";
            break;
        case 3:
            self.canvasURL = @"https://canvas.brown.edu/courses/641699";
            break;
        default:
            break;
    }
}


@end
