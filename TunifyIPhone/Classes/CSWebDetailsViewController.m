//
//  CSWebDetailsViewController.m
//  mapLines
//
//  Created by Craig on 5/31/09.
//  Copyright 2009 Craig Spitzkoff. All rights reserved.
//

#import "CSWebDetailsViewController.h"


@implementation CSWebDetailsViewController
@synthesize url = _url;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	// load the contents of the url
	[_webView loadRequest:[NSURLRequest requestWithURL:_url]];
	
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(IBAction) donePressed:(id)sender
{
	[self.view removeFromSuperview];
}

#pragma mark UIWebViewDelegate methods
- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[_activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[_activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[_activityIndicator stopAnimating];
	
	NSLog(@"Error Loading web page");
}

- (void)dealloc {
    
	[_webView    release];
	[_url        release];
	
	[super dealloc];
}


@end
