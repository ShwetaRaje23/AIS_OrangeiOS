//
//  LocationBasedQuest.h
//  XT641539
//
//  Created by Raje, Shweta Nitin on 10/25/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Quest.h"


@interface LocationBasedQuest : Quest

@property (nonatomic, retain) NSDecimalNumber * steps;
@property (nonatomic, retain) NSDecimalNumber * direction;

@end