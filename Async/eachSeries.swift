//
//  eachSeries.swift
//  Async
//
//  Created by Chris Montrois on 2/13/15.
//  Copyright (c) 2015 bigevilrobot. All rights reserved.
//

import Foundation

extension Async {

  class func eachSeries<I>(
    items: [I],
    transform: (I, (NSError?) -> ()) -> (),
    complete: (NSError?) -> ()
  ) {
    var queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL)

    _each(items, complete: complete) { item, next in
      dispatch_sync(queue) {
        transform(item, next)
      }
    }
  }
  
}