//
//  Utils.m
//  XT641539
//
//  Created by Sasha Azad on 04/12/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "Utils.h"
#import "Character+Extended.h"

@implementation Utils

+ (NSDictionary*) sendSynchronousRequestOfType:(NSString*)type toUrlWithString:(NSString*)urlstring withData:(NSDictionary*)datadict{
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlstring]];
    [theRequest setHTTPMethod:type?type:@"GET"];
    if (datadict) {
        NSMutableString* myParameters = [[NSMutableString alloc]initWithCapacity:1];
        BOOL is_first_dict_value = YES;
        for (id key in datadict){
            if (is_first_dict_value) {
                is_first_dict_value = NO;
                [myParameters appendString:[NSString stringWithFormat:@"%@=%@", key, [datadict valueForKey:key]]];
            }else{
                [myParameters appendString:[NSString stringWithFormat:@"&%@=%@", key, [datadict valueForKey:key]]];
            }
        }
        [theRequest setHTTPBody:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:theRequest
                                          returningResponse:&urlResponse
                                                      error:&error];
    if (error == nil) {
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        return responseDict;
    }
    else {
        return @{@"error":[error userInfo]};
    }
}

+ (NSDictionary*) parseStoryJSON {
    
//    NSDictionary *jsonResponse = [self sendSynchronousRequestOfType:@"GET" toUrlWithString:@"http://orange-server.herokuapp.com/tellMeAStory/" withData:nil];
    
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sampleServerResponse" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

        NSLog(@"%@",jsonResponse);

    
    
    //Victim
    NSNumber* victimid = [jsonResponse valueForKey:@"victim"];
    NSNumber* killerid = [jsonResponse valueForKey:@"killer"];
    NSString* motiveid = [jsonResponse valueForKey:@"motive"];
    
    
    [[NSUserDefaults standardUserDefaults]setObject:victimid forKey:@"victimid"];
    [[NSUserDefaults standardUserDefaults]setObject:killerid forKey:@"killerid"];
    [[NSUserDefaults standardUserDefaults]setObject:motiveid forKey:@"motive"];
    
    //Characters
    NSManagedObjectContext* context = [NSManagedObjectContext MR_context];
    NSString* victimName = @"";
    for (NSDictionary* character in [jsonResponse objectForKey:@"characters"]){
        
        Character* ch = [Character MR_createEntityInContext:context];
        ch.name = [character valueForKey:@"name"];
        ch.characterDesc = [character valueForKey:@"characterDescription"];
        ch.characterID = [character valueForKey:@"characterid"];
        [context MR_saveToPersistentStoreAndWait];
        
        if ([ch.characterID isEqualToNumber:victimid]) {
            victimName = ch.name;
        }
        
    }
    
    
    //Put default clue
    for (Character* character in [Character MR_findAllInContext:context]) {
        
        //Put first Clue
        Clue *firstClue = [Clue MR_createEntityInContext:context];
        firstClue.clueText = [NSString stringWithFormat:@"The %@ is dead ! Can you find the killer ?",victimName];
        firstClue.isSolved = [NSNumber numberWithBool:YES];
        firstClue.clueId = [NSString stringWithFormat:@"-1"];
        
        firstClue.clueForCharacter = character;
        [character addCluesObject:firstClue];
        [context MR_saveToPersistentStoreAndWait];
    }
    
    //Actions
    NSArray* actionDict = [jsonResponse objectForKey:@"actions"];
    
    //Objects
    NSArray* objectDict = [jsonResponse objectForKey:@"objects"];
    
    //Locations
    NSArray* locationDict = [jsonResponse objectForKey:@"locations"];
    
    //Clues
    NSArray* historyDict = [jsonResponse objectForKey:@"history"];
    
    //Characters
    NSArray *characterDict = [jsonResponse objectForKey:@"characters"];
    
    int i=-1;
    for (NSDictionary* history in historyDict) {
        
        Clue* clue = [Clue MR_createEntityInContext:context];
        NSMutableString* objectsStr = [[NSMutableString alloc]initWithString:@""];
        NSMutableString* pplStr = [[NSMutableString alloc]initWithString:@""];
        
        //Action
        NSNumber* actionid = [history valueForKey:@"action_id"];
        clue.action = [self getActionForId:actionid];
        
        //ClueId
        i++;
        clue.clueId = [NSString stringWithFormat:@"%d",i];
        
        //isSolved
        clue.isSolved = [NSNumber numberWithBool:NO];
        clue.questText = @"You have a new clue !";
        
        
        //Location
        NSNumber* locId = [history valueForKey:@"location"];
        clue.location = [self getValueForKey:@"name" matchingId:locId forKey:@"placeid" fromDict:locationDict];
        
        //Objects and people
        NSUInteger tempcount1=0;
        for (NSNumber* objid in [history valueForKey:@"objects_involved"]) {
            if (tempcount1 != 0) {
                [objectsStr appendString:@", "];
            }
           [objectsStr appendString:[self getValueForKey:@"name" matchingId:objid forKey:@"objectid" fromDict:objectDict]];
            tempcount1++;
        }
        
        NSUInteger tempcount2=0;
        for (NSNumber* objid in [history valueForKey:@"performed_on"]) {
            if (tempcount2 != 0) {
                [pplStr appendString:@", "];
            }
            [pplStr appendString:[self getValueForKey:@"name" matchingId:objid forKey:@"characterid" fromDict:characterDict]];
            NSLog(@"%@", pplStr);
            tempcount2 ++;
        }
        
        clue.object = objectsStr;
        clue.charactersInLocation = pplStr;
        
//        if (pplStr.length >0) {
//            clue.object = [NSString stringWithFormat:@"%@ and **** %@",objectsStr,pplStr];
//        }
//        else{
//            clue.object = objectsStr;
//        }
        
    
        
        //Time
        clue.timestamp = [history valueForKey:@"time"];
        clue.iteration = [history valueForKey:@"iteration"];
        
        //People
        Character* me = [self getCharacterWithId:[history valueForKey:@"performed_by"] inContext:context];
        clue.clueForCharacter = me;
        
        
//        clue.clueText = [NSString stringWithFormat:@"%@ %@ %@ at the %@",me.name, clue.action, clue.object, clue.location];
        
        [context MR_saveToPersistentStoreAndWait];
    }
    
    
    
    return jsonResponse;
}

+ (NSString*)getValueForKey:(NSString*)key matchingId:(NSNumber*)valueid forKey:(NSString*)matchKey fromDict:(NSArray*)list{
    
    for (NSDictionary* elem in list) {
        if ([[elem valueForKey:matchKey] isEqualToNumber:valueid]) {
            return [elem valueForKey:key];
        }
    }
    return @"";
}

+ (NSString*)getActionForId:(NSNumber*)actionid{
    switch ([actionid integerValue]) {
        case 1:
            return @"saw";
            break;
        case 2:
            return @"heard";
            break;
        case 3:
            return @"picked up";
            break;
        case 4:
            return @"killed";
            break;
        case 5:
            return @"spoke to";
            break;
        case 6:
            return @"dropped";
            break;
        case 7:
            return @"walked";
            break;
        case 8:
            return @"fought";
            break;
        default:
            break;
    }
    return @"";
}

+ (Character*) getCharacterWithId:(NSNumber*)charid inContext:(NSManagedObjectContext*)context{
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"characterID == %@",charid];
    NSArray* ret = [Character MR_findAllWithPredicate:pred inContext:context];
    
    if (ret.count >0) {
        return [ret firstObject];
    }
    return nil;
}

@end
