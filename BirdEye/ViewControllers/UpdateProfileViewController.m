//
//  UpdateProfileViewController.m
//  BirdEye
//
//  Created by Xiangwei Wang on 2018/10/01.
//  Copyright © 2018 Xiangwei.Work. All rights reserved.
//

#import "UpdateProfileViewController.h"
#import <ReactiveObjC.h>
#import "CountryPickupViewController.h"
#import <SVProgressHUD.h>

@interface TextFieldCell : UITableViewCell
@property(nonatomic, weak) IBOutlet UITextField *textField;
@end
@implementation TextFieldCell
@end
@interface TextViewCell : UITableViewCell
@property(nonatomic, weak) IBOutlet UITextView *textView;
@end
@implementation TextViewCell
@end
@interface LabelCell : UITableViewCell
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@end
@implementation LabelCell
@end

@interface UpdateProfileViewController ()

@end

@implementation UpdateProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self rac_liftSelector:@selector(presentLoading:) withSignals:[[self rac_signalForSelector:@selector(viewWillDisappear:)] map:^id _Nullable(id _Nullable value) {
        return @NO;
    }], nil];
    
    self.accountViewModel = [[AccountViewModel alloc] init];
    [self handleSaveAction];
}

-(void) handleSaveAction {
    self.saveButton.rac_command = self.accountViewModel.updateProfileCommand;
    
    @weakify(self)
    [[self.accountViewModel.updateProfileCommand.executionSignals flatten] subscribeNext:^(RACThreeTuple *x) {
        //@strongify(self)
        
        //NSURLRequest *request = [x first];
        //NSHTTPURLResponse *response = [x second];
        [SVProgressHUD showSuccessWithStatus:@"Updated"];
    }];
    
    [[self.accountViewModel.updateProfileCommand.errors deliverOnMainThread] subscribeNext:^(NSError * _Nullable error) {
        NSLog(@"error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"Save Error"];
    }];

    [self rac_liftSelector:@selector(presentLoading:) withSignals:self.accountViewModel.updateProfileCommand.executing, nil];
}

- (void)presentLoading:(NSNumber *)loading {
    NSLog(@"loading:%@", loading);
    if([loading boolValue] && ![SVProgressHUD isVisible]) {
        NSLog(@"show loading");
        [SVProgressHUD show];
    } else {
        NSLog(@"hide loading");
        //[SVProgressHUD setStatus:<#(nullable NSString *)#>]
        [SVProgressHUD dismiss];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *sectionHeaders = @[@"Username*",
                                       @"Gender",
                                       @"Country / Area",
                                       @"Introduction"];
    return [sectionHeaders objectAtIndex: section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserName" forIndexPath:indexPath];
        RAC(cell.textField, text) = [RACObserve(self.accountViewModel, name) takeUntil:[cell rac_prepareForReuseSignal]];
        cell.textField.placeholder = @"Your name";
        @weakify(self)
        [[[cell.textField rac_textSignal] takeUntil:[cell rac_prepareForReuseSignal]] subscribeNext:^(NSString * _Nullable name) {
            @strongify(self)
            self.accountViewModel.name = name;
        }];
        return cell;
    } else if(indexPath.section == 1) {
        LabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Gender" forIndexPath:indexPath];
   
        RAC(cell.titleLabel, text) = [[RACObserve(self.accountViewModel, gender) map:^id _Nullable(NSString *  _Nullable gender) {
            if([@"male" isEqualToString:gender]) {
                return @"Male";
            } else if([@"female" isEqualToString:gender]) {
                return @"Female";
            } else if([@"undisclosed" isEqualToString:gender]) {
                return @"Prefer not to say";
            } else {
                return @"Please choose";
            }
            
        }] takeUntil:[cell rac_prepareForReuseSignal]];
        return cell;
    } else if(indexPath.section == 2) {
        LabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Country" forIndexPath:indexPath];
        RAC(cell.titleLabel, text) = [[RACObserve(self.accountViewModel, countryName) map:^id _Nullable(NSString *  _Nullable countryName) {
            if(countryName.length == 0) {
                return @"Please choose";
            }
            return countryName;
        }] takeUntil:[cell rac_prepareForReuseSignal]];
        return cell;
    } else if(indexPath.section == 3) {
        TextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Introduction" forIndexPath:indexPath];
       
        RAC(cell.textView, text) = [RACObserve(self.accountViewModel, des) takeUntil:[cell rac_prepareForReuseSignal]];
        //cell.textView.placeholder = @"Your introduction";
        @weakify(self)
        [[[cell.textView rac_textSignal] takeUntil:[cell rac_prepareForReuseSignal]] subscribeNext:^(NSString * _Nullable introduction) {
            @strongify(self)
            self.accountViewModel.des = introduction;
        }];
        return cell;
    }
    return nil;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 3) {
        return 150;
    }
    return 50;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1) {
        //gender
        UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [sheet addAction:[UIAlertAction actionWithTitle:@"Male" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.accountViewModel.gender = @"male";
        }]];
        [sheet addAction:[UIAlertAction actionWithTitle:@"Female" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.accountViewModel.gender = @"female";
        }]];
        [sheet addAction:[UIAlertAction actionWithTitle:@"Prefer not to say" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.accountViewModel.gender = @"undisclosed";
        }]];
        [sheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:sheet animated:YES completion:nil];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"CountryList"]) {
        CountryPickupViewController *vc = segue.destinationViewController;
        vc.accountViewModel = self.accountViewModel;
    }
}
@end
