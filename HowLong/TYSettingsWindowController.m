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
@end

@implementation TYSettingsWindowController

NSString * const kSettingsUpdatedNotification = @"settings_updated";

@synthesize bucketListTxtField = _bucketListTxtField;
@synthesize birthDatePicker = _birthDatePicker;

-(id) init {
    return [super initWithWindowNibName:@"SettingsWindow"];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self populateData];
}

-(IBAction)saveButtonClicked:(id)sender {
    [self hide];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *birthDate = [self.birthDatePicker dateValue];
    if (birthDate) {
        [defaults setObject:birthDate forKey:kBirthDateKey];
    }
    
    NSString *bucketListUrl = [self.bucketListTxtField stringValue];
    [defaults setObject:bucketListUrl forKey:kBucketListUrlKey];
    [self hide];
}

-(IBAction)cancelButtonClicked:(id)sender {
    [self hide];
}

-(void) show {
    [self populateData];
    [self.window makeKeyAndOrderFront:NSApp];
}

-(void) hide {
    [self.window close];
}

-(void) populateData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *birthDate = [defaults objectForKey:kBirthDateKey];
    NSString *bucketListUrl = [defaults objectForKey:kBucketListUrlKey];
    
    if (birthDate) {
        [self.birthDatePicker setDateValue:birthDate];
    }
    if (bucketListUrl && ![bucketListUrl isEqualToString:@""]) {
        [self.bucketListTxtField setStringValue:bucketListUrl];
    }
}

@end
