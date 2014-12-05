//
//  Character+Extended.h
//  XT641539
//
//  Created by Raje, Shweta Nitin on 10/25/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "Character.h"
#import "Quest+Extended.h"
#import "Clue+Extended.h"

@interface Character (Extended)

+ (Character*) getCharacterFromId:(NSString*)characterID inContext:(NSManagedObjectContext*)context;
+ (void) parseStoryData:(NSDictionary*)storyData;
- (NSMutableArray*)getPossibleQuestions;
@end
