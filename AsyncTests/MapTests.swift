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
    Async.map(["one", "two"], iterator: uppercaseString) { err, results in
      XCTAssertEqual(results, ["ONE", "TWO"], "called transform")
    }
  }

  // Helpers

  func uppercaseString(input: String, complete: (NSError?, String) -> ()) {
    complete(nil, input.uppercaseString)
  }

}
