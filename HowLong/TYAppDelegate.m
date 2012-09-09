//
//  TYAppDelegate.m
//  HowLong
//
//  Created by Tejaswi Yerukalapudi on 9/8/12.
//  Copyright (c) 2012 Tejaswi Yerukalapudi. All rights reserved.
//

#import "TYAppDelegate.h"
#import "TYTimeManager.h"

@implementation TYAppDelegate

@synthesize statusMenuItem = _statusMenuItem;
@synthesize menu = _menu;
@synthesize manager = _manager;

static NSString * const kBucketListUrl = @"https://docs.google.com/document/d/1kJ91CM0xfvUdgTXnii0sKZ9cDJwMYv7Yal2scNlycp4";

-(void) awakeFromNib
{
    // Insert code here to initialize your application
    self.manager = [[TYTimeManager alloc] init];
    [self.manager addObserver:self forKeyPath:@"hoursLeft" options:0 context:NULL];
    
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    self.statusMenuItem = [statusBar statusItemWithLength:NSVariableStatusItemLength];
    [self.statusMenuItem setTitle:[NSString stringWithFormat:@"%2.2f | %ld", self.manager.percentageComplete, self.manager.hoursLeft]];
    [self.statusMenuItem setHighlightMode:YES];
    self.statusMenuItem.menu = self.menu;
}

#pragma mark - Event Handlers

-(IBAction)openBucketListItemClicked:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:kBucketListUrl]];
}

-(IBAction)setBirthDateItemClicked:(id)sender {

}

-(IBAction)quitItemClicked:(id)sender {
    [NSApp terminate:self];
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self.statusMenuItem setTitle:[NSString stringWithFormat:@"%2.2f | %.6ld", self.manager.percentageComplete, self.manager.hoursLeft]];
}

#pragma mark - Helpers

@end
