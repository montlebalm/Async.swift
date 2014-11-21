//
//  Async.swift
//  Async
//
//  Created by Chris Montrois on 11/12/14.
//  Copyright (c) 2014 bigevilrobot. All rights reserved.
//

import Foundation

class Async {
  
  internal class func _map<I, O>(tasks: [I], complete: (NSError?, [O]) -> (), iterator: (I, (NSError?, O) -> ()) -> ()) {
    var temp: [(Int, O)] = []
    let next = { (err: NSError?, result: O, index: Int) -> () in
      if err != nil {
        complete(err, [])
      } else {
        temp.append((index, result))
        
        if temp.count == tasks.count {
          // Put the results in the original order
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
  
  internal class func _each<I>(tasks: [I], complete: (NSError?) -> (), iterator: (I, (NSError?) -> ()) -> ()) {
    var remaining = tasks.count
    let next = { (err: NSError?) -> () in
      if err != nil {
        complete(err)
      } else {
        remaining -= 1
        
        if remaining == 0 {
          complete(nil)
        }
      }
    }

    for task in tasks {
      iterator(task, next)
    }
  }
  
}