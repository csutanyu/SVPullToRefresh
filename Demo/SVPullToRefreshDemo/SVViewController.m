//
//  SVViewController.m
//  SVPullToRefreshDemo
//
//  Created by Sam Vermette on 23.04.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "SVViewController.h"
#import "SVPullToRefresh.h"
#import "SVPullToRefreshLoadingView.h"
#import "SVInfiniteScrollingLoadingView.h"
@interface SVViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SVViewController
@synthesize tableView = tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    __weak SVViewController *weakSelf = self;
    
    // setup pull-to-refresh
    
//    self.tableView.backgroundView = [UIColor redColor];
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
    
    NSString *imagePrefx = @"loading_black_";
    NSInteger imageCount = 8;
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:imageCount];
    for (NSInteger index = 1; index <= imageCount; ++index) {
        NSString *imageName = [NSString stringWithFormat:@"%@%02ld", imagePrefx, (long)index];
        [array addObject:[UIImage imageNamed:imageName]];
    }
    SVPullToRefreshLoadingView *loadingView = [[SVPullToRefreshLoadingView alloc] initWithFrame:CGRectZero];
    loadingView.dragingAnimationImages = array;
    
    SVInfiniteScrollingLoadingView *infiniteLoadingView = [[SVInfiniteScrollingLoadingView alloc] initWithFrame:CGRectZero];
    infiniteLoadingView.loadingAnimationImages = array;
    
    [array removeAllObjects];
    imagePrefx = @"loading_white_";
    for (NSInteger index = 1; index <= imageCount; ++index) {
        NSString *imageName = [NSString stringWithFormat:@"%@%02ld", imagePrefx, (long)index];
        [array addObject:[UIImage imageNamed:imageName]];
    }
    
    loadingView.loadingAnimationImages = array;
    [self.tableView.pullToRefreshView setCustomView:loadingView forState:SVPullToRefreshStateAll];
    
    infiniteLoadingView.loadingAnimationImages = array;
    [self.tableView.infiniteScrollingView setCustomView:infiniteLoadingView forState:SVInfiniteScrollingStateAll];
    
    
    // Following lines is just for text clear
    self.tableView.pullToRefreshView.backgroundColor = [UIColor redColor];
    self.tableView.infiniteScrollingView.backgroundColor = [UIColor redColor];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [tableView triggerPullToRefresh];
}

#pragma mark - Actions

- (void)setupDataSource {
    self.dataSource = [NSMutableArray array];
    for(int i=0; i<15; i++)
        [self.dataSource addObject:[NSDate dateWithTimeIntervalSinceNow:-(i*90)]];
}

- (void)insertRowAtTop {
    __weak SVViewController *weakSelf = self;

    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
        [weakSelf.dataSource insertObject:[NSDate date] atIndex:0];
        [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        [weakSelf.tableView endUpdates];
        
        [weakSelf.tableView.pullToRefreshView stopAnimating];
    });
}


- (void)insertRowAtBottom {
    __weak SVViewController *weakSelf = self;

    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
        [weakSelf.dataSource addObject:[weakSelf.dataSource.lastObject dateByAddingTimeInterval:-90]];
        [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.dataSource.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        [weakSelf.tableView endUpdates];
        
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
}
#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    NSDate *date = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle];
    return cell;
}

@end
