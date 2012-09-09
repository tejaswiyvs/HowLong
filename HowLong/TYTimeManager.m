//
//  TYTimeManager.m
//  HowLong
//
//  Created by Tejaswi Yerukalapudi on 9/8/12.
//  Copyright (c) 2012 Tejaswi Yerukalapudi. All rights reserved.
//

#import "TYTimeManager.h"

@interface TYTimeManager ()
-(long) ageFromBirthDate:(NSDate *) birthDate;
-(long) hoursLeftFromBirthDate:(NSDate *) birthDate;
-(NSDate *) dateByAddingYears:(int) years toBirthDate:(NSDate *) birthDate;
@end

@implementation TYTimeManager

@synthesize birthDate = _birthDate;
@synthesize hoursLeft = _countDownTimer;
@synthesize percentageComplete = _percentageComplete;

static NSString * const kBirthDateKey = @"birth_date";

static const int kMaxYears = 30;
static const int kGoodYears = 10;
static const float kTimerRefreshRate = 3600.0f;

-(id) init {
    self = [super init];
    if (self) {
//        self.birthDate = [[NSUserDefaults standardUserDefaults] objectForKey:kBirthDateKey];
        // Load to my birthdate by default, add a picker sometime later.
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        self.birthDate = [formatter dateFromString:@"01/03/1987"];
        self.hoursLeft = [self hoursLeftFromBirthDate:self.birthDate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerRefreshRate target:self selector:@selector(refreshHoursLeft:) userInfo:nil repeats:YES];
    }
    return self;
}

#pragma mark - Helpers

-(float) percentageComplete {
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

-(void) refreshHoursLeft:(id) sender {
    self.hoursLeft = [self hoursLeftFromBirthDate:self.birthDate];
}

-(long) hoursLeftFromBirthDate:(NSDate *) birthDate {
    if (!birthDate || [self ageFromBirthDate:birthDate] >= 30) {
        return 0;
    }
    NSDate *lifeEndsAtDate = [self dateByAddingYears:kMaxYears toBirthDate:birthDate];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger flags = NSHourCalendarUnit;
    NSDateComponents *components = [calendar components:flags
                                               fromDate:[[NSDate alloc] init]
                                                 toDate:lifeEndsAtDate
                                                options:0];
    return [components hour];
}

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
