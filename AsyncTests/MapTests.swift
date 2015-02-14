//
//  MapTests.swift
//  Async
//
//  Created by Chris Montrois on 11/14/14.
//  Copyright (c) 2014 bigevilrobot. All rights reserved.
//

import XCTest

class MapTests: XCTestCase {

  func testPreservesOrder() {
    func double(num: Int, complete: (NSError?, Int) -> ()) {
      complete(nil, num * 2)
    }

    Async.map([1, 2], iterator: double) { err, results in
      XCTAssertEqual(results, [2, 4])
    }
  }

  func testRunsInParallel() {
    var completedOrder: [Int] = []

    func throttle(num: Int, callback: (NSError?, Int) -> ()) {
      if num == 1 {
        sleep(1)
      }

      completedOrder.append(num)
      callback(nil, num)
    }

    Async.map([1, 2], iterator: throttle) { err, results in
      XCTAssertEqual(completedOrder, [2, 1])
    }
  }

}
