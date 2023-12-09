// Created by chizztectep on 09.12.2023

import Foundation
import UIKit

extension MainViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Compute the value of the text view after the text is inserted.
        let currentText = textView.text ?? ""
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        switch textView.tag {
        case 1:
            return (updatedText.isNumberWithDot && updatedText.filter({ $0 == "." }).count <= 1)
        default:
            return updatedText.isNumber
        }
    }
}
