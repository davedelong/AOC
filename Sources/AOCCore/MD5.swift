//
//  MD5.swift
//  AOC
//
//  Created by Dave DeLong on 12/8/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import Foundation
import CryptoKit
import CommonCrypto

public extension Data {
    
    @available(macOS 10.15, *)
    func hash<H: HashFunction>(using algorithmType: H.Type = H.self) -> Data {
        var function = algorithmType.init()
        self.withUnsafeBytes {
            function.update(bufferPointer: $0)
        }
        let digest = function.finalize()
        return Data(digest)
    }
    
}

public extension String {
    
    @available(macOS 10.15, *)
    func hash<H: HashFunction>(using algorithmType: H.Type = H.self) -> Data {
        return Data(utf8).hash(using: algorithmType)
    }
    
    
    func md5() -> Data {
        if #available(OSX 10.15, *) {
            return hash(using: Insecure.MD5.self)
        } else {
            // Fallback on earlier versions
            var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
            writeMD5(&digestData)
            return digestData
        }
    }
    
    func writeMD5(_ destination: inout Data) {
        let messageData = Data(utf8)
        
        _ = destination.withUnsafeMutableBytes { digestBytes in
            _ = messageData.withUnsafeBytes { messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
    }
    
    func md5String() -> String {
        let data = md5()
        return data.map { String(format: "%02hhx", arguments: [$0]) }.joined()
    }
    
}
