//
//  DetailsVC.swift
//  Pollut
//
//  Created by Bhagat Singh on 4/23/17.
//  Copyright © 2017 com.bhagat_singh. All rights reserved.
//

import UIKit
import Alamofire

class DetailsVC: UIViewController {

    @IBOutlet weak var kmLabel: UILabel!
    @IBOutlet weak var carbonMultiplier: UILabel!
    @IBOutlet weak var answer: UILabel!
    
    var totalDistance : String = ""
    var carbonFootprintMultiple : String = ""
    var carbonFootprint : String = ""
    var amountMultiplier : String = ""
    var amount : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    
    }
    
    func setData(){
        Alamofire.request("http://akshaybaweja.com/iitd-hack.php?request=get", method: .get).responseJSON { (response) in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String,AnyObject>{
                if let td = dict["total_distance"] as? String{
                    self.totalDistance = td
                    self.kmLabel.text = td
                    print(self.totalDistance)
                }
                
                if let cfm = dict["carbon_footprint_multiple"] as? String{
                    self.carbonFootprintMultiple = cfm
                    self.carbonMultiplier.text = "\(self.totalDistance) * \(cfm)"
                    print(self.carbonFootprintMultiple)
                }
                
                if let cf = dict["carbon_footprint"] as? String{
                    self.carbonFootprint = cf
                    self.carbonMultiplier.text = cf
                    print(self.carbonFootprint)
                }
                
                if let am = dict["amount_multiplier"] as? String{
                    self.amountMultiplier = am
                    
                    print(self.amountMultiplier)
                }
                
                if let a = dict["amount"] as? String{
                    self.amount = a
                    self.answer.text = "₹\(a)"
                    print(self.amount)
                }
            
            }
            
        }
        
        
        
        carbonMultiplier.text = carbonFootprint
        
        answer.text = amount
        
        
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        
        let defaultText = "I just offset my CO2 emissions by \(amount) rupees by donationg to CarbonFund.org!. Check out Pollut at pollut.akshaybaweja.com/"
        let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
    

}
