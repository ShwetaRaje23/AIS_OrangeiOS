//
//  ONGDialogueViewController.h
//  XT641539
//
//  Created by RNOC Admin on 10/21/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ONGDialogueViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
