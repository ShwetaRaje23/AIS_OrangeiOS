//
//  Quest.h
//  XT641539
//
//  Created by Salunke, Shanu on 10/26/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Clue;

@interface Quest : NSManagedObject

@property (nonatomic, retain) NSString * questText;
@property (nonatomic, retain) Clue *resultClue;

@end
