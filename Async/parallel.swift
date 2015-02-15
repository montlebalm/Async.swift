import Foundation

extension Async {

  class func parallel<O>(
    tasks: [((NSError?, O) -> ()) -> ()],
    complete: (NSError?, [O]) -> ()
  ) {
    var queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT)

    _map(tasks, complete: complete) { task, next in
      dispatch_async(queue) {
        task(next)
      }
    }
  }

}
