//
//  RTest.swift
//  placesapp
//
//  Created by Andy on 23/10/2015.
//  Copyright © 2015 niveusrosea. All rights reserved.
//

import Foundation

enum DefaultError: ErrorType {
    case InvalidSelection
}

class RTest
{
    
    init()
    {
        
        print("Test Started")
//        normal()
//        merge()
//        combineWithPreviousData()
//        test()
        print("Test Completed")
    }
    
    func test()
    {
        
        let values = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        
//        print(values.contentsHash())
        
        let signal = RSignal<[Int], DefaultError>()
        
        signal.dispatch(values)
        
        signal.observe { event in
//            print("1: \(event)")
        }
        
        signal.dispatch(values)
        
        signal.observe { event in
//            print("2: \(event)")
        }
        
        signal.dispatch(values)
        
        signal.dispatch([1, 2, 3])
        
        let signal2 = RSignal<[String: Int], DefaultError>()
        
        signal2.observe { event in
//            print("3: \(event)")
        }
        
        signal2.dispatch(["test": 1])
        
        signal2.dispatch(["test": 1])
        
//        print("test")
        
    }
    
    func normal()
    {
        
        
        let signal = RSignal<[Int], DefaultError>()//.bufferSize(1)
        let signal3 = RSignal<[Int], DefaultError>()//.bufferSize(1)
        
        signal.combineWith(signal3).remap { (a, b) -> [Int] in
            var output = [Int]()
            for var idx = 0; idx < a.count; idx = idx + 1
            {
                output.append(a[idx] + b[idx])
            }
            return output
            }.observe { event in
                switch event {
                case let .Next(value):
                    print("Combined \(value)")
                    break
                case let .Error(error):
                    print("Combined Error \(error)")
                    break
                default :()
                }
        }
        
        signal.optionalCombineWith(signal3).observe { event in
            switch event {
            case let .Next(value):
                print("Optional Combined \(value)")
                break
            case let .Error(error):
                print("Optional Combined Error \(error)")
                break
            default :()
            }
        }
        
        let _ = signal.observe { event in
            switch event {
            case let .Next(value):
                print("Event1 Next \(value)")
                break
            case .Interrupted:
                break
            case let .Error(error):
                print("Event1 Error \(error)")
                break
            case .Completed:
                break
            case .Processing:
                break
            default: ()
            }
        }
        
        let signal2 = signal.remap { values -> [String] in
            var output = [String]()
            for value in values
            {
                output.append("V \(value + 1)")
            }
            return output
        }
        
        let _ = signal2.observe { event in
            switch event {
            case let .Next(value):
                print("Event2 Next \(value)")
                break
            case .Interrupted:
                break
            case let .Error(error):
                print("Event2 Error \(error)")
                break
            case .Completed:
                break
            case .Processing:
                break
            default: ()
            }
        }
        
        signal.dispatch([1, 2, 3, 4, 6])
        signal3.dispatch([5, 4, 3, 2, 0])
        
        let _ = signal2.observe { event in
            switch event {
            case let .Next(value):
                print("Event3 Next \(value)")
                break
            case .Interrupted:
                break
            case let .Error(error):
                print("Event3 Error \(error)")
                break
            case .Completed:
                break
            case .Processing:
                break
            default: ()
            }
        }
        
        signal.clearBuffer()
        
        let _ = signal2.observe { event in
            switch event {
            case let .Next(value):
                print("Event4 Next \(value)")
                break
            case .Interrupted:
                break
            case let .Error(error):
                print("Event4 Error \(error)")
                break
            case .Completed:
                break
            case .Processing:
                break
            default: ()
            }
        }
        
        signal.error(DefaultError.InvalidSelection)
        
        signal3.error(.InvalidSelection)
    }
    
    func combineWithPreviousData()
    {
        
        let signal1 = RSignal<Int, DefaultError>()//.bufferSize(1)
        let signal2 = RSignal<Int, DefaultError>()//.bufferSize(1)
        
        signal1.dispatch(5)
        signal2.dispatch(5)
        
        signal1.combineWith(signal2).observe { event in
            switch event {
            case let .Next((int1, int2)):
                print("\(int1), \(int2)")
            default: ()
            }
        }
    
        signal1.dispatch(2)
        signal2.dispatch(2)
        
    }
    
    func merge()
    {
        
        let signal = RSignal<Int, DefaultError>()
        
        let signal2 = signal.merge { values -> Int in
            var output = 0
            for value in values
            {
                output += value
            }
            return output
        }//.bufferSize(1)
        
        signal.dispatch(5)
        signal.dispatch(2)
        signal.dispatch(3)
        signal.completed()
        
        signal2.observe { event in
            switch event {
            case let .Next(value):
                print("Val : \(value)")
                break
            default: ()
            }
        }.dispose()
        
        print("Yello")
        
    }
    
}