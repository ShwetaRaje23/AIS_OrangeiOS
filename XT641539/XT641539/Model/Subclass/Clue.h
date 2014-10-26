//
//  Clue.h
//  XT641539
//
//  Created by Raje, Shweta Nitin on 10/25/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Character, Quest;

@interface Clue : NSManagedObject

@property (nonatomic, retain) NSString * timestamp;
@property (nonatomic, retain) NSString * clueText;
@property (nonatomic, retain) NSString * clueId;
@property (nonatomic, retain) NSNumber * isSolved;
@property (nonatomic, retain) Character *clueFromCharacter;
@property (nonatomic, retain) Quest *questForClue;

@end
