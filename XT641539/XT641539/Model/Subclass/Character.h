//
//  Character.h
//  XT641539
//
//  Created by Aditya Anupam on 12/5/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Clue, DialogueMessage;

@interface Character : NSManagedObject

@property (nonatomic, retain) NSNumber * characterID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDecimalNumber * role;
@property (nonatomic, retain) NSString * characterDesc;
@property (nonatomic, retain) NSSet *clues;
@property (nonatomic, retain) NSSet *dialogueMessages;
@end

@interface Character (CoreDataGeneratedAccessors)

- (void)addCluesObject:(Clue *)value;
- (void)removeCluesObject:(Clue *)value;
- (void)addClues:(NSSet *)values;
- (void)removeClues:(NSSet *)values;

- (void)addDialogueMessagesObject:(DialogueMessage *)value;
- (void)removeDialogueMessagesObject:(DialogueMessage *)value;
- (void)addDialogueMessages:(NSSet *)values;
- (void)removeDialogueMessages:(NSSet *)values;

@end
