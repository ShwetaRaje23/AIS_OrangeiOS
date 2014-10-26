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

@end

@implementation ONGCluesViewController


#pragma mark TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.clues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CluesCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Clue* clue = [self.clues objectAtIndex:indexPath.row];
    NSString* displayString;
    
    if ([clue.isSolved isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        //Dispaly Clue
        displayString = [NSString stringWithFormat:@"C: %@",clue.clueText];
    }else{
        //Dispaly Quest
        displayString = [NSString stringWithFormat:@"Q: %@",clue.questForClue.questText];
    }
    
    
    NSLog(@"%@",clue);
    
    cell.textLabel.text = displayString;
    return cell;
}

#pragma mark Tableview Delegates

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //[self performSegueWithIdentifier:@"showClue" sender:self];
    
    Clue *clue = [self.clues objectAtIndex:indexPath.row];
    clue.isSolved = [NSNumber numberWithBool:YES];
    clue.clueText = clue.questForClue.questText;
    [clue.managedObjectContext save:nil];
    
    [self.tableView reloadData];
}


#pragma mark Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Tableview Extends below tabbar
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.contentInset = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    //Get All quests and clues from database
    self.context = [NSManagedObjectContext MR_context];
    self.clues = [[NSMutableArray alloc]initWithCapacity:1];
    
    //Temp
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm:ss:ms"];
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    
    //Get first default clue
    Clue* defaultClue = [Clue MR_createEntityInContext:self.context];
    defaultClue.clueText = stringFromDate;
    defaultClue.isSolved = [NSNumber numberWithBool:YES];
    [self.context save:nil];
    [self.clues insertObject:defaultClue atIndex:0];
    
    //Get all solved Clues
    NSPredicate* solvedClues = [NSPredicate predicateWithFormat:@"isSolved == %@",[NSNumber numberWithBool:YES]];
    [self.clues addObjectsFromArray:[Clue MR_findAllWithPredicate:solvedClues inContext:self.context]];
    
    //Get one quest (temporarily random)
    NSPredicate* unsolvedClues = [NSPredicate predicateWithFormat:@"isSolved == %@",[NSNumber numberWithBool:NO]];
    [self.clues insertObject:[[Clue MR_findAllWithPredicate:unsolvedClues inContext:self.context] firstObject] atIndex:0];
    
    
    NSLog(@"%@",self.clues);
    [self.tableView reloadData];
    
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
