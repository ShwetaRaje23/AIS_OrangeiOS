//
//  Clue+Extended.h
//  XT641539
//
//  Created by Raje, Shweta Nitin on 10/25/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "Clue.h"
#import "Clue+Extended.h"
#import "Quest+Extended.h"

@interface Clue (Extended)
+ (Clue*) getClueFromId:(NSString*)clueId inContext:(NSManagedObjectContext*)context;
@end
