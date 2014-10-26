//
//  Quest+Extended.m
//  XT641539
//
//  Created by Raje, Shweta Nitin on 10/25/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "Quest+Extended.h"

@implementation Quest (Extended)

+ (Quest*) createQuestUsingHistory:(StoryHistory *)history inContext:(NSManagedObjectContext *)context{
    
    Quest *quest = [Quest MR_createEntityInContext:context];
    quest.questText = history.location;
    [context save:nil];
    return quest;
}

@end
