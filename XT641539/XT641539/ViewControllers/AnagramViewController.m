//
//  AnagramViewController.m
//  XT641539
//
//  Created by Sasha Azad on 04/12/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "AnagramViewController.h"
#import "Anagram.h"
#import "TargetView.h"
#import <AudioToolbox/AudioToolbox.h>

#import "Character+Extended.h"


#define kTileMargin 20

#define kAudioEffectFiles @[kSoundDing, kSoundWrong, kSoundWin]

@interface AnagramViewController ()

@property (strong, nonatomic) NSMutableArray* myLetterOptions;

@property (nonatomic,strong) NSManagedObjectContext* context;
@property (nonatomic,strong) Character* loggedInCharacter;

@end

@implementation AnagramViewController{
    NSMutableArray* _tiles;
    NSMutableArray* _targets;
    NSMutableDictionary* audio;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self setupGameView];
    
    [self dealRandomAnagrams];
    
    self.context = [NSManagedObjectContext MR_context];
    NSString* loggedInCharacterID = [[NSUserDefaults standardUserDefaults]objectForKey:LOGGED_IN_CHARACTER];
    self.loggedInCharacter = [Character getCharacterFromId:loggedInCharacterID inContext:self.context];
    
    
}

- (void) setupGameView {
    
    
    CGFloat kScreenWidth = self.view.frame.size.width;
    CGFloat kScreenHeight = self.view.frame.size.height;
    
    UIView* gameLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    gameLayer.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:219.0f/255.0f blue:191.0f/255.0f alpha:1];
    
    [self.view addSubview: gameLayer];
    
    //    self.controller.gameView = gameLayer;
}

- (void) dealRandomAnagrams {
    
    CGFloat kScreenWidth = self.view.frame.size.width;
    CGFloat kScreenHeight = self.view.frame.size.height;
    
    Anagram* anaAttempt = [Anagram levelWithNum:1];
    
    int randomIndex = arc4random()%[anaAttempt.anagrams count];
    NSArray* anaPair = anaAttempt.anagrams[ randomIndex ];
    
    
    NSString *tryAnagram = [anaPair objectAtIndex:0];
    float tryAnaLength = [tryAnagram length];
    
    NSString *answerAnagram = [anaPair objectAtIndex:1];
    float ansAnaLength = [answerAnagram length];
    
    //calculate the tile size
    float maxLength = MAX(tryAnaLength, ansAnaLength);
    
    float tileSide = ceilf( kScreenWidth*0.9 / maxLength ) - kTileMargin;
    
    //get the left margin for first tile
    float xOffset = (kScreenWidth - maxLength * (tileSide + kTileMargin))/2;
    
    //adjust for tile center (instead of the tile's origin)
    xOffset += tileSide/2;
    
    _tiles = [NSMutableArray arrayWithCapacity: tryAnaLength];
    
    //2 create tiles
    for (int i=0;i<tryAnaLength;i++) {
        NSString* letter = [tryAnagram substringWithRange:NSMakeRange(i, 1)];
        
        //3
        if (![letter isEqualToString:@" "]) {
            TileView* tile = [[TileView alloc] initWithLetter:letter andSideLength:tileSide];
            tile.center = CGPointMake(xOffset + i*(tileSide + kTileMargin), kScreenHeight/4*3);
            [tile randomize];
            tile.dragDelegate = self;
            
            //4
            [self.view addSubview:tile];
            [_tiles addObject: tile];
        }
    }
    
    
    _targets = [NSMutableArray arrayWithCapacity: ansAnaLength];
    
    // create targets
    for (int i=0;i<ansAnaLength;i++) {
        NSString* letter = [answerAnagram substringWithRange:NSMakeRange(i, 1)];
        
        if (![letter isEqualToString:@" "]) {
            TargetView* target = [[TargetView alloc] initWithLetter:letter andSideLength:tileSide];
            target.center = CGPointMake(xOffset + i*(tileSide + kTileMargin), kScreenHeight/4);
            
            [self.view addSubview:target];
            [_targets addObject: target];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//a tile was dragged, check if matches a target
-(void)tileView:(TileView*)tileView didDragToPoint:(CGPoint)pt
{
    TargetView* targetView = nil;
    
    for (TargetView* tv in _targets) {
        if (CGRectContainsPoint(tv.frame, pt)) {
            targetView = tv;
            break;
        }
    }
    
    //1 check if target was found
    if (targetView!=nil) {
        
        //2 check if letter matches
        if ([targetView.letter isEqualToString: tileView.letter]) {
            [self placeTile:tileView atTarget:targetView];
            [self checkForSuccess];
            
        } else {
            [tileView randomize];
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
    }
}

-(void)checkForSuccess
{
        for (TargetView* t in _targets) {
            //no success, bail out
            if (t.isMatched==NO) return;
        }
    
    _clueToShow.clueText = [NSString stringWithFormat:@"%@ %@ in %@ at %@",[_clueToShow.clueForCharacter.name isEqualToString:self.loggedInCharacter.name]?@"You":_clueToShow.clueForCharacter.name, _clueToShow.action, _clueToShow.location, [ONGUtils stringFromDate:_clueToShow.timestamp]];
    _clueToShow.isSolved = [NSNumber numberWithBool:YES];
    
    [_clueToShow.managedObjectContext MR_saveToPersistentStoreAndWait];
    
    NSLog(@"Game Over");
    NSLog(@"Clue to show %@", _clueToShow);
    
}

-(void)placeTile:(TileView*)tileView atTarget:(TargetView*)targetView
{
    //1
    targetView.isMatched = YES;
    tileView.isMatched = YES;
    
    //2
    tileView.userInteractionEnabled = NO;
    
    //3
    [UIView animateWithDuration:0.35
                          delay:0.00
                        options:UIViewAnimationOptionCurveEaseOut
     //4
                     animations:^{
                         tileView.center = targetView.center;
                         tileView.transform = CGAffineTransformIdentity;
                     }
     //5
                     completion:^(BOOL finished){
                         targetView.hidden = YES;
                     }];
}

#pragma mark Audio Stuff




@end
