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
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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


@end
