//
//  MainViewController.m
//  Example DataBase Project
//
//  Created by Adam Szeptycki on 02/11/13.
//  Copyright (c) 2013 Adam Szeptycki. All rights reserved.
//

#import "MainViewController.h"
#import "PersonCell.h"
#import "Person.h"
#import "Database.h"
@interface MainViewController ()
@property (nonatomic,strong) NSMutableArray *peopleArray;
@end

@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NTDatabase sharedInstance]fetchAllPeopleWithCompetionBlock:^(NSArray *result) {
        self.peopleArray = [result mutableCopy];
        [self.tableView reloadData];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.peopleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonCell* cell = [tableView dequeueReusableCellWithIdentifier:[PersonCell reuseIdentifier]];
    Person *p = self.peopleArray[indexPath.row];
    cell.nameLabel.text = p.name;
    cell.numberLabel.text = [NSString stringWithFormat:@"%d",p.number];
    return cell;
}

- (IBAction)okButtonClicked:(UIButton *)sender
{
    if(![self.nameTextField.text isEqualToString:@""] && ![self.numberTextField.text isEqualToString:@""]){
        NSString *name = self.nameTextField.text;
        int number = [self.numberTextField.text intValue];
        
        [[NTDatabase sharedInstance]addPersonWithName:name andNumber:number withCompetionBlock:^(NSArray *result) {
            [self.tableView beginUpdates];
            if(!self.peopleArray){
                self.peopleArray = [[NSMutableArray alloc]initWithCapacity:1];
            }
            [self.peopleArray addObject:[result lastObject]];
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.peopleArray.count-1 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            self.numberTextField.text = @"";
            self.nameTextField.text = @"";
            [self.tableView endUpdates];
        }];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tableView beginUpdates];
        Person *p = self.peopleArray[indexPath.row];
        [[NTDatabase sharedInstance] removePersonWithNumber:p.number withCompletionBlock:nil];
        [self.peopleArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
@end
