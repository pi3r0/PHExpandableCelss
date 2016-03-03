//
//  PHECellTestV.swift
//  ExpandableCells
//
//  Created by Pierre Houguet on 02/03/2016.
//  Copyright © 2016 Pierre Houguet. All rights reserved.
//

import UIKit

class PHECellTestV: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var _aLabel : UILabel!;
    
    
    override init(frame: CGRect) {
        
        _aLabel = UILabel(frame: CGRect(x: 0, y: (frame.height - 20)/2, width: frame.width, height: 20));
        _aLabel.textAlignment = .Center;

        
        super.init(frame: frame);
        
        addSubview(_aLabel);
        autoresizesSubviews = true;
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews();
        
        _aLabel.frame = CGRect(x: 0, y: (frame.height - 20)/2, width: frame.width, height: 20);
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBackgroundColor(backgroundColor : UIColor, forIndex index : NSInteger) {
        
        self.backgroundColor = backgroundColor;
        
        _aLabel.text = "Cell at index \(index)";
    }
    
    
    
    

}
