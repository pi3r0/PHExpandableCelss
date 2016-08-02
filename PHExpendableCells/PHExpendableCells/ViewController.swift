//
//  ViewController.swift
//  PHExpendableCells
//
//  Created by Pierre Houguet on 03/03/2016.
//  Copyright © 2016 Pierre Houguet. All rights reserved.
//

import UIKit

class ViewController: UIViewController , PHEScrollViewDatasource, PHEScrollViewDelegate {
    
    
    @IBOutlet var _expendableSV : PHEScrollView!;
    
    
    var numberOfRow : NSInteger = 10;
    
    
    let params : [String : AnyObject] = [
                                         "expandAll" : true,
                                         "horizontalScroll" : false,
                                         "pagingEnabled" : true
                                        ];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        _expendableSV.delegate = self;
        _expendableSV.datasource = self;
     
        //Customization - way 1
        
//        _expendableSV.pagingEnabled = false;
//        _expendableSV.expandAll = false;
//        _expendableSV.hideScrollIndicator = false;
//        _expendableSV.horizontalScroll = true;
        
        //Customization - way 2
        _expendableSV.setParams(params);
        
        
        //Start
        _expendableSV.reloadData();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: DataSource
    
    func numberOfRow(scrollView: PHEScrollView) -> NSInteger {
        
        return numberOfRow;
    }
    
    // MARK: Delegate
    
    func maxheightForCell(scrollView: PHEScrollView) -> CGFloat {
        return view.frame.height*3/4;
    }
    
    func minheightForCell(scrollView: PHEScrollView) -> CGFloat {
        return 100;
    }
    
    
    func expandableScrollView(scrollView: PHEScrollView, cellForRowAtIndex index : NSInteger) -> UIView {
        
        
        let aView : PHECellTestV = PHECellTestV(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100), andHeight: view.frame.height*3/4);
        aView.setImageIndex(index);
        
        return aView;
        
        
    }
    
    // MARK: Event
    
    func expandableScrollView(scrollView: PHEScrollView, didSelectRowAtIndex index: NSInteger) {
        
        
        NSLog("User did select this one at index %d", index);
    }

}

