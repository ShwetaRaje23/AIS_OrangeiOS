//
//  Character.h
//  XT641539
//
//  Created by Raje, Shweta Nitin on 10/25/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Clue, DialogueMessage, Personality, Relationship, StoryHistory;

@interface Character : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * characterID;
@property (nonatomic, retain) NSDecimalNumber * role;
@property (nonatomic, retain) Personality *personality;
@property (nonatomic, retain) NSSet *relationship;
@property (nonatomic, retain) NSSet *clues;
@property (nonatomic, retain) NSSet *dialogueMessages;
@property (nonatomic, retain) NSSet *storyHistory;
@end

@interface Character (CoreDataGeneratedAccessors)

- (void)addRelationshipObject:(Relationship *)value;
- (void)removeRelationshipObject:(Relationship *)value;
- (void)addRelationship:(NSSet *)values;
- (void)removeRelationship:(NSSet *)values;

- (void)addCluesObject:(Clue *)value;
- (void)removeCluesObject:(Clue *)value;
- (void)addClues:(NSSet *)values;
- (void)removeClues:(NSSet *)values;

- (void)addDialogueMessagesObject:(DialogueMessage *)value;
- (void)removeDialogueMessagesObject:(DialogueMessage *)value;
- (void)addDialogueMessages:(NSSet *)values;
- (void)removeDialogueMessages:(NSSet *)values;

- (void)addStoryHistoryObject:(StoryHistory *)value;
- (void)removeStoryHistoryObject:(StoryHistory *)value;
- (void)addStoryHistory:(NSSet *)values;
- (void)removeStoryHistory:(NSSet *)values;

@end
