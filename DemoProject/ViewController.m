//
//  ViewController.m
//  test
//
//  Created by Rich Long on 19/01/2016.
//  Copyright © 2016 RL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //Set up network connection to end point
    self.network = [[Network alloc] initWithDelegate:self];
    
    //Hide UI until content loaded
    self.imageView.hidden = YES;
    self.itemTitle.hidden = YES;
    self.broadcastChannel.hidden = YES;
    self.synopsis.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        
        if (self.listItem) {
            [self.network getSingleItem:self.listItem.url];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates once complete
                [self recieveSingleItemError:500];
            });
        }
    });
}

#pragma mark - Single item delegate methods

- (void)recieveSingleItem:(NSData *)xmlResponse {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        self.singleItem = [[SingleItem alloc]initWithXML:xmlResponse];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates once complete
            [self setUIElementContent];
        });
    });
}

- (void)recieveSingleItemError:(long)statusCode {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                             message:[NSString stringWithFormat:@"Error %ld\n Unable to load content", statusCode]
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:actionOk];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self presentViewController:alertController animated:YES completion:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });}

- (void)recieveImage:(NSData *)dataResponse {
    
    UIImage *downloadedImage = [UIImage imageWithData: dataResponse];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        //Run UI Updates once complete
        [self.imageView setImage:downloadedImage];
        [MBProgressHUD hideHUDForView:self.imageView animated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
}

- (void)setUIElementContent {
    
    //Set content based on XML
    self.itemTitle.text = self.singleItem.title;
    self.broadcastChannel.text = self.singleItem.broadcastChannel;
    self.synopsis.text = self.singleItem.synopsis;
    
    self.title = self.singleItem.title;

    //Request image and add loading icon to imageview
    [self.network getImage:self.singleItem.image];
    [MBProgressHUD showHUDAddedTo:self.imageView animated:YES];

    //Show all views with content loaded
    self.imageView.hidden = NO;
    self.itemTitle.hidden = NO;
    self.broadcastChannel.hidden = NO;
    self.synopsis.hidden = NO;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
