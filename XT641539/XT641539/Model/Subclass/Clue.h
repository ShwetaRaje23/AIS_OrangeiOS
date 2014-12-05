//
//  Clue.h
//  XT641539
//
//  Created by Salunke, Shanu on 10/26/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Character, Quest;

@interface Clue : NSManagedObject

@property (nonatomic, retain) NSString * clueId;
@property (nonatomic, retain) NSString * clueText;
@property (nonatomic, retain) NSNumber * isSolved;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * action;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) Character *clueFromCharacter;
@property (nonatomic, retain) Quest *questForClue;
@property (nonatomic, retain) Character *clueForCharacter;

@end
