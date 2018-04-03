//
//  ViewController.swift
//  PresageSample
//
//  Created by Abu Saad Papa on 26/03/18.
//  Copyright © 2018 Abu Saad Papa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, PredictionBarDelegate {

    @IBOutlet weak var txtField: UITextField!
    var bar:PredictionBar!
    var predictor: ObjCPresageHelper?
    
    override func viewDidLoad() {
        txtField.delegate = self
        bar = PredictionBar.init()
        bar.delegate = self
        self.view.addSubview(bar)
        predictor = ObjCPresageHelper()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var suggestions: NSArray
        suggestions = predictor!.getSuggesstionsForWord(textField.text!+string)! as NSArray
        bar.setPredictions(predictions: suggestions)
        return true;
    }
    
    func shouldAutorotateToInterfaceOrientation(interfaceOrientation: UIInterfaceOrientation) -> Bool
    {
        return (interfaceOrientation == UIInterfaceOrientation.portrait);
    }
    
    
    override func viewWillAppear(_ animated:Bool) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardStateChange),
            name: .UIKeyboardWillHide,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardStateChange),
            name: .UIKeyboardWillShow,
            object: nil)
    }
    
    override func viewWillDisappear(_ animated:Bool)  {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardStateChange(notification: NSNotification) {
        var frameStart:CGRect = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? CGRect)!
        var frameEnd:CGRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect)!
        frameStart = self.view.convert(frameStart, from: self.view.window)
        frameEnd = self.view.convert(frameEnd, from: self.view.window)
        
        UIView.beginAnimations("slide in prediction bar", context:nil)
        var barFrame:CGRect  = bar.frame;
        barFrame.origin.y = frameEnd.origin.y - (frameStart.origin.y < frameEnd.origin.y ? 0 : bar.frame.size.height);
        bar.frame = barFrame;
        UIView.commitAnimations()
    }
    
    func predictionBar(predictionBar: PredictionBar, didSelectPrediction: String) {
        
        if txtField.text?.last == " " {
            txtField.text = txtField.text! + " " + didSelectPrediction + " "
        } else {
            let myStringWithoutLastWord = txtField.text?.components(separatedBy: " ").dropLast().joined(separator: " ")
            txtField.text = myStringWithoutLastWord! + " " + didSelectPrediction + " "
        }
        
        var suggestions: NSArray
        suggestions = predictor!.getSuggesstionsForWord(txtField.text!)! as NSArray
        bar.setPredictions(predictions: suggestions)
    }

}

