//
//  EachSeriesTests.swift
//  Async
//
//  Created by Chris Montrois on 2/13/15.
//  Copyright (c) 2015 bigevilrobot. All rights reserved.
//

import XCTest

class EachSeriesTests: XCTestCase {

  func testRunsInSeries() {
    var completedOrder: [String] = []

    func transform(text: String, callback: (NSError?) -> ()) {
      if text == "slow" {
        sleep(1)
      }

      completedOrder.append(text)
      callback(nil)
    }

    Async.eachSeries(["slow", "fast"], transform: transform) { err in
      XCTAssertEqual(completedOrder, ["slow", "fast"])
    }
  }
  
}
