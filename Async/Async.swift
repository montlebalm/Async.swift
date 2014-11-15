//
//  Async.swift
//  Async
//
//  Created by Chris Montrois on 11/12/14.
//  Copyright (c) 2014 bigevilrobot. All rights reserved.
//

import Foundation

func iterate<I, O>(tasks: [I], complete: (NSError?, [O]) -> (), iterator: (I, (NSError?, O) -> ()) -> ()) {
  var temp: [(Int, O)] = []
  
  let next = { (err: NSError?, result: O, index: Int) -> () in
    if err != nil {
      complete(err, [])
    } else {
      temp.append((index, result))
      
      if temp.count == tasks.count {
        let sortedTemp = temp.sorted { $0.0 < $1.0 }
        let results = sortedTemp.map { $0.1 }
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

class Async {
  
  class func map<I, O>(items: [I], transform: (I, (NSError?, O) -> ()) -> (), complete: (NSError?, [O]) -> ()) {
    iterate(items, complete) { item, next in
      transform(item, next)
    }
  }
  
  class func parallel<O>(tasks: [((NSError?, O) -> ()) -> ()], complete: (NSError?, [O]) -> ()) {
    iterate(tasks, complete) { task, next in
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        task(next)
      }
    }
  }
  
  class func series<O>(tasks: [((NSError?, O) -> ()) -> ()], complete: (NSError?, [O]) -> ()) {
    iterate(tasks, complete) { task, next in
      task(next)
    }
  }
  
}