//
//  TYSettingsWindowController.h
//  HowLong
//
//  Created by Tejaswi Yerukalapudi on 9/11/12.
//  Copyright (c) 2012 Tejaswi Yerukalapudi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TYMessageManager.h"

NSString * const kSettingsUpdatedNotification;

@interface TYSettingsWindowController : NSWindowController<NSWindowDelegate>

@property (nonatomic, strong) IBOutlet NSTextField *bucketListTxtField;
@property (nonatomic, strong) IBOutlet NSDatePicker *birthDatePicker;
@property (nonatomic, strong) IBOutlet NSButton *showTweetsBtn;
//this is read asynchronously by the app delegate
@property (atomic) BOOL shouldShowMessage;

-(IBAction)saveButtonClicked:(id)sender;
-(IBAction)cancelButtonClicked:(id)sender;

-(void) show;
-(void) hide;

@end
