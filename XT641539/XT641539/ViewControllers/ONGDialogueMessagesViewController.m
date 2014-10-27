//
//  ONGDialogueMessagesViewController.m
//  XT641539
//
//  Created by Salunke, Shanu on 10/26/14.
//  Copyright (c) 2014 Orange. All rights reserved.
//

#import "ONGDialogueMessagesViewController.h"
#import "ONGCluesViewController.h"
#import "Character+Extended.h"
#import "DialogueMessage.h"
#import "ONGDialogueMEssageTableViewCell.h"

@interface ONGDialogueMessagesViewController ()
@property (nonatomic,strong) NSMutableArray* messages;
@property (nonatomic,strong) NSManagedObjectContext* context;
@end

@implementation ONGDialogueMessagesViewController

#pragma mark Button Action
//Temp
const int toCharacterResponseTag = 1;
const int fromCharacterResponseTag = 0;
- (IBAction)showActionSheet:(id)sender {
    
    //Create Responses
    NSMutableArray *responses = [[NSMutableArray alloc]initWithCapacity:1];
    int responseTag = -1;
    if ([self isAbleToAsk]) {
        responseTag = toCharacterResponseTag;
    }else{
        responseTag = fromCharacterResponseTag;
    }
    responses = [self.characterToTalkTo getPossibleQuestions];
    
    if (responses.count > 0) {
        //Show Actionsheet
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Say Something" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
        popup.tag = responseTag;
        for (NSString* title in responses) {
            [popup addButtonWithTitle:title];
        }
        [popup showInView:self.view];
    }
    else{
        [[[UIAlertView alloc]initWithTitle:@"Oops !" message:@"This character has no clues to share with you" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
    }
   
}

#pragma mark Helpers

- (BOOL) isAbleToAsk{
    
    //You can ask if there are no messages
    if (self.messages.count == 0) {
        return YES;
    }else{
        DialogueMessage* lastMessage = [self.messages lastObject];
        //You cannot ask if the last message was from a character asking you a question
        if ([lastMessage.recievedFromCharacter isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            return NO;
        }
        //But you can ask if the last message was from you (either question or response ?)
        else{
            return YES;
        }
    }
    
}

- (void) getDialogueMessages{
    
    //Get MEssages with characterToTalkTo
    NSPredicate* messagesWithCharacter = [NSPredicate predicateWithFormat:@"withCharacter == %@",self.characterToTalkTo];
    self.messages = [[NSMutableArray alloc]initWithCapacity:1];
    [self.messages addObjectsFromArray:[DialogueMessage MR_findAllWithPredicate:messagesWithCharacter inContext:self.context]];
}

#pragma mark TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"themCell";
    
    DialogueMessage* message = [self.messages objectAtIndex:indexPath.row];
    if ([message.recievedFromCharacter isEqualToNumber:[NSNumber numberWithBool:NO]]) {
        CellIdentifier = @"usCell";
    }
    
    ONGDialogueMEssageTableViewCell *cell = (ONGDialogueMEssageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (ONGDialogueMEssageTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.messageLabel.text = message.messageText;
    
    return cell;
}

#pragma mark Tableview Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [NSManagedObjectContext MR_context];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //Set Title
    self.title = self.characterToTalkTo.name;
    
    //Set Logged in user
    NSString* loggedInCharacterID = [[NSUserDefaults standardUserDefaults]objectForKey:LOGGED_IN_CHARACTER];
    self.loggedInCharacter = [Character getCharacterFromId:loggedInCharacterID inContext:self.context];
    
    //Get Old messages
    [self getDialogueMessages];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Actionsheet Delegates
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case toCharacterResponseTag: {
            
            switch (buttonIndex) {
                case 0:
                    //Cancel
                    break;
                default:
                {
                    //Create a message dialogue
                    DialogueMessage* newMessage = [DialogueMessage MR_createEntityInContext:self.characterToTalkTo.managedObjectContext];
                    newMessage.messageId = [NSString stringWithFormat:@"%ld",random()];
                    newMessage.messageText = [popup buttonTitleAtIndex:buttonIndex];
                    newMessage.timestamp = [NSDate date];
                    newMessage.recievedFromCharacter = [NSNumber numberWithBool:NO];
                    newMessage.clueId = nil;
                    newMessage.withCharacter = self.characterToTalkTo;
                    [self.characterToTalkTo.managedObjectContext MR_saveToPersistentStoreAndWait];
                }
                    break;
            }
            
            }
            break;
        default:
            break;
    }
    
    [self getDialogueMessages];
    [self.tableView reloadData];
}

@end
