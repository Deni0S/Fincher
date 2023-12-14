import Foundation

final class DetailsScreenViewModel {
    enum Payments {
        case annuitent(amount: Double, payment: Double, term: Double, monthRate: Double)
        case differentiated(amount: Double, payment: Double, term: Double, monthRate: Double)
    }

    private let payments: Payments

    private(set) lazy var monthData: [DetailsScreenViewData] = calculateData(payments: payments)
    private(set) var chartData: [ChartData] = []

    init(
        payments: Payments
    ) {
        self.payments = payments
    }
}

private extension DetailsScreenViewModel {
    func calculateData(
        payments: Payments
    ) -> [DetailsScreenViewData] {
        switch payments {
        case let .annuitent(amount, payment, term, monthRate):
            return calculateCreditData(
                amount: amount,
                payment: payment,
                term: term,
                monthRate: monthRate,
                isAnuitent: true)
        case  let.differentiated(amount, payment, term, monthRate):
            return calculateCreditData(
                amount: amount,
                payment: payment,
                term: term,
                monthRate: monthRate,
                isAnuitent: false)
        }
    }

    func calculateCreditData(
        amount: Double,
        payment: Double,
        term: Double,
        monthRate: Double,
        isAnuitent: Bool
    ) -> [DetailsScreenViewData] {
        guard term > 0 else { return [] }

        var monthsData: [DetailsScreenViewData] = []

        var principalDebt = amount
        var overpayment = 0.0

        for index in 1...Int(term) {
            guard principalDebt >= 0 else { continue }
            let percent = principalDebt * monthRate
            let renewal = isAnuitent ? (payment - percent) : (payment + percent)
            principalDebt -= renewal
            overpayment += percent

            let data = DetailsScreenViewData(
                number: "",
                date: "№ \(index)",
                amount: "Платеж: \(Int(isAnuitent ? payment : renewal)) ₽",
                percent: "Проценты: \(Int(percent)) ₽",
                renewal: "Долг: \(Int(isAnuitent ? renewal : payment)) ₽",
                contrib: "",
                general: "Остаток: \(max(Int(principalDebt), 0)) ₽",
                overpayment: "Переплата: \(Int(overpayment)) ₽")
            monthsData.append(data)
            chartData.append(ChartData(number: index, count: Int(percent)))
        }
        return monthsData
    }
}
