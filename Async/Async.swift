//
//  Async.swift
//  Async
//
//  Created by Chris Montrois on 11/12/14.
//  Copyright (c) 2014 bigevilrobot. All rights reserved.
//

import Foundation

public class Async {

  internal class func _map<I, O>(
    tasks: [I],
    complete: (NSError?, [O]) -> (),
    iterator: (I, (NSError?, O) -> ()) -> ()
  ) {
    var ongoing: [(Int, O)] = []

    for i in 0..<tasks.count {
      iterator(tasks[i]) { err, result in
        ongoing.append((i, result))

        if err != nil || ongoing.count == tasks.count {
          let results = ongoing.sorted({ $0.0 < $1.0 }).map({ $0.1 })
          complete(err, results)
        }
      }
    }
  }

  internal class func _each<I>(
    tasks: [I],
    complete: (NSError?) -> (),
    iterator: (I, (NSError?) -> ()) -> ()
  ) {
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

  internal class func _reduce<I, O>(
    tasks: [I],
    initial: O,
    complete: (NSError?, O) -> (),
    iterator: (O, I, (NSError?, O) -> ()) -> ()
  ) {
    var remaining = tasks.count
    var reduction = initial

    for task in tasks {
      iterator(reduction, task) { (err: NSError?, memo: O) -> () in
        reduction = memo

        if err != nil || --remaining == 0 {
          complete(err, reduction)
        }
      }
    }
  }

}
