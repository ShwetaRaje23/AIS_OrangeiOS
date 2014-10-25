//
//  ONGHomeViewController.m
//  XT641539
//
//  Created by RNOC Admin on 10/21/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "ONGHomeViewController.h"

//Temp
#import "ONGCluesViewController.h"
#import "AppDelegate.h"

@interface ONGHomeViewController ()

@end

@implementation ONGHomeViewController

#pragma mark Button Actions
- (IBAction)playButtonPressed:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ONGCluesViewController* cluesVC = [storyboard instantiateViewControllerWithIdentifier:@"ONGGameTabController"];
    [self.view.window setRootViewController:cluesVC];
}


#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
