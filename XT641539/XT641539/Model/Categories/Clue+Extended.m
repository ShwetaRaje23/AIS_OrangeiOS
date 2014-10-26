//
//  Clue+Extended.m
//  XT641539
//
//  Created by Raje, Shweta Nitin on 10/25/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "Clue+Extended.h"

@implementation Clue (Extended)

+ (Clue*)createClueUsingHistory:(StoryHistory *)history inContext:(NSManagedObjectContext *)context{
    
    
    Clue* clue = [Clue MR_createEntityInContext:context];
    
    clue.isSolved = [NSNumber numberWithBool:NO];
    clue.timestamp = history.timestamp;
    clue.clueText = [NSString stringWithFormat:@"%@ %@ at the %@", history.character, history.action, history.location];
    
    [context save:nil];
    
    
    return clue;
}

@end
