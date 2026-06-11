//
//  Task.h
//  ToDo App
//
//  Created by albaraa alsayed on 10/11/1447 AH.
//

#ifndef Task_h
#define Task_h
#import <Foundation/Foundation.h>

@interface Task : NSObject

@property NSString *name;
@property NSString *desc;
@property long priority;
@property BOOL isDone;
@property BOOL isInProgress;
@property NSDate *date;

-(NSDictionary*) toDictionary;
-(Task *)initWithDictionary:(NSDictionary *)dict;

@end

#endif /* Task_h */
