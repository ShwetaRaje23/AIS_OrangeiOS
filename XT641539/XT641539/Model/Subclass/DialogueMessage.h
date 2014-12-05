//
//  DialogueMessage.h
//  XT641539
//
//  Created by Aditya Anupam on 12/5/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Character;

@interface DialogueMessage : NSManagedObject

@property (nonatomic, retain) NSString * clueId;
@property (nonatomic, retain) NSString * messageId;
@property (nonatomic, retain) NSString * messageText;
@property (nonatomic, retain) NSNumber * recievedFromCharacter;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) Character *withCharacter;

@end
