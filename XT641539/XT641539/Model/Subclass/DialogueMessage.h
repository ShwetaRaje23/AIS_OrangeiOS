//
//  DialogueMessage.h
//  XT641539
//
//  Created by Salunke, Shanu on 10/26/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Character;

@interface DialogueMessage : NSManagedObject

@property (nonatomic, retain) NSString * messageId;
@property (nonatomic, retain) NSString * messageText;
@property (nonatomic, retain) NSString * timestamp;
@property (nonatomic, retain) NSNumber * recievedFromCharacter;
@property (nonatomic, retain) NSString * clueId;
@property (nonatomic, retain) Character *withCharacter;

@end
