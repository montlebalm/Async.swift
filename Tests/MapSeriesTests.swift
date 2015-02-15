//
//  MapSeriesTests.swift
//  Async
//
//  Created by Chris Montrois on 2/13/15.
//  Copyright (c) 2015 bigevilrobot. All rights reserved.
//

import XCTest

class MapSeriesTests: XCTestCase {

  func testPreservesOrder() {
    func double(num: Int, complete: (NSError?, Int) -> ()) {
      complete(nil, num * 2)
    }

    Async.mapSeries([1, 2], iterator: double) { err, results in
      XCTAssertEqual(results, [2, 4])
    }
  }

  func testRunsInSeries() {
    var completedOrder: [String] = []

    func throttle(text: String, callback: (NSError?, String) -> ()) {
      if text == "slow" {
        sleep(1)
      }

      completedOrder.append(text)
      callback(nil, text)
    }

    Async.mapSeries(["slow", "fast"], iterator: throttle) { err, results in
      XCTAssertEqual(completedOrder, ["slow", "fast"])
    }
  }
  
}
