//
//  Clue+Extended.m
//  XT641539
//
//  Created by Raje, Shweta Nitin on 10/25/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "Clue+Extended.h"

@implementation Clue (Extended)

+ (Clue*) getClueFromId:(NSString*)clueId inContext:(NSManagedObjectContext*)context{
    
    NSPredicate* findCharacterWithIDPredicate = [NSPredicate predicateWithFormat:@"clueId == %@",[NSNumber numberWithInteger:[clueId integerValue]]];
    
    NSArray* cluesWithId = [Clue MR_findAllWithPredicate:findCharacterWithIDPredicate inContext:context];
    Clue* clue = nil;
    
    if (cluesWithId.count == 0) {
        //No Clue Found
    }
    else{
        clue = [cluesWithId firstObject];
    }
    return clue;
}

@end
