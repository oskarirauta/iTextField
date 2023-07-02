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
        
        var didBeginEditing: () -> Void
        var didChange: () -> Void
        var didEndEditing: () -> Void
        var shouldReturn: () -> Void
        var shouldClear: () -> Void
        
        init(text: Binding<String>,
             isEditing: Binding<Bool>,
             characterLimit: Int?,
             didBeginEditing: @escaping () -> Void,
             didChange: @escaping () -> Void,
             didEndEditing: @escaping () -> Void,
             shouldReturn: @escaping () -> Void,
             shouldClear: @escaping () -> Void)
        {
            self._text = text
            self._isEditing = isEditing
            self.characterLimit = characterLimit
            self.didBeginEditing = didBeginEditing
            self.didChange = didChange
            self.didEndEditing = didEndEditing
            self.shouldReturn = shouldReturn
            self.shouldClear = shouldClear
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
            text = textField.text ?? ""
            didChange()
        }
        
        public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            DispatchQueue.main.async { [self] in
                if isEditing {
                    isEditing = false
                }
                didEndEditing()
            }
        }
        
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            isEditing = false
            shouldReturn()
            return false
        }
        
        public func textFieldShouldClear(_ textField: UITextField) -> Bool {
            shouldClear()
            text = ""
            return false
        }
        
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            //if there is a character limit set and new text will be greater than limt, then don't allow the newly proposed edit
            if let limit = characterLimit, let text = textField.text {
                if text.count + string.count > limit {
                    return false
                }
            }

            return true
        }
    }
    
}
