//
//  MD5.swift
//  AOC
//
//  Created by Dave DeLong on 12/8/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import Foundation
import CryptoKit

public protocol BufferHashable {
    func hash<H: HashFunction>(using algorithmType: H.Type) -> Data
}

extension BufferHashable {
    
    public func md5() -> Data {
        return hash(using: Insecure.MD5.self)
    }
    
    public func md5String() -> String {
        return md5().map { String(format: "%02hhx", arguments: [$0]) }.joined()
    }
    
}

extension Data: BufferHashable {
    
    public func hash<H: HashFunction>(using algorithmType: H.Type = H.self) -> Data {
        var function = algorithmType.init()
        self.withUnsafeBytes {
            function.update(bufferPointer: $0)
        }
        let digest = function.finalize()
        return Data(digest)
    }
    
}

extension String: BufferHashable {
    
    public func hash<H: HashFunction>(using algorithmType: H.Type = H.self) -> Data {
        return Data(utf8).hash(using: algorithmType)
    }
    
}
