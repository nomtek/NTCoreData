//
//  PersonCell.h
//  Example DataBase Project
//
//  Created by Adam Szeptycki on 02/11/13.
//  Copyright (c) 2013 Adam Szeptycki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

+ (NSString*)reuseIdentifier;
@end
