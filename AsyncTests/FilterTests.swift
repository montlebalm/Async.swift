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
    var completedOrder: [Int] = []

    func throttle(num: Int, callback: (Bool) -> ()) {
      if num == 1 {
        sleep(1)
      }

      completedOrder.append(num)
      callback(true)
    }

    Async.filter([1, 2], iterator: throttle) { results in
      XCTAssertEqual(completedOrder, [2, 1])
    }
  }

}
