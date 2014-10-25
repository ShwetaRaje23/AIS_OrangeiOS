//
//  ONGDialogueViewController.m
//  XT641539
//
//  Created by RNOC Admin on 10/21/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "ONGDialogueViewController.h"

@interface ONGDialogueViewController ()

@end

@implementation ONGDialogueViewController

#pragma mark TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifierUs = @"dialogueCellUs";
    static NSString *CellIdentifierThem = @"dialogueCellThem";
    
    UITableViewCell *cell;
    
    if (indexPath.row % 2 == 0) {
        //Us
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierUs];
        cell.textLabel.text = [NSString stringWithFormat:@"cell%li%li", (long)indexPath.section, (long)indexPath.row];
    }
    else{
        //Them
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierThem];
        cell.textLabel.text = [NSString stringWithFormat:@"cell%li%li", (long)indexPath.section, (long)indexPath.row];
    }
    
    
    
    
    
    return cell;
}

#pragma mark Tableview Delegates

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
