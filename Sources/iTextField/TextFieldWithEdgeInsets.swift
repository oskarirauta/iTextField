//
//  TextFieldWithEdgeInsets.swift
//  
//
//  Created by Mussa Charles on 2023/07/01.
//

import UIKit

final class TextFieldWithEdgeInsets: UITextField {
    
    // MARK: - Properties
    public var insets: UIEdgeInsets
    private let clearButtonPadding: CGFloat
    
    static var defaultInsets: UIEdgeInsets {
        UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
    }
    
    // MARK: - Life Cycle
    
    init(
        insets: UIEdgeInsets = TextFieldWithEdgeInsets.defaultInsets,
        clearButtonPadding: CGFloat
    ) {
        self.insets = insets
        self.clearButtonPadding = clearButtonPadding
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Adding insets
    /*
     Credits:
      1. https://stackoverflow.com/a/63379184/7551807
      2. For insetting clear button: https://stackoverflow.com/a/24615661/7551807
     */
    
    // Place holder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds.inset(by: insets))
    }
    
    // text position
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds
                                    .inset(by: insets))
    }
    
    // left & right view
    public override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        return super.clearButtonRect(forBounds: bounds.insetBy(dx: insets.left - clearButtonPadding, dy: 0))
    }
    
}
