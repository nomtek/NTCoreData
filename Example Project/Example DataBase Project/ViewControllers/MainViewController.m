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
#import "ProjectsViewController.h"
@interface MainViewController () <NTDataBaseContextChangesNotifications>
    @property (nonatomic,strong) NSMutableArray *peopleArray;
    @property (nonatomic,assign) int offset;
@end


#define FETCH_LIMIT 2

@implementation MainViewController

- (void)mainContextDidInsertObjects:(NSSet*)objects
{

}

- (void)mainContextDidDeleteObjects:(NSSet *)objects
{

}

- (void)mainContextDidUpdateObjects:(NSSet *)objects
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.offset = 0;
    self.peopleArray = [[NSMutableArray alloc]initWithCapacity:FETCH_LIMIT];
    [self loadDevelopersWithLimit:FETCH_LIMIT andOffset:0];
    [[NTDatabase sharedInstance]addDelegate:self];
}

-(void)loadDevelopersWithLimit:(int)limit andOffset:(int)offset
{
    [[NTDatabase sharedInstance]fetchAllDevelopersLimited:FETCH_LIMIT offset:self.offset WithCompetionBlock:^(NSArray *result) {
        [self.peopleArray addObjectsFromArray:result];
        [self.tableView reloadData];
    }];

    self.offset += FETCH_LIMIT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.peopleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonCell* cell = [tableView dequeueReusableCellWithIdentifier:[PersonCell reuseIdentifier]];
    Developer *d = self.peopleArray[indexPath.row];
    cell.nameLabel.text = d.name;
    cell.numberLabel.text = [NSString stringWithFormat:@"%d",d.id];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"firstSegueue" sender:self.peopleArray[indexPath.row]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"firstSegueue"]){
        ProjectsViewController *destinationVC = segue.destinationViewController;
        destinationVC.dev  = (Developer*)sender;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{

    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;

    float reload_distance = 10;
    if(y > h + reload_distance) {
        [self loadDevelopersWithLimit:FETCH_LIMIT andOffset:self.offset];
    }
}
@end
