//
//  eachLimit.swift
//  Async
//
//  Created by Chris Montrois on 11/19/14.
//  Copyright (c) 2014 bigevilrobot. All rights reserved.
//

import Foundation

extension Async {
  
  class func eachLimit<I>(items: [I], limit: Int, iterator: (I, (NSError?) -> ()) -> (), complete: (NSError?) -> ()) {
    var queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT)
    var limitingSemaphore = dispatch_semaphore_create(limit)

    _each(items, complete) { item, next in
      dispatch_async(queue) {
        dispatch_semaphore_wait(limitingSemaphore, DISPATCH_TIME_FOREVER)
        iterator(item, next)
        dispatch_semaphore_signal(limitingSemaphore)
      }
    }
  }
  
}