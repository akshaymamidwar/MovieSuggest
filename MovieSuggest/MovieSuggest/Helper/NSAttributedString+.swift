//
//  NSAttributedString.swift
//  MovieSuggest
//
//  Created by Akshay Mamidwar    on 28/08/24.
//

import Foundation
import UIKit

extension NSAttributedString {

    static func bold(_ text: String, font: UIFont = UIFont.boldSystemFont(ofSize: 16)) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        return NSAttributedString(string: text, attributes: attributes)
    }

    static func normal(_ text: String, font: UIFont = UIFont.systemFont(ofSize: 16)) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        return NSAttributedString(string: text, attributes: attributes)
    }

    static func attributedString(boldText: String, normalText: String) -> NSAttributedString {
        let boldPart = NSAttributedString.bold(boldText)
        let normalPart = NSAttributedString.normal(normalText)

        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(boldPart)
        mutableAttributedString.append(normalPart)

        return mutableAttributedString
    }
}
