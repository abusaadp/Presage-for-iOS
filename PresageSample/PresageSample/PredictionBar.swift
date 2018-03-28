//
//  PredictionBar.swift
//  PresageSample
//
//  Created by Abu Saad Papa on 27/03/18.
//  Copyright © 2018 Abu Saad Papa. All rights reserved.
//

import Foundation
import UIKit

protocol PredictionBarDelegate:class{
    func predictionBar(predictionBar:PredictionBar, didSelectPrediction:String)

}

class PredictionBar : UIView {
    var _predictions: NSArray = []
    var _predictionLabels:NSMutableArray = []
    weak var delegate: PredictionBarDelegate?
    
    override init( frame: CGRect)
    {
        super.init(frame: frame)
        
        let screenRect = UIScreen.main.bounds
        
        self.frame.size.height = 40
        self.frame.size.width = screenRect.size.width + 2
        self.frame.origin.x = -1
        self.frame.origin.y = screenRect.size.height

        
        let gradient:CAGradientLayer = CAGradientLayer.init()
        gradient.frame = self.bounds;
            
        let gradColour1:UIColor = UIColor.init(red: 241.0/255.0, green: 241.0/255.0, blue: 243.0/255, alpha: 1.0)
        let gradColour2:UIColor = UIColor.init(red: 223.0/255.0, green: 223.0/255.0, blue: 231.0/255, alpha: 1.0)
        gradient.colors = [gradColour1, gradColour2]
        
        let borderColour:UIColor = UIColor.init(red: 173.0/255.0, green: 173.0/255.0, blue: 171.0/255, alpha: 0.8)
        self.layer.borderColor = borderColour.cgColor
        self.layer.borderWidth = 1.0
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPredictions(predictions: NSArray )  {
        _predictions = predictions

        var i = 0
        for prediction in _predictions {
            var label:UILabel
            var previousLabel:UILabel
           
            if _predictionLabels.count > i {
                label = _predictionLabels.object(at:i) as! UILabel
            } else {
                label = UILabel()
                label.backgroundColor = UIColor.clear
                label.font = UIFont.systemFont(ofSize: 20)
                label.layer.borderColor = UIColor.init(red: 173.0/255.0, green: 173.0/255.0, blue: 171.0/255, alpha: 0.9).cgColor
                label.layer.borderWidth = 1.0
                label.textAlignment = NSTextAlignment.center
                label.isUserInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
                label.addGestureRecognizer(tapGesture)
                _predictionLabels.add(label)
            }

            self.addSubview(label)
            label.text = (prediction as? String)
            label.sizeToFit()

            var frame:CGRect  = label.frame;
            if(_predictionLabels.count > i - 1 && i - 1 >= 0){
                previousLabel = _predictionLabels.object(at:i-1) as! UILabel
                let previousFrame:CGRect  = previousLabel.frame;
                frame.origin.x = previousFrame.origin.x + previousFrame.size.width;

                if(frame.origin.x + frame.size.width > self.frame.size.width){
                    //don't draw predictions off the screen
                    label.removeFromSuperview()
                }
            }else {
                frame.origin.x = 0;
            }

            frame.size.height = 40;
            frame.size.width += 20;
            frame.origin.x -= 1;
            label.frame = frame;
            i = i+1
        }
    
        if (i < _predictionLabels.count) {
            for _ in (i..<_predictionLabels.count) {
                let label:UILabel = self._predictionLabels.object(at: i) as! UILabel
                label.removeFromSuperview()
                self._predictionLabels.remove(label)
            }
        }
    }

    @objc func handleTap(sender:UITapGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.ended) {
            let loc:CGPoint = sender.location(in: self)
            let label:UILabel = self.hitTest(loc, with: nil) as! UILabel
            print("Prediction tapped: ", label.text ?? "");

            delegate?.predictionBar(predictionBar: self, didSelectPrediction: label.text!)
        }
    }
}
