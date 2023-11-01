import Foundation

struct CreditMonthData {
    /// Номер месяца
    let number: Int
    /// Дата платежа
    let date: Date
    /// Сума  платежа
    let paymentAmount: Double
    /// Платеж по основному долгу
    let paymentPrincipal: Double
    /// Проценты к выплате
    let paymentInterest: Double
    /// Cумма досрочного погашения
    let repaymentAmount: Double
    /// Сумма основного долга
    let remainingAmount: Double
}
