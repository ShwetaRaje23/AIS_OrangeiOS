//
//  ONGCluesViewController.h
//  XT641539
//
//  Created by RNOC Admin on 10/21/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clue+Extended.h"
#import "Character+Extended.h"
#import "ONGClueTableViewCell.h"

@interface ONGCluesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
