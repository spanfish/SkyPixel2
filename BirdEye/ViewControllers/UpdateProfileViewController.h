//
//  UpdateProfileViewController.h
//  BirdEye
//
//  Created by Xiangwei Wang on 2018/10/01.
//  Copyright © 2018 Xiangwei.Work. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountViewModel.h"

@interface UpdateProfileViewController : UITableViewController

@property(nonatomic, weak) IBOutlet UIBarButtonItem *saveButton;
@property(nonatomic, strong) AccountViewModel *accountViewModel;
@end
