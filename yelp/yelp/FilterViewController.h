//
//  FilterViewController.h
//  yelp
//
//  Created by sindhuja sridharan on 9/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterViewControllerDelegate <NSObject>

-(void)searchForFilters:(NSMutableDictionary *)data;

@end

@interface FilterViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) id<FilterViewControllerDelegate> delegate;

@end
