//
//  APIClient.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 22/11/14.
//  Copyright (c) 2014 Martin Richter. All rights reserved.
//

#import "APIClient.h"
#import "Match.h"
#import "Player.h"

static NSString * const APIClientUserDefaultsKeyMatches = @"Matches";
static NSString * const APIClientUserDefaultsKeyPlayers = @"Players";
static NSTimeInterval const APIClientFakeLatency = 0.5;

@interface APIClient ()

@property (nonatomic, copy) NSArray *matches;
@property (nonatomic, copy) NSArray *players;

@end

@implementation APIClient

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    _matches = [self persistedMatches];
    _players = [self persistedPlayers];

    return self;
}

#pragma mark - Matches

- (RACSignal *)fetchMatches {
    return [[RACSignal return:self.matches] delay:APIClientFakeLatency];
}

- (RACSignal *)createMatchWithHomePlayers:(NSSet *)homePlayers awayPlayers:(NSSet *)awayPlayers homeGoals:(NSUInteger)homeGoals awayGoals:(NSUInteger)awayGoals {
    Match *newMatch = [[Match alloc] initWithHomePlayers:homePlayers awayPlayers:awayPlayers homeGoals:homeGoals awayGoals:awayGoals];

    self.matches = [self.matches arrayByAddingObject:newMatch];
    return [[RACSignal return:@(YES)] delay:APIClientFakeLatency];
}

#pragma mark - Players

- (RACSignal *)fetchPlayers {
    return [[RACSignal return:self.players] delay:APIClientFakeLatency];
}

- (RACSignal *)createPlayerWithName:(NSString *)name {
    Player *newPlayer = [[Player alloc] initWithIdentifier:[NSUUID UUID].UUIDString name:name];

    self.players = [self.players arrayByAddingObject:newPlayer];
    return [[RACSignal return:@(YES)] delay:APIClientFakeLatency];
}

#pragma mark - Persistence

- (void)persist {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSData *archivedMatches = [NSKeyedArchiver archivedDataWithRootObject:self.matches];
    [userDefaults setObject:archivedMatches forKey:APIClientUserDefaultsKeyMatches];

    NSData *archivedPlayers = [NSKeyedArchiver archivedDataWithRootObject:self.players];
    [userDefaults setObject:archivedPlayers forKey:APIClientUserDefaultsKeyPlayers];

    [userDefaults synchronize];
}

- (NSArray *)persistedMatches {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *archivedMatches = [userDefaults objectForKey:APIClientUserDefaultsKeyMatches];

    return (archivedMatches
            ? [NSKeyedUnarchiver unarchiveObjectWithData:archivedMatches]
            : @[]);
}

- (NSArray *)persistedPlayers {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *archivedPlayers = [userDefaults objectForKey:APIClientUserDefaultsKeyPlayers];

    if (archivedPlayers) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:archivedPlayers];
    } else {
        return @[
            [[Player alloc] initWithIdentifier:[NSUUID UUID].UUIDString name:@"Alice"],
            [[Player alloc] initWithIdentifier:[NSUUID UUID].UUIDString name:@"Bob"],
            [[Player alloc] initWithIdentifier:[NSUUID UUID].UUIDString name:@"Charlie"],
            [[Player alloc] initWithIdentifier:[NSUUID UUID].UUIDString name:@"Dora"]
        ];
    }
}

@end
