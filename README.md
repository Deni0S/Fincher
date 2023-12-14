
# Fincher

Приложение Fincher выполняет функцию кредитного калькулятора. Реализован функционал вычисления ежемесячного платежа, срока кредита и максимальной суммы кредита.


## Screenshots

![App Screenshot](https://github.com/androidc/Fincher/blob/develop/Screen11.png)
![App Screenshot](https://github.com/androidc/Fincher/blob/develop/Screen22.png)
![App Screenshot](https://github.com/androidc/Fincher/blob/develop/screen3.jpg)
![App Screenshot](https://github.com/androidc/Fincher/blob/develop/screen4.jpg)


## Описание решения

Проект выполнен без использования StoryBoard, все элементы созданы в коде и размещены с использованием Constraints. Проект выполнен в команде из двух человек

Описание функционала

На главном экране в StackView находятся 
- Segment Control для выбора типа платежа (аннуитетный или дифференцированный)
- DropDown для выбора типа калькулятора (ежемесячный платеж / срок кредита / максимальная сумма кредита). При выборе типа меняются поля ввода
- TextView для заполнения данными. Реализована проверка TextView на ввод. Разрешены только цифры.
- Кнопка "рассчитать", которая производит расчет для соответствующего типа. Если какие-то поля не заполнены, то расчет не производится, соответствующая функция выкидывает throw.
- Кнопка "график платежей", по которой открывается view с таблицей с графиком платежей, вычисленных по кнопке "рассчитать"

## Архитектурные и технологические решения

- UIKit
- Combine
- Localization
- MVVM
- Extensions
- Delegate
- Publishers
- Throwing functions


## Элементы дизайна

- StackView
- Buttons
- Labels
- DropDown
- TextView
- Segment Control
- TableView


## Авторы

- [@androidc](https://www.github.com/androidc) 

- [@Deni0S](https://www.github.com/Deni0S) 
