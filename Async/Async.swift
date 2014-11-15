//
//  Async.swift
//  Async
//
//  Created by Chris Montrois on 11/12/14.
//  Copyright (c) 2014 bigevilrobot. All rights reserved.
//

import Foundation

class Async {
  
  class func iterate<I, O>(tasks: [I], complete: (NSError?, [O]) -> (), iterator: (I, (NSError?, O) -> ()) -> ()) {
    var tempResults: [(Int, O)] = []
    
    let next = { (err: NSError?, result: O, index: Int) -> () in
      if err != nil {
        complete(err, [])
      } else {
        tempResults.append((index, result))
        
        if tempResults.count == tasks.count {
          let sortedTempResults = tempResults.sorted { $0.0 < $1.0 }
          let results = sortedTempResults.map { $0.1 }
          complete(nil, results)
        }
      }
    }
    
    for i in 0..<tasks.count {
      iterator(tasks[i]) { err, result in
        next(err, result, i)
      }
    }
  }

  class func map<I, O>(items: [I], transform: (I, (NSError?, O) -> ()) -> (), complete: (NSError?, [O]) -> ()) {
    Async.iterate(items, complete: complete) { item, next in
      transform(item, next)
    }
  }

  class func parallel<T>(tasks: [((NSError?, T) -> ()) -> ()], complete: (NSError?, [T]) -> ()) {
    Async.iterate(tasks, complete: complete) { task, next in
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        task(next)
      }
    }
  }

  class func series<T>(tasks: [((NSError?, T) -> ()) -> ()], complete: (NSError?, [T]) -> ()) {
    Async.iterate(tasks, complete: complete) { task, next in
      task(next)
    }
  }
  
}