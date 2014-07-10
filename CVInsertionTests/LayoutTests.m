//
//  LayoutTests.m
//  CVInsertion
//
//  Created by Tim on 10/07/14.
//  Copyright (c) 2014 Charismatic Megafauna Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CustomLayout.h"

@interface CustomLayout ()
-(void)calculateSpokeRadius;
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
}

- (void)testExample
{
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
