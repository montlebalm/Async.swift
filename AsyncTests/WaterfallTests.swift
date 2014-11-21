//
//  WaterfallTests.swift
//  Async
//
//  Created by Chris Montrois on 11/21/14.
//  Copyright (c) 2014 bigevilrobot. All rights reserved.
//

import XCTest

class WaterfallTests: XCTestCase {

  func testPreservesOrder() {
    let expect = expectationWithDescription("Wait for sleep")

    Async.waterfall([slow(0), fast(1)]) { err, results in
      XCTAssertEqual(results, [0, 1])
      expect.fulfill()
    }

    waitForExpectationsWithTimeout(2) { err in }
  }

  func testResultsPassedAlong() {
    let expect = expectationWithDescription("Wait for async")

    Async.waterfall([sumPlusOne, sumPlusOne, sumPlusOne]) { err, results in
      XCTAssertEqual(results, [1, 2, 4])
      expect.fulfill()
    }

    waitForExpectationsWithTimeout(1) { err in }
  }

  // Helpers

  func sumPlusOne(results: [Int], callback: (NSError?, Int) -> ()) {
    let sum = results.reduce(0) { $0 + $1 }
    callback(nil, sum + 1)
  }

  func fast(order: Int)(results: [Int], callback: (NSError?, Int) -> ()) {
    callback(nil, order)
  }

  func slow(order: Int)(results: [Int], callback: (NSError?, Int) -> ()) {
    sleep(1)
    callback(nil, order)
  }

}