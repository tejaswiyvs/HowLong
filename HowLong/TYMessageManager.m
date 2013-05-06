//
//  TYTweetManager.m
//  HowLong
//
//  Created by Teja on 10/31/12.
//  Copyright (c) 2012 Tejaswi Yerukalapudi. All rights reserved.
//

#import "TYMessageManager.h"
#import "AFNetworking.h"

@implementation TYMessage

-(id) initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        self.url = dictionary[@"url"];
        self.message = dictionary[@"message"];
    }
    return self;
}

@end

@implementation TYMessageManager

NSString * const kTweetJSONURL = @"https://dl.dropbox.com/s/ciouz6obohsn3kv/messages.json";

-(id) init {
    self = [super init];
    if (self) {
        self.messages = [NSMutableArray array];
        [self loadMessages];
    }
    return self;
}

-(void) dealloc {
}

-(void) loadMessages {
    NSURL *url = [NSURL URLWithString:kTweetJSONURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray *results = (NSArray *) JSON;
        
        for (NSDictionary *result in results) {
            TYMessage *tweet = [[TYMessage alloc] initWithDictionary:result];
            [self.messages addObject:tweet];
        }
        
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@ - %@ - %@", response, error, JSON);
    }];
    [operation start];
}

-(TYMessage *) randomMessage {
    return (self.messages.count > 0) ? [self.messages objectAtIndex:(arc4random() % [self.messages count])] : nil;
}

-(NSDate *) nineAmNextDay {
    NSDate *yourDate = [[NSDate alloc] init];
    // start by retrieving day, weekday, month and year components for yourDate
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:yourDate];
    NSInteger theDay = [todayComponents day];
    NSInteger theMonth = [todayComponents month];
    NSInteger theYear = [todayComponents year];
    
    // now build a NSDate object for yourDate using these components
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:(theDay + 1)];
    [components setMonth:theMonth];
    [components setYear:theYear];
    [components setHour:9];
    
    return [gregorian dateFromComponents:components];
}
@end
