//
//  StoryHistory.h
//  XT641539
//
//  Created by Raje, Shweta Nitin on 10/25/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Character;

@interface StoryHistory : NSManagedObject

@property (nonatomic, retain) NSString * timestamp;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * action;
@property (nonatomic, retain) Character *character;

@end
