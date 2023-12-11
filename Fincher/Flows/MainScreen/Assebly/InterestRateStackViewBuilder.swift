import Foundation
import SnapKit
import UIKit

class InterestRateStackViewBuilder {
    private let lblInterestRate: UILabel = {
        let lbl = UILabel()
        lbl.text = Strings.shared.interestRateString
        lbl.textColor = .lightGray
        return lbl
    }()

    let textViewInterestRate: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.textAlignment = .center
        textView.tintColor = .black
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 5
        textView.font = .systemFont(ofSize: 18)
        textView.tag = 1
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        return textView
    }()

    private let lblPercent: UILabel = {
        let lbl = UILabel()
        lbl.text = " %"
        lbl.textColor = .lightGray
        return lbl
    }()

    func buildInterestRateStackView() -> UIStackView {
        let resultStackView = UIStackView()
        resultStackView.axis = .vertical
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        [
         self.textViewInterestRate,
         self.lblPercent].forEach { stackView.addArrangedSubview($0) }
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        [
          self.lblInterestRate,
          stackView].forEach { resultStackView.addArrangedSubview($0) }
        resultStackView.spacing = UIStackView.spacingUseSystem
        resultStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20,
                                                                           bottom: 20, trailing: 20)
        return resultStackView
    }
}
