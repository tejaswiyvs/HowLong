//
//  TYTimeManager.h
//  HowLong
//
//  Created by Tejaswi Yerukalapudi on 9/8/12.
//  Copyright (c) 2012 Tejaswi Yerukalapudi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYTimeManager : NSObject

@property (nonatomic, assign) NSDate *birthDate;
@property (nonatomic, assign) long hoursLeft;
@property (nonatomic, assign) float percentageComplete;
@property (nonatomic, strong) NSTimer *timer;

@end
