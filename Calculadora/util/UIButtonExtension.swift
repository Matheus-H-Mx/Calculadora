//
//  UIButtonExtension.swift
//  Calculadora
//
//  Created by Matheus Henrique on 06/05/21.
//

import UIKit

private let orange = UIColor(red: 254/255, green: 148/255, blue: 0/255, alpha: 1)

extension UIButton {
    
    // Borda redondo
    
        func round() {
            layer.cornerRadius = bounds.height / 2
            clipsToBounds = true
        }
    
    // Brilha
    
        func shine() {
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 0.5
            }) { (completion) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.alpha = 1
                })
            }
              
        }
    
    // Apariencia selecão botao de operacão
    
        func selectOperation(_ selected: Bool) {
            backgroundColor = selected ? .white : orange
            setTitleColor(selected ? orange : .white, for: .normal)
        }

    }
   

