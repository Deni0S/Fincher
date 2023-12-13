// Created by chizztectep on 09.12.2023

import Foundation
import UIKit

extension MainViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        switch textView.tag {
        case 1:
            return (updatedText.isNumberWithDot && updatedText.filter({ $0 == "." }).count <= 1)
        default:
            return updatedText.isNumber
        }
    }
}
