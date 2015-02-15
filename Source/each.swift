import Foundation

extension Async {

  class func each<I>(
    items: [I],
    transform: (I, (NSError?) -> ()) -> (),
    complete: (NSError?) -> ()
  ) {
    var queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT)

    _each(items, complete: complete) { item, next in
      dispatch_async(queue) {
        transform(item, next)
      }
    }
  }

}
