//
//  Changeset.m
//  ObjectiveGoal
//
//  Created by Martin Richter on 20/01/15.
//  Copyright (c) 2015 Martin Richter. All rights reserved.
//

#import <UIKit/UITableView.h>
#import "Changeset.h"
#import <BlocksKit/NSArray+BlocksKit.h>

@implementation Changeset

#pragma mark - Lifecycle

- (instancetype)initWithDeletions:(NSArray *)deletions insertions:(NSArray *)insertions {
    NSParameterAssert([deletions isKindOfClass:NSArray.class]);
    NSParameterAssert([insertions isKindOfClass:NSArray.class]);

    self = [super init];
    if (!self) return nil;

    _deletions = [deletions copy];
    _insertions = [insertions copy];

    return self;
}

#pragma mark - Match Changesets

+ (Changeset *)changesetOfIndexPathsFromItems:(NSArray *)oldItems toItems:(NSArray *)newItems
{
    NSMutableArray *mutableDeletions = [NSMutableArray array];
    NSMutableArray *mutableInsertions = [NSMutableArray array];

    [oldItems enumerateObjectsUsingBlock:^(NSObject *item, NSUInteger index, BOOL *stop) {
        if (![newItems containsObject:item]) {
            [mutableDeletions addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        }
    }];

    [newItems enumerateObjectsUsingBlock:^(NSObject *item, NSUInteger index, BOOL *stop) {
        if (![oldItems containsObject:item]) {
            [mutableInsertions addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        }
    }];

    NSArray *deletions = [mutableDeletions copy];
    NSArray *insertions = [mutableInsertions copy];

    return [[Changeset alloc] initWithDeletions:deletions insertions:insertions];
}

@end
