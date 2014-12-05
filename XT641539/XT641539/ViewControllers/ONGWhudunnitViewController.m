//
//  ONGWhudunnitViewController.m
//  XT641539
//
//  Created by RNOC Admin on 10/21/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "ONGWhudunnitViewController.h"
#import "ONGCluesViewController.h"
#import "Character+Extended.h"
#import "ONGDialogueMessagesViewController.h"


@interface ONGWhudunnitViewController ()
@property (nonatomic,strong) NSArray* characterList;
@property (nonatomic,strong) NSManagedObjectContext* context;

@end

@implementation ONGWhudunnitViewController

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
    
    Character* character = [self.characterList objectAtIndex:indexPath.row];
//    NSString* message = [NSString stringWithFormat:@"You have accused %@ of the murder. You will be told the truth at the end of the game.", character.name];
//    [[[UIAlertView alloc]initWithTitle:@"J'accuse !" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
    
    NSString* motive = [[NSUserDefaults standardUserDefaults] valueForKey:@"motive"];
    NSNumber* killer = [[NSUserDefaults standardUserDefaults]valueForKey:@"killerid"];
    NSString* killChar = @"";
    for (Character* ch in self.characterList) {
        if ([ch.characterID isEqualToNumber:killer]) {
            killChar = ch.name;
        }
    }
    
    [[[UIAlertView alloc]initWithTitle:killChar message:motive delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
    
    
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
    
    //Set Title
    //Logged In Character
    NSString* loggedInCharacterID = [[NSUserDefaults standardUserDefaults]objectForKey:LOGGED_IN_CHARACTER];
    Character* character = [Character getCharacterFromId:loggedInCharacterID inContext:self.context];
//    self.title = [NSString stringWithFormat:@"Playing As: %@",character.name];
    
    //Logged In Character
//    NSString* loggedInCharacterID = [[NSUserDefaults standardUserDefaults]objectForKey:LOGGED_IN_CHARACTER];
    
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
- (IBAction)doLogout:(id)sender {
}
@end
