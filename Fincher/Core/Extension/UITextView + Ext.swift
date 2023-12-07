import Combine
import UIKit

extension UITextView {
    var textPublisher: AnyPublisher<Int, Never> {
        NotificationCenter.default
            .publisher(
                for: UITextView.textDidChangeNotification,
                object: self)
            .compactMap { $0.object as? UITextView }
            .map { $0.text ?? "" }
            .map({ value in
                Int(value) ?? 0
            })
            .eraseToAnyPublisher()
    }

    var doublePublisher: AnyPublisher<Double, Never> {
        NotificationCenter.default
            .publisher(for: UITextView.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextView }
            .map { $0.text ?? "" }
            .map({ value in
                Double(value) ?? 0.0
            })
            .eraseToAnyPublisher()
    }
}
