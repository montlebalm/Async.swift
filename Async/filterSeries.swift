//
//  filterSeries.swift
//  Async
//
//  Created by Chris Montrois on 2/13/15.
//  Copyright (c) 2015 bigevilrobot. All rights reserved.
//

import Foundation

extension Async {

  class func filterSeries<I>(
    items: [I],
    iterator: (I, (Bool) -> ()) -> (),
    complete: ([I]) -> ()
  ) {
    var queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT)

    _filter(items, complete: complete) { item, callback in
      dispatch_sync(queue) {
        iterator(item, callback)
      }
    }
  }

}
