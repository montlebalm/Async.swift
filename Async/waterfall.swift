import Foundation

extension Async {

  class func waterfall<O>(
    tasks: [([O], (NSError?, O) -> ()) -> ()],
    complete: (NSError?, [O]) -> ()
  ) {
    var results: [O] = []
    var queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL)

    for task in tasks {
      dispatch_sync(queue) {
        task(results) { err, result in
          results.append(result)

          if err != nil || results.count == tasks.count {
            complete(err, results)
          }
        }
      }
    }
  }

}
