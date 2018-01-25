//
//  LatestTestVC.h
//  WordBucket
//
//  Created by Mehak Bhutani on 12/26/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LatestTestVC : UIViewController
{
    NSMutableArray *arrTest,*arrTestBucketImg,*arrTestValue;
    
}
@property(nonatomic, strong) IBOutlet UITableView *tbTest;
@property(nonatomic, strong) NSMutableArray *arrLatest;
@end
