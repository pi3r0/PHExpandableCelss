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
    
    // MARK: Customisation
    
    /**
    * func expandAll(scrollView)
    * get if the scrollview must expand all cells or only them on the limits.
    * By default, the scrollview expands only cells on limit.
    * @Param : scrollView : PHEScrollView, the scrollView asking
    * @Return : Bool, true or false.
    */
    optional func expandAll(scrollView : PHEScrollView) -> Bool;
    
    /**
     * func hideVerticalScrollIndicator(scrollView)
     * get if the indicator must be visible or not, by default it's visible.
     * @Param : scrollView : PHEScrollView, the scrollView asking
     * @Return : Bool, true or false is you want to hide/show
     */
    optional func hideVerticalScrollIndicator(scrollView : PHEScrollView) -> Bool;
    
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

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
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
    
    var _expandAll : Bool {
        
        get {
            
            if (delegate != nil && delegate!.expandAll?(self) != nil) {
            
                return delegate!.expandAll!(self);
            } else {
                return false;
            }
            
            
        }
    }
    
    
    var _hideScrollIndicator : Bool {
        
        get {
            
            if (delegate != nil && delegate!.hideVerticalScrollIndicator?(self) != nil) {
                
                return delegate!.hideVerticalScrollIndicator!(self);
            } else {
                return false;
            }
            
            
        }
    }
    

    required init?(coder aDecoder: NSCoder) {
        
        _scrollView = UIScrollView(coder: aDecoder)!;
        _scrollView.backgroundColor = UIColor.clearColor();
    
        
        super.init(coder: aDecoder);
        
        _scrollView.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height);
        _scrollView.delegate = self;
        addSubview(_scrollView);
        
    }
    
    
    override init(frame: CGRect) {
        
        
        _scrollView = UIScrollView(frame: CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height));
        _scrollView.backgroundColor = UIColor.clearColor();

        
        
        
        super.init(frame: frame);
        
        
        addSubview(_scrollView);
        _scrollView.delegate = self;
    
    }
    
    var _lastIndex : NSInteger = 0;
    
    func reloadData() {
    
        var total : CGFloat = 0.0;
        
        
        _scrollView.showsVerticalScrollIndicator = !_hideScrollIndicator;
            
        
        
        _cells  = [];
        
        for (var i : NSInteger = 0; i < _numberOfRow; i++) {
            
            let aView : UIView = delegate!.expandableScrollView(self, cellForRowAtIndex: i);
            aView.tag = i;
            
            var cellHeight : CGFloat = _maxHeigth;
            if (i > 0) {
                cellHeight = _minHeight;
            }
            
            aView.frame = CGRect(x: 0.0, y: total, width: frame.width, height: cellHeight);
            
            
            let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didSelectRowAtIndex:");
            aView.addGestureRecognizer(tapGesture);
            
            
            total += cellHeight;
            _cells.append(aView);
            _scrollView.addSubview(aView);
            
        }
        
        
        if (_expandAll) {
            total = total + frame.height - _maxHeigth;
            _lastIndex = _cells.count;
        } else {
            
            _lastIndex =  NSInteger((total - frame.height) / _minHeight) + 1;
        }
        
        _scrollView.contentSize.height = total;
        
        difference;
    }
    
    
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
        let offset : CGFloat = scrollView.contentOffset.y;
        
        let index : NSInteger = currentIndex(offset);
        
        if (index >= 0 && index < _lastIndex - 1) {
        
            let realOffset : CGFloat = offset - CGFloat(index)*_minHeight;
            
            let prevCell : UIView = _cells[index];
            
            
            let cell : UIView = _cells[index + 1];
            
            let factor : CGFloat = realOffset/_minHeight;
            
            let startY : CGFloat =  CGFloat(index)*_minHeight;
        
        
            if factor < 1.0 && factor > 0 {
                prevCell.frame = CGRect(x: 0.0, y: startY, width: frame.width, height: _maxHeigth - difference*factor);
                cell.frame = CGRect(x: 0.0, y: _maxHeigth + startY - difference*(factor), width: frame.width, height:  _minHeight + difference*factor);
            
            }
            
            
        
        }
        
       
        
    }
    
    
    func didSelectRowAtIndex(tapGesture : UITapGestureRecognizer) {
        
        let view = tapGesture.view;
        
        let index = view!.tag;
    
        var startY : CGFloat =  CGFloat(index)*_minHeight;
        if (index > _lastIndex - 1) {
            
             startY =  CGFloat(_lastIndex - 1)*_minHeight;
        }
        
         _scrollView.setContentOffset(CGPoint(x: 0.0, y: startY), animated: true);
    
       
        
        if (delegate != nil && delegate!.expandableScrollView?(self, didSelectRowAtIndex: index) != nil) {
            
            delegate!.expandableScrollView!(self, didSelectRowAtIndex: index);
        }
    }

    func currentIndex(offset : CGFloat) -> NSInteger {
        
        let index : NSInteger = NSInteger(offset/_minHeight);
        
        return index;
    }

    
   
}
