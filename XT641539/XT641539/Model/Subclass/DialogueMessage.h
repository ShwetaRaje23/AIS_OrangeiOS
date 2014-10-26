//
//  DialogueMessage.h
//  XT641539
//
//  Created by Raje, Shweta Nitin on 10/25/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Character;

@interface DialogueMessage : NSManagedObject

@property (nonatomic, retain) NSString * timestamp;
@property (nonatomic, retain) NSString * messageText;
@property (nonatomic, retain) NSString * messageId;
@property (nonatomic, retain) Character *messageFromCharacter;

@end
