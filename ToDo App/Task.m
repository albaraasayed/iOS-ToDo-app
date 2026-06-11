//
//  Task.m
//  ToDo App
//
//  Created by albaraa alsayed on 11/11/1447 AH.
//

#import <Foundation/Foundation.h>
#import "Task.h"

@implementation Task

-(Task*) init {
    _isDone = NO;
    _isInProgress = NO;
    return self;
}

- (NSDictionary *)toDictionary {
    return @{
        @"name": self.name ?: @"",
        @"desc": self.desc ?: @"",
        @"priority": @(self.priority),
        @"isDone": @(self.isDone),
        @"isInProgress": @(self.isInProgress),
        @"date": self.date ?: [NSDate date]
    };
}

- (Task *)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _name = dict[@"name"];
        _desc = dict[@"desc"];
        _priority = [dict[@"priority"] longValue];
        _isDone = [dict[@"isDone"] boolValue];
        _isInProgress = [dict[@"isInProgress"] boolValue];
        _date = dict[@"date"];
    }
    return self;
}

@end
