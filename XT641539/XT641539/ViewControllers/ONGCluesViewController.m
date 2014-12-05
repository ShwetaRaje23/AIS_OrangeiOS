//
//  ONGCluesViewController.m
//  XT641539
//
//  Created by RNOC Admin on 10/21/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "AnagramViewController.h"
#import "ONGCluesViewController.h"

@interface ONGCluesViewController ()
@property (nonatomic,strong) NSMutableArray* clues;
@property (nonatomic,strong) NSManagedObjectContext* context;
@property (nonatomic,strong) Character* loggedInCharacter;
//@property (nonatomic, strong) Clue* clueToPass;
//@property (nonatomic, strong) BOOL shouldGenerate;
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
    
    //    Get ONLY Your Own Quests first !!!
    NSPredicate* unsolvedClues = [NSPredicate predicateWithFormat:@"isSolved == %@",[NSNumber numberWithBool:NO]];
    NSPredicate* clueForUser = [NSPredicate predicateWithFormat:@"clueForCharacter == %@",self.loggedInCharacter];
    NSCompoundPredicate* compoundPredicateForClues = [NSCompoundPredicate andPredicateWithSubpredicates:@[unsolvedClues, clueForUser]];
    
    NSPredicate* clueForOthers = [NSPredicate predicateWithFormat:@"clueForCharacter != %@", self.loggedInCharacter];
    
    NSArray* unsolvedQuests = [Clue MR_findAllWithPredicate:compoundPredicateForClues inContext:context];
    
    if (unsolvedQuests.count > 0) {
        BOOL addFlag = false;
        for (Clue *unsolved in unsolvedQuests) {
            for (Clue *check in questsAndClues) {
                if (unsolved.clueText == check.clueText && unsolved.clueForCharacter == check.clueForCharacter && unsolved.clueId == check.clueId) {
                    NSLog(@"Already exists in the array!!!!!!!!");
                    addFlag = true;
                    break;
                }
            }
        }
        if (!addFlag) {
            [questsAndClues insertObject:[unsolvedQuests firstObject] atIndex:0];
        }
    }
    else {
        NSArray* othersQuests = [Clue MR_findAllWithPredicate:clueForOthers inContext:context];
        
        if (othersQuests.count > 0) {
            BOOL addFlag = false;
            
            for (Clue *unsolved in othersQuests) {
                for (Clue *check in questsAndClues) {
                    if (unsolved.clueText == check.clueText && unsolved.clueForCharacter == check.clueForCharacter && unsolved.clueId == check.clueId && unsolved.clueText != nil){
                        NSLog(@"Already exists in the array!!!!!!!!");
                        addFlag = true;
                        break;
                    }
                }
            }
            if (!addFlag) {
                [questsAndClues insertObject:[othersQuests firstObject] atIndex:0];
            }
        }
    }
    
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
        //Display Clue
        CellIdentifier = @"cluesCell";
        displayString = clue.clueText;
    }else{
        //Display Quest
        CellIdentifier = @"questCell";
        displayString = clue.questForClue.questText;
    }
    
    
    //    NSLog(@"%@",clue);
    
    ONGClueTableViewCell *cell = (ONGClueTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ONGClueTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.clueOrQuestTextLabel.text = displayString?displayString:@"Damn, null cell !";
    return cell;
}

#pragma mark Tableview Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    NSLog(@"Clicking on this row!!! %ld", (long)indexPath.row);
    
    Clue *clue = [self.clues objectAtIndex:indexPath.row];
    clue.isSolved = [NSNumber numberWithBool:YES];
    
    clue.clueText = @"Solve this anagram for a clue";
    //    self.clueToPass = clue;
    
    if (indexPath.row == 0) {
        
        
        
        
        //        AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //
        //        appDel.clueIdForDetailPane = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        //        appDel.clueNameForDetailPane = [NSString stringWithFormat:@"%@ %@ in %@ at %@",[clue.clueForCharacter.name isEqualToString:self.loggedInCharacter.name]?@"You":clue.clueForCharacter.name, clue.action, clue.location, [ONGUtils stringFromDate:clue.timestamp]];
        
        [clue.managedObjectContext MR_saveToPersistentStoreAndWait];
        [self.loggedInCharacter addCluesObject:clue];
        
        //GET MORE CLUES
        self.clues = [self getQuestsAndCluesInContext:self.context];
        [self.tableView reloadData];
        
        
        
        
    }
    
    else {
        
        //        AnagramViewController *detailViewController = [[AnagramViewController alloc]init];
        //        detailViewController.clueToShow = [self.clues objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"showQuest" sender:clue];
    }
    //    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //CONTEXT
    self.context = [NSManagedObjectContext MR_context];
    
    //Tableview Extends below tabbar
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.contentInset = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    
    //Logged In Character
    NSString* loggedInCharacterID = [[NSUserDefaults standardUserDefaults]objectForKey:LOGGED_IN_CHARACTER];
    self.loggedInCharacter = [Character getCharacterFromId:loggedInCharacterID inContext:self.context];
    
    //Set Title
    //    self.title = [NSString stringWithFormat:@"Clues",self.loggedInCharacter.name];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    //Get Data
    self.clues = [self getQuestsAndCluesInContext:self.context];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


#pragma mark Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    AnagramViewController *detailViewController = (AnagramViewController*)[segue destinationViewController];
    detailViewController.clueToShow = sender;
    //    [self.navigationController pushViewController:detailController animated:YES];
    
}


@end
