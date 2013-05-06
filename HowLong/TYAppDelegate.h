//
//  TYAppDelegate.h
//  HowLong
//
//  Created by Tejaswi Yerukalapudi on 9/8/12.
//  Copyright (c) 2012 Tejaswi Yerukalapudi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TYTimeManager.h"
#import "TYSettingsWindowController.h"

@interface TYAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

// Menu items
@property (nonatomic, strong) IBOutlet NSMenu *menu;
@property (nonatomic, strong) IBOutlet NSMenuItem *setBirthDateItem;
@property (nonatomic, strong) NSStatusItem *statusMenuItem;

@property (nonatomic, strong) TYTimeManager *manager;
@property (nonatomic, strong) TYSettingsWindowController *settingsController;

-(IBAction)openBucketListItemClicked:(id)sender;
-(IBAction)setBirthDateItemClicked:(id)sender;
-(IBAction)quitItemClicked:(id)sender;

@end
