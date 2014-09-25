//
//  FilterViewController.m
//  yelp
//
//  Created by sindhuja sridharan on 9/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "YelpClient.h"


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface FilterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *filterTableView;

//holds section names
@property (strong, nonatomic)NSArray *filterSectionTitles;
@property (strong, nonatomic) NSArray *filterCategories;
@property (strong, nonatomic) NSMutableArray *dealsSwitch;


@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Filters";
        //Should move to a sepearte file
        self.filterCategories =@[
                                 @{
                                       @"name": @"Most Popular",
                                       @"options":@[@"Offering a Deal"],
                                       @"collapsed_size" : [NSNumber numberWithInt:1],
                                       },
                                  [@{
                                      @"name": @"Distance",
                                      @"options":
                                          @[
                                              @{@"name": @"Auto",      @"value": [NSNumber numberWithFloat:50000]},
                                              @{@"name": @"0.3 miles", @"value": [NSNumber numberWithFloat:482]},
                                              @{@"name": @"1 mile",    @"value": [NSNumber numberWithFloat:1609]},
                                              @{@"name": @"5 miles",   @"value": [NSNumber numberWithFloat:8046]},
                                              @{@"name": @"20 miles",  @"value": [NSNumber numberWithFloat:32186]}
                                              ],
                                      @"expanded": [NSNumber numberWithBool:NO],
                                      @"collapsed_size" : [NSNumber numberWithInt:1],
                                      @"selected": [NSNumber numberWithInt:0]
                                      }mutableCopy],
                                   [@{
                                      @"name": @"Sort by",
                                      @"options":
                                          @[
                                              @{@"name": @"Best Match",    @"value": [NSNumber numberWithInt:0]},
                                              @{@"name": @"Distance",      @"value": [NSNumber numberWithInt:1]},
                                              @{@"name": @"Rating",        @"value": [NSNumber numberWithInt:2]}
                                              ],
                                      @"expanded": [NSNumber numberWithBool:NO],
                                      @"collapsed_size" : [NSNumber numberWithInt:1],
                                      @"selected": [NSNumber numberWithInt:0]
                                      }mutableCopy],
                                  [@{
                                      @"name": @"Categories",
                                      @"options":
                                          @[
                                              [@{@"name": @"American (New)",           @"value": @"newamerican",       @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"American (Traditional)",   @"value": @"tradamerican",      @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Argentine",                @"value": @"argentine",         @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Asian Fusion",             @"value": @"asianfusion",       @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Australian",               @"value": @"australian",        @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Austrian",                 @"value": @"austrian",          @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Brazilian",                @"value": @"brazilian",         @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Breakfast & Brunch",       @"value": @"breakfast_brunch",  @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Buffets",                  @"value": @"buffets",           @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Burgers",                  @"value": @"burgers",           @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Burmese",                  @"value": @"burmese",           @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Cafes",                    @"value": @"cafes",             @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Cajun/Creole",             @"value": @"cajun",             @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Chinese",                  @"value": @"chinese",           @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Cantonese",                @"value": @"cantonese",         @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Dim Sum",                  @"value": @"dimsum",            @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Cuban",                    @"value": @"cuban",             @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Diners",                   @"value": @"diners",            @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Dumplings",                @"value": @"dumplings",         @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Ethiopian",                @"value": @"ethiopian",         @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Fast Food",                @"value": @"hotdogs",           @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"French",                   @"value": @"french",            @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"German",                   @"value": @"german",            @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Greek",                    @"value": @"greek",             @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Indian",                   @"value": @"indpak",            @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Indonesian",               @"value": @"indonesian",        @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Irish",                    @"value": @"irish",             @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Italian",                  @"value": @"italian",           @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Japanese",                 @"value": @"japanese",          @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Korean",                   @"value": @"korean",            @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Venezuelan",               @"value": @"venezuelan",        @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Malaysian",                @"value": @"malaysian",         @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Pizza",                    @"value": @"pizza",             @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Seafood",                  @"value": @"seafood",           @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Turkish",                  @"value": @"turkish",           @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Vegan",                    @"value": @"vegan",             @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Vegetarian",               @"value": @"vegetarian",        @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                              [@{@"name": @"Vietnamese",               @"value": @"vietnamese",        @"selected": [NSNumber numberWithBool:NO]} mutableCopy]
                                              ],
                                      @"expanded": [NSNumber numberWithBool:NO],
                                      @"collapsed_size" : [NSNumber numberWithInt:5]
                                      } mutableCopy]
                                 ];

    }
    
    
    self.dealsSwitch = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < ((NSArray*)self.filterCategories[0][@"options"]).count; i++) {
        self.dealsSwitch[i] = @(NO);
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //init table
    
    self.filterTableView.dataSource = self;
    self.filterTableView.delegate = self;
    
    //set left nav and right bar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onClickCancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleDone target:self action:@selector(onClickSearch)];
    
    
    [self.filterTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DropdownCell"];

    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    int selected = [self.filterCategories[indexPath.section][@"selected"] intValue];
    if(indexPath.section == 0) {
        cell.textLabel.text = self.filterCategories[indexPath.section][@"options"][indexPath.row];
        //Add the Switch
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = switchView;
        [switchView setOn:[self.dealsSwitch[indexPath.row] boolValue]];
        [switchView addTarget:self action:@selector(sender:whenSwitched:) forControlEvents:UIControlEventValueChanged];
        
    }
    else if(indexPath.section == 1) {
        //Add Collapase for Distance
        cell.textLabel.text = self.filterCategories[indexPath.section][@"options"][indexPath.row][@"name"];
        if ([self.filterCategories[indexPath.section][@"expanded"] boolValue] == NO) {
            cell = [self.filterTableView dequeueReusableCellWithIdentifier:@"DropdownCell" forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = self.filterCategories[indexPath.section][@"options"][selected][@"name"];
        } else if([self.filterCategories[indexPath.section][@"selected"] intValue] == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }


    } else if(indexPath.section == 2) {
        //Add Collapase for Sort By
        cell.textLabel.text = self.filterCategories[indexPath.section][@"options"][indexPath.row][@"name"];
        if ([self.filterCategories[indexPath.section][@"expanded"] boolValue] == NO) {
            cell = [self.filterTableView dequeueReusableCellWithIdentifier:@"DropdownCell" forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = self.filterCategories[indexPath.section][@"options"][selected][@"name"];
            
        }else if([self.filterCategories[indexPath.section][@"selected"] intValue] == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }

    }
    else if(indexPath.section == 3) {
        if(indexPath.row == ([self.filterCategories[indexPath.section][@"collapsed_size"] intValue] -1) &&[self.filterCategories[indexPath.section][@"expanded"] boolValue] == NO) {
            cell.textLabel.textColor = UIColorFromRGB(0xc8c8c8);
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = @"See All";
        } else {
            cell.textLabel.text = self.filterCategories[indexPath.section][@"options"][indexPath.row][@"name"];
            if ([self SelectedRow:indexPath.row withSection:indexPath.section]) {
                   cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }

        }
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

   [self.filterTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int section = indexPath.section;
    int row = indexPath.row;
    
    NSDictionary *filter = self.filterCategories[indexPath.section];
    
    if([filter[@"name"] isEqualToString:@"Distance"] || [filter[@"name"] isEqualToString:@"Sort by"]) {
        if([self isSectionExpanded:section])
        {
            self.filterCategories[indexPath.section][@"selected"] = [NSNumber numberWithInt:row];
            
        }
        [self toggleSection:section];

    }else if([filter[@"name"] isEqualToString:@"Categories"]) {
        if (![self isSectionExpanded:section] && row == ([filter[@"collapsed_size"] intValue] - 1 ) ) {
            NSLog(@"toggleExpand");
            [self toggleSection:section];
        } else {
            [self toggleSelectedRow:row withSection:section];
        }

    }
        
    [self.filterTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)onClickCancel:(id)sender {
    [[self navigationController]popViewControllerAnimated:YES];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.filterCategories.count;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.filterCategories[section][@"name"];
}

//Get the total number of rows in each section here
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        if ([self.filterCategories[section][@"expanded"] boolValue]) {
            return ((NSArray *)self.filterCategories[section][@"options"]).count;
        }
        else {
            return 1;
        }
    }
    else if (section == 2) {
        if ([self.filterCategories[section][@"expanded"] boolValue]) {
            return ((NSArray *)self.filterCategories[section][@"options"]).count;
        }
        else {
            return 1;
        }
    }
    else if (section == 3) {
        if ([self.filterCategories[section][@"expanded"] boolValue]) {
            return ((NSArray *)self.filterCategories[section][@"options"]).count;
        }
        else {
            return 4;
        }
    }
    return 1;
}


-(void) onClickSearch {
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    
    //Process the filters
    for(NSDictionary *filter in self.filterCategories) {
        //get the name of each filter name
        NSString *filterName = filter[@"name"];
        if([filterName  isEqual: @"Sort by"]) {
            NSNumber *sort = [[[filter objectForKey:@"options"] objectAtIndex:
                                 [[filter objectForKey:@"selected" ] intValue]] objectForKey:@"value"];
            [filters setObject:sort forKey:@"sort"];
        }
        else if ([filterName  isEqual: @"Distance"]) {
            NSNumber *radius = [[[filter objectForKey:@"options"] objectAtIndex:
                                   [[filter objectForKey:@"selected" ] intValue]] objectForKey:@"value"];
            

            [filters setObject:radius forKey:@"radius_filter"];
        }
        else if ([filterName isEqual: @"Categories"]) {
            NSMutableArray *catSelected = [[NSMutableArray alloc] init];
            for (NSDictionary *cat in [filter  objectForKey:@"options"]) {
                if ([cat[@"selected"] boolValue]) {
                    [catSelected addObject:cat[@"value"]];
                }
            }
            NSString *categories = [catSelected componentsJoinedByString:@","];
            [filters setObject:categories forKey:@"category_filter"];
        }
    }
    
    [filters setObject:self.dealsSwitch forKey:@"dealsSwitch"];
    
    NSLog(@"option: %@", filters);
    
    [self searchForFilters:filters];
    [[self navigationController]popViewControllerAnimated:YES];

    [self dismissViewControllerAnimated:YES completion:^{}];
    return;
}

-(void)searchForFilters:(NSMutableDictionary *)data {
    if([self.delegate respondsToSelector:@selector(searchForFilters:)]) {
        [self.delegate searchForFilters:data];
    }
    
}
- (void)sender:(id)sender whenSwitched:(BOOL)value {
    
    NSIndexPath *indexpath = [self.filterTableView indexPathForCell:sender];
    if(indexpath.section == 0) {
        self.dealsSwitch[indexpath.row] = @(value);
    }
}

- (BOOL)isSectionExpanded:(NSInteger)section
{
    return [self.filterCategories[section][@"expanded"] boolValue];
}


- (BOOL)toggleSection:(NSInteger) section {
    self.filterCategories[section][@"expanded"] =
    ([self.filterCategories[section][@"expanded"] boolValue] == YES) ?
    [NSNumber numberWithBool:NO] :
    [NSNumber numberWithBool:YES];
    return [self.filterCategories[section][@"expanded"] boolValue];
}


- (BOOL)toggleSelectedRow:(NSInteger)row withSection:(NSInteger)section {
    self.filterCategories[section][@"options"][row][@"selected"]  =
    ([self.filterCategories[section][@"options"][row][@"selected"] boolValue] == YES) ?
    [NSNumber numberWithBool:NO] :
    [NSNumber numberWithBool:YES];
    return [self.filterCategories[section][@"options"][row][@"selected"] boolValue];
}

- (BOOL)SelectedRow:(NSInteger) row withSection:(NSInteger)section  {
    return [self.filterCategories[section][@"options"][row][@"selected"] boolValue];
}

@end
