//
//  TYAppDelegate.m
//  HowLong
//
//  Created by Tejaswi Yerukalapudi on 9/8/12.
//  Copyright (c) 2012 Tejaswi Yerukalapudi. All rights reserved.
//

#import "TYAppDelegate.h"
#import "TYTimeManager.h"
#import "TYMessageManager.h"
#import "TYSettingsWindowController.h"
#import "Constants.h"


@interface TYAppDelegate ()<NSUserNotificationCenterDelegate>

// Menu items
@property (nonatomic, strong) IBOutlet NSMenu *menu;
@property (nonatomic, strong) IBOutlet NSMenuItem *setBirthDateItem;
@property (nonatomic, strong) NSStatusItem *statusMenuItem;

@property (nonatomic, strong) TYTimeManager *timeManager;
@property (nonatomic, strong) TYMessageManager *messageManager;
@property (nonatomic, strong) TYSettingsWindowController *settingsController;

-(void) refreshStatusText;
-(void) settingsNotificationFired:(NSNotification *) notification;
@end

@implementation TYAppDelegate

const int kWindowWidth = 600;
const int kWindowHeight = 400;

-(void) awakeFromNib {
    self.timeManager = [[TYTimeManager alloc] init];
    [self.timeManager addObserver:self forKeyPath:@"hoursLeft" options:0 context:NULL];
    
    self.messageManager = [[TYMessageManager alloc] init];
    
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

-(void)applicationDidFinishLaunching:(NSNotification *)notification {
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
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

-(IBAction)showMessageItemClicked:(id)sender {
    TYMessage *message = [self.messageManager randomMessage];
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:@[message.message] forKeys:@[@"full-message"]];

    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"A 30th Birthday Message!";
    notification.informativeText = message.message;
    notification.userInfo = userInfo;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    
    
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
    [self.statusMenuItem setTitle:[NSString stringWithFormat:@"%2.2f%%", self.timeManager.percentageComplete]];
}

#pragma mark - Notification Center delegate

-(BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}

-(void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:notification.userInfo[@"full-message"]];
    [alert runModal];
}


@end
