//
//  TYTweetManager.h
//  HowLong
//
//  Created by Teja on 10/31/12.
//  Copyright (c) 2012 Tejaswi Yerukalapudi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYMessage : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *message;

-(id) initWithDictionary:(NSDictionary *) dictionary;

@end

@interface TYMessageManager : NSObject

//AFNetworking downloads tweets in the background when loadMessages is called
@property (atomic, strong) NSMutableArray *messages;

-(void) loadMessages;
-(TYMessage *) randomMessage;

@end
