import UIKit

final class DetailsScreenCell: UITableViewCell {
    private let dateLabel = UILabel()
    private let amountLabel = UILabel()
    private let percentLabel = UILabel()
    private let renewalLabel = UILabel()
    private let contribLabel = UILabel()
    private let generalLabel = UILabel()
    private let overpaymentLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        accessoryType = .none
    }

    func configure(
        item: DetailsScreenViewData
    ) {
        dateLabel.text = item.date
        amountLabel.text = item.amount
        percentLabel.text = item.percent
        renewalLabel.text = item.renewal
        contribLabel.text = item.contrib
        generalLabel.text = item.general
        overpaymentLabel.text = item.overpayment
    }
}

private extension DetailsScreenCell {
    func setupSubviews() {
        setupLabels([
            amountLabel,
            dateLabel,
            percentLabel,
            renewalLabel,
            contribLabel,
            generalLabel,
            overpaymentLabel
        ])

        backgroundColor = .systemGroupedBackground
        let contentStack = contentStack
        addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    var contentStack: UIStackView {
        vStack([
            hStack([
                dateLabel,
                amountLabel]),
            hStack([
                percentLabel,
                renewalLabel]),
            hStack([
                generalLabel,
                overpaymentLabel])
        ])
    }

    func setupLabels(_ labels: [UILabel]) {
        labels.forEach { label in
            label.textColor = .darkGray
            label.numberOfLines = 2
            label.textAlignment = .left
            label.font = .boldSystemFont(ofSize: 14)
        }
    }

    func hStack(_ views: [UIView]) -> UIStackView {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 30
        stack.axis = .horizontal
        views.forEach { stack.addArrangedSubview($0) }
        return stack
    }

    func vStack(_ views: [UIView]) -> UIStackView {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 5
        stack.axis = .vertical
        views.forEach { stack.addArrangedSubview($0) }
        return stack
    }
}
