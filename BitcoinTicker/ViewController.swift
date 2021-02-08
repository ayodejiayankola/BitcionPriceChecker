//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // https://bitcoinaverage.com/en/bitcoin-price/btc-to-usd
    
    
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["NGN","AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let currencySignArray = ["₦","$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    
    
    
    var currencyPicked = ""
    
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
       
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        return currencyArray.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row:Int, forComponent: Int) -> String? {
        return currencyArray[row]
     
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(currencyArray[row])
        finalURL = baseURL + currencyArray[row]
        print(finalURL)
        currencyPicked = currencySignArray[row]
        getBitcoinPriceData(url: finalURL)
    }
    
  
    
   
    
//
    //MARK: - Networking
    /***************************************************************/

    func getBitcoinPriceData(url: String) {

        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the bitcoin price data")
                    let priceJSON : JSON = JSON(response.result.value!)

                    self.updateBitcoinPriceData(json: priceJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }





    //MARK: - JSON Parsing
    /***************************************************************/

    func updateBitcoinPriceData(json : JSON) {

        if let bitcoinResult = json["ask"].double {

        bitcoinPriceLabel.text = currencyPicked +
            String(bitcoinResult)
        } else {
        return bitcoinPriceLabel.text = "Price unavailable"

    }

    }




}

