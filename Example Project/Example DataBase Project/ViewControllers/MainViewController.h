//
//  MainViewController.h
//  Example DataBase Project
//
//  Created by Adam Szeptycki on 02/11/13.
//  Copyright (c) 2013 Adam Szeptycki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
- (IBAction)okButtonClicked:(UIButton *)sender;
@end
