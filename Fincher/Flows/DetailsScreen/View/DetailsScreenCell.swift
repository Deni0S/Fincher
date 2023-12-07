import UIKit

final class DetailsScreenCell: UITableViewCell {
    private let numberLabel = UILabel()
    private let amountLabel = UILabel()
    private let dateLabel = UILabel()
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

    func configure(_ item: DetailsScreenViewData) {
        numberLabel.text = item.number
        amountLabel.text = item.amount
        dateLabel.text = item.date
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
            numberLabel,
            amountLabel,
            dateLabel,
            percentLabel,
            renewalLabel,
            contribLabel,
            generalLabel,
            overpaymentLabel
        ])

        backgroundColor = .systemBackground
        addSubview(numberLabel)
        let contentStack = contentStack
        addSubview(contentStack)

        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -60),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
    }

    var contentStack: UIStackView {
        vStack([
            hStack([
                amountLabel,
                dateLabel]),
            hStack([
                percentLabel,
                renewalLabel,
                contribLabel]),
            hStack([
                generalLabel,
                overpaymentLabel])
        ])
    }

    func setupLabels(_ labels: [UILabel]) {
        labels.forEach { label in
            label.textColor = .label
            label.numberOfLines = 2
            label.textAlignment = .left
            label.font = .boldSystemFont(ofSize: 12)
        }
    }

    func hStack(_ views: [UIView]) -> UIStackView {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 20
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
