//
//  RSignalProducer.swift
//  placesapp
//
//  Created by Andy on 26/10/2015.
//  Copyright © 2015 niveusrosea. All rights reserved.
//

import Foundation

class RSignalProducer<T, E: ErrorType>: RSignal<T, E>
{
    
    private var action:(RSignalProducer<T, E>) -> ()!
    
    init(action: (RSignalProducer<T, E>) -> ())
    {
        self.action = action
    }
    
    override func observeAll(observer: RObserver) -> RDisposable {
        let observer = super.observeAll(observer)
        self.action(self)
        return observer
    }
    
}