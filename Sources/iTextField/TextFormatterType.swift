//
//  TextFormatterType.swift
//  
//
//  Created by Mussa Charles on 2023/07/02.
//

import Foundation

/// An enum holding the type of text formatting to by applied to a text field as user types.
public enum TextFormatterType {

    /// A currency formatter where a number like 10000 will be changed to 10,000postfix, where post fix
    /// stands for the currency something like 10,000$ or 10,000 Won
    case currency(postFix: String)
}
