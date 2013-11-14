//
//  ProjectsViewController.m
//  Example DataBase Project
//
//  Created by Adam Szeptycki on 13/11/13.
//  Copyright (c) 2013 Adam Szeptycki. All rights reserved.
//

#import "ProjectsViewController.h"
#import "PersonCell.h"
#import "Project.h"
@interface ProjectsViewController ()
@property (nonatomic,strong) NSArray* projects;
@end

@implementation ProjectsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.projects = [self.dev.projects allObjects];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.projects.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PersonCell* cell = [tableView dequeueReusableCellWithIdentifier:@"personCell"];
    Project *p = self.projects[indexPath.row];
    cell.nameLabel.text = p.name;
    cell.numberLabel.text = [NSString stringWithFormat:@"%d",p.budget];
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    <#code#>
//}


@end
