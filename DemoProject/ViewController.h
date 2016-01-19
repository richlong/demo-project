//
//  ViewController.h
//  test
//
//  Created by Internet Dev on 19/01/2016.
//  Copyright © 2016 RL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Network.h"
#import "PopularList.h"
#import "ListItem.h"
#import "SingleItem.h"

@interface ViewController : UIViewController <SingleItemDelegate>

@property (nonatomic, strong) Network *network;
@property (nonatomic, strong) PopularList *popularList;
@property (nonatomic, strong) SingleItem *singleItem;
@property (nonatomic, strong) ListItem *listItem;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UILabel *broadcastChannel;
@property (weak, nonatomic) IBOutlet UITextView *synopsis;

@end

