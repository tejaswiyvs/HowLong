//
//  TYSettingsWindowController.m
//  HowLong
//
//  Created by Tejaswi Yerukalapudi on 9/11/12.
//  Copyright (c) 2012 Tejaswi Yerukalapudi. All rights reserved.
//

#import "TYSettingsWindowController.h"
#import "Constants.h"

@interface TYSettingsWindowController ()
-(void) populateData;
-(void) postNotification;
-(BOOL) showTweetsStatus;
@end

@implementation TYSettingsWindowController

NSString * const kSettingsUpdatedNotification = @"settings_updated";

-(id) init {
    self = [super initWithWindowNibName:@"SettingsWindow"];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.shouldShowMessage = [[defaults objectForKey:kTweetEnabledKey] boolValue];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self populateData];
}

-(IBAction)saveButtonClicked:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Update birthdate
    NSDate *birthDate = [self.birthDatePicker dateValue];
    if (birthDate) {
        [defaults setObject:birthDate forKey:kBirthDateKey];
    }
    
    // Update bucketlist url
    NSString *bucketListUrl = [self.bucketListTxtField stringValue];
    [defaults setObject:bucketListUrl forKey:kBucketListUrlKey];
    
    self.shouldShowMessage = [self showTweetsStatus];
    [defaults setObject:[NSNumber numberWithBool:self.shouldShowMessage] forKey:kTweetEnabledKey];
    [defaults synchronize];
    
    // Post Notification so that the App Delegate updates the UI
    [self postNotification];
    
    // Hide self.
    [self hide];
}

-(IBAction)cancelButtonClicked:(id)sender {
    [self hide];
}

-(void) show {
    [self.window makeKeyAndOrderFront:NSApp];
    [NSApp activateIgnoringOtherApps:YES];
}

-(void) hide {
    [self.window close];
}

-(void) populateData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *birthDate = [defaults objectForKey:kBirthDateKey];
    NSString *bucketListUrl = [defaults objectForKey:kBucketListUrlKey];
    self.shouldShowMessage = [[defaults objectForKey:kTweetEnabledKey] boolValue];
    
    if (birthDate) {
        [self.birthDatePicker setDateValue:birthDate];
    }
    if (bucketListUrl && ![bucketListUrl isEqualToString:@""]) {
        [self.bucketListTxtField setStringValue:bucketListUrl];
    }
    [self.showTweetsBtn setState:NSOffState];
    if (self.shouldShowMessage) {
        [self.showTweetsBtn setState:NSOnState];
    }
    else {
        [self.showTweetsBtn setState:NSOffState];
    }
}

-(void) postNotification {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kSettingsUpdatedNotification object:nil]];
}

-(BOOL) showTweetsStatus {
    return (self.showTweetsBtn.state == NSOnState);
}

@end
