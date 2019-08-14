//
//  ViewController.m
//  BCListDiffable
//
//  Created by boluchuling on 2019/8/5.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate
//, UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableViewDiffableDataSource *diffableDataSource;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableViewCell *(^cellProvider)(UITableView * _Nonnull, NSIndexPath * _Nonnull, id _Nonnull);

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configurationData];
    
    [self configurationBlock];

    [self configurationTableView];
    
    [self configurationButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // 刷新放到这里，放到viewDidLoad会警告视图还未显示
    [self reload];
}

- (void)configurationData
{
    self.dataArray = @[@"1-00000",
                       @"1-11111",
                       @"1-22222",
                       @"1-33333",
                       @"1-44444",
                       @"1-55555",
                       @"1-66666",
                       @"1-77777",
                       @"1-88888",
                       @"1-99999"].mutableCopy;
}

- (void)configurationBlock
{
    __weak typeof(self) weakSelf = self;
    self.cellProvider = ^UITableViewCell * _Nullable(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath, id _Nonnull identity) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        
        cell.textLabel.text = weakSelf.dataArray[indexPath.row];
        
        return cell;
    };
}

- (void)configurationButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(200, 100, 50, 30);
    button.backgroundColor = [UIColor greenColor];
    [button addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)configurationTableView
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    self.diffableDataSource = [[UITableViewDiffableDataSource alloc] initWithTableView:self.tableView cellProvider:self.cellProvider];
}

- (void)reload
{
    NSDiffableDataSourceSnapshot *snapshot = [[NSDiffableDataSourceSnapshot alloc] init];
    
    [snapshot appendSectionsWithIdentifiers:@[@"first"]];
    [snapshot appendItemsWithIdentifiers:self.dataArray intoSectionWithIdentifier:@"first"];
    
    [self.diffableDataSource applySnapshot:snapshot animatingDifferences:YES];
}

- (void)tapAction:(UIButton *)sender
{
    if (2 > self.dataArray.count - 1) {
        // 复原
        [self configurationData];
        
        [self reload];
        
        return;
    }
    
    NSString *deleteObj = self.dataArray[2];
    [self.dataArray removeObjectAtIndex:2];
    
    
    NSDiffableDataSourceSnapshot *snapshot = self.diffableDataSource.snapshot;
    [snapshot deleteItemsWithIdentifiers:@[deleteObj]];
    
    [self.diffableDataSource applySnapshot:snapshot animatingDifferences:YES];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
        _tableView.delegate = self;
//        _tableView.dataSource = self;
        
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select %@", @(indexPath.row));
}

/*
 * 注释掉的不需要也可以, 当设置diffableDataSource时，datasource的代理方法就不会执行了
 */
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return self.cellProvider(tableView, indexPath, @(1));
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataArray.count;
//}

@end

