//
//  StringExtensions.swift
//  SwiftLogootUndo_Example
//
//  Created by TonyNguyen on 12/13/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

extension String {
    func isBackspace() -> Bool {
        guard let char = cString(using: .utf8) else {
            return false
        }
        let isBackspace = strcmp(char, "\\b")
        return isBackspace == -92
    }
}
