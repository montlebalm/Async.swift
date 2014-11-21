//
//  SeriesTests.swift
//  Async
//
//  Created by Chris Montrois on 11/14/14.
//  Copyright (c) 2014 bigevilrobot. All rights reserved.
//

import XCTest

class SeriesTests: XCTestCase {

  func testPreservesOrder() {
    let expect = expectationWithDescription("Wait for testPreservesOrder")

    Async.series([slow, fast]) { err, results in
      XCTAssertEqual([results[0].text, results[1].text], ["slow", "fast"])
      expect.fulfill()
    }

    waitForExpectationsWithTimeout(2) { err in }
  }

  func testRunsInSeries() {
    let expect = expectationWithDescription("Wait for sleep")

    Async.series([slow, fast]) { err, results in
      XCTAssertLessThan(results[0].time, results[1].time)
      expect.fulfill()
    }

    waitForExpectationsWithTimeout(2) { err in }
  }

  // Helpers

  func fast(callback: (NSError?, (text: String, time: NSTimeInterval)) -> ()) {
    callback(nil, ("fast", NSDate().timeIntervalSince1970))
  }

  func slow(callback: (NSError?, (text: String, time: NSTimeInterval)) -> ()) {
    sleep(1)
    callback(nil, ("slow", NSDate().timeIntervalSince1970))
  }

}