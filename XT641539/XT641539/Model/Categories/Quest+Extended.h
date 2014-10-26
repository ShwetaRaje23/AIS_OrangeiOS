//
//  Quest+Extended.h
//  XT641539
//
//  Created by Raje, Shweta Nitin on 10/25/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "Quest.h"
#import "StoryHistory.h"

@interface Quest (Extended)

+ (Quest*)createQuestUsingHistory:(StoryHistory*)history inContext:(NSManagedObjectContext*)context;

@end
