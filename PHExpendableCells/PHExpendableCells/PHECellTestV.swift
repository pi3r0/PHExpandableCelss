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
    
    var _anImageV   : UIImageView!;
    var _aLabel     : UILabel!;
    
    var _height : CGFloat = 0;
    
    init(frame: CGRect, andHeight height : CGFloat ) {
        
        _height = height;
        let originY = (frame.height - _height)/2;
        _anImageV = UIImageView(frame: CGRect(x: 0.0, y: originY, width: frame.height, height: _height));
        _anImageV.contentMode = .ScaleAspectFill;
        
        _aLabel = UILabel(frame: CGRect(x: 0, y: (frame.height - 20)/2, width: frame.width, height: 20));
        _aLabel.textAlignment = .Center;

        
        super.init(frame: frame);
        
        addSubview(_anImageV);
        addSubview(_aLabel);
        clipsToBounds = true;
        autoresizesSubviews = true;
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews();
        
        let originY = (frame.height - (_height))/2;
        _anImageV.frame = CGRect(x: 0.0, y: originY, width: frame.width, height: _height);
        
        _aLabel.frame = CGRect(x: 0, y: (frame.height - 20)/2, width: frame.width, height: 20);
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageIndex(index : NSInteger) {
        
        let imageIndex : NSInteger = index%8;
        
        _anImageV.image = UIImage(named: String(imageIndex));
        _aLabel.text = "Cell at index \(index)";
    }
    
    
    
    

}
