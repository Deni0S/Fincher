import Combine
import DropDown
import SnapKit
import UIKit

enum CalculationType: String {
    case anuitent = "Аннуитентные"
    case differentiated = "Дифференцированные"
}

class MainViewController: UIViewController {
    let btnCalculate: UIButton = {
        let btn = UIButton(type: .system)
        if #available(iOS 15.0, *) {
            btn.configuration = .filled()
        } else {}
        btn.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        btn.setTitle("Рассчитать", for: .normal)
        return btn
    }()

    let btnDetails: UIButton = {
        let btn = UIButton(type: .system)
        if #available(iOS 15.0, *) {
            btn.configuration = .filled()
        } else {}
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

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.calculationStackViewBuilder = CalculateOptionStackViewBuilder(viewController: self)
        self.calculaionSV = calculationStackViewBuilder.buildCalculationOptionSV()
        self.dropDownButton = dropDownButtonBuilder.buildDropDownButton()
        self.creditTermStackViewBuilder = CreditTermStackViewBuilder(viewModel: viewModel)
        self.creditTermSV = creditTermStackViewBuilder!.buildCreditTermStackView()
        self.interestRateSV = interestRateStackViewBuilder.buildInterestRateStackView()
        self.monthlyPaymentSV = monthlyPaymentStackViewBuilder.buildMonthlyPaymentStackView()
        self.amountOfCreditBuilder = AmountOfCreditStackViewBuilder(viewModel: viewModel)

        self.amountOfCreditSV = amountOfCreditBuilder!.buildAmountOfCreditStackView()

        amountOfCreditBuilder!.textViewAmountCredit.textPublisher
            .assign(to: \.amountOfCredit, on: viewModel)
            .store(in: &subscriptions)
        amountOfCreditBuilder!.textViewAmountCredit.delegate = self

        creditTermStackViewBuilder!.textViewCreditTerm.textPublisher
            .assign(to: \.creditTerm, on: viewModel)
            .store(in: &subscriptions)
        creditTermStackViewBuilder?.textViewCreditTerm.delegate = self

        interestRateStackViewBuilder.textViewInterestRate.doublePublisher
            .assign(to: \.interestRate, on: viewModel)
            .store(in: &subscriptions)
        interestRateStackViewBuilder.textViewInterestRate.delegate = self

        monthlyPaymentStackViewBuilder.textViewMonthlyPayment.doublePublisher
            .assign(to: \.paymentSetted, on: viewModel)
            .store(in: &subscriptions)
        monthlyPaymentStackViewBuilder.textViewMonthlyPayment.delegate = self
    }

    lazy var segmentedControl: UISegmentedControl = {
        // Initialize segmented control
        let items = [CalculationType.anuitent.rawValue, CalculationType.differentiated.rawValue]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        // Style the Segmented Control
        customSC.layer.cornerRadius = 5.0  // Don't let background bleed
        customSC.backgroundColor = UIColor.black
        customSC.tintColor = UIColor.white
        // Add target action method
        customSC.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        return customSC
    }()

    lazy var mainSV: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.distribution = .fill
        [segmentedControl,
         calculaionSV,
         dropDownButton,
         amountOfCreditSV,
         creditTermSV,
         interestRateSV,
         btnCalculate,
         btnDetails
        ].forEach { stackView.addArrangedSubview($0) }
        stackView.setCustomSpacing(40, after: interestRateSV)
        stackView.setCustomSpacing(40, after: btnCalculate)
        return stackView
    }()

    @objc
    func segmentAction(_ segmentedControl: UISegmentedControl) {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                tagHandlerPublisher.send(0)
            case 1:
                tagHandlerPublisher.send(1)
            default:
                break
            }
        }

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
            segmentedControl,
            calculaionSV,
            dropDownButton
        ]
        switch value {
        case 0:
            views.append(amountOfCreditSV)
            views.append(creditTermSV)
            views.append(interestRateSV)
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
        views.append(btnDetails)
        views.forEach { mainSV.addArrangedSubview($0) }
        mainSV.setCustomSpacing(40, after: interestRateSV)
        mainSV.setCustomSpacing(40, after: btnCalculate)
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
        btnCalculate.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        btnDetails.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }

    private func tryCalculateAnnuitentPayments() {
        do {
            try calculateAnnuitentPayments(viewModel.calculateAnnuitentPayments())
        } catch CalculateError.noAmountOfCredit {
            print("no amount of credit")
        } catch CalculateError.noInterestRate {
            print("no interest rate")
        } catch CalculateError.noCreditTerm {
            print("no credit Term")
        } catch {
            print("unknown error")
        }
    }

    private func tryCalculateDiffPayments() {
        do {
            try calculateDiffPayments(viewModel.calculateDiffPayments())
        } catch CalculateError.noAmountOfCredit {
            print("no amount of credit")
        } catch CalculateError.noInterestRate {
            print("no interest rate")
        } catch CalculateError.noCreditTerm {
            print("no credit Term")
        } catch {
            print("unknown error")
        }
    }

    private func tryCalculateTermPayments() {
        do {
            try calculateTermPayments(viewModel.calculateTermPayments())
        } catch CalculateError.noAmountOfCredit {
            print("no amount of credit")
        } catch CalculateError.noInterestRate {
            print("no interest rate")
        } catch CalculateError.smallPayment {
            print("payment is not enough to pay percent")
        } catch CalculateError.noMonthlyPayment {
            print("no monthly payment")
        } catch {
            print("unknown error")
        }
    }

    private func tryCalculateMaxCredit() {
        do {
            try calculateMaxCredit(viewModel.calculateMaxCredit())
        } catch CalculateError.noAmountOfCredit {
            print("no amount of credit")
        } catch CalculateError.noInterestRate {
            print("no interest rate")
        } catch CalculateError.noCreditTerm {
            print("no credit Term")
        } catch CalculateError.noMonthlyPayment {
            print("no monthly payment")
        } catch {
            print("unknown error")
        }
    }

    @objc
    func btnPopUpCalculate(sender: UIButton) {
        if selectedCalculationOption == 0 {
            if selectedTag == 0 {
                tryCalculateAnnuitentPayments()
            } else {
                tryCalculateDiffPayments()
            }
        } else if selectedCalculationOption == 1 {
            tryCalculateTermPayments()
        } else if selectedCalculationOption == 2 {
            tryCalculateMaxCredit()
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
            let lText = Strings.shared.mPaymentStr + " " + String(format: "%.2f", viewModel.monthlyPaymentA)
            lblAnnuitentPayment = createLabel(lText)
            lblPercentAll = createLabel("\(Strings.shared.interestChargesString) " + String(format: "%.2f", payments))
            mainSV.addArrangedSubview(lblAnnuitentPayment!)
            mainSV.addArrangedSubview(lblPercentAll!)
        } else {
            let lText = Strings.shared.mPaymentStr + " " + String(format: "%.2f", viewModel.monthlyPaymentA)
            lblAnnuitentPayment?.text = lText
            lblPercentAll?.text = Strings.shared.interestChargesString + " " + String(format: "%.2f", payments)
        }
    }

    private func calculateDiffPayments(_ payments: (Double, Double, Double)) {
        let annuitentText1 = String(format: "%.2f", payments.0)
        let annuitentText2 = String(format: "%.2f", payments.1)
        if lblDiffPayment == nil,
           lblPercentAll == nil {
            lblDiffPayment = createLabel("\(Strings.shared.mPaymentStr) " + annuitentText1 + " ... " + annuitentText2)
            lblPercentAll = createLabel("\(Strings.shared.interestChargesString) " + String(format: "%.2f", payments.2))
            mainSV.addArrangedSubview(lblDiffPayment!)
            mainSV.addArrangedSubview(lblPercentAll!)
        } else {
            lblDiffPayment?.text = "\(Strings.shared.mPaymentStr) " + annuitentText1 + " ... " + annuitentText2
            lblPercentAll?.text = "\(Strings.shared.interestChargesString) " + String(format: "%.2f", payments.2)
        }
    }

    private func calculateTermPayments(_ payments: (Int, Double)) {
        if lblAnnuitentPayment == nil,
           lblPercentAll == nil {
            lblAnnuitentPayment = createLabel("\(Strings.shared.creditTerm2String) \(payments.0)")
            lblPercentAll = createLabel("\(Strings.shared.interestChargesString) " + String(format: "%.2f", payments.1))
            mainSV.addArrangedSubview(lblAnnuitentPayment!)
            mainSV.addArrangedSubview(lblPercentAll!)
        } else {
            lblAnnuitentPayment?.text = "\(Strings.shared.creditTerm2String) \(payments.0)"
            lblPercentAll?.text = "\(Strings.shared.interestChargesString) " + String(format: "%.2f", payments.1)
        }
    }

    private func calculateMaxCredit(_ payments: (Double, Double)) {
        if lblAnnuitentPayment == nil,
           lblPercentAll == nil {
            lblAnnuitentPayment = createLabel("\(Strings.shared.amountOfCredit) " + String(format: "%.2f", payments.0))
            lblPercentAll = createLabel("\(Strings.shared.interestChargesString) " + String(format: "%.2f", payments.1))
            mainSV.addArrangedSubview(lblAnnuitentPayment!)
            mainSV.addArrangedSubview(lblPercentAll!)
        } else {
            lblAnnuitentPayment?.text = "\(Strings.shared.amountOfCredit) " + String(format: "%.2f", payments.0)
            lblPercentAll?.text = "\(Strings.shared.interestChargesString) " + String(format: "%.2f", payments.1)
        }
    }

    private func createLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .red
        return label
    }
}
