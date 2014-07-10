//
//  LayoutTests.m
//  CVInsertion
//
//  Created by Tim on 10/07/14.
//  Copyright (c) 2014 Charismatic Megafauna Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CustomLayout.h"
#import <OCMock/OCMock.h>

@interface CustomLayout ()
-(float)calculateSpokeRadius;
-(CGPoint)calculateCenterForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface LayoutTests : XCTestCase
@property (nonatomic, strong) CustomLayout *customLayout;
@end

@implementation LayoutTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.customLayout = [[CustomLayout alloc] init];
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    self.customLayout = nil;
}

-(void)testLayoutCanBeInstantiated {
    XCTAssertNotNil(self.customLayout, @"self.customLayout should not be nil");
}

-(void)testCustomLayoutHasCalculateSpokeRadiusMethod {
    XCTAssertTrue([self.customLayout respondsToSelector:@selector(calculateSpokeRadius)], @"does not respond to calculateSpokeRadius");
}

-(void)testCalculateSpokeRadiusReturnsCorrectValueForOneItem {
    
    // Create mock UICollectionView
    id collectionViewMock = OCMClassMock([UICollectionView class]);
    
    // Stub numberOfItemsInSection
    OCMStub([collectionViewMock numberOfItemsInSection:0]).andReturn(1);

    // Should return 0
    XCTAssertEqual([self.customLayout calculateSpokeRadius], 0.0f, @"should return 0 for a single item");
}

-(void)testCalculateSpokeRadiusReturnsCorrectValueForTwoItems {

    // Create mock UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 500, 500) collectionViewLayout:self.customLayout];
    
    id collectionViewMock = OCMPartialMock(collectionView);
    [[[collectionViewMock stub] andReturnValue:@(1)] numberOfItemsInSection:0];
    
    [collectionViewMock setCollectionViewLayout:self.customLayout];
    
    // Set item size
    [self.customLayout setItemSize:CGSizeMake(100, 100)];
    [self.customLayout setSidePadding:10.0f];

    // Should return
    XCTAssertEqual([self.customLayout calculateSpokeRadius], 190.0f, @"should be 190.0f");
    
}

-(void)testCalculateSpokeRadiusUsesHeightOfCollectionViewIfShortest {

    // Create mock UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 500, 200) collectionViewLayout:self.customLayout];
    
    id collectionViewMock = OCMPartialMock(collectionView);
    [[[collectionViewMock stub] andReturnValue:@(1)] numberOfItemsInSection:0];
    
    [collectionViewMock setCollectionViewLayout:self.customLayout];
    
    // Set item size
    [self.customLayout setItemSize:CGSizeMake(100, 100)];
    [self.customLayout setSidePadding:10.0f];
    
    // Should return
    XCTAssertEqual([self.customLayout calculateSpokeRadius], 40.0f, @"should be 40.0f");

}

-(void)testCalculateSpokeRadiusUsesWidthOfCollectionViewIfShortest {
    
    // Create mock UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 200, 500) collectionViewLayout:self.customLayout];
    
    id collectionViewMock = OCMPartialMock(collectionView);
    [[[collectionViewMock stub] andReturnValue:@(1)] numberOfItemsInSection:0];
    
    [collectionViewMock setCollectionViewLayout:self.customLayout];
    
    // Set item size
    [self.customLayout setItemSize:CGSizeMake(100, 100)];
    [self.customLayout setSidePadding:10.0f];
    
    // Should return
    XCTAssertEqual([self.customLayout calculateSpokeRadius], 40.0f, @"should be 40.0f");
    
}

-(void)testCalculateCenter {
    
    // Create mock UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 200, 500) collectionViewLayout:self.customLayout];
    
    id collectionViewMock = OCMPartialMock(collectionView);
    [collectionViewMock setCollectionViewLayout:self.customLayout];
    
    [self.customLayout setItemSize:CGSizeMake(100, 100)];
    [self.customLayout setSidePadding:0.0f];
    
    // Should return 90deg for 4 items
    [[[collectionViewMock stub] andReturnValue:@(4)] numberOfItemsInSection:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    CGPoint returnedPoint = [self.customLayout calculateCenterForItemAtIndexPath:indexPath];
    
    XCTAssertEqual(returnedPoint.x, 200, @"should be 200");
    XCTAssertEqual(returnedPoint.y, 50, @"should be 50");
    
}

- (void)testExample
{
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
