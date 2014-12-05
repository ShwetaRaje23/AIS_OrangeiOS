//
//  ONGHomeViewController.m
//  XT641539
//
//  Created by RNOC Admin on 10/21/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "ONGHomeViewController.h"
#import "ONGCluesViewController.h"
#import "Character+Extended.h"
#import "Utils.h"

//Temp
#import "ONGCharacterSelectionViewController.h"

@interface ONGHomeViewController ()
@property (nonatomic,strong) NSManagedObjectContext* context;
@property (nonatomic,strong) Character* loggedInCharacter;
@property (nonatomic,strong) NSString* loggedInCharacterID;
@end

@implementation ONGHomeViewController

#pragma mark Button Actions
- (IBAction)playButtonPressed:(UIButton *)sender {
    
    
    //Logged In Character
    _loggedInCharacterID = [[NSUserDefaults standardUserDefaults]objectForKey:LOGGED_IN_CHARACTER];
    _loggedInCharacter = [Character getCharacterFromId:_loggedInCharacterID inContext:self.context];
    
    if (!self.loggedInCharacter) {
        NSLog(@"Never logged in before");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ONGCharacterSelectionViewController* cluesVC = [storyboard instantiateViewControllerWithIdentifier:@"ONGCharacterSelectionViewController"];
        [self.view.window setRootViewController:cluesVC];
        
    }
    else {
        NSLog(@"Logged in before as %@", self.loggedInCharacter.name);
        //Get Selected Character
        Character* selectedCharacter = self.loggedInCharacter;
        
        //Store character id in nsuserdefaults
        [[NSUserDefaults standardUserDefaults] setObject:selectedCharacter.characterID forKey:LOGGED_IN_CHARACTER];
        
        //Show the Game Tabs
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ONGCluesViewController* cluesVC = [storyboard instantiateViewControllerWithIdentifier:@"ONGGameTabController"];
        [self.view.window setRootViewController:cluesVC];
    }
}


#pragma mark Lifecycle

- (void)viewDidLoad {
    
    //CONTEXT
    self.context = [NSManagedObjectContext MR_context];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *trialData = [Utils sendSynchronousRequestOfType:@"GET" toUrlWithString:@"http://orange-server.herokuapp.com/tellMeAStory/" withData:nil];
    
    NSLog(@"trialData ::: %@", trialData);
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self parseStoryJSON];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TODO Remove and put in a game manger file
#pragma mark Helper

- (void) parseStoryJSON{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sampleServerResponse" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    
    NSLog(@"%@",json);
    
    //Parse Story Data
    [Character parseStoryData:json];
}


@end
