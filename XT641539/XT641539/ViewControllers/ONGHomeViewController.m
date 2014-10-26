//
//  ONGHomeViewController.m
//  XT641539
//
//  Created by RNOC Admin on 10/21/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "ONGHomeViewController.h"
#import "Character+Extended.h"

//Temp
#import "ONGCharacterSelectionViewController.h"

@interface ONGHomeViewController ()

@end

@implementation ONGHomeViewController

#pragma mark Button Actions
- (IBAction)playButtonPressed:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ONGCharacterSelectionViewController* cluesVC = [storyboard instantiateViewControllerWithIdentifier:@"ONGCharacterSelectionViewController"];
    [self.view.window setRootViewController:cluesVC];
}


#pragma mark Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
