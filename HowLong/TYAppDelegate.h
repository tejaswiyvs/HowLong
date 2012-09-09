//
//  TYAppDelegate.h
//  HowLong
//
//  Created by Tejaswi Yerukalapudi on 9/8/12.
//  Copyright (c) 2012 Tejaswi Yerukalapudi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TYTimeManager.h"

@interface TYAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic, strong) IBOutlet NSMenu *menu;
@property (nonatomic, strong) NSStatusItem *statusMenuItem;
@property (nonatomic, strong) TYTimeManager *manager;

-(IBAction)openBucketListItemClicked:(id)sender;
-(IBAction)setBirthDateItemClicked:(id)sender;
-(IBAction)quitItemClicked:(id)sender;
@end
