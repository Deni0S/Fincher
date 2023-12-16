// Created by chizztectep on 09.12.2023

import Foundation
import UIKit

extension MainViewController: UITextViewDelegate, AlertProtocol {
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
    func simpleAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(
            title: Strings.shared.okString,
            style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
