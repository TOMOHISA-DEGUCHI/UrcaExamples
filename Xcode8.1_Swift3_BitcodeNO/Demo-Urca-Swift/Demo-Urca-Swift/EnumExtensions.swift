//
//  Enumerable.swift
//  CreativeFormat
//
//  Created by TDEGUCHI on 2016/10/03.
//  Copyright © 2016年 MAVERICK.,INC. All rights reserved.
//

/// Enum拡張プロトコル.
protocol EnumExtension { associatedtype Case = Self }

extension EnumExtension where Case: Hashable {
    
    /// Enum用イテレータ.
    private static var iterator: AnyIterator<Case> {
        var n = 0
        return AnyIterator {
            defer { n += 1 }
            
            let next = withUnsafePointer(to: &n) {
                UnsafeRawPointer($0).assumingMemoryBound(to: Case.self).pointee
            }
            return next.hashValue == n ? next : nil
        }
    }
    
    static func enumerate() -> EnumeratedSequence<AnySequence<Case>> {
        return AnySequence(self.iterator).enumerated()
    }
    
    /// 列挙子配列.
    static var cases: [Case] { return Array(self.iterator) }
    /// 列挙子数.
    static var count: Int { return self.cases.count }
}
