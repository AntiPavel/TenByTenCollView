//
//  WaitingHTMLViewController.m
//  TenByTenCollView
//
//  Created by Павел Антонов on 27.07.15.
//  Copyright (c) 2015 Павел Антонов. All rights reserved.
//

#import "WaitingHTMLViewController.h"
#import "ServerManager.h"
#import "CollectionViewController.h"

@interface WaitingHTMLViewController ()

@property (strong, nonatomic) UIAlertView* alert;

@end

@implementation WaitingHTMLViewController

static NSString* stringDate = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self alertInit];

    [self searchHTMLDataWithDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) alertInit {
    
    _alert = [[UIAlertView alloc] initWithTitle:@"Подождите" message:@"идет загрузка" delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    
    [_alert show];
}

#pragma mark - API

- (void) searchHTMLDataWithDate {
    
    [[ServerManager sharedManager]
     searchLastTop100Date: stringDate
     onSuccess:^(NSString * dateTop100UrlString) {
         
         stringDate = [stringDate stringByAppendingString:dateTop100UrlString];
         
          [_alert dismissWithClickedButtonIndex:nil animated:YES];
         
         [self performSegueWithIdentifier:@"segueThenHTMLIsLoad" sender: nil];
     }
     onFailure:^(BOOL* isHaveHTMLData) {
         
     }];
}

#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
 if ([[segue identifier] isEqualToString:@"segueThenHTMLIsLoad"]) {
     
 UIViewController* destinationViewController = (UIViewController*)segue.destinationViewController;
    
 }
 [segue destinationViewController];
     
 }

@end
