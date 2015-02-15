import Foundation

extension Async {

  class func reduce<I, O>(
    items: [I],
    initial: O,
    iterator: (O, I, (NSError?, O) -> ()) -> (),
    complete: (NSError?, O) -> ()
  ) {
    var queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL)

    _reduce(items, initial: initial, complete: complete) { current, input, next in
      dispatch_sync(queue) {
        iterator(current, input, next)
      }
    }
  }

}
