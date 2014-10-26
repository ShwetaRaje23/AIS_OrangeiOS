//
//  ONGCluesViewController.m
//  XT641539
//
//  Created by RNOC Admin on 10/21/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "ONGCluesViewController.h"

@interface ONGCluesViewController ()
@property (nonatomic,strong) NSMutableArray* clues;
@property (nonatomic,strong) NSManagedObjectContext* context;
@property (nonatomic,strong) Character* loggedInCharacter;
@end

@implementation ONGCluesViewController

#pragma mark Helpers

- (NSMutableArray*) getQuestsAndCluesInContext:(NSManagedObjectContext*)context{
    
    NSMutableArray* questsAndClues = [[NSMutableArray alloc]initWithCapacity:1];
    
    //Get first default clue
    Clue* defaultClue = [Clue MR_createEntityInContext:context];
    defaultClue.clueText = @"The Governor is Dead !";
    defaultClue.isSolved = [NSNumber numberWithBool:YES];
    [context MR_saveToPersistentStoreAndWait];
    [questsAndClues insertObject:defaultClue atIndex:0];
    
    
    
    
    //Get all solved Clues
    NSPredicate* solvedClues = [NSPredicate predicateWithFormat:@"isSolved == %@",[NSNumber numberWithBool:YES]];
    [questsAndClues addObjectsFromArray:[[self.loggedInCharacter.clues filteredSetUsingPredicate:solvedClues] allObjects]];
//    [questsAndClues addObjectsFromArray:[Clue MR_findAllWithPredicate:solvedClues inContext:context]];
    
    //Get one quest (temporarily random)
    NSPredicate* unsolvedClues = [NSPredicate predicateWithFormat:@"isSolved == %@",[NSNumber numberWithBool:NO]];
    NSArray* unsolvedQuests = [Clue MR_findAllWithPredicate:unsolvedClues inContext:context];
    if (unsolvedQuests.count > 0) {
            [questsAndClues insertObject:[unsolvedQuests firstObject] atIndex:0];
    }
    
//    [questsAndClues addObjectsFromArray:[Clue MR_findAllWithPredicate:unsolvedClues inContext:self.context]];
    
    return questsAndClues;
}

#pragma mark TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.clues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier;
    
    Clue* clue = [self.clues objectAtIndex:indexPath.row];
    NSString* displayString;
    
    if ([clue.isSolved isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        //Dispaly Clue
        CellIdentifier = @"cluesCell";
        displayString = clue.clueText;
    }else{
        //Dispaly Quest
        CellIdentifier = @"questCell";
        displayString = clue.questForClue.questText;
    }
    
    
//    NSLog(@"%@",clue);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
        
    }
    cell.textLabel.text = displayString;
    return cell;
}

#pragma mark Tableview Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    Clue *clue = [self.clues objectAtIndex:indexPath.row];
    clue.isSolved = [NSNumber numberWithBool:YES];
    clue.clueText = [NSString stringWithFormat:@"%@ %@ in %@ at %@",[clue.clueForCharacter.name isEqualToString:self.loggedInCharacter.name]?@"You":clue.clueForCharacter.name, clue.action, clue.location, clue.timestamp];
    [clue.managedObjectContext MR_saveToPersistentStoreAndWait];
    [self.loggedInCharacter addCluesObject:clue];
    
    //GET MORE CLUES
    self.clues = [self getQuestsAndCluesInContext:self.context];
    [self.tableView reloadData];
}


#pragma mark Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //CONTEXT
    self.context = [NSManagedObjectContext MR_context];
    
    //Tableview Extends below tabbar
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.contentInset = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    
    //Logged In Character
    NSString* loggedInCharacterID = [[NSUserDefaults standardUserDefaults]objectForKey:LOGGED_IN_CHARACTER];
    self.loggedInCharacter = [Character getCharacterFromId:loggedInCharacterID inContext:self.context];
    
    //Get Data
    self.clues = [self getQuestsAndCluesInContext:self.context];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

@end
