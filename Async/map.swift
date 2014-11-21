//
//  map.swift
//  Async
//
//  Created by Chris Montrois on 11/19/14.
//  Copyright (c) 2014 bigevilrobot. All rights reserved.
//

import Foundation

extension Async {

  class func map<I, O>(items: [I], iterator: (I, (NSError?, O) -> ()) -> (), complete: (NSError?, [O]) -> ()) {
    var queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT)

    _map(items, complete) { input, callback in
      dispatch_async(queue) {
        iterator(input, callback)
      }
    }
  }
  
}