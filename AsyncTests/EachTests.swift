//
//  EachTests.swift
//  Async
//
//  Created by Chris Montrois on 11/15/14.
//  Copyright (c) 2014 bigevilrobot. All rights reserved.
//

import XCTest

class EachTests: XCTestCase {

  func testRunsInParallel() {
    let expect = expectationWithDescription("Wait for sleep")
    var results: [(Int, NSTimeInterval)] = []

    func transform(sleepTime: Int, callback: (NSError?) -> ()) {
      sleep(UInt32(sleepTime))
      let result = (sleepTime, NSDate().timeIntervalSince1970)
      results.append(result)
      callback(nil)
    }

    Async.each([1, 0], transform) { err in
      XCTAssertLessThan(results[0].0, results[1].0)
      expect.fulfill()
    }
    
    waitForExpectationsWithTimeout(2) { err in }
  }

}