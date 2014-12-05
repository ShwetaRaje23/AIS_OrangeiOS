//
//  TimeBasedQuest.h
//  XT641539
//
//  Created by Aditya Anupam on 12/5/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Quest.h"


@interface TimeBasedQuest : Quest

@property (nonatomic, retain) NSDecimalNumber * timeLimit;

@end
