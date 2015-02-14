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
    var completedOrder: [String] = []

    func transform(text: String, callback: (NSError?) -> ()) {
      if text == "slow" {
        sleep(1)
      }

      completedOrder.append(text)
      callback(nil)
    }

    Async.each(["slow", "fast"], transform: transform) { err in
      XCTAssertEqual(completedOrder, ["fast", "slow"])
    }
  }

}
