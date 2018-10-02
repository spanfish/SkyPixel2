//
//  CountryPickupViewController.m
//  BirdEye
//
//  Created by Xiangwei Wang on 2018/10/01.
//  Copyright © 2018 Xiangwei.Work. All rights reserved.
//

#import "CountryPickupViewController.h"
#import <SVProgressHUD.h>
#import "AccountViewModel.h"

@interface CountryCell : UITableViewCell

@property(nonatomic, strong) NSDictionary *country;
@end

@implementation CountryCell
-(void) awakeFromNib {
    [super awakeFromNib];
    RAC(self.textLabel, text) = [RACObserve(self, country) map:^id _Nullable(NSDictionary*  _Nullable value) {
        return [value objectForKey:@"name"];
    }];
}
@end


@interface CountryPickupViewController ()

@end

@implementation CountryPickupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self rac_liftSelector:@selector(presentLoading:) withSignals:[[self rac_signalForSelector:@selector(viewWillDisappear:)] map:^id _Nullable(id _Nullable value) {
        return @NO;
    }], nil];
    self.viewModel = [[CountryViewModel alloc] init];
    [self handleLoadCountriesCommand];
    self.viewModel.active = YES;
}

-(void) handleLoadCountriesCommand {
    @weakify(self)
    [[[self.viewModel.loadCountriesCommand.executionSignals deliverOnMainThread] flatten] subscribeNext:^(RACThreeTuple *tuple) {
        @strongify(self)
        NSLog(@"");
//        NSURLRequest *request = [x first];
//        NSHTTPURLResponse *response = [x second];
        NSDictionary *res = [tuple third];
        [self.viewModel setCountryData:[[res objectForKey:@"data"] objectForKey:@"items"]];
        [self.tableView reloadData];
    }];
    
    [[self.viewModel.loadCountriesCommand.errors deliverOnMainThread] subscribeNext:^(NSError * _Nullable error) {
        NSLog(@"error: %@", error);
        //[SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"Error"];
    }];
    
    [self rac_liftSelector:@selector(presentLoading:) withSignals:self.viewModel.loadCountriesCommand.executing, nil];
}

- (void)presentLoading:(NSNumber *)loading {
    NSLog(@"loading:%@", loading);
    if([loading boolValue] && ![SVProgressHUD isVisible]) {
        NSLog(@"show loading");
        [SVProgressHUD show];
    } else {
        NSLog(@"hide loading");
        [SVProgressHUD dismiss];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel.countryArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [self.viewModel.countryArray objectAtIndex:section];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CountryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Country" forIndexPath:indexPath];
    
    NSArray *array = [self.viewModel.countryArray objectAtIndex: indexPath.section];
    cell.country = [array objectAtIndex:indexPath.row];
    return cell;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.viewModel titleForHeaderInSection:section];
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.viewModel.countryIndexes;
}

-(NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = [self.viewModel.countryArray objectAtIndex: indexPath.section];
    NSDictionary *country = [array objectAtIndex:indexPath.row];
    self.accountViewModel.countryName = [country objectForKey:@"name"];
    self.accountViewModel.countryCode = [country objectForKey:@"code"];
    
    [self.navigationController popViewControllerAnimated:YES];
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

@end
