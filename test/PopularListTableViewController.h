//
//  PopularListTableViewController.h
//  test
//
//  Created by Internet Dev on 19/01/2016.
//  Copyright © 2016 RL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopularList.h"
#import "ListItem.h"
#import "Network.h"

@interface PopularListTableViewController : UITableViewController <PopularListDelegate>

@property (nonatomic, strong) Network *network;
@property (nonatomic, strong) PopularList *popularList;
@property (nonatomic, strong) ListItem *selectedListItem;
@end
