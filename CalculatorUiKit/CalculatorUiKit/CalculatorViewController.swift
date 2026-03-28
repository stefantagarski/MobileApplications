//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Stefan Tagarski on 27.3.26.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    // MARK: - State
    
    private var displayText: String = "0" {
        didSet { displayLabel.text = displayText }
    }
    private var firstOperand: Double?
    private var currentOperation: String?
    private var shouldResetDisplay: Bool = false
    
    // MARK: - Button Definitions
    
    private let portraitButtons: [[String]] = [
        ["7", "8", "9", "/"],
        ["4", "5", "6", "*"],
        ["1", "2", "3", "-"],
        ["C", "0", "=", "+"]
    ]
    
    private let landscapeButtons: [[String]] = [
        ["sin", "cos", "tan", "7", "8", "9", "/"],
        ["√",   "%",   "^",  "4", "5", "6", "*"],
        ["(",   ")",   "±",  "1", "2", "3", "-"],
        ["π",   "e",   ".",  "C", "0", "=", "+"]
    ]
    
    private static let operatorSet: Set<String> = ["/", "*", "-", "+", "="]
    private static let scientificSet: Set<String> = [
        "sin", "cos", "tan", "√", "%", "^", "(", ")", "±", "π", "e", "."
    ]
    
    private var isLandscape: Bool {
        let size = view.bounds.size
        return size.width > size.height
    }
    
    private var currentButtons: [[String]] {
        isLandscape ? landscapeButtons : portraitButtons
    }
    
    private var columnCount: Int {
        isLandscape ? 7 : 4
    }
    
    // MARK: - UI Elements
    
    private let displayLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .right
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.4
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let displayContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let buttonsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var buttonViews: [UIButton] = []
    
    // MARK: - Constraints (toggled on rotation)
    
    private var displayHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupDisplayArea()
        setupButtonsContainer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rebuildButtons()
        updateDisplayFont()
    }
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.rebuildButtons()
            self.updateDisplayFont()
        })
    }
    
    // MARK: - Setup
    
    private func setupDisplayArea() {
        view.addSubview(displayContainer)
        displayContainer.addSubview(displayLabel)
        
        displayHeightConstraint = displayContainer.heightAnchor.constraint(equalToConstant: 90)
        
        NSLayoutConstraint.activate([
            displayContainer.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8
            ),
            displayContainer.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16
            ),
            displayContainer.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16
            ),
            displayHeightConstraint,
            
            displayLabel.topAnchor.constraint(equalTo: displayContainer.topAnchor, constant: 8),
            displayLabel.bottomAnchor.constraint(equalTo: displayContainer.bottomAnchor, constant: -8),
            displayLabel.leadingAnchor.constraint(equalTo: displayContainer.leadingAnchor, constant: 16),
            displayLabel.trailingAnchor.constraint(equalTo: displayContainer.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupButtonsContainer() {
        view.addSubview(buttonsContainer)
        
        NSLayoutConstraint.activate([
            buttonsContainer.topAnchor.constraint(
                equalTo: displayContainer.bottomAnchor, constant: 8
            ),
            buttonsContainer.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16
            ),
            buttonsContainer.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16
            ),
            buttonsContainer.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8
            ),
        ])
    }
    
    // MARK: - Dynamic Layout
    
    private func updateDisplayFont() {
        let landscape = isLandscape
        displayLabel.font = landscape
            ? UIFont.preferredFont(forTextStyle: .title2)
            : UIFont.preferredFont(forTextStyle: .largeTitle)
        displayHeightConstraint.constant = landscape ? 50 : 90
    }
    
    private func rebuildButtons() {
        // Remove old buttons
        buttonViews.forEach { $0.removeFromSuperview() }
        buttonViews.removeAll()
        
        let landscape = isLandscape
        let buttons = currentButtons
        let cols = columnCount
        let rows = buttons.count
        
        let spacing: CGFloat = landscape ? 6 : 10
        let containerWidth = buttonsContainer.bounds.width
        let containerHeight = buttonsContainer.bounds.height
        
        guard containerWidth > 0, containerHeight > 0 else { return }
        
        let maxByWidth = (containerWidth - CGFloat(cols - 1) * spacing) / CGFloat(cols)
        let maxByHeight = (containerHeight - CGFloat(rows - 1) * spacing) / CGFloat(rows)
        let buttonSize = min(maxByWidth, maxByHeight)
        
        let totalGridWidth = CGFloat(cols) * buttonSize + CGFloat(cols - 1) * spacing
        let totalGridHeight = CGFloat(rows) * buttonSize + CGFloat(rows - 1) * spacing
        let startX = (containerWidth - totalGridWidth) / 2
        let startY = (containerHeight - totalGridHeight) / 2
        
        let fontSize: UIFont = landscape
            ? UIFont.systemFont(ofSize: 16, weight: .medium)
            : UIFont.systemFont(ofSize: 24, weight: .medium)
        
        for (rowIndex, row) in buttons.enumerated() {
            for (colIndex, title) in row.enumerated() {
                let x = startX + CGFloat(colIndex) * (buttonSize + spacing)
                let y = startY + CGFloat(rowIndex) * (buttonSize + spacing)
                
                let button = UIButton(type: .system)
                button.setTitle(title, for: .normal)
                button.titleLabel?.font = fontSize
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = buttonColor(for: title)
                button.layer.cornerRadius = landscape ? 8 : 10
                button.clipsToBounds = true
                button.frame = CGRect(x: x, y: y, width: buttonSize, height: buttonSize)
                button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
                
                buttonsContainer.addSubview(button)
                buttonViews.append(button)
            }
        }
    }
    
    // MARK: - Button Colors
    
    private func buttonColor(for title: String) -> UIColor {
        if title == "C" {
            return UIColor.systemRed.withAlphaComponent(0.7)
        } else if Self.operatorSet.contains(title) {
            return UIColor.systemOrange.withAlphaComponent(0.8)
        } else if Self.scientificSet.contains(title) {
            return UIColor.systemPurple.withAlphaComponent(0.6)
        } else {
            return UIColor.systemBlue.withAlphaComponent(0.7)
        }
    }
    
    // MARK: - Button Handling
    
    @objc private func buttonPressed(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        buttonTapped(title)
    }
    
    private func buttonTapped(_ button: String) {
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
            displayText = "\(Double.pi)"
            shouldResetDisplay = true
        case "e":
            displayText = "\(M_E)"
            shouldResetDisplay = true
        default:
            break
        }
    }
    
    // MARK: - Calculator Logic
    
    private func handleDigit(_ digit: String) {
        if displayText == "0" || shouldResetDisplay {
            displayText = digit
            shouldResetDisplay = false
        } else {
            displayText += digit
        }
    }
    
    private func handleDecimalPoint() {
        if shouldResetDisplay {
            displayText = "0."
            shouldResetDisplay = false
        } else if !displayText.contains(".") {
            displayText += "."
        }
    }
    
    private func setOperation(_ operation: String) {
        if let _ = Double(displayText) {
            if firstOperand != nil && currentOperation != nil && !shouldResetDisplay {
                performCalculation()
            }
            firstOperand = Double(displayText)
            currentOperation = operation
            shouldResetDisplay = true
        }
    }
    
    private func performCalculation() {
        guard let first = firstOperand,
              let second = Double(displayText),
              let operation = currentOperation else { return }
        
        var result: Double
        
        switch operation {
        case "+": result = first + second
        case "-": result = first - second
        case "*": result = first * second
        case "/":
            if second == 0 {
                displayText = "Error"
                firstOperand = nil
                currentOperation = nil
                return
            }
            result = first / second
        case "^": result = pow(first, second)
        default: return
        }
        
        displayText = formatResult(result)
        firstOperand = nil
        currentOperation = nil
        shouldResetDisplay = true
    }
    
    private func handleUnaryOperation(_ op: String) {
        guard let value = Double(displayText) else { return }
        var result: Double
        
        switch op {
        case "sin": result = sin(value)
        case "cos": result = cos(value)
        case "tan": result = tan(value)
        case "√":
            if value < 0 {
                displayText = "Error"
                return
            }
            result = sqrt(value)
        default: return
        }
        
        displayText = formatResult(result)
        shouldResetDisplay = true
    }
    
    private func handlePercent() {
        guard let value = Double(displayText) else { return }
        displayText = formatResult(value / 100)
        shouldResetDisplay = true
    }
    
    private func handlePlusMinus() {
        guard let value = Double(displayText) else { return }
        displayText = formatResult(value * -1)
    }
    
    private func formatResult(_ value: Double) -> String {
        if value == value.rounded() && abs(value) < 1e15 {
            return String(format: "%.0f", value)
        }
        return String(format: "%.10g", value)
    }
    
    private func clearAll() {
        displayText = "0"
        firstOperand = nil
        currentOperation = nil
        shouldResetDisplay = false
    }
}
