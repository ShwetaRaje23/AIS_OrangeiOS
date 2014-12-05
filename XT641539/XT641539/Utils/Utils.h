//
//  Utils.h
//  XT641539
//
//  Created by Sasha Azad on 04/12/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

//+ (NSDictionary*) sendSynchronousRequestOfType:(NSString*)type toUrlWithString:(NSString*)urlstring withData:(NSDictionary*)datadict;
//
+ (NSDictionary *) parseStoryJSON;

+(NSDictionary *) getCharactersFromResponseDictionary;

+(NSDictionary *) getHistoryFromResponseDictionary;

@end
