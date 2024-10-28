//
//  iTextField+Coordinator.swift
//  
//
//  Created by Mussa Charles on 2023/07/02.
//

import UIKit
import SwiftUI


public extension iTextField {
    
     final class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
         @Binding var isEditing: Bool
        var characterLimit: Int? = nil
        private let textFormatterType: TextFormatterType?
         private var isDeleting: Bool = false
        
        var didBeginEditing: () -> Void
        var didChange: () -> Void
        var didEndEditing: () -> Void
        var shouldReturn: () -> Bool
        var shouldClear: () -> Bool
        var shouldChange: (NSRange, String) -> Bool

        init(text: Binding<String>,
             isEditing: Binding<Bool>,
             characterLimit: Int?,
             textFormatterType: TextFormatterType?,
             didBeginEditing: @escaping () -> Void,
             didChange: @escaping () -> Void,
             didEndEditing: @escaping () -> Void,
             shouldReturn: @escaping () -> Bool,
             shouldClear: @escaping () -> Bool,
             shouldChange: @escaping (NSRange, String) -> Bool)
        {
            self._text = text
            self._isEditing = isEditing
            self.characterLimit = characterLimit
            self.textFormatterType = textFormatterType
            self.didBeginEditing = didBeginEditing
            self.didChange = didChange
            self.didEndEditing = didEndEditing
            self.shouldReturn = shouldReturn
            self.shouldClear = shouldClear
            self.shouldChange = shouldChange
        }
        
        public func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async { [self] in
                if !isEditing {
                    isEditing = true
                }
                if textField.clearsOnBeginEditing {
                    text = ""
                }
                didBeginEditing()
            }
        }
        
        @objc func textFieldDidChange(_ textField: UITextField) {
            defer {
                formatTextIfNeeded(textField)
            }
            text = textField.text ?? ""
            didChange()
        }
        
        public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            defer {
                formatTextIfNeeded(textField)
            }
            DispatchQueue.main.async { [self] in
                if isEditing {
                    isEditing = false
                }
                didEndEditing()
            }
        }
        
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            defer {
                formatTextIfNeeded(textField)
            }
            isEditing = false
            return shouldReturn() // false
        }
        
        public func textFieldShouldClear(_ textField: UITextField) -> Bool {
            let result = shouldClear()
            if result {
                text = ""
            }
            return result // false
        }
        
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            //if there is a character limit set and new text will be greater than limt, then don't allow the newly proposed edit
            if let limit = characterLimit, let text = textField.text {
                if text.count + string.count > limit {
                    return false
                }
            }

            return shouldChange(range, string)
        }
    }
    
}


private extension iTextField.Coordinator {
    
 
    
    func formatTextIfNeeded(_ textField: UITextField) {
        guard let textFormatterType = self.textFormatterType,
        isEditing == false else {return}
        
        // TODO: - Add logic for formatting text (Note: The commented one didn't work as expected so more work needed (Charles, July 2, 2023).
//        switch textFormatterType {
//        case .currency(let postFix, let localeIdentifier):
//            var isNumberOrDecimalInputTextField: Bool {
//               return textField.keyboardType == .numberPad ||
//                textField.keyboardType == .decimalPad ||
//                textField.keyboardType == .phonePad
//           }
//
//            guard isNumberOrDecimalInputTextField else {return}
//
//            guard let currentTypedText  = textField.text,
//                  !currentTypedText.isEmpty,!currentTypedText.contains(postFix)
//            else {return}
//
//            DispatchQueue.main.async {
//                textField.text?.append(postFix)
//                self.text = textField.text ?? ""
//            }
//        }
    }

}
