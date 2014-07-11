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
-(float)calculateRotationPerItem;
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

-(void)testCalculateAngularDisplacementForOneItem {
    
    // Create mock UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 200, 500) collectionViewLayout:self.customLayout];
    
    id collectionViewMock = OCMPartialMock(collectionView);
    
    NSInteger items = 1;
    [[[collectionViewMock stub] andReturnValue:OCMOCK_VALUE(items)] numberOfItemsInSection:0];
    
    [collectionViewMock setCollectionViewLayout:self.customLayout];

    float calculatedRotation = [self.customLayout calculateRotationPerItem];
    
    XCTAssertEqual(calculatedRotation, 0.0f, @"rotation for 1 item should be zero");
    
}

-(void)testCalculateAngularDisplacementForTwoItems {
    
    // Create mock UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 200, 500) collectionViewLayout:self.customLayout];
    
    id collectionViewMock = OCMPartialMock(collectionView);

    NSInteger items = 2;
    [[[collectionViewMock stub] andReturnValue:OCMOCK_VALUE(items)] numberOfItemsInSection:0];
    
    [collectionViewMock setCollectionViewLayout:self.customLayout];
    
    float calculatedRotation = [self.customLayout calculateRotationPerItem];
    
    XCTAssertEqualWithAccuracy(calculatedRotation, M_PI, 0.00001, @"rotation for 2 item should be M_PI");
    
}

-(void)testCalculateAngularDisplacementForThreeItems {
    
    // Create mock UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 200, 500) collectionViewLayout:self.customLayout];
    
    id collectionViewMock = OCMPartialMock(collectionView);
    
    NSInteger items = 3;
    [[[collectionViewMock stub] andReturnValue:OCMOCK_VALUE(items)] numberOfItemsInSection:0];
    
    [collectionViewMock setCollectionViewLayout:self.customLayout];
    
    float calculatedRotation = [self.customLayout calculateRotationPerItem];
    
    float expectedRotation = (2 * M_PI) / 3;
    
    XCTAssertEqualWithAccuracy(calculatedRotation, expectedRotation, 0.00001, @"rotation for 3 item3 should be 2M_PI/3");
    
}

-(void)testCalculateAngularDisplacementForFourItems {

    // Create mock UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 200, 500) collectionViewLayout:self.customLayout];
    
    id collectionViewMock = OCMPartialMock(collectionView);
    
    NSInteger items = 4;
    [[[collectionViewMock stub] andReturnValue:OCMOCK_VALUE(items)] numberOfItemsInSection:0];
    
    [collectionViewMock setCollectionViewLayout:self.customLayout];
    
    float calculatedRotation = [self.customLayout calculateRotationPerItem];
    
    float expectedRotation = (2 * M_PI) / 4;
    
    XCTAssertEqualWithAccuracy(calculatedRotation, expectedRotation, 0.00001, @"rotation for 3 item3 should be 2M_PI/3");
    
}

-(void)testCalculateAngularDisplacementForManyItems {
    
    // Create mock UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 200, 500) collectionViewLayout:self.customLayout];
    
    id collectionViewMock = OCMPartialMock(collectionView);
    
    NSInteger items = 47;
    [[[collectionViewMock stub] andReturnValue:OCMOCK_VALUE(items)] numberOfItemsInSection:0];
    
    [collectionViewMock setCollectionViewLayout:self.customLayout];
    
    float calculatedRotation = [self.customLayout calculateRotationPerItem];
    
    float expectedRotation = (2 * M_PI) / 47;
    
    XCTAssertEqualWithAccuracy(calculatedRotation, expectedRotation, 0.00001, @"rotation for 47 item3 should be 2M_PI/3");
    
}

-(void)testCalculateCenterForOneItem {
    
    // Create mock UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 500, 500) collectionViewLayout:self.customLayout];
    
    id collectionViewMock = OCMPartialMock(collectionView);
    [collectionViewMock setCollectionViewLayout:self.customLayout];
    
    [self.customLayout setItemSize:CGSizeMake(100, 100)];
    [self.customLayout setSidePadding:0.0f];
    
    NSInteger items = 1;
    [[[collectionViewMock stub] andReturnValue:OCMOCK_VALUE(items)] numberOfItemsInSection:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    CGPoint returnedPoint = [self.customLayout calculateCenterForItemAtIndexPath:indexPath];
    
    // Should return the centre of the collection view for a single item
    XCTAssertEqual(returnedPoint.x, 250, @"should be 200");
    XCTAssertEqual(returnedPoint.y, 250, @"should be 50");
    
}

-(void)testCalculateCenterForTwoItems {
    
    // Create mock UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 500, 500) collectionViewLayout:self.customLayout];
    
    id collectionViewMock = OCMPartialMock(collectionView);
    [collectionViewMock setCollectionViewLayout:self.customLayout];
    
    [self.customLayout setItemSize:CGSizeMake(100, 100)];
    [self.customLayout setSidePadding:0.0f];
    
    NSInteger items = 2;
    [[[collectionViewMock stub] andReturnValue:OCMOCK_VALUE(items)] numberOfItemsInSection:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    
    CGPoint returnedPoint = [self.customLayout calculateCenterForItemAtIndexPath:indexPath];
    
    // Should return 500,250 for the second of two items
    XCTAssertEqualWithAccuracy(returnedPoint.x, 250, 0.01, @"should be 250");
    XCTAssertEqualWithAccuracy(returnedPoint.y, 450, 0.01, @"should be 450");
    
}

-(void)testCalculateCenterForFourItems {
    
    // Create mock UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 500, 500) collectionViewLayout:self.customLayout];
    
    id collectionViewMock = OCMPartialMock(collectionView);
    [collectionViewMock setCollectionViewLayout:self.customLayout];
    
    [self.customLayout setItemSize:CGSizeMake(100, 100)];
    [self.customLayout setSidePadding:0.0f];
    
    NSInteger items = 4;
    [[[collectionViewMock stub] andReturnValue:OCMOCK_VALUE(items)] numberOfItemsInSection:0];
    
    
    // Test item 0

    NSIndexPath *indexPath0 = [NSIndexPath indexPathForItem:0 inSection:0];
    CGPoint returnedPoint0 = [self.customLayout calculateCenterForItemAtIndexPath:indexPath0];
    // Should return 500,250 for the second of two items
    XCTAssertEqualWithAccuracy(returnedPoint0.x, 250, 0.01, @"should be 250");
    XCTAssertEqualWithAccuracy(returnedPoint0.y, 50, 0.01, @"should be 50");
    
    // Test item 1

    NSIndexPath *indexPath1 = [NSIndexPath indexPathForItem:1 inSection:0];
    CGPoint returnedPoint1 = [self.customLayout calculateCenterForItemAtIndexPath:indexPath1];
    // Should return 500,250 for the second of two items
    XCTAssertEqualWithAccuracy(returnedPoint1.x, 450, 0.01, @"should be 450");
    XCTAssertEqualWithAccuracy(returnedPoint1.y, 250, 0.01, @"should be 250");

    // Test item 2

    NSIndexPath *indexPath2 = [NSIndexPath indexPathForItem:2 inSection:0];
    CGPoint returnedPoint2 = [self.customLayout calculateCenterForItemAtIndexPath:indexPath2];
    // Should return 500,250 for the second of two items
    XCTAssertEqualWithAccuracy(returnedPoint2.x, 250, 0.01, @"should be 250");
    XCTAssertEqualWithAccuracy(returnedPoint2.y, 450, 0.01, @"should be 0");

    // Test item 3

    NSIndexPath *indexPath3 = [NSIndexPath indexPathForItem:3 inSection:0];
    CGPoint returnedPoint3 = [self.customLayout calculateCenterForItemAtIndexPath:indexPath3];
    // Should return 500,250 for the second of two items
    XCTAssertEqualWithAccuracy(returnedPoint3.x, 50, 0.01, @"should be 50");
    XCTAssertEqualWithAccuracy(returnedPoint3.y, 250, 0.01, @"should be 450");

    
}

@end
