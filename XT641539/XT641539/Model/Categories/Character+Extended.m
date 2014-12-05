//
//  Character+Extended.m
//  XT641539
//
//  Created by Raje, Shweta Nitin on 10/25/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "Character+Extended.h"

@implementation Character (Extended)


+ (Character*) getCharacterFromId:(NSString*)characterID inContext:(NSManagedObjectContext*)context{
    
    NSPredicate* findCharacterWithIDPredicate = [NSPredicate predicateWithFormat:@"characterID == %@",[NSNumber numberWithInteger:[characterID integerValue]]];
    
    NSArray* charactersWithId = [Character MR_findAllWithPredicate:findCharacterWithIDPredicate inContext:context];
    Character* character = nil;
    
    if (charactersWithId.count == 0) {
        //No Character Found
        NSLog(@"NO CHARACTER FOUND");
    }
    else{
        character = [charactersWithId firstObject];
    }
    return character;
}

#pragma mark Parsers

+ (void) parseStoryData:(NSDictionary*)storyData{
    
    NSArray* characters = [storyData valueForKey:@"characters"];
    NSArray* histories = [storyData valueForKey:@"storyHistory"];
    
    //Parse characters
    for (NSDictionary* character in characters) {
        [self parseStoryCharacter:character];
    }
    
    //Parse History
    for (NSDictionary* history in histories) {
        [self parseStoryHistory:history];
    }
    
}

+ (void) parseStoryCharacter:(NSDictionary *)characterDict{
    
    NSManagedObjectContext* context = [NSManagedObjectContext MR_context];
    Character* character = [self getCharacterFromId:[characterDict valueForKey:@"characterID"] inContext:context];
    
    if (!character) {
        character = [Character MR_createEntityInContext:context];
        character.name = [characterDict valueForKey:@"name"];
        character.characterID = [NSNumber numberWithInteger:[[characterDict valueForKey:@"characterID"] integerValue]];
//        character.role = [characterDict valueForKey:@"role"]; //Decimal From Enum
        
        [context MR_saveToPersistentStoreAndWait];
    }else{
        
        //Update
    }
    
}

+ (void) parseStoryHistory:(NSDictionary *)historyDict{
    
    NSManagedObjectContext* context = [NSManagedObjectContext MR_context];
    Character* character = [self getCharacterFromId:[historyDict valueForKey:@"characterID"] inContext:context];
//    StoryHistory* history;
    Clue* clue;
    
    if (!character) {
        //ERROR !
        NSLog(@"No character for history");
        
        
    }else{
        
        //Create history
//        history = [StoryHistory MR_createEntityInContext:context];
//        history.timestamp = [historyDict valueForKey:@"timestamp"];
//        history.action = [historyDict valueForKey:@"action"];
//        history.location = [historyDict valueForKey:@"location"];
//        history.character = character;

        clue = [Clue getClueFromId:[historyDict valueForKey:@"clueId"] inContext:context];
        
        if (!clue) {
            clue = [Clue MR_createEntityInContext:context];
            clue.isSolved = [NSNumber numberWithBool:NO];
        }
        
        clue.timestamp = [ONGUtils dateForString:[historyDict valueForKey:@"timestamp"]];
        clue.action = [historyDict valueForKey:@"action"];
        clue.location = [historyDict valueForKey:@"location"];
        clue.clueForCharacter = character;
        clue.clueId = [historyDict valueForKey:@"clueId"];
        
        //Create Quest and Clues
        Quest* quest = [Quest createQuestUsingClue:clue inContext:context];
        
        clue.questForClue = quest;
        [context MR_saveToPersistentStoreAndWait];
    }
    
    
}

#pragma mark Dialogue

- (NSMutableArray*)getPossibleQuestions{
    
    NSMutableArray* questions = [[NSMutableArray alloc]initWithCapacity:1];
    NSArray* allClues = [self.clues allObjects];
    
    
    if (allClues.count > 0) {
        for (int i=0; i<MIN(4, allClues.count); i++) {
            Clue* clue = [allClues objectAtIndex:i];
            NSString* question =[NSString stringWithFormat:@"What happened in the %@ ?",clue.location];
            if (![questions containsObject:question]) {
                [questions addObject:question];
            }
        }
    }
    
    return questions;
}

- (NSMutableArray*)getPossibleResponses{
    return nil;
}

@end
