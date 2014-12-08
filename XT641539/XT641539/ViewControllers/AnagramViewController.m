//
//  AnagramViewController.m
//  XT641539
//
//  Created by Sasha Azad on 04/12/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "AnagramViewController.h"
#import "TargetView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ExplodeView.h"
#import "StarDustView.h"
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

- (NSString *)shuffle:(NSString*)thisString{
    
    NSMutableArray *tempArr = [[NSMutableArray alloc]initWithCapacity:[thisString length]];
    
    for (int i=0; i < [thisString length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [thisString characterAtIndex:i]];
        [tempArr addObject:ichar];
    }
    
    for (int i = 0; i < tempArr.count; i++) {
        int randomInt1 = arc4random() % [tempArr count];
        int randomInt2 = arc4random() % [tempArr count];
        [tempArr exchangeObjectAtIndex:randomInt1 withObjectAtIndex:randomInt2];
    }
    
    NSString *tempString = [tempArr componentsJoinedByString:@""];
    
    return tempString;
}

- (void) dealRandomAnagrams {
    
    CGFloat kScreenWidth = self.view.frame.size.width;
    CGFloat kScreenHeight = self.view.frame.size.height;
    
//    Anagram* anaAttempt = [Anagram levelWithNum:1];
    
    NSString *answerAnagram = [_clueToShow valueForKey:@"location"];
    NSString *tryAnagram = [self shuffle:answerAnagram];
    
    float ansAnaLength = [answerAnagram length];
    float tryAnaLength = [tryAnagram length];
    
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
//    for (TargetView* t in _targets) {
//        //no success, bail out
//        if (t.isMatched==NO) return;
//    }
    
    CGFloat kScreenWidth = self.view.frame.size.width;

    for (Clue *eachClue in _allClues) {
        if ([eachClue.location isEqualToString:_clueToShow.location]) {
            
            NSString *tempClueText = [NSString stringWithFormat:@" Time: %@ \n Location: %@ \n People Present : %@",
                                          eachClue.timestamp, eachClue.location, eachClue.charactersInLocation];
            
            eachClue.clueText = tempClueText;
            
//            eachClue.clueText = [NSString stringWithFormat:@"%@ %@ %@ in %@ at %@",[eachClue.clueForCharacter.name isEqualToString:self.loggedInCharacter.name]?@"You":eachClue.clueForCharacter.name, eachClue.action, eachClue.object, eachClue.location, eachClue.timestamp];
            
            eachClue.isSolved = [NSNumber numberWithBool:YES];
            [eachClue.managedObjectContext MR_saveToPersistentStoreAndWait];
        }
    }
    
    
//    self.clueToShow.clueText = [NSString stringWithFormat:@"%@ %@ %@ in %@ at %@",[_clueToShow.clueForCharacter.name isEqualToString:self.loggedInCharacter.name]?@"You":_clueToShow.clueForCharacter.name, _clueToShow.action, _clueToShow.object, _clueToShow.location, self.clueToShow.timestamp];
//    self.clueToShow.isSolved = [NSNumber numberWithBool:YES];
    
//    [self.clueToShow.managedObjectContext MR_saveToPersistentStoreAndWait];
    
    //win animation
    TargetView* firstTarget = _targets[0];
    
    int startX = 0;
    int endX = kScreenWidth + 300;
    int startY = firstTarget.center.y;
    
    StarDustView* stars = [[StarDustView alloc] initWithFrame:CGRectMake(startX, startY, 10, 10)];
    
    [self.view addSubview:stars];
    [self.view sendSubviewToBack:stars];
    
    [UIView animateWithDuration:3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         stars.center = CGPointMake(endX, startY);
                     } completion:^(BOOL finished) {
                         
                         //game finished
                         [stars removeFromSuperview];
                     }];
    
    NSLog(@"Game Over");
//    NSLog(@"Clue to show %@", _clueToShow);
    
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
    
    ExplodeView* explode = [[ExplodeView alloc] initWithFrame:CGRectMake(tileView.center.x,tileView.center.y,10,10)];
    [tileView.superview addSubview: explode];
    [tileView.superview sendSubviewToBack:explode];
}

#pragma mark Audio Stuff




@end
