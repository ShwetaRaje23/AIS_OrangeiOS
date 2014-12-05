//
//  Clue.h
//  XT641539
//
//  Created by Aditya Anupam on 12/5/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Character;

@interface Clue : NSManagedObject

@property (nonatomic, retain) NSString * action;
@property (nonatomic, retain) NSString * clueId;
@property (nonatomic, retain) NSString * clueText;
@property (nonatomic, retain) NSNumber * isSolved;
@property (nonatomic, retain) NSNumber * iteration;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * object;
@property (nonatomic, retain) NSString * timestamp;
@property (nonatomic, retain) NSString * questText;
@property (nonatomic, retain) Character *clueForCharacter;
@property (nonatomic, retain) Character *clueFromCharacter;

@end
