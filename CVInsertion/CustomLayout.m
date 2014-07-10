//
//  CustomLayout.m
//  CVInsertion
//
//  Created by Tim on 10/07/14.
//  Copyright (c) 2014 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CustomLayout.h"

@interface CustomLayout ()

@property (nonatomic, strong) NSMutableArray *layoutAttributes;

@end

@implementation CustomLayout

-(void)prepareLayout {
    
    [super prepareLayout];

    // Figure out the number of items that we're dealing with
    // Here, we assume that there is only one section in the collection view
    int numberOfItems = [self.collectionView numberOfItemsInSection:0];
    
    // Create a mutable array to hold the layout attributes
    self.layoutAttributes = [[NSMutableArray alloc] initWithCapacity:numberOfItems];
    
    // Create the attributes for each item in turn
    for (int count = 0; count < numberOfItems; count++) {
        
        // Construct the index path for the item we're dealing with
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:count inSection:0];
        
        // Create a UICollectionViewLayoutAttributes item for this indexPath
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
        
        // Calculate where the centre of the item should be
        float xCoord = 100 + (count * 10);
        float yCoord = 100 + (count * 10);
        
        CGPoint center = CGPointMake(xCoord, yCoord);
        [attributes setCenter:center];
        
        // Set the item's size
        [attributes setSize:self.itemSize];
        
        // Set the Z-index so they "stack" on top of each other
        [attributes setZIndex:count + 1];
        
        // Add our new set of attributes into the array
        [self.layoutAttributes addObject:attributes];
        
    }

}

-(CGSize)collectionViewContentSize {
    
    [super collectionViewContentSize];
    
    // The assumption here is that the content size is the same as the collection view size,
    // as it's full screen and won't scroll
    return self.collectionView.frame.size;
    
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    // As all elements will be shown, return all of them
    return self.layoutAttributes;
    
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {

    // Return the layout attributes for the specific item
    return [self.layoutAttributes objectAtIndex:indexPath.row];
    
}

@end
