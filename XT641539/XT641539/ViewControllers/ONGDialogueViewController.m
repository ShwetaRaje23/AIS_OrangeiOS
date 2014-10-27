//
//  ONGDialogueViewController.m
//  XT641539
//
//  Created by RNOC Admin on 10/21/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "ONGDialogueViewController.h"
#import "ONGCluesViewController.h"
#import "Character+Extended.h"
#import "ONGDialogueMessagesViewController.h"


@interface ONGDialogueViewController ()
@property (nonatomic,strong) NSArray* characterList;
@property (nonatomic,strong) NSManagedObjectContext* context;

@end

@implementation ONGDialogueViewController

#pragma mark TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.characterList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"characterCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Character* character = [self.characterList objectAtIndex:indexPath.row];
    cell.textLabel.text = character.name;
    
    return cell;
}

#pragma mark Tableview Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
}

#pragma mark Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidAppear:(BOOL)animated{
    
    
    [super viewDidAppear:animated];
    
    //Get characters from database
    self.context = [NSManagedObjectContext MR_context];
    
    //Logged In Character
    NSString* loggedInCharacterID = [[NSUserDefaults standardUserDefaults]objectForKey:LOGGED_IN_CHARACTER];
    
    NSPredicate* notMePRedicate = [NSPredicate predicateWithFormat:@"characterID != %@",[NSNumber numberWithInteger:[loggedInCharacterID integerValue]]];
    self.characterList = [Character MR_findAllWithPredicate:notMePRedicate inContext:self.context];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //Get Character
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    
    
    ONGDialogueMessagesViewController* messageVC = (ONGDialogueMessagesViewController*)[segue destinationViewController];
    messageVC.characterToTalkTo = [self.characterList objectAtIndex:indexPath.row];
}


@end
