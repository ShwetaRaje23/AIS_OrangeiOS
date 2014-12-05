//
//  AnagramViewController.h
//  XT641539
//
//  Created by Sasha Azad on 04/12/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TileView.h"
#import "Clue.h"
#import "Clue+Extended.h"

@interface AnagramViewController : UIViewController <TileDragDelegateProtocol>

@property (strong, nonatomic) Clue *clueToShow;

@end
