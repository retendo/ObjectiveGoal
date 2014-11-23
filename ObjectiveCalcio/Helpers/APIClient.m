//
//  APIClient.m
//  ObjectiveCalcio
//
//  Created by Martin Richter on 22/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "APIClient.h"
#import "Match.h"

@interface APIClient ()

@property (nonatomic, copy) NSArray *matches;

@end

@implementation APIClient

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    _matches = @[];

    return self;
}

- (RACSignal *)fetchMatches {
    return [[RACSignal return:self.matches] delay:1];
}

- (void)createMatchWithHomePlayers:(NSString *)homePlayers awayPlayers:(NSString *)awayPlayers homeGoals:(NSUInteger)homeGoals awayGoals:(NSUInteger)awayGoals {
    Match *newMatch = [[Match alloc] initWithHomePlayers:homePlayers awayPlayers:awayPlayers homeGoals:homeGoals awayGoals:awayGoals];
    self.matches = [self.matches arrayByAddingObject:newMatch];
}

@end
