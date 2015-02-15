import Foundation

extension Async {

  class func series<O>(
    tasks: [((NSError?, O) -> ()) -> ()],
    complete: (NSError?, [O]) -> ()
  ) {
    var queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL)

    _map(tasks, complete: complete) { task, next in
      dispatch_sync(queue) {
        task(next)
      }
    }
  }

}
