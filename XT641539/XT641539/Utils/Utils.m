//
//  Utils.m
//  XT641539
//
//  Created by Sasha Azad on 04/12/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSDictionary*) sendSynchronousRequestOfType:(NSString*)type toUrlWithString:(NSString*)urlstring withData:(NSDictionary*)datadict{
    
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlstring]];
    [theRequest setHTTPMethod:type?type:@"GET"];
    if (datadict) {
        NSLog(@"%@",datadict);
        //        [theRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        //        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:datadict options:0 error:nil];
        //        [theRequest setHTTPBody:[NSKeyedArchiver archivedDataWithRootObject:jsonData]];
        
        NSMutableString* myParameters = [[NSMutableString alloc]initWithCapacity:1];
        BOOL is_first_dict_value = YES;
        for (id key in datadict){
            if (is_first_dict_value) {
                is_first_dict_value = NO;
                [myParameters appendString:[NSString stringWithFormat:@"%@=%@", key, [datadict valueForKey:key]]];
            }else{
                [myParameters appendString:[NSString stringWithFormat:@"&%@=%@", key, [datadict valueForKey:key]]];
            }
        }
        
        
        NSLog(@"%@",myParameters);
        [theRequest setHTTPBody:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    
    NSURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData * data = [NSURLConnection sendSynchronousRequest:theRequest
                                          returningResponse:&urlResponse
                                                      error:&error];
    
    if (error == nil) {
        //        NSString *response = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"Response Dictionary = %@",responseDict);
        return responseDict;
    }
    else {
        //        NSString *response = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSLog(@"%@", [error userInfo]);
        return @{@"error":[error userInfo]};
    }
    
    
}

@end
