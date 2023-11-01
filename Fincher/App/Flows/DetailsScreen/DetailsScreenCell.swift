import UIKit

final class DetailsScreenCell: UITableViewCell {

    private lazy var numberLabel = numberLabelSetup
    private lazy var amountLabel = customLabelSetup
    private lazy var dateLabel = customLabelSetup
    private lazy var percentLabel = customLabelSetup
    private lazy var renewalLabel = customLabelSetup
    private lazy var contribLabel = customLabelSetup
    private lazy var generalLabel = customLabelSetup

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("DetailsScreenCell has not been implemented")
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
    }
}

private extension DetailsScreenCell {

    func setupSubviews() {
        backgroundColor = .systemBackground
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
        hStack([
            numberLabel,
            vStack([
                hStack([
                    amountLabel,
                    dateLabel]),
                hStack([
                    percentLabel,
                    renewalLabel,
                    contribLabel]),
                generalLabel,
            ]),
        ])
    }

    var numberLabelSetup: UILabel {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }

    var customLabelSetup: UILabel {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }

    func hStack(_ views: [UIView]) -> UIStackView {
        let stack = UIStackView()
        stack.distribution  = .fillEqually
        stack.alignment = .center
        stack.spacing = 20
        stack.axis = .horizontal
        views.forEach { stack.addArrangedSubview($0) }
        return stack
    }

    func vStack(_ views: [UIView]) -> UIStackView {
        let stack = UIStackView()
        stack.distribution  = .fillEqually
        stack.alignment = .center
        stack.spacing = 5
        stack.axis = .vertical
        views.forEach { stack.addArrangedSubview($0) }
        return stack
    }
}
