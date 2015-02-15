import Foundation

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
    var ongoing: [(Int, Bool)] = []

    for (i, item) in enumerate(items) {
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

  internal class func _map<I, O>(
    items: [I],
    complete: (NSError?, [O]) -> (),
    iterator: (I, (NSError?, O) -> ()) -> ()
  ) {
    var ongoing: [(Int, O)] = []

    for (i, item) in enumerate(items) {
      iterator(items[i]) { err, result in
        ongoing.append((i, result))

        if err != nil || ongoing.count == items.count {
          let results = ongoing.sorted({ $0.0 < $1.0 }).map({ $0.1 })
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

}
