//
//  ViewController.m
//  LogDeviceInfoJsContext
//
//  Created by Dimitar Danailov on 7/14/17.
//  Copyright © 2017 Dimitar Danailov. All rights reserved.
//

#import "ViewController.h"

#import "DeviceInformationCollector.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    webView.delegate = self;
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
    
    [self.view addSubview:webView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //Check here if still webview is loding the content
    if (webView.isLoading) return;
    
    //after code when webview finishes
    NSLog(@"Webview loding finished");
    
    DeviceInformationCollector *deviceCollector = [[DeviceInformationCollector alloc] init];
    
    NSLog(@"DeviceInformationCollector ----------- ");
    NSLog(@"Device Id -  %@", deviceCollector.deviceId);
    NSLog(@"Device name -  %@", deviceCollector.deviceName);
    NSLog(@"Username -  %@", deviceCollector.username);
    NSLog(@"Device system - %@", deviceCollector.deviceSystem);
    NSLog(@"Device system version - %@", deviceCollector.deviceSystemVersion);
    NSLog(@" ip address - %@", deviceCollector.ipAddress);
    NSLog(@"----------- ");

    // get JSContext from UIWebView instance
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // enable error logging
    [context setExceptionHandler:^(JSContext *context, JSValue *value) {
        NSLog(@"WEB JS: %@", value);
    }];

    
    context[@"deviceCollector"] = deviceCollector;
}


@end
