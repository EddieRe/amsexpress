//
//  AMSCalendarViewController.m
//  AMS Express
//
//  Created by Eddie Re on 7/31/14.
//  Copyright (c) 2014 Alpert Medical School. All rights reserved.
//

#import "AMSCalendarViewController.h"

@interface AMSCalendarViewController ()
@property BOOL isLoading;
@property NSString *calendarURL;

@end

@implementation AMSCalendarViewController

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
    [self loadRequestFromString:self.calendarURL];
}

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
- (IBAction)homeAction:(id)sender {
    [self loadRequestFromString:self.calendarURL];
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

- (void)setCalendarURL
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    NSLog(@"%@", path);
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSNumber *indexNumber = [settings objectForKey:@"year"];
    NSUInteger index = [indexNumber integerValue];
    switch (index) {
        case 0:
            self.calendarURL = @"https://www.google.com/calendar/embed?mode=AGENDA&height=600&wkst=1&bgcolor=%23FFFFFF&src=brown.edu_4sn3cqe9ttnuai8qspo2qdqc84%40group.calendar.google.com&color=%23182C57&ctz=America%2FNew_York";
            break;
        case 1:
            self.calendarURL = @"https://www.google.com/calendar/embed?mode=AGENDA&height=600&wkst=1&bgcolor=%23FFFFFF&src=brown.edu_f4se52ubvu18js8kiv41sjrhqo%40group.calendar.google.com&color=%2329527A&ctz=America%2FNew_York";
            break;
        case 2:
            self.calendarURL = @"https://www.google.com/calendar/embed?mode=AGENDA&height=600&wkst=1&bgcolor=%23FFFFFF&src=brown.edu_ttutoa6671kcod39l4aqnpe3ig%40group.calendar.google.com&color=%231B887A&ctz=America%2FNew_York";
            break;
        case 3:
            self.calendarURL = @"https://www.google.com/calendar/embed?mode=AGENDA&height=600&wkst=1&bgcolor=%23FFFFFF&src=brown.edu_ttutoa6671kcod39l4aqnpe3ig%40group.calendar.google.com&color=%231B887A&ctz=America%2FNew_York";
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

@end
