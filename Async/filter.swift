import Foundation

extension Async {

  class func filter<I>(
    items: [I],
    iterator: (I, (Bool) -> ()) -> (),
    complete: ([I]) -> ()
  ) {
    var queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT)

    _filter(items, complete: complete) { item, callback in
      dispatch_async(queue) {
        iterator(item, callback)
      }
    }
  }

}
