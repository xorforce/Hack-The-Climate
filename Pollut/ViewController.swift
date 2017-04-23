//
//  ViewController.swift
//  Pollut
//
//  Created by Bhagat Singh on 4/23/17.
//  Copyright © 2017 com.bhagat_singh. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController,PiechartDelegate{

    var total = CGFloat()
    var paid = CGFloat()
    var views: [String: UIView] = [:]
    var amount = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getData {
            self.updateMainUI()
        }
    }
    @IBOutlet weak var currentLabel: UILabel!
    
    func updateMainUI(){
        var error = Piechart.Slice()
        error.value = (total-paid)/total
        print(total)
        print(paid)
        error.color = UIColor.red
        error.text = ""
        
        var zero = Piechart.Slice()
        zero.value = paid/total
        zero.color = UIColor(red: 0/255, green: 172/255, blue: 145/255, alpha: 1.0)
        zero.text = ""
        
        let piechart = Piechart()
        piechart.delegate = self
        piechart.title = "Offset"
        piechart.activeSlice = 1
        piechart.layer.borderWidth = 1
        piechart.slices = [error, zero]
        
        
        piechart.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(piechart)
        views["piechart"] = piechart
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[piechart]-50-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-80-[piechart(==300)]", options: [], metrics: nil, views: views))
        
        currentLabel.text = "Your amount for the current sessions would be ₹\(amount)"
        
    }
    
    func setSubtitle(_ total: CGFloat, slice: Piechart.Slice) -> String {
        return ""
    }
    
    func setInfo(_ total: CGFloat, slice: Piechart.Slice) -> String {
        return ""
    }
    
    func getData(completed: @escaping completed) {
        
        Alamofire.request("http://akshaybaweja.com/iitd-hack.php?request=get", method: .get).responseJSON { (response) in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String,AnyObject>{
                if let te = dict["total_entries"] as? Int{
                    self.total = CGFloat(te)
                    print(self.total)
                }
                
                if let tp = dict["total_paid"] as? Int {
                    self.paid = CGFloat(tp)
                    print(self.paid)
                }
                
                if let a = dict["outstanding_amount"] as? String{
                    self.amount = a
                }
            }
            completed()
        }
    }
    
    @IBAction func donateButtonPressed(_ sender: Any) {
        
        let activityController = UIAlertController(title: "Donate", message: "Proceed to payment??", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Proceed to Pay?", style: .default) { (alert) in
            Alamofire.request("http://akshaybaweja.com/iitd-hack.php?request=pay", method: .get).responseJSON { (response) in
                _ = response.result
                }
            Alamofire.request("http://akshaybaweja.com/iitd-hack.php?request=get", method: .get).responseJSON { (response) in
                let result = response.result
                
                if let dict = result.value as? Dictionary<String,AnyObject>{
                    if let te = dict["total_entries"] as? Int{
                        self.total = CGFloat(te)
                    }
                    
                    if let tp = dict["total_paid"] as? Int {
                        self.paid = CGFloat(tp)
                    }
                }

            }
        
        }
        self.getData {
                self.updateMainUI()
            }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            self.dismiss(animated: true, completion: nil)
        }
        
        activityController.addAction(okAction)
        activityController.addAction(cancelAction)
        present(activityController, animated: true, completion: nil)
    }
    
    
}
