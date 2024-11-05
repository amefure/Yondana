//
//  ExString.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/05.
//

extension String {
    public func toInt() -> Int {
        guard let num = Int(self) else { return 0 }
        return num
    }
}
