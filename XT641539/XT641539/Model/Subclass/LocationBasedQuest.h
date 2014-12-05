//
//  LocationBasedQuest.h
//  XT641539
//
//  Created by Salunke, Shanu on 10/26/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Quest.h"


@interface LocationBasedQuest : Quest

@property (nonatomic, retain) NSDecimalNumber * direction;
@property (nonatomic, retain) NSDecimalNumber * steps;

@end
