//
//  ContentView.swift
//  Calculator
//
//  Created by Stefan Tagarski on 27.3.26.
//

import SwiftUI

struct ContentView: View {
    @State private var display: String = "0"
    @State private var firstOperand: Double? = nil
    @State private var secondOperand: Double? = nil
    @State private var currentOperation: String? = nil
    @State private var shouldResetDisplay: Bool = false
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var isLandscape: Bool {
        verticalSizeClass == .compact
    }
    
    let portraitButtons: [[String]] = [
        ["7", "8", "9", "/"],
        ["4", "5", "6", "*"],
        ["1", "2", "3", "-"],
        ["C", "0", "=", "+"]
    ]
    
    let landscapeButtons: [[String]] = [
        ["sin", "cos", "tan", "7", "8", "9", "/"],
        ["√",   "%",   "^",  "4", "5", "6", "*"],
        ["(",   ")",   "±",  "1", "2", "3", "-"],
        ["π",   "e",   ".",  "C", "0", "=", "+"]
    ]
    
    var currentButtons: [[String]] {
        isLandscape ? landscapeButtons : portraitButtons
    }
    
    var columnCount: Int {
        isLandscape ? 7 : 4
    }
    
    private static let operatorSet: Set<String> = ["/", "*", "-", "+", "="]
    private static let scientificSet: Set<String> = [
        "sin", "cos", "tan", "√", "%", "^", "(", ")", "±", "π", "e", "."
    ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: isLandscape ? 8 : 20) {
                Text(display)
                    .font(isLandscape ? .title : .largeTitle)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 16)
                    .padding(.vertical, isLandscape ? 8 : 16)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                let buttonSize = calculateButtonSize(geometry: geometry)
                
                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(.flexible(), spacing: isLandscape ? 6 : 10),
                        count: columnCount
                    ),
                    spacing: isLandscape ? 6 : 10
                ) {
                    ForEach(currentButtons.flatMap { $0 }, id: \.self) { button in
                        Button(action: {
                            buttonTapped(button)
                        }) {
                            Text(button)
                                .font(isLandscape ? .body : .title)
                                .fontWeight(.medium)
                                .frame(width: buttonSize, height: buttonSize)
                                .background(buttonColor(for: button))
                                .foregroundColor(.white)
                                .cornerRadius(isLandscape ? 8 : 10)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, isLandscape ? 4 : 16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
        
    func calculateButtonSize(geometry: GeometryProxy) -> CGFloat {
        let width = geometry.size.width
        let height = geometry.size.height
        let cols = CGFloat(columnCount)
        let rows: CGFloat = 4
        let hSpacing: CGFloat = isLandscape ? 6 : 10
        let vSpacing: CGFloat = isLandscape ? 6 : 10
        let hPadding: CGFloat = 32
        let displayHeight: CGFloat = isLandscape ? 50 : 90
        
        let maxByWidth = (width - hPadding - (cols - 1) * hSpacing) / cols
        let maxByHeight = (height - displayHeight - (rows - 1) * vSpacing - 40) / rows
        
        return min(maxByWidth, maxByHeight)
    }
        
    func buttonColor(for button: String) -> Color {
        if button == "C" {
            return Color.red.opacity(0.7)
        } else if Self.operatorSet.contains(button) {
            return Color.orange.opacity(0.8)
        } else if Self.scientificSet.contains(button) {
            return Color.purple.opacity(0.6)
        } else {
            return Color.blue.opacity(0.7)
        }
    }
        
    func buttonTapped(_ button: String) {
        switch button {
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
            handleDigit(button)
        case ".":
            handleDecimalPoint()
        case "C":
            clearAll()
        case "=":
            performCalculation()
        case "+", "-", "*", "/", "^":
            setOperation(button)
        case "sin", "cos", "tan", "√":
            handleUnaryOperation(button)
        case "%":
            handlePercent()
        case "±":
            handlePlusMinus()
        case "π":
            display = "\(Double.pi)"
            shouldResetDisplay = true
        case "e":
            display = "\(M_E)"
            shouldResetDisplay = true
        default:
            break
        }
    }
    
    func handleDigit(_ digit: String) {
        if display == "0" || shouldResetDisplay {
            display = digit
            shouldResetDisplay = false
        } else {
            display += digit
        }
    }
    
    func handleDecimalPoint() {
        if shouldResetDisplay {
            display = "0."
            shouldResetDisplay = false
        } else if !display.contains(".") {
            display += "."
        }
    }
    
    func setOperation(_ operation: String) {
        if let _ = Double(display) {
            if firstOperand != nil && currentOperation != nil && !shouldResetDisplay {
                performCalculation()
            }
            firstOperand = Double(display)
            currentOperation = operation
            shouldResetDisplay = true
        }
    }
    
    func performCalculation() {
        guard let first = firstOperand,
              let second = Double(display),
              let operation = currentOperation else { return }
        
        var result: Double
        
        switch operation {
        case "+": result = first + second
        case "-": result = first - second
        case "*": result = first * second
        case "/":
            if second == 0 {
                display = "Error"
                firstOperand = nil
                currentOperation = nil
                return
            }
            result = first / second
        case "^": result = pow(first, second)
        default: return
        }
        
        display = formatResult(result)
        firstOperand = nil
        currentOperation = nil
        shouldResetDisplay = true
    }
    
    func handleUnaryOperation(_ op: String) {
        guard let value = Double(display) else { return }
        var result: Double
        
        switch op {
        case "sin": result = sin(value)
        case "cos": result = cos(value)
        case "tan": result = tan(value)
        case "√":
            if value < 0 {
                display = "Error"
                return
            }
            result = sqrt(value)
        default: return
        }
        
        display = formatResult(result)
        shouldResetDisplay = true
    }
    
    func handlePercent() {
        guard let value = Double(display) else { return }
        display = formatResult(value / 100)
        shouldResetDisplay = true
    }
    
    func handlePlusMinus() {
        guard let value = Double(display) else { return }
        display = formatResult(value * -1)
    }
    
    func formatResult(_ value: Double) -> String {
        if value == value.rounded() && abs(value) < 1e15 {
            return String(format: "%.0f", value)
        }
        return String(format: "%.10g", value)
    }
    
    func clearAll() {
        display = "0"
        firstOperand = nil
        secondOperand = nil
        currentOperation = nil
        shouldResetDisplay = false
    }
}

#Preview {
    ContentView()
}
