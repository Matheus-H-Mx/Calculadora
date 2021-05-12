//
//  HomeViewController.swift
//  Calculadora
//
//  Created by Matheus Henrique on 06/05/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    // MARK: - Outlets
    
    //RESULTS
    
    @IBOutlet weak var ResultLabel: UILabel!
    
    //NUMBERS
    
    @IBOutlet weak var Number0: UIButton!
    @IBOutlet weak var Number1: UIButton!
    @IBOutlet weak var Number2: UIButton!
    @IBOutlet weak var Number3: UIButton!
    @IBOutlet weak var Number4: UIButton!
    @IBOutlet weak var Number5: UIButton!
    @IBOutlet weak var Number6: UIButton!
    @IBOutlet weak var Number7: UIButton!
    @IBOutlet weak var Number8: UIButton!
    @IBOutlet weak var Number9: UIButton!
    @IBOutlet weak var NumberDecimal: UIButton!
    
    //OPERATORS
    
    @IBOutlet weak var OperatorAC: UIButton!
    @IBOutlet weak var OperatorPlusMinus: UIButton!
    @IBOutlet weak var OperatorPercent: UIButton!
    @IBOutlet weak var OperatorResult: UIButton!
    @IBOutlet weak var OperatorAddition: UIButton!
    @IBOutlet weak var OperatorSubtraction: UIButton!
    @IBOutlet weak var OperatorMultiplication: UIButton!
    @IBOutlet weak var OperatorDivision: UIButton!
          
    // MARK: - Variables
        
    private var total: Double = 0 //total
    private var temp: Double = 0 //Valor por tela
    private var operating = false //indica o se há um operador
    private var Decimal = false // indica o valor decimal
    private var operation: OperatioType = .none // operação atual
    
    // MARK: - Constantes
    
    private let kDecimalSeparator = Locale.current.decimalSeparator!
    private let kMaxLength = 9
    private let kMaxValue: Double = 99999999
    private let kMinValue: Double = 0.0000001
    private let kTotal = "total"
    
    private enum OperatioType{
        case none, addiction, subtraction, multiplication, division, percent
    }
    
    // Formatação de valores Aux
    
    private let auxFormatter: NumberFormatter = {
        let  formatter = NumberFormatter()
        let Locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.groupingSeparator = Locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumIntegerDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    // Formatação de valores Aux totais
    
    private let auxTotalFormatter: NumberFormatter = {
        let  formatter = NumberFormatter()
        formatter.groupingSeparator = ""
        formatter.groupingSeparator = ""
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumIntegerDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    // Formatação de valores por telas
    
    private let printFormatter: NumberFormatter = {
        let  formatter = NumberFormatter()
        let Locale = Locale.current
        formatter.groupingSeparator = Locale.groupingSeparator
        formatter.groupingSeparator = Locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        return formatter
    }()
    
    //Formatação de valores telas em formato CIENTIFICO
    
    private let printScientificFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 3
        formatter.exponentSymbol = "e"
        return formatter
    }()
    
    // MARK: - Initialization
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:)has not implemented ")
    }
    
   // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        
    NumberDecimal.setTitle(kDecimalSeparator, for:.normal)
        
        total = UserDefaults.standard.double(forKey: kTotal)
    
        Result()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // UI
        Number0.round()
        Number1.round()
        Number2.round()
        Number3.round()
        Number4.round()
        Number5.round()
        Number6.round()
        Number7.round()
        Number8.round()
        Number9.round()
        NumberDecimal.round()
            
        OperatorAC.round()
        OperatorPlusMinus.round()
        OperatorPercent.round()
        OperatorResult.round()
        OperatorAddition.round()
        OperatorSubtraction.round()
        OperatorMultiplication.round()
        OperatorDivision.round()
    }
    
   // MARK: - Button Actions
    
    @IBAction func OperatorACAction(_ sender: UIButton) {
        clear()
        sender.shine()
    }
    
    @IBAction func OperatorPlusMinusAction(_ sender: UIButton) {
        temp = temp * (-1)
        ResultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        sender.shine()
    }
    
    @IBAction func OperatorPercentAction(_ sender: UIButton) {
        if operation != .percent{
            Result()
        }
        operating = true
        operation = .percent
        Result()
        
        sender.shine()
    }
    
    @IBAction func OperatorResultAction(_ sender: UIButton) {
        Result()
        
        sender.shine()
    }
   
    @IBAction func OperatorAdditionAction(_ sender: UIButton) {
        
        if operation != .none {
            Result()
        }
        
        operating = true
        operation = .addiction
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func OperatorSubtractionAction(_ sender: UIButton) {
        if operation != .none {
            Result()
        }
        operating = true
        operation = .subtraction
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func OperatorMultiplicationAction(_ sender: UIButton) {
        
        operating = true
        operation = .multiplication
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func OperatorDivisionAction(_ sender: UIButton) {
        
        if operation != .none {
            Result()
        }
        operating = true
        operation = .division
        sender.selectOperation(true)
        
         sender.shine()
    }
        
    @IBAction func NumberDecimalAction(_ sender: UIButton) {
        
        let currentTemp = auxFormatter.string(from: NSNumber(value: temp))!
        if (!operating && currentTemp.count >= kMaxLength) {
        return
    }
        
        ResultLabel.text = ResultLabel.text! + kDecimalSeparator
        Decimal = true
        
        selectVisualOperation()
        
        sender.shine()
    }
    
    @IBAction func NumberAction(_ sender: UIButton) {
                
        OperatorAC.setTitle("C", for: .normal)
        
        var currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= kMaxLength{
            return
        }
        
        currentTemp = auxFormatter.string(from: NSNumber(value: temp))!
        
        //temos seleção de operação
        
        if operating {
            total = total == 0 ? temp : total
            ResultLabel.text = ""
            currentTemp = ""
            operating = false
        }
        
        // temos selecionado decimais
        if Decimal {
            currentTemp = "\(currentTemp)\(kDecimalSeparator)"
            Decimal = false
            
        }
        let  Number = sender.tag
        temp = Double(currentTemp + String(Number))!
        ResultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        
        sender.shine()
    }
    
    //limpa os valores
    
    private func clear() {
            if operation == .none {
                total = 0
            }
            operation = .none
            OperatorAC.setTitle("AC", for: .normal)
            if temp != 0 {
                temp = 0
                ResultLabel.text = "0"
            } else {
                total = 0
                Result()
            }
        }
    //Obtem Resultado final
    
    private func Result(){
        
        switch operation {
        case .none:
            //Não faz nada
            break
        case .addiction:
            total = total + temp
            break
        case .subtraction:
            total = total - temp
            break
        case.multiplication:
            total = total * temp
            break
        case .division:
            total = total / temp
            break
        case .percent:
            total = total / 100
            total = temp
            break
        
        }
        
        //Formatação de tela
        
        if let currentTotal = auxTotalFormatter.string(from: NSNumber(value:total)), currentTotal.count > kMaxLength {
            ResultLabel.text = printScientificFormatter.string(from: NSNumber(value:total))
        }else {
            ResultLabel.text = printFormatter.string(from: NSNumber(value: total))
        }
              
        operation = .none
        selectVisualOperation()
        UserDefaults.standard.set(total, forKey: kTotal)
        print("TOTAL: \(total)")
        
    }
    private func selectVisualOperation() {
           
           if !operating {
               // No estamos operando
               OperatorAddition.selectOperation(false)
               OperatorSubtraction.selectOperation(false)
               OperatorMultiplication.selectOperation(false)
               OperatorDivision.selectOperation(false)
           } else {
               switch operation {
               case .none, .percent:
                   OperatorAddition.selectOperation(false)
                   OperatorSubtraction.selectOperation(false)
                   OperatorMultiplication.selectOperation(false)
                   OperatorDivision.selectOperation(false)
                   break
               case .addiction:
                   OperatorAddition.selectOperation(true)
                   OperatorSubtraction.selectOperation(false)
                   OperatorMultiplication.selectOperation(false)
                   OperatorDivision.selectOperation(false)
                   break
               case .subtraction:
                   OperatorAddition.selectOperation(false)
                   OperatorSubtraction.selectOperation(true)
                   OperatorMultiplication.selectOperation(false)
                   OperatorDivision.selectOperation(false)
                   break
               case .multiplication:
                   OperatorAddition.selectOperation(false)
                   OperatorSubtraction.selectOperation(false)
                   OperatorMultiplication.selectOperation(true)
                   OperatorDivision.selectOperation(false)
                   break
               case .division:
                   OperatorAddition.selectOperation(false)
                   OperatorSubtraction.selectOperation(false)
                   OperatorMultiplication.selectOperation(false)
                   OperatorDivision.selectOperation(true)
                   break
               }
           }
       }
    
    }
    

