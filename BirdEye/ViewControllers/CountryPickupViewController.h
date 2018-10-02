//
//  CountryPickupViewController.h
//  BirdEye
//
//  Created by Xiangwei Wang on 2018/10/01.
//  Copyright © 2018 Xiangwei.Work. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryViewModel.h"

@class AccountViewModel;
@interface CountryPickupViewController : UITableViewController

@property(nonatomic, strong) CountryViewModel *viewModel;
@property(nonatomic, strong) AccountViewModel *accountViewModel;
@end
