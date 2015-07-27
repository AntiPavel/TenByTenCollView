//
//  CollectionViewController.m
//  TenByTenCollView
//
//  Created by Павел Антонов on 27.07.15.
//  Copyright (c) 2015 Павел Антонов. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "ServerManager.h"
#import "UIImageView+AFNetworking.h"

@interface CollectionViewController ()

@property (strong, nonatomic) NSMutableArray* imageUrls;

@end

@implementation CollectionViewController

static NSString* const reuseIdentifier = @"Cell";
static NSString* stringDate = nil;



- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageUrls = [NSMutableArray array];
    
    [self getImageUrlFromServer];
  self.navigationItem.hidesBackButton = YES;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - API

- (void) getImageUrlFromServer {

    [[ServerManager sharedManager]
     getImageUrlNameWithDate: stringDate
     onSuccess:^(NSArray* imageUrls) {
         
         [self.imageUrls addObjectsFromArray: imageUrls];
         NSLog(@"imgNames count= %ld", [self.imageUrls count]);
     }
     onFailure:^(BOOL* isHaveUrl) {

     }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.imageUrls count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[self.imageUrls objectAtIndex:indexPath.row]];
    
    __weak CollectionViewCell* weakCell = cell;
    
    UIImage* placeholder = [UIImage imageNamed:@"vienna2.jpg"];
    
    [cell.imageView
     setImageWithURLRequest:request
     placeholderImage:placeholder
     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
         weakCell.imageView.image = image;
        
     }
     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
         
     }];

    return cell;
}

@end
