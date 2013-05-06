//
//  TYTweetManager.h
//  HowLong
//
//  Created by Teja on 10/31/12.
//  Copyright (c) 2012 Tejaswi Yerukalapudi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYTweetManager : NSObject

@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) NSUserNotification *notification;

-(void) startNotifications;
-(void) stopNotifications;

@end
