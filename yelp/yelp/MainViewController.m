//
//  MainViewController.m
//  yelp
//
//  Created by sindhuja sridharan on 9/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "YelpReviewViewCell.h"
#import "FilterViewController.h"
#import <MBProgressHUD.h>
#import "UIImageView+AFNetworking.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;

//Adding Searchbar and filter buttons
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIBarButtonItem *filterButton;

//Add refresh control
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //init nav bar
    [self initFilterNavBarButton];
    [self initSearchNavBarCmp];
    //init table view
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 125;
    NSLog(@"In view did load");
    UINib *YelpReviewViewCellNib = [UINib nibWithNibName:@"YelpReviewViewCell" bundle:nil];
    [self.tableView registerNib:YelpReviewViewCellNib forCellReuseIdentifier:@"YelpReviewViewCell"];
    
    //Add refersh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(searchPerform:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:self.refreshControl];
    [self searchPerform:@""];

}

-(void)initFilterNavBarButton {
    self.filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilter)];
    self.navigationItem.leftBarButtonItem = self.filterButton;
}
-(void)initSearchNavBarCmp {
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.tintColor = [UIColor blackColor];
    self.navigationItem.titleView = self.searchBar;
}

-(void)searchPerform:(NSString *) searchTerm{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"SearchPerform function with search terms %@", searchTerm);
    
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    
    [self.client searchWithTerm:@"Food" success:^(AFHTTPRequestOperation *operation, id response) {
        self.businesses = response[@"businesses"];
        //NSLog(@"response: %@", self.businesses);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
         [self.refreshControl endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"search bar is clicked");
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UITextField *searchBarTextField;
    for(UIView *subView in searchBar.subviews) {
        for(UIView *secondLevelSubView in subView.subviews) {
            if([secondLevelSubView isKindOfClass:[UITextField class]]) {
                searchBarTextField = (UITextField *)secondLevelSubView;
                break;
            }
        }
    }
    [searchBar resignFirstResponder];
    
    [self.client searchWithTerm:searchBarTextField.text success:^(AFHTTPRequestOperation *operation, id response) {
        self.businesses = response[@"businesses"];
        //NSLog(@"response: %@", self.businesses);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"cancel search is clicked");
    [searchBar resignFirstResponder];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"table view");
    NSLog(@"cell for now at index path: %d", indexPath.row);
    
    static NSString *reviewCell = @"YelpReviewViewCell";
    YelpReviewViewCell *reviewcell = [self.tableView dequeueReusableCellWithIdentifier:reviewCell];
    NSDictionary *business = self.businesses[indexPath.row];
    NSLog(@"business : %@",business[@"name"]);
    //Name
    NSString *name = [NSString stringWithFormat:@"%d. %@", indexPath.row +1, business[@"name"]];
    //cell.titleLabel.numberOfLines = 6;
    reviewcell.titleLabel.text = name;
    
    //Rating
    [reviewcell.ratingImageView setImageWithURL:[NSURL URLWithString:business[@"rating_img_url"]]];
    
    //reviewsLabel
    NSString *count = [NSString stringWithFormat:@"%@ Reviews", business[@"review_count"]];
    reviewcell.reviewsLabel.text = count;
    
    //resturantImageView
    [reviewcell.resturantImageView setImageWithURL:[NSURL URLWithString:business[@"image_url"]]];
    
    //address
    NSArray *addressArray = business[@"location"][@"address"];
    addressArray = [addressArray arrayByAddingObjectsFromArray:business[@"location"][@"neighborhoods"]];
    NSString *address = [addressArray componentsJoinedByString:@","];
    reviewcell.addressLabel.text = address;
    
    //categories
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for(id object in business[@"categories"]){
        [categoryArray addObject:object[0]];
    }
    NSString *category = [categoryArray componentsJoinedByString:@", "];
    reviewcell.categoriesLabel.text = category;
    
    return reviewcell;
}

-(void)onFilter {
    NSLog(@"On filter click");
    
    FilterViewController *fvc = [[FilterViewController alloc]init];
    fvc.delegate = self;
    [self.navigationController pushViewController:fvc animated:YES];
    
}
-(void)searchForFilters:(NSMutableDictionary *)data {
    NSLog(@"data --------%@", data);
    
    // Create dictionary
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    // Deals
    if (data[@"dealsSwitch"][0]) {
        [dictionary setObject:data[@"dealsSwitch"][0] forKey:@"deals_filter"];
    }
    //sort by
    if(data[@"sort"]) {
        [dictionary setObject:data[@"sort"] forKey:@"sort"];
    }
    //category
    if(data[@"category_filter"]) {
        [dictionary setObject:data[@"category_filter"] forKey:@"category_filter"];
    }
    //radius
    if(data[@"radius_filter"]) {
        [dictionary setObject:data[@"radius_filter"] forKey:@"radius_filter"];
    }
    
    [self.client searchWithDictionary:dictionary success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"SUCESS------%@",response);
        self.businesses = response[@"businesses"];
        [self.tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

@end
