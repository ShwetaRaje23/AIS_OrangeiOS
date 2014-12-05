//
//  ONGDialogueMessagesViewController.h
//  XT641539
//
//  Created by Salunke, Shanu on 10/26/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Character+Extended.h"

@interface ONGDialogueMessagesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) Character* characterToTalkTo;
@property (nonatomic,strong) Character* loggedInCharacter;
@end
