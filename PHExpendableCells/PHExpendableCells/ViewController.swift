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
    
    
    var colors : Array<UIColor> = [UIColor.greenColor(), UIColor.redColor(), UIColor.blueColor(), UIColor.purpleColor(), UIColor.yellowColor(), UIColor.orangeColor(), UIColor.whiteColor(), UIColor.brownColor(),UIColor.greenColor(), UIColor.redColor(), UIColor.blueColor() ];
    var numberOfRow : NSInteger = 10;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        _expendableSV.delegate = self;
        _expendableSV.datasource = self;
        
        //Customization
        _expendableSV.hideScrollIndicator = true;
//        _expendableSV.horizantalScroll = true;
        
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
        return view.frame.width - 100;
    }
    
    func minheightForCell(scrollView: PHEScrollView) -> CGFloat {
        return 100;
    }
    
    
    func expandableScrollView(scrollView: PHEScrollView, cellForRowAtIndex index : NSInteger) -> UIView {
        
        
        let aView : PHECellTestV = PHECellTestV(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100));
        aView.setBackgroundColor(colors[index], forIndex: index);
        
        return aView;
        
        
    }
    
    // MARK: Event
    
    func expandableScrollView(scrollView: PHEScrollView, didSelectRowAtIndex index: NSInteger) {
        
        
        NSLog("User did select this one at index %d", index);
    }

}

