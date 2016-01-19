//
//  PopularListTableViewController.m
//  test
//
//  Created by Internet Dev on 19/01/2016.
//  Copyright © 2016 RL. All rights reserved.
//

#import "PopularListTableViewController.h"
#import "ViewController.h"

@interface PopularListTableViewController ()

@end

@implementation PopularListTableViewController

static NSString *singleItemSegue = @"singleItemSegue";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //Set up network connection to end point and get popular list XML.
    self.network = [[Network alloc] initWithDelegate:self];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        [self.network getPopularList];
    });
    
}

#pragma mark - Popular list delegate methods

- (void)recievePopularList:(NSData*)xmlResponse{
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        self.popularList = [[PopularList alloc] initWithXML:xmlResponse];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates once complete
            [self.tableView reloadData];
        });
    });
}

- (void)recievePopularListError:(long)statusCode{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                             message:[NSString stringWithFormat:@"Error %ld\n Unable to load content", statusCode]
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.popularList.listOfPopularItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *Identifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    
    ListItem *currentItem = [self.popularList.listOfPopularItems objectAtIndex:indexPath.row];
    cell.textLabel.text = currentItem.title;
    cell.detailTextLabel.text = currentItem.shortDescription;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedListItem = [self.popularList.listOfPopularItems objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:singleItemSegue sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:singleItemSegue]) {
        ViewController *destination = (ViewController *)segue.destinationViewController;
        destination.listItem = self.selectedListItem;
    }
}

@end
