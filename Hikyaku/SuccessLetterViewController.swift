//
//  SuccessLetterViewController.swift
//  Hikyaku
//
//  Created by 岡山将也 on 2017/12/27.
//  Copyright © 2017年 shouya.okayama. All rights reserved.
//

import UIKit

class SuccessLetterViewController: UIViewController {

    @IBOutlet weak var atesakiLabel: UILabel!
    @IBAction func homeButton(_ sender: Any) {
        let nextView = storyboard?.instantiateViewController(withIdentifier: "Slide")
        present(nextView!, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
