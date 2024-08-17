//
//  String+extension.swift
//  SoccerBeat
//
//  Created by Gucci on 8/17/24.
//

import Foundation

extension String {
    func localized(comment: String = "") -> String {
        NSLocalizedString(self, value: self, comment: comment)
    }

    func localized(with argument: CVarArg = [], comment: String = "") -> String {
        String(format: self.localized(comment: comment), argument)
    }
}
