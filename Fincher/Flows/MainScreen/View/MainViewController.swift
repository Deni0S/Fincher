import Combine
import DropDown
import SnapKit
import UIKit

enum CalculationType: String {
    case anuitent = "Ануитентные"
    case differentiated = "Дифференцированные"
}

enum TagViews: Int {
    case anuitentButton = 1
    case differentiatedButton = 2
    case infoAnuitentButton = 3
    case infoDifferentiatedButton = 4
}

class MainViewController: UIViewController {
    let btnCalculate: UIButton = {
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        btn.setTitle("Рассчитать", for: .normal)
        return btn
    }()

    let btnDetails: UIButton = {
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        btn.setTitle("График платежей", for: .normal)
        return btn
    }()

    var subscriptions = Set<AnyCancellable>()
    private let tagHandlerPublisher = PassthroughSubject<Int, Never>()
    var selectedTag: Int = 0
    var selectedCalculationOption: Int = 0
    private let viewModel = MainViewModel()

    var lblAnnuitentPayment: UILabel?
    var lblPercentAll: UILabel?
    var lblDiffPayment: UILabel?
    var calculationStackViewBuilder = CalculateOptionStackViewBuilder()
    let dropDownButtonBuilder = DropDownButtonBuilder()

    let interestRateStackViewBuilder = InterestRateStackViewBuilder()
    let monthlyPaymentStackViewBuilder = MonthlyPaymentStackViewBuilder()
    var creditTermStackViewBuilder: CreditTermStackViewBuilder?
    var amountOfCreditBuilder: AmountOfCreditStackViewBuilder?
    var calculaionSV = UIStackView()
    var dropDownButton = UIButton()
    var amountOfCreditSV = UIStackView()
    var creditTermSV = UIStackView()
    var interestRateSV = UIStackView()
    var monthlyPaymentSV = UIStackView()
    var radioButtonView = UIView()

    var calculationType: CalculationType = .anuitent

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.calculationStackViewBuilder = CalculateOptionStackViewBuilder(viewController: self)
        self.calculaionSV = calculationStackViewBuilder.buildCalculationOptionSV()
        self.dropDownButton = dropDownButtonBuilder.buildDropDownButton()
        self.creditTermStackViewBuilder = CreditTermStackViewBuilder(viewModel: viewModel)
        self.creditTermSV = creditTermStackViewBuilder!.buildCreditTermStackView()
        self.interestRateSV = interestRateStackViewBuilder.buildInterestRateStackView()
        self.monthlyPaymentSV = monthlyPaymentStackViewBuilder.buildMonthlyPaymentStackView()
        self.radioButtonView = createCalculationTypeView()
        self.amountOfCreditBuilder = AmountOfCreditStackViewBuilder(viewModel: viewModel)

        self.amountOfCreditSV = amountOfCreditBuilder!.buildAmountOfCreditStackView()

        amountOfCreditBuilder!.textViewAmountCredit.textPublisher
            .assign(to: \.amountOfCredit, on: viewModel)
            .store(in: &subscriptions)

        creditTermStackViewBuilder!.textViewCreditTerm.textPublisher
            .assign(to: \.creditTerm, on: viewModel)
            .store(in: &subscriptions)

        interestRateStackViewBuilder.textViewInterestRate.doublePublisher
            .assign(to: \.interestRate, on: viewModel)
            .store(in: &subscriptions)

        monthlyPaymentStackViewBuilder.textViewMonthlyPayment.doublePublisher
            .assign(to: \.paymentSetted, on: viewModel)
            .store(in: &subscriptions)
    }

    lazy var mainSV: UIStackView = {
        let radioView = createCalculationTypeView()
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.distribution = .fill
        [calculaionSV,
         dropDownButton,
         amountOfCreditSV,
         creditTermSV,
         interestRateSV,
         radioView,
         btnCalculate,
         btnDetails
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.addSubview(self.mainSV)
        self.setupConstraintsMain()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        btnCalculate.addTarget(self, action: #selector(btnPopUpCalculate), for: .touchUpInside)
        btnDetails.addTarget(self, action: #selector(btnDetailsTap), for: .touchUpInside)

        tagHandlerPublisher.sink {[self] value in
            self.selectedTag = value
            self.mainSV.subviews.forEach { view in
                if view == lblAnnuitentPayment {
                    view.removeFromSuperview()
                }
                if view == lblPercentAll {
                    view.removeFromSuperview()
                }
                if view == lblDiffPayment {
                    view.removeFromSuperview()
                }
            }
            clearLabels()
        }.store(in: &subscriptions)

        dropDownButtonBuilder.$calculationOption
            .dropFirst()
            .sink { [weak self] in self?.calculationOption($0) }
            .store(in: &subscriptions)
    }

    private func calculationOption(_ value: Int) {
        selectedCalculationOption = value
        mainSV.subviews.forEach({ $0.removeFromSuperview() })
        clearLabels()
        var views = [
            calculaionSV,
            dropDownButton
        ]
        switch value {
        case 0:
            views.append(amountOfCreditSV)
            views.append(creditTermSV)
            views.append(interestRateSV)
            views.append(radioButtonView)
        case 1:
            views.append(amountOfCreditSV)
            views.append(monthlyPaymentSV)
            views.append(interestRateSV)
        case 2:
            views.append(creditTermSV)
            views.append(monthlyPaymentSV)
            views.append(interestRateSV)
        default:
            break
        }
        views.append(btnCalculate)
        views.forEach { mainSV.addArrangedSubview($0) }
        setupConstraintsMain()
    }

    private func clearLabels() {
        self.lblPercentAll = nil
        self.lblDiffPayment = nil
        self.lblAnnuitentPayment = nil
    }

    private func setupConstraintsMain () {
        mainSV.translatesAutoresizingMaskIntoConstraints = false
        mainSV.spacing = UIStackView.spacingUseSystem
        mainSV.isLayoutMarginsRelativeArrangement = true
        mainSV.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

        mainSV.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }

    func createCalculationTypeView() -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        let anuitentView = createRadioButtonView(.anuitent)
        let differentiatedView = createRadioButtonView(.differentiated)
        stack.addArrangedSubview(anuitentView)
        stack.addArrangedSubview(differentiatedView)
        return stack
    }

    func createRadioButtonView(_ type: CalculationType) -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        let radioButton = createRadioButton(type)
        let infoButton = createCalculationInfoButton(type)
        switch type {
        case .anuitent:
            radioButton.tag = TagViews.anuitentButton.rawValue
            infoButton.tag = TagViews.infoAnuitentButton.rawValue
        case .differentiated:
            radioButton.tag = TagViews.differentiatedButton.rawValue
            infoButton.tag = TagViews.infoDifferentiatedButton.rawValue
        }
        stack.addArrangedSubview(radioButton)
        stack.addArrangedSubview(infoButton)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }

    func createCalculationInfoButton(_ type: CalculationType) -> UIButton {
        let infoButton = UIButton(type: .system)
        infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        infoButton.addTarget(self, action: #selector(radioButtonTap(sender:)), for: .touchUpInside)

        infoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoButton.widthAnchor.constraint(equalToConstant: 44),
            infoButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        return infoButton
    }

    func createRadioButton(_ type: CalculationType) -> UIButton {
        let radioButton = UIButton(type: .system)
        radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
        radioButton.setImage(UIImage(systemName: "circle.circle"), for: .selected)
        radioButton.addTarget(self, action: #selector(radioButtonTap(sender:)), for: .touchUpInside)
        radioButton.setTitle(type.rawValue, for: .normal)
        radioButton.isSelected = type == calculationType

        radioButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            radioButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        return radioButton
    }

    func calculationTypeHandler(_ type: CalculationType) {
        let anuitentButton = view.viewWithTag(TagViews.anuitentButton.rawValue) as? UIButton
        let differentiatedButton = view.viewWithTag(TagViews.differentiatedButton.rawValue) as? UIButton
        switch type {
        case .anuitent:
            tagHandlerPublisher.send(0)
            anuitentButton?.isSelected = true
            differentiatedButton?.isSelected = false
        case .differentiated:
            tagHandlerPublisher.send(1)
            anuitentButton?.isSelected = false
            differentiatedButton?.isSelected = true
        }
        calculationType = type
    }

    func tagHandler(_ tag: Int) {
        switch TagViews(rawValue: tag) {
        case .anuitentButton:
            calculationTypeHandler(.anuitent)
        case .differentiatedButton:
            calculationTypeHandler(.differentiated)
        case .infoAnuitentButton:
            print("show anuitent calculation info")
        case .infoDifferentiatedButton:
            print("show differentiated calculation info")
        case .none:
            break
        }
    }

    @objc
    func radioButtonTap(sender: UIButton) {
        tagHandler(sender.tag)
    }

    @objc
    func btnPopUpCalculate(sender: UIButton) {
        if selectedCalculationOption == 0 {
            if selectedTag == 0 {
                calculateAnnuitentPayments(viewModel.calculateAnnuitentPayments())
            } else {
                calculateDiffPayments(viewModel.calculateDiffPayments())
            }
        } else if selectedCalculationOption == 1 {
            calculateTermPayments(viewModel.calculateTermPayments())
        } else if selectedCalculationOption == 2 {
            calculateMaxCredit(viewModel.calculateMaxCredit())
        }
    }

    @objc
    func btnDetailsTap(sender: UIButton) {
        let assembly = DetailsScreenAssembly()
        let payments: DetailsScreenViewModel.Payments
        if selectedCalculationOption == 0 {
            if selectedTag == 0 {
                payments = .annuitent(
                    amount: Double(viewModel.amountOfCredit),
                    payment: viewModel.monthlyPaymentA,
                    term: Double(viewModel.termInMonth),
                    monthRate: viewModel.pTax)
            } else {
                payments = .differentiated(
                    amount: Double(viewModel.amountOfCredit),
                    payment: viewModel.monthlyPaymentB,
                    term: Double(viewModel.termInMonth),
                    monthRate: viewModel.pTax)
            }
        } else if selectedCalculationOption == 1 {
            payments = .term
        } else if selectedCalculationOption == 2 {
            payments = .amountMax
        } else {
            return
        }
        let controller = assembly.assemble(payments)
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    private func calculateAnnuitentPayments(_ payments: Double) {
        if lblAnnuitentPayment == nil,
              lblPercentAll == nil {
            lblAnnuitentPayment = createLabel("Ежемесячный платеж " + String(format: "%.2f", viewModel.monthlyPaymentA))
            lblPercentAll = createLabel("Начисленные проценты " + String(format: "%.2f", payments))
            mainSV.addArrangedSubview(lblAnnuitentPayment!)
            mainSV.addArrangedSubview(lblPercentAll!)
        } else {
            lblAnnuitentPayment?.text = "Ежемесячный платеж " + String(format: "%.2f", viewModel.monthlyPaymentA)
            lblPercentAll?.text = "Начисленные проценты " + String(format: "%.2f", payments)
        }
    }

    private func calculateDiffPayments(_ payments: (Double, Double, Double)) {
        let annuitentText1 = String(format: "%.2f", payments.0)
        let annuitentText2 = String(format: "%.2f", payments.1)
        if lblDiffPayment == nil,
           lblPercentAll == nil {
            lblDiffPayment = createLabel("Ежемесячный платеж " + annuitentText1 + " ... " + annuitentText2)
            lblPercentAll = createLabel("Начисленные проценты " + String(format: "%.2f", payments.2))
            mainSV.addArrangedSubview(lblDiffPayment!)
            mainSV.addArrangedSubview(lblPercentAll!)
        } else {
            lblDiffPayment?.text = "Ежемесячный платеж " + annuitentText1 + " ... " + annuitentText2
            lblPercentAll?.text = "Начисленные проценты " + String(format: "%.2f", payments.2)
        }
    }

    private func calculateTermPayments(_ payments: (Int, Double)) {
        if lblAnnuitentPayment == nil,
           lblPercentAll == nil {
            lblPercentAll = createLabel("Срок кредита \(payments.0)")
            lblAnnuitentPayment = createLabel("Срок кредита \(payments.0)")
            lblPercentAll = createLabel("Начисленные проценты " + String(format: "%.2f", payments.1))
            mainSV.addArrangedSubview(lblAnnuitentPayment!)
            mainSV.addArrangedSubview(lblPercentAll!)
        } else {
            lblAnnuitentPayment?.text = "Срок кредита \(payments.0)"
            lblPercentAll?.text = "Начисленные проценты " + String(format: "%.2f", payments.1)
        }
    }

    private func calculateMaxCredit(_ payments: (Double, Double)) {
        if lblAnnuitentPayment == nil,
           lblPercentAll == nil {
            lblAnnuitentPayment = createLabel("Сумма кредита " + String(format: "%.2f", payments.0))
            lblPercentAll = createLabel("Начисленные проценты " + String(format: "%.2f", payments.1))
            mainSV.addArrangedSubview(lblAnnuitentPayment!)
            mainSV.addArrangedSubview(lblPercentAll!)
        } else {
            lblAnnuitentPayment?.text = "Сумма кредита " + String(format: "%.2f", payments.0)
            lblPercentAll?.text = "Начисленные проценты " + String(format: "%.2f", payments.1)
        }
    }

    private func createLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .red
        return label
    }
}
