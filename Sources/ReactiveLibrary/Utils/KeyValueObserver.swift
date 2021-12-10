//
//  KeyValueObserver.swift
//  
//
//  Created by Sima Vlad Grigore on 09/12/2021.
//

import Foundation

internal final class KeyValueObserver<ObserveType>: NSObject {
    private let block: (ObserveType) -> ()
    private let keyPath: String
    private let object: NSObject
    
    internal init(object: NSObject, keyPath: String, _ block: @escaping (ObserveType) -> ()) {
        self.block = block
        self.keyPath = keyPath
        self.object = object
        super.init()
        object.addObserver(self, forKeyPath: keyPath, options: .new, context: nil)
    }
    
    deinit {
        object.removeObserver(self, forKeyPath: keyPath)
    }
    
    internal override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        block(change![.newKey] as! ObserveType)
    }
}
