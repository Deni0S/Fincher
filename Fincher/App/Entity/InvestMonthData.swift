import Foundation

struct InvestMonthData {
    /// Номер месяца
    let number: Int
    /// Дата платежа
    let date: Date
    /// Сума выплаты
    let paymentAmount: Double
    /// Вложенная сумма
    let investAmount: Double
    /// Накопленные проценты
    let investInterest: Double
    /// Дополнительный взнос
    let paymentAdditional: Double
    /// Общая сумма вложений
    let generalШnvestAmount: Double
}
