//
//  FilterTests.swift
//  Async
//
//  Created by Chris Montrois on 2/13/15.
//  Copyright (c) 2015 bigevilrobot. All rights reserved.
//

import XCTest

class FilterTests: XCTestCase {

  func testPreservesOrder() {
    func isEven(num: Int, callback: (Bool) -> ()) {
      callback(num % 2 == 0)
    }

    Async.filter([1, 2, 3, 4], iterator: isEven) { results in
      XCTAssertEqual(results, [2, 4])
    }
  }

  func testRunsInParallel() {
    var completedOrder: [String] = []

    func throttle(text: String, callback: (Bool) -> ()) {
      if text == "slow" {
        sleep(1)
      }

      completedOrder.append(text)
      callback(true)
    }

    Async.filter(["slow", "fast"], iterator: throttle) { results in
      XCTAssertEqual(completedOrder, ["fast", "slow"])
    }
  }

}
