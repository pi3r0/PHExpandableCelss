//
//  PHExpendableSV.swift
//  ExpandableCells
//
//  Created by Pierre Houguet on 02/03/2016.
//  Copyright © 2016 Pierre Houguet. All rights reserved.
//

import UIKit


protocol PHEScrollViewDatasource {
    func numberOfRow(scrollView : PHEScrollView) -> NSInteger;
    
}

@objc protocol PHEScrollViewDelegate {
    func maxheightForCell(scrollView : PHEScrollView) -> CGFloat;
    func minheightForCell(scrollView : PHEScrollView) -> CGFloat;
    func expandableScrollView(scrollView : PHEScrollView, cellForRowAtIndex index : NSInteger) -> UIView;
    
    
    optional func expandAll(scrollView : PHEScrollView) -> Bool;
    optional func hideVerticalScrollIndicator(scrollView : PHEScrollView) -> Bool;
    optional func hideHorizontalBar(scrollView : PHEScrollView) -> Bool;
    optional func enabledPaging(scrollView : PHEScrollView) -> Bool;

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
    
    var _enabledPaging : Bool {
        
        get {
            
            if (delegate != nil && delegate!.enabledPaging?(self) != nil) {
                
                return delegate!.enabledPaging!(self);
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
    
    func buildSV() {
    
        var total : CGFloat = 0.0;
        
        
        _scrollView.showsVerticalScrollIndicator = !_hideScrollIndicator;
            
        
        
        _cells  = [];
        
        for (var i : NSInteger = 0; i < _numberOfRow; i++) {
            
            let aView : UIView = delegate!.expandableScrollView(self, cellForRowAtIndex: i);
            
            var cellHeight : CGFloat = _maxHeigth;
            if (i > 0) {
                cellHeight = _minHeight;
            }
            
            aView.frame = CGRect(x: 0.0, y: total, width: frame.width, height: cellHeight);

            total += cellHeight;
            _cells.append(aView);
            _scrollView.addSubview(aView);
            
        }
        
        
        if (_expandAll) {
            total = total + frame.height - _maxHeigth;
            _lastIndex = _cells.count;
        } else {
            
            _lastIndex = NSInteger((frame.height - _maxHeigth) / _minHeight);
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
            
//            for (var i = 0; i < _cells.count; i++) {
//                
//                if (i == index) {
//                
//                    let startY : CGFloat =  CGFloat(index)*_minHeight;
//                    
//                    if factor < 1.0 && factor > 0 {
//                        prevCell.frame = CGRect(x: 0.0, y: startY, width: frame.width, height: _maxHeigth - difference*factor);
//                        
//                        
//                    }
//                } else if (i == index + 1) {
//                    
//                    let startY : CGFloat =  CGFloat(index)*_minHeight;
//                    if factor < 1.0 && factor > 0 {
//                       
//                        cell.frame = CGRect(x: 0.0, y: _maxHeigth + startY - difference*(factor), width: frame.width, height:  _minHeight + difference*factor);
//                        
//                    } else {
//                        
//                        var startY : CGFloat =  CGFloat(i - 1)*_minHeight;
//                        if (i > index) {
//                            startY += _maxHeigth;
//                        }
//                        
//                        let cell = _cells[i];
//                        
//                        cell.frame = CGRect(x: 0.0, y: startY, width: frame.width, height:  _minHeight);
//                    }
//                }
//                
//            }
        
            if factor < 1.0 && factor > 0 {
                prevCell.frame = CGRect(x: 0.0, y: startY, width: frame.width, height: _maxHeigth - difference*factor);
                cell.frame = CGRect(x: 0.0, y: _maxHeigth + startY - difference*(factor), width: frame.width, height:  _minHeight + difference*factor);
            
            }
            
            
        
        }
        
       
        
    }
    
    func currentIndex(offset : CGFloat) -> NSInteger {
        
        let index : NSInteger = NSInteger(offset/_minHeight);

        return index;
    }
    
    func currentRatio(offset : CGFloat) -> CGFloat {
        
        let index  = offset/_minHeight;        return index;
    }
    
    
    func redaptCellsForOffset(offset : CGFloat, andIndex index : NSInteger) {
        
    
        
        if (index >= 0 && index < _lastIndex - 1) {
            
            let realOffset : CGFloat = offset - CGFloat(index)*_minHeight;
            
            let prevCell : UIView = _cells[index];
            
            
            let cell : UIView = _cells[index + 1];
            
            let factor : CGFloat = realOffset/_minHeight;
            
            let startY : CGFloat =  CGFloat(index)*_minHeight;
            
            for (var i = 0; i < _cells.count; i++) {
                
                if (i == index) {
                    
                    let startY : CGFloat =  CGFloat(index)*_minHeight;
                    
                    if factor < 1.0 && factor > 0 {
                        prevCell.frame = CGRect(x: 0.0, y: startY, width: frame.width, height: _minHeight);
                        
                        
                    }
                } else if (i == index + 1) {
                    
                    let startY : CGFloat =  CGFloat(index)*_minHeight;
                    if factor < 1.0 && factor > 0 {
                        
                        cell.frame = CGRect(x: 0.0, y: _maxHeigth + startY, width: frame.width, height:  _maxHeigth);
                        
                    } else {
                        
                        var startY : CGFloat =  CGFloat(i - 1)*_minHeight;
                        if (i > index) {
                            startY += _maxHeigth;
                        }
                        
                        let cell = _cells[i];
                        
                        cell.frame = CGRect(x: 0.0, y: startY, width: frame.width, height:  _minHeight);
                    }
                }
                
            }

        
        }
    }
    
    
    
//    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        
//        
//        if (_enabledPaging) {
//            
//            
//            let offset = scrollView.contentOffset.y;
//            var index : NSInteger = currentIndex(offset);
//            let ratio  : CGFloat = currentRatio(offset);
//            
//            
//            if (index >= 0 && index < _lastIndex - 1) {
//                
//                NSLog("ration = %f", ratio);
//                NSLog("index = %d", index);
//                
//                
//                if ratio > (CGFloat(index) + 0.5) {
//                    index++;
//                    
//                }
//                
//                
//                let startY : CGFloat =  CGFloat(index)*_minHeight;
//                
//                //            UIView.animateWithDuration(0.2, delay: 0.0, options: .AllowUserInteraction, animations: { () -> Void in
//                //
//                //                self._scrollView.contentOffset.y = startY;
//                //
//                //                }, completion: { (finish) -> Void in
//                //
//                //            })
//                scrollView.setContentOffset(CGPoint(x: 0, y: startY), animated: true);
//            }
//            
//            
//            
//        }
//        
//    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
//        if (_enabledPaging) {
//            
//            
//            let offset = scrollView.contentOffset.y;
//            var index : NSInteger = currentIndex(offset);
//            let ratio  : CGFloat = currentRatio(offset);
//            
//            
//            if (index >= 0 && index < _lastIndex - 1) {
//                
//                NSLog("ration = %f", ratio);
//                NSLog("index = %d", index);
//                
//                
//                if ratio > (CGFloat(index) + 0.5) {
//                    index++;
//                    
//                }
//                
//                
//                let startY : CGFloat =  CGFloat(index)*_minHeight;
//                
//                UIView.animateWithDuration(0.2, delay: 0.0, options: .AllowUserInteraction, animations: { () -> Void in
//                
//                    self._scrollView.contentOffset.y = startY;
//                    self.redaptCellsForOffset(startY, andIndex: index);
//            
//                    }, completion: { (finish) -> Void in
//                        
//                })
////                scrollView.setContentOffset(CGPoint(x: 0, y: startY), animated: true);
//            }
//            
//           
//
//        }


    }
}
