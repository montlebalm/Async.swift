import Foundation
import UIKit

public class Async {

  internal class func _each<I>(
    tasks: [I],
    complete: (NSError?) -> (),
    iterator: (I, (NSError?) -> ()) -> ()
  ) {
    var remaining = tasks.count

    for task in tasks {
      iterator(task) { err in
        if err != nil || --remaining == 0 {
          complete(err)
        }
      }
    }
  }

  internal class func _filter<I>(
    items: [I],
    complete: ([I]) -> (),
    iterator: (I, (Bool) -> ()) -> ()
  ) {
    var ongoing = [Int: Bool]()

    for (i, item) in enumerate(items) {
      iterator(item) { passed in
        ongoing[i] = passed

        if ongoing.count == items.count {
          let results = Array(ongoing.keys)
            .map({ (index: $0, passed: ongoing[$0]!) })
            .filter({ $0.1 })
            .sorted({ $0.index < $1.index })
            .map({ items[$0.index] })
          complete(results)
        }
      }
    }
  }

  internal class func _map<I, O>(
    items: [I],
    complete: (NSError?, [O]) -> (),
    iterator: (I, (NSError?, O) -> ()) -> ()
  ) {
    var ongoing = [Int: O]()

    for (i, item) in enumerate(items) {
      iterator(items[i]) { err, result in
        ongoing[i] = result

        if err != nil || ongoing.count == items.count {
          let results = Array(ongoing.keys)
            .map({ (index: $0, passed: ongoing[$0]!) })
            .sorted({ $0.0 < $1.0 }).map({ $0.1 })
          complete(err, results)
        }
      }
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

  internal class func _detect<I>(
    items: [I],
    complete: (NSError?, I) -> (),
    iterator: (I, (NSError?, Bool) -> ()) -> ()
  ) {
    var ctr = 0

    for item in items {
      iterator(item) { (err: NSError?, passed: Bool) -> () in
        if err != nil || passed {
          complete(err, item)
        }
      }
    }
  }

}
