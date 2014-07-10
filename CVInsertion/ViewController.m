//
//  ViewController.m
//  CVInsertion
//
//  Created by Tim on 10/07/14.
//  Copyright (c) 2014 Charismatic Megafauna Ltd. All rights reserved.
//

#import "ViewController.h"
#import "CustomLayout.h"

#define kCellReuseIdentifier @"CellReuseIdentifier"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) CustomLayout *customLayout;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setupData];
    [self setupCollectionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Setup methods

-(void)setupData {
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 25; i++) {
        [self.dataArray addObject:[NSNumber numberWithInt:i]];
    }

}

-(void)setupCollectionView {
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CVCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifier];
   
/*
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [self.flowLayout setMinimumInteritemSpacing:10.0f];
    [self.flowLayout setMinimumLineSpacing:10.0f];
    [self.flowLayout setItemSize:CGSizeMake(100.0f, 100.0f)];
    
    [self.collectionView setCollectionViewLayout:self.flowLayout];
*/
    
    self.customLayout = [[CustomLayout alloc] init];
    [self.customLayout setItemSize:CGSizeMake(100.0f, 100.0f)];
    [self.collectionView setCollectionViewLayout:self.customLayout];
    
}

#pragma mark -
#pragma mark UICollectionView methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    
    UILabel *cellLabel = (UILabel *)[cell viewWithTag:1000];
    
    NSNumber *itemNumber = [self.dataArray objectAtIndex:indexPath.row];
    
    [cellLabel setText:[itemNumber stringValue]];
    
    return cell;
    
}

#pragma mark -
#pragma mark Interaction methods

-(IBAction)didTapAddItemButton:(id)sender {

    NSNumber *lastItem = [self.dataArray lastObject];
    
    NSNumber *newItem = [NSNumber numberWithInt:[lastItem intValue] + 1];
    
    [self.dataArray addObject:newItem];
    
    [self.collectionView reloadData];
    
}

-(IBAction)didTapRemoveItemButton:(id)sender {
    
    // Don't attempt to remove a non-existent item!
    if ([self.dataArray count] == 0) {
        return;
    }
    
    [self.dataArray removeLastObject];
    
    [self.collectionView reloadData];
    
}

-(IBAction)didTapEmbiggenButton:(id)sender {

    // Stop if we're going to go above 250x250
    if (self.customLayout.itemSize.width >= 250) {
        return;
    }

    float currentWidth = self.customLayout.itemSize.width;
    float currentHeight = self.customLayout.itemSize.height;
    
    [self.customLayout setItemSize:CGSizeMake(currentWidth + 10,
                                              currentHeight + 10)];

    [self.collectionView reloadData];
}

-(IBAction)didTapEmsmallenButton:(id)sender {

    // Stop if we're going to go below 30x30
    if (self.customLayout.itemSize.width <= 30) {
        return;
    }
    
    float currentWidth = self.customLayout.itemSize.width;
    float currentHeight = self.customLayout.itemSize.height;
    
    [self.customLayout setItemSize:CGSizeMake(currentWidth - 10,
                                              currentHeight - 10)];
    
    [self.collectionView reloadData];
    
}


@end
