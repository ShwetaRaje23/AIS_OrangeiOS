//
//  ONGCharacterSelectionViewController.m
//  XT641539
//
//  Created by Raje, Shweta Nitin on 10/25/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "ONGCharacterSelectionViewController.h"
#import "ONGCharacterTableViewCell.h"
#import "ONGCluesViewController.h"
#import "Character+Extended.h"



@interface ONGCharacterSelectionViewController ()
@property (nonatomic,strong) NSArray* characterList;
@property (nonatomic,strong) NSManagedObjectContext* context;

@end

@implementation ONGCharacterSelectionViewController

#pragma mark TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.characterList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"characterCell";
    
    ONGCharacterTableViewCell *cell = (ONGCharacterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (ONGCharacterTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell.textLabel.text = [NSString stringWithFormat:@"cell%li%li", (long)indexPath.section, (long)indexPath.row];
    }
    
    Character* character = [self.characterList objectAtIndex:indexPath.row];
    cell.characterLabel.text = character.name;
    cell.descriptionLabel.text = @"Description";
    
    return cell;
}

#pragma mark Tableview Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //Get Selected Character
    Character* selectedCharacter = [self.characterList objectAtIndex:indexPath.row];
    
    //Store character id in nsuserdefaults
    [[NSUserDefaults standardUserDefaults] setObject:selectedCharacter.characterID forKey:LOGGED_IN_CHARACTER];
    
    
    //Show the Game Tabs
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ONGCluesViewController* cluesVC = [storyboard instantiateViewControllerWithIdentifier:@"ONGGameTabController"];
    [self.view.window setRootViewController:cluesVC];
}

#pragma mark Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.characterDescriptions = @[@{@"name":@"Maid", @"description":@"You are nosey. Have been working for 5 years. You love to gossip"},
//                                   @{@"name":@"Secratary", @"description":@"Close to the governor, more than his wife."},
//                                   @{@"name":@"Wife", @"description":@"You just love the status you have not the Governor"},
//                                   @{@"name":@"Brother", @"description":@" you are jealous of the Governor since ever "},
//                                   @{@"name":@"Uncle", @"description":@" YOu have been like a father to the governor "}];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    
    [super viewDidAppear:animated];
    
    //Get All characters from database
    self.context = [NSManagedObjectContext MR_context];
    self.characterList = [Character MR_findAllInContext:self.context];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
