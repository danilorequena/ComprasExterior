//
//  ViewController.swift
//  ComprasExterior
//
//  Created by Danilo Requena on 11/04/20.
//  Copyright © 2020 Danilo Requena. All rights reserved.
//

import UIKit
import CurrencyTextField

class ViewController: UIViewController {

    var currencysViewModel: CurrencyViewModel?
    var amt: Int = 0
    lazy var  numberFormatter: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.currencySymbol = ""
        formatter.numberStyle = .currency
        return formatter
    }()
    
    //view currencys fixed
    @IBOutlet weak var viewCurrencys: UIView!
    @IBOutlet weak var lbDollar: UILabel!
    @IBOutlet weak var lbEuro: UILabel!
    @IBOutlet weak var lbPounds: UILabel!
    
    @IBOutlet weak var lbCurrencyOut: UILabel!
//    @IBOutlet weak var tfCurrencyOut: CurrencyTextField!
    @IBOutlet weak var tfCurrency: UITextField!
    @IBOutlet weak var lbCurrencyIn: UILabel!
    @IBOutlet weak var lbUSD: UILabel!
    @IBOutlet weak var lbEUR: UILabel!
    @IBOutlet weak var lbGBP: UILabel!
    @IBOutlet weak var lbResultUSD: UILabel!
    @IBOutlet weak var lbResultEUR: UILabel!
    @IBOutlet weak var lbResultGBP: UILabel!
    
    @IBOutlet weak var ivFlagOut: UIImageView!
    @IBOutlet weak var ivFlagIn: UIImageView!
    
    @IBOutlet weak var viewUSDtoBRL: UIView!
    @IBOutlet weak var viewEURtoBRL: UIView!
    @IBOutlet weak var viewGBPtoBRL: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        lbResultUSD.text = " "
        lbResultEUR.text = " "
        lbResultGBP.text = " "
        
        viewUSDtoBRL.isHidden = true
        viewEURtoBRL.isHidden = true
        viewGBPtoBRL.isHidden = true
        
        fetchData()
        
        tfCurrency.delegate = self
    }
    
    

    @IBAction func Calculate(_ sender: UIButton) {
        calculate()
    }
    
    func setupViews() {
        viewCurrencys.layer.cornerRadius = 10
        viewUSDtoBRL.layer.cornerRadius = 10
        viewEURtoBRL.layer.cornerRadius = 10
        viewGBPtoBRL.layer.cornerRadius = 10
    }
    
    func fetchData() {
        Service.loadCurrencys(onComplete: { (currency) in
            self.currencysViewModel = currency.flatMap({return CurrencyViewModel(currency: $0)})
            guard let currencyViewModel = self.currencysViewModel else { return }
            DispatchQueue.main.async {
                self.lbDollar.text = currencyViewModel.currency.usd.code + " " + currencyViewModel.currency.usd.ask
                self.lbEuro.text = currencyViewModel.currency.eur.code + " " + currencyViewModel.currency.eur.ask
                self.lbPounds.text = currencyViewModel.currency.gbp.code + " " + currencyViewModel.currency.gbp.ask
                self.lbCurrencyOut.text = currencyViewModel.currency.usd.code
                self.lbCurrencyIn.text = currencyViewModel.currency.usd.codein
                self.ivFlagIn.image = UIImage(named: "brasil")
                self.ivFlagOut.image = UIImage(named: "estados-unidos")
            }
        }) { (err) in
            print(err)
        }
    }
    
    func calculate() {
        viewUSDtoBRL.isHidden = false
        viewEURtoBRL.isHidden = false
        viewGBPtoBRL.isHidden = false
        
        let iof = 1.0638
        let doubleValueUSD: Double = Double(currencysViewModel!.currency.usd.ask) ?? 0.0
        let doubleValueEUR: Double = Double(currencysViewModel!.currency.eur.ask) ?? 0.0
        let doubleValueGBP: Double = Double(currencysViewModel!.currency.gbp.ask) ?? 0.0
        guard let amount = Double(self.tfCurrency.text!) else {return}
        let resultUSD = amount * doubleValueUSD * iof
        let resultEUR = amount * doubleValueEUR * iof
        let resultGBP = amount * doubleValueGBP * iof
        Formatter.currency.locale = .br
        lbUSD.text = "$" + tfCurrency.text!
        lbEUR.text = "€" + tfCurrency.text!
        lbGBP.text = "£" + tfCurrency.text!
        lbResultUSD.text = resultUSD.currency
        lbResultEUR.text = resultEUR.currency
        lbResultGBP.text = resultGBP.currency
    }
    
    func updateTextField() -> Double {
        let number = Double(amt/100) + Double(amt%100) / 100
        return number
    }
    
    
}

extension Locale {
    static let br = Locale(identifier: "pt_BR")
    static let us = Locale(identifier: "en_US")
    static let uk = Locale(identifier: "en_GB")
    static let eu = Locale(identifier: "en_ES") // ISO Locale
}

extension NumberFormatter {
    convenience init(style: Style, locale: Locale = .current) {
        self.init()
        self.locale = locale
        numberStyle = style
    }
}

extension Formatter {
    static let currency = NumberFormatter(style: .currency)
    static let currencyUS = NumberFormatter(style: .currency, locale: .us)
    static let currencyBR = NumberFormatter(style: .currency, locale: .br)
    static let currencyEU = NumberFormatter(style: .currency, locale: .eu)
    static let currencyGB = NumberFormatter(style: .currency, locale: .uk)
}

extension Numeric {
    var currency: String { Formatter.currency.string(for: self) ?? "" }
    var currencyUS: String { Formatter.currencyUS.string(for: self) ?? "" }
    var currencyBR: String { Formatter.currencyBR.string(for: self) ?? "" }
    var currencyGB: String { Formatter.currencyGB.string(for: self) ?? "" }
    var currencyEU: String { Formatter.currencyEU.string(for: self) ?? "" }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let digit = Int(string) {
            amt = amt * 10 + digit
            tfCurrency.text = String(updateTextField())
        }
        if string == "" {
            amt = amt/10

            tfCurrency.text = String(updateTextField())
        }
        return false
    }
}

