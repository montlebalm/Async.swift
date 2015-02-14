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
    func fast(results: [String], callback: (NSError?, String) -> ()) {
      callback(nil, "fast")
    }

    func slow(results: [String], callback: (NSError?, String) -> ()) {
      sleep(1)
      callback(nil, "slow")
    }

    Async.waterfall([slow, fast]) { err, results in
      XCTAssertEqual(results, ["slow", "fast"])
    }
  }

  func testRunsInSeries() {
    var completedOrder: [String] = []

    func fast(results: [Int], callback: (NSError?, Int) -> ()) {
      completedOrder.append("fast")
      callback(nil, 0)
    }

    func slow(results: [Int], callback: (NSError?, Int) -> ()) {
      sleep(1)
      completedOrder.append("slow")
      callback(nil, 0)
    }

    Async.waterfall([slow, fast]) { err, results in
      XCTAssertEqual(completedOrder, ["slow", "fast"])
    }
  }

  func testResultsPassedAlong() {
    func sumPlusOne(results: [Int], callback: (NSError?, Int) -> ()) {
      let sum = results.reduce(0, combine: +)
      callback(nil, sum + 1)
    }

    Async.waterfall([sumPlusOne, sumPlusOne]) { err, results in
      XCTAssertEqual(results, [1, 2])
    }
  }

}
