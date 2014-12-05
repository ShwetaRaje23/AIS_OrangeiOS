//
//  ExplodeView.m
//  XT641539
//
//  Created by Sasha Azad on 05/12/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "ExplodeView.h"
#import "QuartzCore/QuartzCore.h"

//2
//create the following private variable section
@implementation ExplodeView
{
    CAEmitterLayer* _emitter;
}

// 3
// with the other methods
+ (Class) layerClass
{
    //configure the UIView to have emitter layer
    return [CAEmitterLayer class];
}
@end
