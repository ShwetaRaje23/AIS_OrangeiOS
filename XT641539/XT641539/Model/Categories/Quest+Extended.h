//
//  Quest+Extended.h
//  XT641539
//
//  Created by Raje, Shweta Nitin on 10/25/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "Quest.h"
#import "Clue+Extended.h"

@interface Quest (Extended)

+ (Quest*)createQuestUsingClue:(Clue*)clue inContext:(NSManagedObjectContext*)context;

@end
