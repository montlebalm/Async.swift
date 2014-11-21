//
//  waterfall.swift
//  Async
//
//  Created by Chris Montrois on 11/21/14.
//  Copyright (c) 2014 bigevilrobot. All rights reserved.
//

import Foundation

extension Async {

  class func waterfall<O>(tasks: [([O], (NSError?, O) -> ()) -> ()], complete: (NSError?, [O]) -> ()) {
    var results: [O] = []
    let next = { (err: NSError?, result: O) -> () in
      if err != nil {
        complete(err, [])
      } else {
        results.append(result)

        if results.count == tasks.count {
          complete(nil, results)
        }
      }
    }
    
    var queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL)

    for task in tasks {
      dispatch_sync(queue) {
        task(results, next)
      }
    }
  }
  
}