//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
 
    var coinManager = CoinManager()

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ViewController class as the datasource to the currencyPicker object.
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        coinManager.delegate = self
        // Do any additional setup after loading the view.
    }
    
}

extension ViewController: UIPickerViewDelegate {
    //This method expects a String as an output. The String is the title for a given row. When the PickerView is loading up, it will ask its delegate for a row title and call the above method once for every row. So when it is trying to get the title for the first row, it will pass in a row value of 0 and a component (column) value of 0.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        coinManager.currencyArray[row]
    }
    //This will get called every time when the user scrolls the picker. When that happens it will record the row number that was selected.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}
extension ViewController: UIPickerViewDataSource {
    //How many columns we want in our picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}
extension ViewController: CoinManagerDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdatePrice(_ coinManager: CoinManager, coinPrice: CoinPriceModel) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(format: "%.2f", coinPrice.price)
            self.currencyLabel.text = coinPrice.currencyName
        }
    }
}
