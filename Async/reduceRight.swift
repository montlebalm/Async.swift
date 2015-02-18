import Foundation

extension Async {

  class public func reduceRight<I, O>(
    items: [I],
    initial: O,
    iterator: (O, I, (NSError?, O) -> ()) -> (),
    complete: (NSError?, O) -> ()
  ) {
    var queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL)
    var itemsRev = items.reverse()

    _reduce(itemsRev, initial: initial, complete: complete) { current, input, next in
      dispatch_sync(queue) {
        iterator(current, input, next)
      }
    }
  }

}
