//
//  Clue+Extended.h
//  XT641539
//
//  Created by Raje, Shweta Nitin on 10/25/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "Clue.h"
#import "StoryHistory.h"
#import "Quest+Extended.h"

@interface Clue (Extended)
+ (Clue*)createClueUsingHistory:(StoryHistory*)history inContext:(NSManagedObjectContext*)context;

@end
