//
//  filter.swift
//  Async
//
//  Created by Chris Montrois on 2/13/15.
//  Copyright (c) 2015 bigevilrobot. All rights reserved.
//

import Foundation

extension Async {

  class func filter<I>(
    items: [I],
    iterator: (I, (Bool) -> ()) -> (),
    complete: ([I]) -> ()
  ) {
    var queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT)
    var ongoing: [(Int, Bool)] = []

    for (i, item) in enumerate(items) {
      dispatch_async(queue) {
        iterator(item) { passed in
          ongoing.append((i, passed))

          if ongoing.count == items.count {
            let results = ongoing
              .filter({ $0.1 })
              .sorted({ $0.0 < $1.0 })
              .map({ items[$0.0] })
            complete(results)
          }
        }
      }
    }
  }

}
