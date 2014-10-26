//
//  Character+Extended.h
//  XT641539
//
//  Created by Raje, Shweta Nitin on 10/25/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "Character.h"
#import "StoryHistory.h"
#import "Quest+Extended.h"
#import "Clue+Extended.h"

@interface Character (Extended)

+ (void) parseStoryData:(NSDictionary*)storyData;

@end
