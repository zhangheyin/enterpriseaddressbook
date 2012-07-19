//
//  HomepwnerItemCell.h
//  Homepwner
//
//  Created by joeconway on 9/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CallRecordCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *picView;
@property (retain, nonatomic) IBOutlet UILabel *main_lable;
@property (retain, nonatomic) IBOutlet UILabel *number_lable;
@property (retain, nonatomic) IBOutlet UILabel *dial_time_lable;


@property (copy, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *main;
@property (copy, nonatomic) NSString *number;
@property (copy, nonatomic) NSString *dialTime;
//@property (weak, nonatomic) id controller;
//@property (weak, nonatomic) UITableView *tableView;
//- (IBAction)showImage:(id)sender;

@end
