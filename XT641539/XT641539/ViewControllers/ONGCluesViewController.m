//
//  ONGCluesViewController.m
//  XT641539
//
//  Created by RNOC Admin on 10/21/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "AnagramViewController.h"
#import "ONGCluesViewController.h"
#import "ONGClueDetailsViewController.h"

@interface ONGCluesViewController ()
@property (nonatomic,strong) NSMutableArray* solvedclues;
@property (nonatomic,strong) NSMutableArray* unsolvedclues;
@property (nonatomic,strong) NSManagedObjectContext* context;
@property (nonatomic,strong) Character* loggedInCharacter;
//@property (nonatomic, strong) Clue* clueToPass;
//@property (nonatomic, strong) BOOL shouldGenerate;
@end

@implementation ONGCluesViewController

#pragma mark Helpers
- (NSMutableArray*) getQuestsAndCluesInContext:(NSManagedObjectContext*)context{
    NSMutableArray* questsAndClues = [[NSMutableArray alloc]initWithCapacity:1];
    self.solvedclues = [[NSMutableArray alloc]initWithCapacity:1];
    self.unsolvedclues = [[NSMutableArray alloc]initWithCapacity:1];
    
    //Get all solved Clues
    NSPredicate* solvedClues = [NSPredicate predicateWithFormat:@"isSolved == %@",[NSNumber numberWithBool:YES]];
    NSPredicate* clueForUser1 = [NSPredicate predicateWithFormat:@"clueForCharacter.characterID == %@",self.loggedInCharacter.characterID];
    NSCompoundPredicate* compoundPredicateForClues1 = [NSCompoundPredicate andPredicateWithSubpredicates:@[clueForUser1, solvedClues]];
    [questsAndClues addObjectsFromArray:[[self.loggedInCharacter.clues filteredSetUsingPredicate:compoundPredicateForClues1] allObjects]];
    [self.solvedclues addObjectsFromArray:[[self.loggedInCharacter.clues filteredSetUsingPredicate:compoundPredicateForClues1] allObjects]];
    
    //    Get ONLY Your Own Quests first !!!
    NSPredicate* unsolvedClues = [NSPredicate predicateWithFormat:@"isSolved == %@",[NSNumber numberWithBool:NO]];
    NSPredicate* clueForUser = [NSPredicate predicateWithFormat:@"clueForCharacter.characterID == %@",self.loggedInCharacter.characterID];
    NSCompoundPredicate* compoundPredicateForClues = [NSCompoundPredicate andPredicateWithSubpredicates:@[unsolvedClues, clueForUser]];
    NSArray* unsolvedQuests = [Clue MR_findAllWithPredicate:compoundPredicateForClues inContext:context];
    [self.unsolvedclues addObjectsFromArray:unsolvedQuests];
    
    [questsAndClues addObjectsFromArray:unsolvedQuests];
    
    NSLog(@"== Added %d and %d solved and unsolved clues",self.solvedclues.count, self.unsolvedclues.count);
    
    
//    if (unsolvedQuests.count > 0) {
//        BOOL addFlag = false;
//        for (Clue *unsolved in unsolvedQuests) {
//            for (Clue *check in questsAndClues) {
//                if (unsolved.clueText == check.clueText && unsolved.clueForCharacter == check.clueForCharacter && unsolved.clueId == check.clueId) {
//                    NSLog(@"Already exists in the array!!!!!!!!");
//                    addFlag = true;
//                    break;
//                }
//            }
//        }
//        if (!addFlag) {
//            [questsAndClues insertObject:[unsolvedQuests firstObject] atIndex:0];
//        }
//    }
//    else {
//        NSArray* othersQuests = [Clue MR_findAllWithPredicate:clueForOthers inContext:context];
//        
//        if (othersQuests.count > 0) {
//            BOOL addFlag = false;
//            
//            for (Clue *unsolved in othersQuests) {
//                for (Clue *check in questsAndClues) {
//                    if (unsolved.clueText == check.clueText && unsolved.clueForCharacter == check.clueForCharacter && unsolved.clueId == check.clueId && unsolved.clueText != nil){
//                        NSLog(@"Already exists in the array!!!!!!!!");
//                        addFlag = true;
//                        break;
//                    }
//                }
//            }
//            if (!addFlag) {
//                [questsAndClues insertObject:[othersQuests firstObject] atIndex:0];
//            }
//        }
//    }
    
    return questsAndClues;
    
}

#pragma mark TableView Datasource

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return 1;
        default:{
            return self.solvedclues.count;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier;
    
    Clue* clue = nil;
    NSString* displayString;
    
    switch (indexPath.section) {
        case 0:
            //Unsolved
            clue = [self.unsolvedclues objectAtIndex:indexPath.row];
            displayString = clue.questText;
            CellIdentifier = @"questCell";
            break;
        default:
            //Solved
            clue = [self.solvedclues objectAtIndex:indexPath.row];
            displayString = clue.clueText;
            CellIdentifier = @"cluesCell";
            break;
    }
    
    ONGClueTableViewCell *cell = (ONGClueTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ONGClueTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (displayString) {
            cell.clueOrQuestTextLabel.text = displayString?displayString:@"Damn, null cell !";
    }
    
    return cell;
}

#pragma mark Tableview Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Clue *clue;
    switch (indexPath.section) {
        case 0:{
            //Quest
            clue = [self.unsolvedclues objectAtIndex:indexPath.row];
            [self performSegueWithIdentifier:@"showQuest" sender:clue];
            break;}
        default:{
            //See Clue Details
//            clue = [self.solvedclues objectAtIndex:indexPath.row];
//            [self performSegueWithIdentifier:@"solvedClueDetails" sender:clue];
//            break;
        }
    }
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
    [self getQuestsAndCluesInContext:self.context];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


#pragma mark Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    Clue* clue = (Clue*)sender;
    if ([clue.isSolved isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        ONGClueDetailsViewController* clueDeets = [[ONGClueDetailsViewController alloc]init];
        clueDeets.clueToshow = clue;
    }
    else{
        AnagramViewController *detailViewController = (AnagramViewController*)[segue destinationViewController];
        detailViewController.clueToShow = sender;
    }
}


@end
