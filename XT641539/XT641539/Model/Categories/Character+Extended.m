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
        
        NSError* err;
        [context save:&err];
        if (err) {
            NSLog(@"%@",err);
        }
    }else{
        
        //Update
    }
    
}

+ (void) parseStoryHistory:(NSDictionary *)historyDict{
    
    NSManagedObjectContext* context = [NSManagedObjectContext MR_context];
    Character* character = [self getCharacterFromId:[historyDict valueForKey:@"characterID"] inContext:context];
    StoryHistory* history;
    
    
    if (!character) {
        //ERROR !
        NSLog(@"No character for history");
    }else{
        //Create history
        history = [StoryHistory MR_createEntityInContext:context];
        history.timestamp = [historyDict valueForKey:@"timestamp"];
        history.action = [historyDict valueForKey:@"action"];
        history.location = [historyDict valueForKey:@"location"];
        history.character = character;
        
        //Create Quest and Clues
        Quest* quest = [Quest createQuestUsingHistory:history inContext:context];
        Clue* clue = [Clue createClueUsingHistory:history inContext:context];
        
        clue.questForClue = quest;
        clue.clueFromCharacter = character;
        [context save:nil];
        
        NSError* err;
        [context save:&err];
        if (err) {
            NSLog(@"%@",err);
        }    }
    
    
}

@end
