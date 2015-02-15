import Foundation

extension Async {

  class func filterSeries<I>(
    items: [I],
    iterator: (I, (Bool) -> ()) -> (),
    complete: ([I]) -> ()
  ) {
    var queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL)

    _filter(items, complete: complete) { item, callback in
      dispatch_sync(queue) {
        iterator(item, callback)
      }
    }
  }

}
