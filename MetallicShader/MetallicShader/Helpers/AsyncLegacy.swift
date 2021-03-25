//
//  AsyncLegacy.swift
//
//  Created by Tobias DM on 15/07/14.
//  Modifed by Joseph Lord
//  Copyright (c) 2014 Human Friendly Ltd.
//
//	OS X 10.9+ and iOS 7.0+
//	Only use with ARC
//
//	The MIT License (MIT)
//	Copyright (c) 2014 Tobias Due Munk
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy of
//	this software and associated documentation files (the "Software"), to deal in
//	the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//	the Software, and to permit persons to whom the Software is furnished to do so,
//	subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//	FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//	COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//	IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Foundation
import UIKit

// HACK: For Beta 5, 6
prefix func + (v: qos_class_t) -> Int {
	return Int(v.rawValue)
}

private class GCD {
	
	class final func mainQueue() -> DispatchQueue {
		return DispatchQueue.main
	}
	class final func userInteractiveQueue() -> DispatchQueue {
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
	}
	class final func userInitiatedQueue() -> DispatchQueue {
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
	}
	class final func defaultQueue() -> DispatchQueue {
		return DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
	}
	class final func utilityQueue() -> DispatchQueue {
		return DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
	}
    class final func backgroundQueue() -> DispatchQueue {
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
    }
}

open class Async {
    
    // The block to be executed does not need to be retained in present code
    // only the dispatch_group is needed in order to cancel it.
    // private let block: dispatch_block_t
    fileprivate let dgroup: DispatchGroup = DispatchGroup()
    fileprivate var isCancelled = false
    fileprivate init() {}
    
}

extension Async { // Static methods
	
	/* dispatch_async() */

	fileprivate class final func async(_ block: @escaping () -> Void, inQueue queue: DispatchQueue) -> Async {
        // Wrap block in a struct since dispatch_block_t can't be extended and to give it a group
		let asyncBlock =  Async()

        // Add block to queue
		queue.async(group: asyncBlock.dgroup, execute: asyncBlock.cancellable(block))

        return asyncBlock
		
	}
    
    @discardableResult
	public class final func main(_ block: @escaping () -> Void) -> Async {
		return Async.async(block, inQueue: GCD.mainQueue())
	}
	public class final func userInteractive(_ block: @escaping () -> Void) -> Async {
		return Async.async(block, inQueue: GCD.userInteractiveQueue())
	}
	public class final func userInitiated(_ block: @escaping () -> Void) -> Async {
		return Async.async(block, inQueue: GCD.userInitiatedQueue())
	}
	public class final func default_(_ block: @escaping () -> Void) -> Async {
		return Async.async(block, inQueue: GCD.defaultQueue())
	}
	public class final func utility(_ block: @escaping () -> Void) -> Async {
		return Async.async(block, inQueue: GCD.utilityQueue())
	}
    public class final func background(_ block: @escaping () -> Void) -> Async {
        return Async.async(block, inQueue: GCD.backgroundQueue())
    }
	public class final func customQueue(_ queue: DispatchQueue, block: @escaping () -> Void) -> Async {
		return Async.async(block, inQueue: queue)
	}

	/* dispatch_after() */

	fileprivate class final func after(_ seconds: Double, block: @escaping () -> Void, inQueue queue: DispatchQueue) -> Async {
		let nanoSeconds = Int64(seconds * Double(NSEC_PER_SEC))
		let time = DispatchTime.now() + Double(nanoSeconds) / Double(NSEC_PER_SEC)
		return at(time, block: block, inQueue: queue)
	}
	fileprivate class final func at(_ time: DispatchTime, block: @escaping () -> Void, inQueue queue: DispatchQueue) -> Async {
		// See Async.async() for comments
        let asyncBlock = Async()
        asyncBlock.dgroup.enter()
        queue.asyncAfter(deadline: time) {
            let cancellableBlock = asyncBlock.cancellable(block)
            cancellableBlock() // Compiler crashed in Beta6 when I just did asyncBlock.cancellable(block)() directly.
            asyncBlock.dgroup.leave()
        }
		return asyncBlock
	}
	public class final func main(_ after: Double, block: @escaping () -> Void) -> Async {
		return Async.after(after, block: block, inQueue: GCD.mainQueue())
	}
	public class final func userInteractive(_ after: Double, block: @escaping () -> Void) -> Async {
		return Async.after(after, block: block, inQueue: GCD.userInteractiveQueue())
	}
	public class final func userInitiated(_ after: Double, block: @escaping () -> Void) -> Async {
		return Async.after(after, block: block, inQueue: GCD.userInitiatedQueue())
	}
	public class final func default_(_ after: Double, block: @escaping () -> Void) -> Async {
		return Async.after(after, block: block, inQueue: GCD.defaultQueue())
	}
	public class final func utility(_ after: Double, block: @escaping () -> Void) -> Async {
		return Async.after(after, block: block, inQueue: GCD.utilityQueue())
	}
    public class final func background(_ after: Double, block: @escaping () -> Void) -> Async {
        return Async.after(after, block: block, inQueue: GCD.backgroundQueue())
    }
	public class final func customQueue(_ after: Double, queue: DispatchQueue, block: @escaping () -> Void) -> Async {
		return Async.after(after, block: block, inQueue: queue)
	}
}

extension Async { // Regualar methods matching static once
	
	fileprivate final func chain(block chainingBlock: @escaping () -> Void, runInQueue queue: DispatchQueue) -> Async {
		// See Async.async() for comments
        let asyncBlock = Async()
        asyncBlock.dgroup.enter()
        self.dgroup.notify(queue: queue) {
            let cancellableChainingBlock = asyncBlock.cancellable(chainingBlock)
            cancellableChainingBlock()
            asyncBlock.dgroup.leave()
        }
		return asyncBlock
	}
    
    fileprivate final func cancellable(_ blockToWrap: @escaping () -> Void) -> () -> Void {
        // Retains self in case it is cancelled and then released.
        return {
            if !self.isCancelled {
                blockToWrap()
            }
        }
    }
	
	public final func main(_ chainingBlock: @escaping () -> Void) -> Async {
		return chain(block: chainingBlock, runInQueue: GCD.mainQueue())
	}
	public final func userInteractive(_ chainingBlock: @escaping () -> Void) -> Async {
		return chain(block: chainingBlock, runInQueue: GCD.userInteractiveQueue())
	}
	public final func userInitiated(_ chainingBlock: @escaping () -> Void) -> Async {
		return chain(block: chainingBlock, runInQueue: GCD.userInitiatedQueue())
	}
	public final func default_(_ chainingBlock: @escaping () -> Void) -> Async {
		return chain(block: chainingBlock, runInQueue: GCD.defaultQueue())
	}
	public final func utility(_ chainingBlock: @escaping () -> Void) -> Async {
		return chain(block: chainingBlock, runInQueue: GCD.utilityQueue())
	}
    public final func background(_ chainingBlock: @escaping () -> Void) -> Async {
        return chain(block: chainingBlock, runInQueue: GCD.backgroundQueue())
    }
	public final func customQueue(_ queue: DispatchQueue, chainingBlock: @escaping () -> Void) -> Async {
		return chain(block: chainingBlock, runInQueue: queue)
	}
	
	/* dispatch_after() */

	fileprivate final func after(_ seconds: Double, block chainingBlock: @escaping () -> Void, runInQueue queue: DispatchQueue) -> Async {
        
        let asyncBlock = Async()
        
        self.dgroup.notify(queue: queue) {
            asyncBlock.dgroup.enter()
            let nanoSeconds = Int64(seconds * Double(NSEC_PER_SEC))
            let time = DispatchTime.now() + Double(nanoSeconds) / Double(NSEC_PER_SEC)
            queue.asyncAfter(deadline: time) {
                let cancellableChainingBlock = self.cancellable(chainingBlock)
                cancellableChainingBlock()
                asyncBlock.dgroup.leave()
            }
            
        }

		// Wrap block in a struct since dispatch_block_t can't be extended
		return asyncBlock
	}
	public final func main(_ after: Double, block: @escaping () -> Void) -> Async {
		return self.after(after, block: block, runInQueue: GCD.mainQueue())
	}
	public final func userInteractive(_ after: Double, block: @escaping () -> Void) -> Async {
		return self.after(after, block: block, runInQueue: GCD.userInteractiveQueue())
	}
	public final func userInitiated(_ after: Double, block: @escaping () -> Void) -> Async {
		return self.after(after, block: block, runInQueue: GCD.userInitiatedQueue())
	}
	public final func default_(_ after: Double, block: @escaping () -> Void) -> Async {
		return self.after(after, block: block, runInQueue: GCD.defaultQueue())
	}
	public final func utility(_ after: Double, block: @escaping () -> Void) -> Async {
		return self.after(after, block: block, runInQueue: GCD.utilityQueue())
	}
    public final func background(_ after: Double, block: @escaping () -> Void) -> Async {
        return self.after(after, block: block, runInQueue: GCD.backgroundQueue())
    }
	public final func customQueue(_ after: Double, queue: DispatchQueue, block: @escaping () -> Void) -> Async {
		return self.after(after, block: block, runInQueue: queue)
	}

	/* cancel */

     final func cancel() {
        // I don't think that syncronisation is necessary. Any combination of multiple access
        // should result in some boolean value and the cancel will only cancel
        // if the execution has not yet started.
        isCancelled = true
    }

	/* wait */

	/// If optional parameter forSeconds is not provided, use DISPATCH_TIME_FOREVER
	final func wait(_ seconds: Double = 0.0) {
		if seconds != 0.0 {
			let nanoSeconds = Int64(seconds * Double(NSEC_PER_SEC))
			let time = DispatchTime.now() + Double(nanoSeconds) / Double(NSEC_PER_SEC)
            _ = dgroup.wait(timeout: time)
		} else {
			_ = dgroup.wait(timeout: DispatchTime.distantFuture)
		}
	}
}

public func foreground(_ delay: TimeInterval = 0, task: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: task)
}
public func background(_ delay: TimeInterval = 0, task: @escaping () -> Void) {
    DispatchQueue(label: "Background").asyncAfter(deadline: .now() + delay, execute: task)
}

func backgroundTask(named name: String = "BackgroundTask", delayed sec: TimeInterval = 0, execute: @escaping (@escaping () -> Void) -> Void) {
    var bgTask: UIBackgroundTaskIdentifier?
    let completion = {
        guard let id = bgTask, id != .invalid else { return }
        UIApplication.shared.endBackgroundTask(id)
        bgTask = .invalid
    }
    bgTask = UIApplication.shared.beginBackgroundTask(withName: name, expirationHandler: completion)
    DispatchQueue.global().asyncAfter(deadline: .now() + sec) {
        execute(completion)
    }
}
