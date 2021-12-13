//
//  Disposable.swift
//  
//
//  Created by Sima Vlad Grigore on 11/12/2021.
//

import Foundation

public final class Disposable {
    // MARK: - Properties
    private let dispose: () -> Void
    
    // MARK: - Object Life Cycle
    public init(dispose: @escaping () -> Void) {
        self.dispose = dispose
    }
    
    deinit {
        dispose()
    }
}
