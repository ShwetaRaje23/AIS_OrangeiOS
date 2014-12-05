//
//  Anagram.m
//  XT641539
//
//  Created by Sasha Azad on 04/12/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "Anagram.h"

@implementation Anagram


+(instancetype)levelWithNum:(int)levelNum;
{
    //1 find .plist file for this level
    NSString* fileName = [NSString stringWithFormat:@"anagrams.plist"];
    NSString* levelPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    
    //2 load .plist file
    NSDictionary* levelDict = [NSDictionary dictionaryWithContentsOfFile:levelPath];
    
    //3 validation
    NSAssert(levelDict, @"level config file not found");
    
    //4 create Level instance
    Anagram* l = [[Anagram alloc] init];
    
    //5 initialize the object from the dictionary
    l.pointsPerTile = [levelDict[@"pointsPerTile"] intValue];
    l.anagrams = levelDict[@"anagrams"];
    l.timeToSolve = [levelDict[@"timeToSolve"] intValue];
    
    return l;
}

@end
