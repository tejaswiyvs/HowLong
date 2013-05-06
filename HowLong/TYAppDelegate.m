//
//  TYAppDelegate.m
//  HowLong
//
//  Created by Tejaswi Yerukalapudi on 9/8/12.
//  Copyright (c) 2012 Tejaswi Yerukalapudi. All rights reserved.
//

#import "TYAppDelegate.h"
#import "TYTimeManager.h"
#import "TYSettingsWindowController.h"
#import "Constants.h"


@interface TYAppDelegate ()
-(void) refreshStatusText;
-(void) settingsNotificationFired:(NSNotification *) notification;
@end

@implementation TYAppDelegate

@synthesize statusMenuItem = _statusMenuItem;
@synthesize setBirthDateItem = _setBirthDateItem;
@synthesize menu = _menu;
@synthesize manager = _manager;

const int kWindowWidth = 600;
const int kWindowHeight = 400;

-(void) awakeFromNib
{
    self.manager = [[TYTimeManager alloc] init];
    [self.manager addObserver:self forKeyPath:@"hoursLeft" options:0 context:NULL];
    
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    
    // Populate the status item with values percentage and hours left
    self.statusMenuItem = [statusBar statusItemWithLength:NSVariableStatusItemLength];
    [self.statusMenuItem setHighlightMode:YES];
    self.statusMenuItem.menu = self.menu;
    [self refreshStatusText];
    
    // Register for notifications
    if (!self.settingsController) {
        self.settingsController = [[TYSettingsWindowController alloc] init];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsNotificationFired:) name:kSettingsUpdatedNotification object:nil];
}

-(void)applicationDidBecomeActive:(NSNotification *)notification {
    [self refreshStatusText];
}

#pragma mark - NSNotificationHandler

-(void) settingsNotificationFired:(NSNotification *) notification {
    if ([notification.name isEqualToString:kSettingsUpdatedNotification]) {
        [self refreshStatusText];
    }
}

#pragma mark - Event Handlers

-(IBAction)openBucketListItemClicked:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *bucketListUrl = [defaults objectForKey:kBucketListUrlKey];
    if (bucketListUrl) {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:bucketListUrl]];
    }
}

-(IBAction)setBirthDateItemClicked:(id)sender {
    if (!self.settingsController) {
        self.settingsController = [[TYSettingsWindowController alloc] init];
    }
    [self.settingsController show];
}

-(IBAction)quitItemClicked:(id)sender {
    [NSApp terminate:self];
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self refreshStatusText];
}

#pragma mark - Helpers

-(void) refreshStatusText {
    [self.statusMenuItem setTitle:[NSString stringWithFormat:@"%2.2f%% | %.6ld hrs", self.manager.percentageComplete, self.manager.hoursLeft]];
}

@end
