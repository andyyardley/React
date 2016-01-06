//
//  REvent.swift
//  placesapp
//
//  Created by Andy on 20/10/2015.
//  Copyright © 2015 niveusrosea. All rights reserved.
//

import Foundation

public enum REvent<T, E: ErrorType> {
    /// A value provided by the signal.
    case Next(T)
    /// received.
    case Error(E)
    case Processing
    case Completed
    case ClearBuffer
    case Interrupted
    
    public var value: T? {
        switch self {
        case let .Next(value):
            return value
        default:
            return nil
        }
    }
    
    public var error: E? {
        switch self {
        case let .Error(error):
            return error
        default:
            return nil
        }
    }
    
}



//public final class REvent<T>
//{
//    var value: T!
//    
//    init(value: T)
//    {
//        self.value = value
//    }
//    
//}