//
//  RDisposable.swift
//  placesapp
//
//  Created by Andy on 20/10/2015.
//  Copyright © 2015 niveusrosea. All rights reserved.
//

import Foundation

public protocol RDisposable
{
    func dispose()
}

public class RActionDisposable<T, E: ErrorType>: RDisposable
{
    
    private var signal: RSignal<T, E>!
    var action: Void -> Void!
    weak var target: AnyObject?
    
    init(signal: RSignal<T, E>, action: Void -> Void)
    {
        self.signal = signal
        self.action = action
    }
    
    public func dispose()
    {
        self.action()
    }
    
}

public final class RCompositeDisposable<T, E: ErrorType>: RDisposable
{
    
    var disposables = [RDisposable]()
  public   
    func dispose()
    {
        for disposable in disposables
        {
            disposable.dispose()
        }
    }
    
}