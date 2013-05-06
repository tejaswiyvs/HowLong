//
//  TYTweetManager.m
//  HowLong
//
//  Created by Teja on 10/31/12.
//  Copyright (c) 2012 Tejaswi Yerukalapudi. All rights reserved.
//

#import "TYTweetManager.h"
#import "AFNetworking.h"

@interface TYTweet : NSObject

@property (nonatomic, strong) NSString *tweetId;
@property (nonatomic, strong) NSDate *tweetDate;
@property (nonatomic, strong) NSString *tweet;

-(id) initWithDictionary:(NSDictionary *) dictionary;

@end

@implementation TYTweet

@synthesize tweetId, tweetDate, tweet;

-(id) initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        self.tweetId = [dictionary objectForKey:@"tweet_id"];
        NSString *tweetDateStr = [dictionary objectForKey:@"tweet_date"];
        self.tweetDate = [[NSDate alloc] initWithTimeIntervalSince1970:[tweetDateStr longLongValue]];
        self.tweet = [dictionary objectForKey:@"tweet"];
    }
    return self;
}

@end

@implementation TYTweetManager

NSString * const kTweetJSONURL = @"http://dl.dropbox.com/u/226724/tweets.json";
NSString * const kNotificationKey = @"notification_key";

@synthesize tweets = _tweets;
@synthesize notification = _notification;

-(id) init {
    self = [super init];
    if (self) {
        self.tweets = [NSMutableArray array];
        self.notification = [[NSUserDefaults standardUserDefaults] objectForKey:kNotificationKey];
        [self loadTweets];
    }
    return self;
}

-(void) dealloc {
    if (self.notification) {
        [[NSUserDefaults standardUserDefaults] setObject:self.notification forKey:kNotificationKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void) loadTweets {
    NSURL *url = [NSURL URLWithString:kTweetJSONURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray *results = (NSArray *) JSON;
        for (NSDictionary *result in results) {
            TYTweet *tweet = [[TYTweet alloc] initWithDictionary:result];
            [self.tweets addObject:tweet];
        }
        
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@ - %@ - %@", response, error, JSON);
    }];
    [operation start];
}

-(TYTweet *) randomTweet {
    return (self.tweets.count > 0) ? [self.tweets objectAtIndex:(arc4random() % ([self.tweets count] + 1))] : nil;
}

-(void) startNotifications {
    TYTweet *tweet = [self randomTweet];
    if (tweet && !self.notification) {
        // Temp notification now. This is just for instant gratification so that the user sees a notification as soon as they enable them.
        
        NSUserNotification *tempNotification = [[NSUserNotification alloc] init];
        tempNotification.title = @"Hello, World!";
        tempNotification.informativeText = tweet.tweet;
        
        // Permanent notification. Schedule for 9:00AM from next day.
        self.notification = [[NSUserNotification alloc] init];
        self.notification.title = @"Hello, World!";
        self.notification.informativeText = tweet.tweet;
        self.notification.deliveryDate = [self nineAmNextDay];
        self.notification.soundName = NSUserNotificationDefaultSoundName;
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay:1];
        self.notification.deliveryRepeatInterval = components;
        [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:self.notification];
    }
}

-(void) stopNotifications {
    if (self.notification) {
        [[NSUserNotificationCenter defaultUserNotificationCenter] removeScheduledNotification:self.notification];
        self.notification = nil;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kNotificationKey];
    }
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
