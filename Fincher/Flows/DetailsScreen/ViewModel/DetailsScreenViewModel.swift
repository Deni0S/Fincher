import Foundation

final class DetailsScreenViewModel {
    enum Payments {
        case annuitent(amount: Double, payment: Double, term: Double, monthRate: Double)
        case differentiated(amount: Double, payment: Double, term: Double, monthRate: Double)
        case term
        case amountMax
    }

    private let payments: Payments

    private(set) lazy var monthData: [DetailsScreenViewData] = calculateData(payments)

    init(_ payments: Payments) {
        self.payments = payments
    }
}

private extension DetailsScreenViewModel {
    func calculateData(_ payments: Payments) -> [DetailsScreenViewData] {
        switch payments {
        case let .annuitent(amount, payment, term, monthRate):
            return calculateCreditData(amount, payment, term, monthRate, true)
        case  let.differentiated(amount, payment, term, monthRate):
            return calculateCreditData(amount, payment, term, monthRate, false)
        case .term:
            return mockData()
        case .amountMax:
            return mockData()
        }
    }

    func calculateCreditData(
        _ amount: Double,
        _ payment: Double,
        _ term: Double,
        _ monthRate: Double,
        _ isAnuitent: Bool
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
                number: "\(index)",
                date: "Дата:\n\(index)",
                amount: "Платеж:\n\(Int(isAnuitent ? payment : renewal))",
                percent: "Проценты:\n\(Int(percent))",
                renewal: "Долг:\n\(Int(isAnuitent ? renewal : payment))",
                contrib: "Доп взнос:\n0",
                general: "Остаток:\n\(max(Int(principalDebt), 0))",
                overpayment: "Переплата:\n\(Int(overpayment))")
            monthsData.append(data)
        }
        return monthsData
    }

    func mockData() -> [DetailsScreenViewData] {
        [
            DetailsScreenViewData(
                number: "1", date: "Дата:\n 25.12.2025", amount: "Сумма:\n50 000 руб",
                percent: "Проценты:\n1 000 000 руб", renewal: "Основной:\n50 000 руб", contrib: "Доп взнос:\n0 руб",
                general: "Общая сумма:\n3 000 000", overpayment: "Переплата:\n1000000"),
            DetailsScreenViewData(
                number: "2", date: "Дата:\n 25.01.2026", amount: "Сумма:\n50 000 руб",
                percent: "Проценты:\n1 000 000 руб", renewal: "Основной:\n50 000 руб", contrib: "Доп взнос:\n0 руб",
                general: "Общая сумма:\n2 000 000", overpayment: "Переплата:\n2000000"),
            DetailsScreenViewData(
                number: "3", date: "Дата:\n 25.12.2025", amount: "Сумма:\n1 000 000 руб",
                percent: "Проценты:\n30 000 руб", renewal: "Основной:\n50 000 руб", contrib: "Доп взнос:\n0 руб",
                general: "Общая сумма:\n0", overpayment: "Переплата:\n3000000")
        ]
    }
}
