//
//  Async.swift
//  Async
//
//  Created by Chris Montrois on 11/12/14.
//  Copyright (c) 2014 bigevilrobot. All rights reserved.
//

import Foundation

func _map<I, O>(tasks: [I], complete: (NSError?, [O]) -> (), iterator: (I, (NSError?, O) -> ()) -> ()) {
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

func _each<I>(tasks: [I], complete: (NSError?) -> (), iterator: (I, (NSError?) -> ()) -> ()) {
  var remaining = tasks.count
  let next = { (err: NSError?, index: Int) -> () in
    if err != nil {
      complete(err)
    } else {
      remaining -= 1

      if remaining == 0 {
        complete(nil)
      }
    }
  }
  
  for i in 0..<tasks.count {
    iterator(tasks[i]) { err in
      next(err, i)
    }
  }
}

class Async {

  class func each<I>(items: [I], transform: (I, (NSError?) -> ()) -> (), complete: (NSError?) -> ()) {
    _each(items, complete) { item, next in
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        transform(item, next)
      }
    }
  }

  class func map<I, O>(items: [I], transform: (I, (NSError?, O) -> ()) -> (), complete: (NSError?, [O]) -> ()) {
    _map(items, complete, transform)
  }
  
  class func parallel<O>(tasks: [((NSError?, O) -> ()) -> ()], complete: (NSError?, [O]) -> ()) {
    _map(tasks, complete) { task, next in
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        task(next)
      }
    }
  }
  
  class func series<O>(tasks: [((NSError?, O) -> ()) -> ()], complete: (NSError?, [O]) -> ()) {
    _map(tasks, complete) { task, next in
      task(next)
    }
  }
  
}