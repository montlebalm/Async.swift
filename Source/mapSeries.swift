//
//  mapSeries.swift
//  Async
//
//  Created by Chris Montrois on 2/13/15.
//  Copyright (c) 2015 bigevilrobot. All rights reserved.
//

import Foundation

extension Async {

  class func mapSeries<I, O>(
    items: [I],
    iterator: (I, (NSError?, O) -> ()) -> (),
    complete: (NSError?, [O]) -> ()
  ) {
    var queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL)

    _map(items, complete: complete) { item, callback in
      dispatch_sync(queue) {
        iterator(item, callback)
      }
    }
  }
  
}
