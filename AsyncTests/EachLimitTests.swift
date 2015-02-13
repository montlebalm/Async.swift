//
//  EachLimitTests.swift
//  Async
//
//  Created by Chris Montrois on 11/21/14.
//  Copyright (c) 2014 bigevilrobot. All rights reserved.
//

import XCTest

class EachLimitTests: XCTestCase {

  func testRunsInParallel() {
    let expect = expectationWithDescription("Wait for sleep")
    var results: [(Int, NSTimeInterval)] = []

    func transform(sleepTime: Int, callback: (NSError?) -> ()) {
      sleep(UInt32(sleepTime))
      let result = (sleepTime, NSDate().timeIntervalSince1970)
      results.append(result)
      callback(nil)
    }

    Async.eachLimit([1, 0], limit: 2, iterator: transform) { err in
      XCTAssertLessThan(results[0].0, results[1].0)
      expect.fulfill()
    }

    waitForExpectationsWithTimeout(2) { err in }
  }

  func testRespectsLimit() {
    let expect = expectationWithDescription("Wait for sleep")
    var isParallel = false
    var numParallel = 0

    func transform(num: Int, callback: (NSError?) -> ()) {
      numParallel += 1

      if numParallel == 2 {
        isParallel = true
      }

      sleep(1)
      numParallel -= 1
      callback(nil)
    }

    Async.eachLimit([0, 0], limit: 1, iterator: transform) { err in
      XCTAssertTrue(!isParallel, "Should not be parallel")
      expect.fulfill()
    }

    waitForExpectationsWithTimeout(3) { err in }
  }

}
