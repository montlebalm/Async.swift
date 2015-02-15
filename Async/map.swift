import Foundation

extension Async {

  class func map<I, O>(
    items: [I],
    iterator: (I, (NSError?, O) -> ()) -> (),
    complete: (NSError?, [O]) -> ()
  ) {
    var queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT)

    _map(items, complete: complete) { item, callback in
      dispatch_async(queue) {
        iterator(item, callback)
      }
    }
  }

}
