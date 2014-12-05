//
//  Anagram.h
//  XT641539
//
//  Created by Sasha Azad on 04/12/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Anagram : NSObject

//properties stored in a .plist file
@property (assign, nonatomic) int pointsPerTile;
@property (assign, nonatomic) int timeToSolve;
@property (strong, nonatomic) NSArray* anagrams;

//factory method to load a .plist file and initialize the model
+(instancetype)levelWithNum:(int)levelNum;

@end
