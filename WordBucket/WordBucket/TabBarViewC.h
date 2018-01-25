//
//  TabBarViewC.h
//  WordBucket
//
//  Created by ashish on 2/12/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNewWord.h"

@interface TabBarViewC : UIViewController
@property (strong, nonatomic) IBOutlet UITabBarController *tabBar;
@property (strong) AddNewWord *wordNew;
@property (strong) NSMetadataQuery *query;
@property (nonatomic, strong) UITabBarItem *learnBarButton;

- (void)showWordList;


@end
