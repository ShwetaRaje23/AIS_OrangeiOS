//
//  ONGUtils.m
//  XT641539
//
//  Created by Salunke, Shanu on 10/26/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "ONGUtils.h"

@implementation ONGUtils
+ (NSDate*) dateForString:(NSString*)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss a"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"UTC"]];
    NSDate *date = [dateFormatter dateFromString: dateString];
    NSLog(@"Captured Date %@", [date description]);
    return date;
}
+ (NSString*) stringFromDate:(NSDate*)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm a"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}



@end
