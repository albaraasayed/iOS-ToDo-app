#import "ViewController.h"
#import "NewTaskViewController.h"
#import "TaskDetailsViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *search;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmented;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray *allTasks;
@property NSMutableArray *doneTasks;
@property NSMutableArray *inProgressTasks;
@property NSMutableArray *toDoTasks;
@property NSMutableArray *currentTask;

@property NSMutableArray *highPriorityTasks;
@property NSMutableArray *mediumPriorityTasks;
@property NSMutableArray *lowPriorityTasks;
@property BOOL isGroupedByPriority;

@property NSUserDefaults *defaults;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.search.delegate = self;
    
    _highPriorityTasks = [NSMutableArray new];
    _mediumPriorityTasks = [NSMutableArray new];
    _lowPriorityTasks = [NSMutableArray new];
    
    _allTasks = [NSMutableArray new];
    _doneTasks = [NSMutableArray new];
    _inProgressTasks = [NSMutableArray new];
    _toDoTasks = [NSMutableArray new];
    _defaults = [NSUserDefaults standardUserDefaults];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    id savedData = [_defaults objectForKey:@"allTasks"];
    if ([savedData isKindOfClass:[NSArray class]]) {
        _allTasks = [savedData mutableCopy];
    } else {
        _allTasks = [NSMutableArray new];
    }
    
    [_doneTasks removeAllObjects];
    [_inProgressTasks removeAllObjects];
    [_toDoTasks removeAllObjects];
    
    for (int i = 0; i < _allTasks.count; i++) {
        if ([[_allTasks[i] objectForKey:@"isDone"] isEqual:@1] ) {
            [_doneTasks addObject:_allTasks[i]];
        }
        else if ([[_allTasks[i] objectForKey:@"isInProgress"] isEqual:@1]) {
            [_inProgressTasks addObject:_allTasks[i]];
        }
        else {
            [_toDoTasks addObject:_allTasks[i]];
        }
    }
    
    [self segmentChange:_segmented];
}

-(IBAction)segmentChange:(id)sender {
    self.isGroupedByPriority = NO;
    
    switch ([_segmented selectedSegmentIndex]) {
        case 0:
            _currentTask = _allTasks;
            break;
        case 1:
            _currentTask = _toDoTasks;
            break;
        case 2:
            _currentTask = _inProgressTasks;
            break;
        case 3:
            _currentTask = _doneTasks;
            break;
        case 4:
            self.isGroupedByPriority = YES;
            [_highPriorityTasks removeAllObjects];
            [_mediumPriorityTasks removeAllObjects];
            [_lowPriorityTasks removeAllObjects];
            
            for (NSDictionary *task in _allTasks) {
                if ([[task objectForKey:@"priority"] isEqual:@0]) {
                    [_highPriorityTasks addObject:task];
                } else if ([[task objectForKey:@"priority"] isEqual:@1]) {
                    [_mediumPriorityTasks addObject:task];
                } else {
                    [_lowPriorityTasks addObject:task];
                }
            }
            break;
        default:
            _currentTask = _allTasks;
            break;
    }
    
    [self.tableView reloadData];
}

-(IBAction)addNewTask:(id)sender {
    NewTaskViewController *newTaskScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"newTaskScreen"];
    [self.navigationController pushViewController:newTaskScreen animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isGroupedByPriority) {
        return 3;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.isGroupedByPriority) {
        if (section == 0)
            return @"High Priority";
        if (section == 1)
            return @"Medium Priority";
        if (section == 2)
            return @"Low Priority";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isGroupedByPriority) {
        if (section == 0) return _highPriorityTasks.count;
        if (section == 1) return _mediumPriorityTasks.count;
        if (section == 2) return _lowPriorityTasks.count;
    }
    return _currentTask.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    NSDictionary *thisTask;
    if (self.isGroupedByPriority) {
        if (indexPath.section == 0) thisTask = _highPriorityTasks[indexPath.row];
        else if (indexPath.section == 1) thisTask = _mediumPriorityTasks[indexPath.row];
        else thisTask = _lowPriorityTasks[indexPath.row];
    } else {
        thisTask = _currentTask[indexPath.row];
    }
    
    cell.textLabel.text = [thisTask objectForKey:@"name"];
    
    NSString *descString = [thisTask objectForKey:@"desc"];
    NSDate *taskDate = [thisTask objectForKey:@"date"];
    
    if (taskDate) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        
        NSString *dateString = [formatter stringFromDate:taskDate];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", descString, dateString];
    } else {
        cell.detailTextLabel.text = descString;
    }
    
    cell.imageView.image = [UIImage systemImageNamed:@"flame.fill"];
    
    if ([[thisTask objectForKey:@"priority"] isEqual: @0]) {
        cell.imageView.tintColor = [UIColor redColor];
    } else if ([[thisTask objectForKey:@"priority"] isEqual: @1]) {
        cell.imageView.tintColor = [UIColor orangeColor];
    } else {
        cell.imageView.tintColor = [UIColor systemGreenColor];
    }
    
    if ([[thisTask objectForKey:@"isDone"] isEqual: @1]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskDetailsViewController *taskDetailsController = [self.storyboard instantiateViewControllerWithIdentifier:@"taskDetailsScreen"];
    
    NSDictionary *thisTask;
    if (self.isGroupedByPriority) {
        if (indexPath.section == 0) thisTask = _highPriorityTasks[indexPath.row];
        else if (indexPath.section == 1) thisTask = _mediumPriorityTasks[indexPath.row];
        else thisTask = _lowPriorityTasks[indexPath.row];
    } else {
        thisTask = _currentTask[indexPath.row];
    }
    
    taskDetailsController.taskData = thisTask;
    [self.navigationController pushViewController:taskDetailsController animated:YES];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    switch ([_segmented selectedSegmentIndex]) {
        case 0: _currentTask = _allTasks; break;
        case 1: _currentTask = _toDoTasks; break;
        case 2: _currentTask = _inProgressTasks; break;
        case 3: _currentTask = _doneTasks; break;
        case 4:
            [_highPriorityTasks removeAllObjects];
            [_mediumPriorityTasks removeAllObjects];
            [_lowPriorityTasks removeAllObjects];
            for (NSDictionary *task in _allTasks) {
                if ([[task objectForKey:@"priority"] isEqual:@0]) [_highPriorityTasks addObject:task];
                else if ([[task objectForKey:@"priority"] isEqual:@1]) [_mediumPriorityTasks addObject:task];
                else [_lowPriorityTasks addObject:task];
            }
            break;
        default: _currentTask = _allTasks; break;
    }
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (searchText.length > 0) {
        if (self.isGroupedByPriority) {
            NSMutableArray *filteredHigh = [NSMutableArray new];
            for (NSDictionary *task in _highPriorityTasks) {
                if ([task[@"name"] rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    [filteredHigh addObject:task];
                }
            }
            _highPriorityTasks = filteredHigh;
            
            NSMutableArray *filteredMedium = [NSMutableArray new];
            for (NSDictionary *task in _mediumPriorityTasks) {
                if ([task[@"name"] rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    [filteredMedium addObject:task];
                }
            }
            _mediumPriorityTasks = filteredMedium;
            
            NSMutableArray *filteredLow = [NSMutableArray new];
            for (NSDictionary *task in _lowPriorityTasks) {
                if ([task[@"name"] rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    [filteredLow addObject:task];
                }
            }
            _lowPriorityTasks = filteredLow;
            
        } else {
            NSMutableArray *filteredTasks = [[NSMutableArray alloc] init];
            for (NSDictionary *taskDict in _currentTask) {
                NSString *taskName = [taskDict objectForKey:@"name"];
                if ([taskName rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    [filteredTasks addObject:taskDict];
                }
            }
            _currentTask = filteredTasks;
        }
    }
    
    [_tableView reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView && editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *taskToDelete;

        if (self.isGroupedByPriority) {
            if (indexPath.section == 0) {
                taskToDelete = self.highPriorityTasks[indexPath.row];
                [self.highPriorityTasks removeObjectAtIndex:indexPath.row];
            } else if (indexPath.section == 1) {
                taskToDelete = self.mediumPriorityTasks[indexPath.row];
                [self.mediumPriorityTasks removeObjectAtIndex:indexPath.row];
            } else {
                taskToDelete = self.lowPriorityTasks[indexPath.row];
                [self.lowPriorityTasks removeObjectAtIndex:indexPath.row];
            }
        } else {
            taskToDelete = self.currentTask[indexPath.row];
            [self.currentTask removeObjectAtIndex:indexPath.row];
        }
        
        [self.allTasks removeObject:taskToDelete];
        
        [self.toDoTasks removeObject:taskToDelete];
        [self.inProgressTasks removeObject:taskToDelete];
        [self.doneTasks removeObject:taskToDelete];
        
        
        [self.defaults setObject:self.allTasks forKey:@"allTasks"];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}
@end
