//
//  TYTimeManager.m
//  HowLong
//
//  Created by Tejaswi Yerukalapudi on 9/8/12.
//  Copyright (c) 2012 Tejaswi Yerukalapudi. All rights reserved.
//

#import "TYTimeManager.h"
#import "Constants.h"

@interface TYTimeManager ()
-(long) ageFromBirthDate:(NSDate *) birthDate;
-(NSDate *) dateByAddingYears:(int) years toBirthDate:(NSDate *) birthDate;
@end

@implementation TYTimeManager

@synthesize birthDate = _birthDate;
@synthesize hoursLeft = _hoursLeft;
@synthesize percentageComplete = _percentageComplete;

static const int kMaxYears = 30;
static const int kGoodYears = 10;
static const float kTimerRefreshRate = 3600.0f;

-(id) init {
    self = [super init];
    if (self) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerRefreshRate target:self selector:@selector(refreshHoursLeft:) userInfo:nil repeats:YES];
    }
    return self;
}

#pragma mark - Getters

-(float) percentageComplete {
    if (!self.birthDate) {
        return 0.0f;
    }

    NSCalendar *calender = [NSCalendar currentCalendar];
    long age = [self ageFromBirthDate:self.birthDate];
    if (age >= 30) {
        return 100.0f;
    }
    if (age < 20) {
        return 0.0f;
    }
    
    NSDate *dateWhenTwenty = [self dateByAddingYears:20 toBirthDate:self.birthDate];
    NSDate *dateWhenThirty = [self dateByAddingYears:30 toBirthDate:self.birthDate];
    NSDate *now = [[NSDate alloc] init];
    NSUInteger flags = NSHourCalendarUnit;
    NSDateComponents *completeComponents = [calender components:flags fromDate:dateWhenTwenty toDate:now options:0];
    NSDateComponents *remainingComponents = [calender components:flags fromDate:now toDate:dateWhenThirty options:0];
    
    float completeHours = [completeComponents hour];
    float remainingHours = [remainingComponents hour];
    return (remainingHours / (completeHours + remainingHours)) * 100;
}

-(long) hoursLeft {
    if (!self.birthDate || [self ageFromBirthDate:self.birthDate] >= 30) {
        return 0;
    }
    NSDate *lifeEndsAtDate = [self dateByAddingYears:kMaxYears toBirthDate:self.birthDate];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger flags = NSHourCalendarUnit;
    NSDateComponents *components = [calendar components:flags
                                               fromDate:[[NSDate alloc] init]
                                                 toDate:lifeEndsAtDate
                                                options:0];
    return [components hour];
}

-(NSDate *) birthDate {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kBirthDateKey];
}

#pragma mark - Helpers

-(long) ageFromBirthDate:(NSDate *) birthDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:birthDate];
    
    if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
        (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day]))) {
        return [dateComponentsNow year] - [dateComponentsBirth year] - 1;
    } else {
        return [dateComponentsNow year] - [dateComponentsBirth year];
    }
}

-(NSDate *) dateByAddingYears:(int) years toBirthDate:(NSDate *) birthDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *addComponents = [[NSDateComponents alloc] init];
    addComponents.year = years;
    return [calendar dateByAddingComponents:addComponents toDate:birthDate options:0];
}

@end
