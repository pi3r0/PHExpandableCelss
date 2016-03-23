//
//  PHExpendableSV.swift
//  ExpandableCells
//
//  Created by Pierre Houguet on 02/03/2016.
//  Copyright © 2016 Pierre Houguet. All rights reserved.
//

import UIKit


protocol PHEScrollViewDatasource {
    
    /**
     * func numberOfRow(scrollView)
     * get the number of cells you want to display.
     * @Param : scrollView : PHEScrollView, the scrollView asking
     * @Return : NSInteger, the number of cells choosen
     */
    func numberOfRow(scrollView : PHEScrollView) -> NSInteger;
    
}

@objc protocol PHEScrollViewDelegate {
    
    /**
     * func maxheightForCell(scrollView)
     * get the max height for the expanded cell you want.
     * @Param : scrollView : PHEScrollView, the scrollView asking
     * @Return : CGFloat, the max height choseen
     */
    func maxheightForCell(scrollView : PHEScrollView) -> CGFloat;
    
    /**
     * func minheightForCell(scrollView)
     * get the min height for the expanded cell you want.
     * @Param : scrollView : PHEScrollView, the scrollView asking
     * @Return : CGFloat, the min height choseen
     */
    func minheightForCell(scrollView : PHEScrollView) -> CGFloat;
    
    /**
     * func expandableScrollView(scrollView, cellForRowAtIndex index)
     * get the view you want to display at this index.
     * @Param : scrollView : PHEScrollView, the scrollView asking
     * @Return : UIView, the view you want to display
     */
    func expandableScrollView(scrollView : PHEScrollView, cellForRowAtIndex index : NSInteger) -> UIView;
    
    
    // MARK: Events
    
    /**
    * func expandableScrollView(scrollView, didSelectRowAtIndex index)
    * catch the event when user touch a cell and prevent the delegate.
    * @Param : scrollView : PHEScrollView, the scrollView asking
    * @Param : index : NSInteger, the cell tag touched
    */
    optional func expandableScrollView(scrollView : PHEScrollView, didSelectRowAtIndex index : NSInteger);


}




class PHEScrollView: UIView, UIScrollViewDelegate {

   
    var _scrollView : UIScrollView;

    
    var delegate   : PHEScrollViewDelegate?;
    
    var datasource : PHEScrollViewDatasource?;
    
    
    var _cells : Array<UIView> = [];
    var _currentIndex : NSInteger = 0;
    
    
    var _minHeight :  CGFloat {
        
        get {
            if (delegate != nil) {
                
                return delegate!.minheightForCell(self);
            } else {
                return 0.0;
            }
        }
    }
    
    var _maxHeigth : CGFloat {
        
        get {
            
            if (delegate != nil) {
            
                return delegate!.maxheightForCell(self);
            } else {
                return 0.0;
            }
            
            
        }
    }
    

    var difference : CGFloat {
        
        get {
            
            let value = _maxHeigth - _minHeight;
            
            if (value < 0) {
                NSLog("Difference must be positive, please check your Max and Min values");
                
            }
            
            return value;
            
        }
    }
    

    var _numberOfRow : NSInteger {
        
        get {
            
            if (datasource != nil) {
                
                return datasource!.numberOfRow(self);
            } else {
                return 0;
            }
            
            
        }
    }
    
    var _lastIndex : NSInteger = 0;
    
    var _expandAll : Bool = false;
    var _hideScrollIndicator : Bool = false;
    var _horizantalScroll : Bool = false;
    
    
    
    // MARK: Customization
    
    /**
    * expandAll : Bool
    * Normally all cells can't be expand because the content offset is not too big, by default the library calculate the last
    * cell which can be expanded. If you don't want that behaviour, set this variable to true and the library add necessary
    * offset to expend all cells.
    **/
    var expandAll : Bool {
        
        get {
            return _expandAll;
            
        }
        
        set {
            _expandAll = newValue;
        }
    }
    
    
    
    /**
    * hideScrollIndicator : Bool
    * By default the Vertical Scroll Indicator is visible, if you want to hide this, just set the
    * var to true.
    **/
    var hideScrollIndicator : Bool {
        
        get {
            
            return _hideScrollIndicator;
        }
        
        
        set {
            
            _hideScrollIndicator = newValue;
            _scrollView.showsHorizontalScrollIndicator = !_hideScrollIndicator;
            _scrollView.showsVerticalScrollIndicator = !_hideScrollIndicator;
        }
    }
    
    
    /**
     * horizantalScroll : Bool
     * By default the scroll axe is vertical, you can change by set the var `hideScrollIndicator` to true.
     **/
    var horizantalScroll : Bool {
        
        get {
            
            return _horizantalScroll;
        }
        
        
        set {
            
            _horizantalScroll = newValue;
        }
    }
    
    
    // MARK: Init

    required init?(coder aDecoder: NSCoder) {
        
        _scrollView = UIScrollView(coder: aDecoder)!;
        _scrollView.backgroundColor = UIColor.clearColor();
    
        
        super.init(coder: aDecoder);
        
        _scrollView.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height);
        _scrollView.delegate = self;
        addSubview(_scrollView);
        clipsToBounds = true;
    }
    
    
    override init(frame: CGRect) {
        
        
        _scrollView = UIScrollView(frame: CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height));
        _scrollView.backgroundColor = UIColor.clearColor();

        
        
        
        super.init(frame: frame);
        
        
        addSubview(_scrollView);
        _scrollView.delegate = self;
    
    }
    
   
    
    func reloadData() {
    
        var total : CGFloat = 0.0;
        
        
        _cells  = [];
        
        for (var i : NSInteger = 0; i < _numberOfRow; i++) {
            
            let aView : UIView = delegate!.expandableScrollView(self, cellForRowAtIndex: i);
            aView.tag = i;
            
            var cellHeight : CGFloat = _maxHeigth;
            if (i > 0) {
                cellHeight = _minHeight;
            }
            
            var originX : CGFloat = 0.0;
            var originY : CGFloat = total;
            var width : CGFloat = frame.width;
            var height : CGFloat = cellHeight;

            
            if (_horizantalScroll) {
                
                originX = total;
                originY = 0.0;
                width = cellHeight;
                height = frame.height;

            }
            
            aView.frame = CGRect(x: originX, y: originY, width: width, height: height);
            
            
            let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didSelectRowAtIndex:");
            aView.addGestureRecognizer(tapGesture);
            
            
            total += cellHeight;
            _cells.append(aView);
            _scrollView.addSubview(aView);
            
        }
        
        var space : CGFloat = frame.height;
        
        if (_horizantalScroll) {
            space = frame.width
        }
        
        if (_expandAll) {
           
            
            total = total + space - _maxHeigth;
            _lastIndex = _cells.count;
        } else {
            
            _lastIndex =  NSInteger((total - space) / _minHeight) + 1;
        }
        
        
        if (_horizantalScroll) {
            _scrollView.contentSize.width = total;
        } else {
            _scrollView.contentSize.height = total;
        }
        
        
        difference;
    }
    
    
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
        var offset : CGFloat = scrollView.contentOffset.y;
        if (_horizantalScroll) {
            offset = scrollView.contentOffset.x;
        }
        
        redrawSubviews(offset);       
        
    }
    
    func redrawSubviews(offset : CGFloat) {
        
        
        let index : NSInteger = currentIndex(offset);
        
        let realOffset : CGFloat = offset - CGFloat(index)*_minHeight;
        
        
        let factor : CGFloat = realOffset/_minHeight;
        
        var height = _minHeight;
        var originY : CGFloat = 0.0;
        var i : NSInteger = 0;
        
        for aCell in _cells {
        
            height = _minHeight;
            
            if (i == index) {
                
                //                (aCell as! PHECellTestV).fadeIn(false);
                height =   _maxHeigth - difference*factor;
                
            } else if (i == index + 1 ) {
                //                    (aCell as! PHECellTestV).fadeIn(true);
                
                height = _minHeight + difference*factor
                
                
            }

            if (!_horizantalScroll) {
                  aCell.frame = CGRect(x: 0.0, y: originY, width: frame.width, height: height);
            } else {
                  aCell.frame = CGRect(x: originY, y: 0.0, width: height, height: frame.height);
            }
          
            originY += height;
             i++;
            
        }
    }
    
    
    // MARK: Event
    
    func didSelectRowAtIndex(tapGesture : UITapGestureRecognizer) {
        
        let view = tapGesture.view;
        
        let index = view!.tag;
    
        var startY : CGFloat =  CGFloat(index)*_minHeight;
        if (index > _lastIndex - 1) {
            
             startY =  CGFloat(_lastIndex - 1)*_minHeight;
        }
        
        if (!_horizantalScroll) {
            _scrollView.setContentOffset(CGPoint(x: 0.0, y: startY), animated: true);
        } else {
            _scrollView.setContentOffset(CGPoint(x: startY, y: 0.0), animated: true);
        }
        
        if (delegate != nil && delegate!.expandableScrollView?(self, didSelectRowAtIndex: index) != nil) {
            
            delegate!.expandableScrollView!(self, didSelectRowAtIndex: index);
        }
    }
    
    // MARK: Tools

    func currentIndex(offset : CGFloat) -> NSInteger {
        
        let index : NSInteger = NSInteger(offset/_minHeight);
        
        return index;
    }

    
   
}
