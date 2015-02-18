import Foundation

extension Async {

  /**
    Returns the first value that passes an async truth test
    :param: items the values to be tested
    :param: iterator the test function
    :param: complete the completion callback
  */
  class public func detect<I>(
    items: [I],
    iterator: (I, (NSError?, Bool) -> ()) -> (),
    complete: (NSError?, I) -> ()
  ) {
    var queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT)

    _detect(items, complete: complete) { item, next in
      dispatch_async(queue) {
        iterator(item, next)
      }
    }
  }

}
