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
    Async.waterfall([slow(0), fast(1)]) { err, results in
      XCTAssertEqual(results, [0, 1])
    }
  }

  func testResultsPassedAlong() {
    Async.waterfall([sumPlusOne, sumPlusOne, sumPlusOne]) { err, results in
      XCTAssertEqual(results, [1, 2, 4])
    }
  }

  // Helpers

  private func sumPlusOne(results: [Int], callback: (NSError?, Int) -> ()) {
    let sum = results.reduce(0) { $0 + $1 }
    callback(nil, sum + 1)
  }

  private func fast(order: Int)(results: [Int], callback: (NSError?, Int) -> ()) {
    callback(nil, order)
  }

  private func slow(order: Int)(results: [Int], callback: (NSError?, Int) -> ()) {
    sleep(1)
    callback(nil, order)
  }

}
