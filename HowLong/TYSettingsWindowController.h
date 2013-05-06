//
//  TYSettingsWindowController.h
//  HowLong
//
//  Created by Tejaswi Yerukalapudi on 9/11/12.
//  Copyright (c) 2012 Tejaswi Yerukalapudi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TYTweetManager.h"

NSString * const kSettingsUpdatedNotification;

@interface TYSettingsWindowController : NSWindowController<NSWindowDelegate>

@property (nonatomic, strong) IBOutlet NSTextField *bucketListTxtField;
@property (nonatomic, strong) IBOutlet NSDatePicker *birthDatePicker;
@property (nonatomic, strong) IBOutlet NSButton *showTweetsBtn;
@property (nonatomic, assign) BOOL shouldShowTweets;
@property (nonatomic, strong) TYTweetManager *tweetManager;

-(IBAction)saveButtonClicked:(id)sender;
-(IBAction)cancelButtonClicked:(id)sender;

-(void) show;
-(void) hide;

@end
