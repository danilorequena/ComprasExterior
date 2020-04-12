//
//  ViewController.swift
//  ComprasExterior
//
//  Created by Danilo Requena on 11/04/20.
//  Copyright © 2020 Danilo Requena. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var currencysViewModel: CurrencyViewModel?
    
    //view currencys fixed
    @IBOutlet weak var viewCurrencys: UIView!
    @IBOutlet weak var lbDollar: UILabel!
    @IBOutlet weak var lbEuro: UILabel!
    @IBOutlet weak var lbPounds: UILabel!
    
    @IBOutlet weak var lbCurrencyOut: UILabel!
    @IBOutlet weak var tfCurrencyOut: UITextField!
    @IBOutlet weak var lbCurrencyIn: UILabel!
    @IBOutlet weak var tfCurrencyIn: UITextField!
    @IBOutlet weak var lbResult: UILabel!
    @IBOutlet weak var ivFlagOut: UIImageView!
    @IBOutlet weak var ivFlagIn: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCurrencys.layer.cornerRadius = 10
        lbResult.text = " "
        fetchData()
    }
    
    

    @IBAction func Calculate(_ sender: UIButton) {
        calculate()
    }
    @IBAction func ChangeCurrency(_ sender: UIButton) {
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
        let iof = 1.0638
        let doubleValue: Double = Double(currencysViewModel!.currency.usd.ask) ?? 0.0
        guard let amount = Double(self.tfCurrencyOut.text!) else {return}
        var result = amount * doubleValue * iof
        Formatter.currency.locale = .br
        lbResult.text = result.currency
    }
    
    
}

extension Locale {
    static let br = Locale(identifier: "pt_BR")
    static let us = Locale(identifier: "en_US")
    static let uk = Locale(identifier: "en_GB") // ISO Locale
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
}

extension Numeric {
    var currency: String { Formatter.currency.string(for: self) ?? "" }
    var currencyUS: String { Formatter.currencyUS.string(for: self) ?? "" }
    var currencyBR: String { Formatter.currencyBR.string(for: self) ?? "" }
}

