//
//  CustomLayout.m
//  CVInsertion
//
//  Created by Tim on 10/07/14.
//  Copyright (c) 2014 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CustomLayout.h"
#include <Math.h>

@interface CustomLayout ()

@property (nonatomic, strong) NSMutableArray *layoutAttributes;
@property (nonatomic) CGPoint cvCenterPoint;
@property (nonatomic) float spokeLength;
@property (nonatomic, strong) NSArray *indexPathsBeingUpdated;

@end

@implementation CustomLayout

-(void)prepareLayout {
    
    [super prepareLayout];
    
    // Figure out where the centre of the collection view is
    self.cvCenterPoint = CGPointMake(self.collectionView.frame.size.width / 2,
                                     self.collectionView.frame.size.height / 2);
    
    // Figure out the maximum length of the "spoke"
    float smallestDimension = fminf(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    self.spokeLength = (smallestDimension / 2) - 10.0f; // Allow 10 points of padding on each side

    // Figure out the number of items that we're dealing with
    // Here, we assume that there is only one section in the collection view
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    
    // Create a mutable array to hold the layout attributes
    self.layoutAttributes = [[NSMutableArray alloc] initWithCapacity:numberOfItems];
    
    // Create the attributes for each item in turn
    for (int count = 0; count < numberOfItems; count++) {
        
        // Construct the index path for the item we're dealing with
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:count inSection:0];
        
        // Create a UICollectionViewLayoutAttributes item for this indexPath
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
        
        // Calculate where the centre of the item should be
        CGPoint center = [self calculateCenterForItemAtIndexPath:itemIndexPath];
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

-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {

    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
    
    // Check if this indexPath appears in the list of index paths being updated.
    // If it doesn't, we can don't need to setup the center point
    
    NSIndexSet *indexSet = [self.indexPathsBeingUpdated indexesOfObjectsPassingTest:^BOOL(UICollectionViewUpdateItem *updateItem, NSUInteger idx, BOOL *stop) {
            return (updateItem.indexPathAfterUpdate.row == itemIndexPath.row);
        }];

    // This item isn't one that's appearing, therefore we can use the attributes provided
    // by the superclass method
    
    if ([indexSet count] == 0) {
        return [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    }

    // Test to see if we're dealing with a situation where we're removing
    // the second item - there will now only be 1 item, and the indexPath.row that we're
    // dealing with will be 0.
    //
    // In this situation the first item needs to start where it originated, at the top
    
    if ( ([self.collectionView numberOfItemsInSection:0] == 1) && (itemIndexPath.row == 0)  ){
        [attributes setCenter:[self calculateCenterForFirstItem]];
        [attributes setSize:self.itemSize];
        return attributes;
    }
    
    // This is a brand new item, so we need to set its alpha, size, z-index and center
    
    [attributes setCenter:CGPointMake(self.collectionView.bounds.size.width/2, self.collectionView.bounds.size.height/2)];
    [attributes setAlpha:0.0f];
    [attributes setSize:self.itemSize];
    [attributes setZIndex:0];
    
    return attributes;
    
}

-(UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
    
    // Check if this indexPath appears in the list of index paths being updated.
    // If it doesn't, we can don't need to setup the center point
    
    NSIndexSet *indexSet = [self.indexPathsBeingUpdated indexesOfObjectsPassingTest:^BOOL(UICollectionViewUpdateItem *updateItem, NSUInteger idx, BOOL *stop) {
        return (updateItem.indexPathBeforeUpdate.row == itemIndexPath.row);
    }];
    
    // This item isn't one that's disappearing, therefore we can use the superclass attributes
    
    if ([indexSet count] == 0) {
        return [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    }
    
    // Test to see if we're handling the removal of the first item as it moves to make
    // way for the second one.  In this case, there will be 2 items, and the handling indexPath.row
    // of the item we're dealing with will be 0
    //
    // In this scenario, the item needs to end up back at the top center as the
    // only one
    
    if ( ([self.collectionView numberOfItemsInSection:0] == 2) && (itemIndexPath.row == 0)  ){
        [attributes setCenter:[self calculateCenterForFirstItem]];
        [attributes setSize:self.itemSize];
        [attributes setZIndex:0];
        
        return attributes;
    }

    // This is a disappearing item, so we need to set its alpha, size, z-index and center
    // so that it zooms into towards the centre
    
    [attributes setCenter:CGPointMake(self.collectionView.bounds.size.width/2, self.collectionView.bounds.size.height/2)];
    [attributes setAlpha:0.0f];
    [attributes setSize:self.itemSize];
    [attributes setZIndex:0];
    
    return attributes;
}

-(void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
    self.indexPathsBeingUpdated = updateItems;
}

#pragma mark -
#pragma mark Layout helper methods

-(float)calculateSpokeRadius {
    
    // Calculates the radius of the 'spoke' connecting the item's center and the
    // center of the collectionView
    
    // Find out which is the shorter side, in case
    // the collectionView's not square
    float shorterSide = fminf(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    float collectionViewAllowance = shorterSide / 2;
    float itemWidthAllowance = self.itemSize.width / 2;
    
    // Adjust for side padding (if any)
    return (collectionViewAllowance - (itemWidthAllowance + self.sidePadding));
    
}

-(float)calculateRotationPerItem {
    
    // Shouldn't rotate if there's only one item
    
    if ([self.collectionView numberOfItemsInSection:0] == 1) {
        return 0.0f;
    }
    
    // Otherwise, the rotation is given by 360 / number of items
    // (or 2Pi / number of items as we're dealing with radians here)
    
    return ( 2 * M_PI / [self.collectionView numberOfItemsInSection:0]);
    
}

-(CGPoint)calculateCenterForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // If there's only one item, then it should be centered
    if ([self.collectionView numberOfItemsInSection:0] == 1) {
        return CGPointMake(self.collectionView.bounds.size.width / 2,
                           self.collectionView.bounds.size.height / 2);
    }
    
    // Get angular displacement for this item
    float angularDisplacement = [self calculateRotationPerItem];
    
    // Calculate rotation required for this item
    float theta = (angularDisplacement * indexPath.row);
    
    // Trig to calculate the x and y shifts required to
    // get the moved around a circle of diameter spoke radius
    float xDisplacement = sinf(theta) * [self calculateSpokeRadius];
    float yDisplacement = cosf(theta) * [self calculateSpokeRadius];
    
    // Make the centre point of the hour label block
    float xPosition = (self.collectionView.bounds.size.width/2) + xDisplacement;
    float yPosition = (self.collectionView.bounds.size.width/2) - yDisplacement;
    
    return CGPointMake(xPosition, yPosition);
    
}

-(CGPoint)calculateCenterForFirstItem {
    
    float xPosition = self.collectionView.bounds.size.width / 2;
    float yPosition = 0 + (self.itemSize.height / 2) + self.sidePadding;
    
    return CGPointMake(xPosition, yPosition);
    
}

@end
