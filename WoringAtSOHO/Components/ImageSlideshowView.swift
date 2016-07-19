//
//  ImageSlideshowView.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/7/16.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit

class ImageSlideshowView: UIScrollView, UIScrollViewDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    //图片url列表
    var imageUrlList: [NSURL]? = nil
    var pageControl: UIPageControl = UIPageControl()
    
    func initializeVars() {
        delegate = self
        pagingEnabled = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeVars()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        initializeVars()
    }
    
    //代理
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let width = UIScreen.mainScreen().bounds.width
        let offsetX = scrollView.contentOffset.x
        
        if offsetX == 0 {
            scrollView.contentOffset = CGPointMake(width * CGFloat(4), 0)
        }
        if offsetX == width * CGFloat(4 + 1) {
            scrollView.contentOffset = CGPointMake(width, 0)
        }
        
        let currentPage = scrollView.contentOffset.x / width + 0.5
        self.pageControl.currentPage = Int(currentPage)
    }
    
    

}
