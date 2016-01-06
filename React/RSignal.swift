//
//  RSignal.swift
//  placesapp
//
//  Created by Andy on 20/10/2015.
//  Copyright © 2015 niveusrosea. All rights reserved.
//

// ReactiveCocoa -> Simples
// Sink is just a block which receives an event
// ActionDisposable contains a block which removes itself from the signal

/*

Signal -> Observers -> Signal
ClearBuffer -> Signal -> Observers (Process)

*/

public enum NetworkError: ErrorType {
    case NoInternet(String)
}

import Foundation

private final class RCombineLatestState<T> {
    var latestValue: T?
    var completed = false
}

//private enum RSignalEvent<T, E: ErrorType>: REvent<T, E>
//{
//    case ClearBuffer
//}

public class RRemap<T, U>
{
    public typealias perform = (T) -> (U)
}

public class RSignal<T, E: ErrorType>
{
    
    public typealias RObserver = REvent<T, E> -> ()
    
    private var buffer:REvent<T, E>?
    private var observers = [RObserver]()
    private var cacheHash: String?
    
    public init()
    {
        
    }
    
    deinit
    {

    }
    
    func dispatchEvent(event: REvent<T, E>)
    {
        if let value = event.value as? RHashObject
        {
            let hash = value.contentsHash()
            if let cacheHash = cacheHash where hash == cacheHash
            {
                let value = event.value!
                let value2 = buffer!.value!
                print("\(value) \(value2)")
                return
            }
            self.cacheHash = hash
            self.buffer = event
        }
        for observer in observers
        {
            observer(event)
//            _sendEventToObserver(event, observer: observer)
        }
    }
    
    func _sendEventToObserver(event: REvent<T, E>, observer: RObserver)
    {
        observer(event)
    }
    
//    func bufferSize(size: Int) -> RSignal<T, E>
//    {
//        bufferSize = size
//        return self
//    }
    
    public func dispatch(value: T)
    {
        let event = REvent<T, E>.Next(value)
        buffer = event
        dispatchEvent(event)
    }
    
    public func error(error: E)
    {
        let event = REvent<T, E>.Error(error)
        dispatchEvent(event)
    }
    
    public func processing()
    {
        let event = REvent<T, E>.Processing
        dispatchEvent(event)
    }
    
    public func completed()
    {
        let event = REvent<T, E>.Completed
        dispatchEvent(event)
    }
    
    public func interupted()
    {
        let event = REvent<T, E>.Interrupted
        dispatchEvent(event)
    }
    
    public func clearBuffer()
    {
        let event = REvent<T, E>.ClearBuffer
        print(event)
        buffer = nil//[REvent<T, E>]()
        dispatchEvent(event)
    }
    
    private func internalMapping<U, E>(event: REvent<T, E>, signal: RSignal<U, E>, observer: REvent<T, E> -> ())
    {
        switch event {
            case .Next(_):
                observer(event)
                break
            case .ClearBuffer:
                signal.clearBuffer()
                break
            default: ()
        }
    }
    
    public func merge<U>(merge: [T] -> U) -> RSignal<U, E>
    {
        var output = [T]()
        let signal = RSignal<U, E>()
//        signal.bufferSize = self.bufferSize
        self.observe { event in
            switch event {
            case let .Next(value):
                output.append(value)
                break
            case .Completed:
                signal.dispatch(merge(output))
                output = [T]()
            default: ()
            }
        }
        return signal
    }
    
    func remap2<U>(mutator: RRemap<T, U>.perform) -> RSignal<U, E>
    {
        let signal = RSignal<U, E>()
        self.observeSignal(signal, next: { event in
            if let value = event.value
            {
                let mutatedValue = mutator(value)
                signal.dispatch(mutatedValue)
            }
        }, other: { event in
            signal.dispatchEvent(self.convEvent(event))
        })
        return signal
    }
    
    public func remap<U>(mutator: T -> U) -> RSignal<U, E>
    {
        let signal = RSignal<U, E>()
//        signal.bufferSize = self.bufferSize
        self.observeSignal(signal, next: { event in
            if let value = event.value
            {
                signal.dispatch(mutator(value))
            }
        }, other: { event in
            signal.dispatchEvent(self.convEvent(event))
        })
        return signal
    }
    
    public func filter(filter: T -> Bool) -> RSignal<T, E>
    {
        let signal = RSignal<T, E>()
//        signal.bufferSize = self.bufferSize
        self.observeSignal(signal, next: { event in
            if filter(event.value!)
            {
                signal.dispatch(event.value!)
            }
        }, other: { event in
            signal.dispatchEvent(self.convEvent(event))
        })
        return signal
    }
    
    public func observe(observer: RObserver) -> RDisposable
    {
        return self.observeAll { event in
            switch event {
                case .ClearBuffer:
                break
            default:
                observer(event)
            }
        }
    }

    func observeAll(observer: RObserver) -> RDisposable
    {
        let disposable = RActionDisposable<T, E>(signal: self) {
            //
        }
        observers.append(observer)
//        if buffer.count > 0
//        {
//            for event in buffer
//            {
        if let buffer = buffer
        {
            observer(buffer)
        }
//            }
//        }
        return disposable
    }
    
    private func observeSignal<U>(signal: RSignal<U, E>, next: RObserver, other: RObserver) -> RDisposable
    {
        return self.observeAll { event in
            switch event {
            case .ClearBuffer:
                signal.clearBuffer()
                break
            case .Next(_):
                next(event)
                break
            default:
                other(event)
                break
//            case .Error(_):
//                signal.dispatchEvent(self.convEvent(event))
//                break;
//            case .Completed:
//                signal.dispatchEvent(self.convEvent(event))
//                break
//            case .Interrupted:
//                signal.dispatchEvent(self.convEvent(event))
//                break
//            case .Processing:
//                signal.dispatchEvent(self.convEvent(event))
//                break
            }
        }
    }
    
    private func convEvent<R, U>(event: REvent<R, E>) -> REvent<U, E>
    {
        switch event {
        case .Next(_):
            return REvent.Completed
        case let .Error(error):
            return REvent<U, E>.Error(error)
        case .ClearBuffer:
            return REvent<U, E>.ClearBuffer
        case .Completed:
            return REvent<U, E>.Completed
        case .Processing:
            return REvent<U, E>.Processing
        case .Interrupted:
            return REvent<U, E>.Interrupted
        }
    }
    
    public func combineWith<U>(otherSignal: RSignal<U, E>) -> RSignal<(T, U), E>
    {
        
        let signal = RSignal<(T, U), E>()//.bufferSize(1)
        
        var myLastValue: T?
        var otherLastValue: U?
        
        let combinedDispatch = { () -> () in
            guard let myLastValue = myLastValue, otherLastValue = otherLastValue else
            {
                return
            }
            signal.dispatch((myLastValue, otherLastValue))
        }
    
        self.observe { event in
            switch event {
            case let .Next(value):
                myLastValue = value
                combinedDispatch()
                break
            default:
                let newEvent: REvent<(T, U), E> = self.convEvent(event)
                signal.dispatchEvent(newEvent)
                break
            }
        }
        otherSignal.observe { event in
            switch event {
            case let .Next(value):
                otherLastValue = value
                combinedDispatch()
                break
            default:
                let newEvent: REvent<(T, U), E> = self.convEvent(event)
                signal.dispatchEvent(newEvent)
                break
            }
        }
        
        return signal
        
    }
    
    public func optionalCombineWith<U>(otherSignal: RSignal<U, E>) -> RSignal<(T?, U?), E>
    {
        
        let signal = RSignal<(T?, U?), E>()
        
        var myLastValue: T?
        var otherLastValue: U?
        
        let combinedDispatch = { () -> () in
            signal.dispatch((myLastValue, otherLastValue))
        }
        
        self.observe { event in
            switch event {
            case let .Next(value):
                myLastValue = value
                combinedDispatch()
                break
            default:
                let newEvent: REvent<(T?, U?), E> = self.convEvent(event)
                signal.dispatchEvent(newEvent)
                break
            }
        }
        otherSignal.observe { event in
            switch event {
            case let .Next(value):
                otherLastValue = value
                combinedDispatch()
                break
            default:
                let newEvent: REvent<(T?, U?), E> = self.convEvent(event)
                signal.dispatchEvent(newEvent)
                break
            }
        }
        
        combinedDispatch()
        
        return signal
        
    }
    
//    private func drain()
//    {
//        
//    }
//    
//    public func flattenBuffer() -> RDisposable<T, E>
//    {
//        
//    }
    
//    func removeObserver(observer: RObserver)
//    {
//        for i in (0..<observers.endIndex).reverse()
//        {
//            if observers[i] === observer
//            {
//                observers.removeAtIndex(i)
//                return
//            }
//        }
//    }
    
}