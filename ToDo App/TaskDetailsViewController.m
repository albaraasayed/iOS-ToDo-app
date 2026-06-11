//
//  TaskDetailsViewController.m
//  ToDo App
//
//  Created by albaraa alsayed on 10/11/1447 AH.
//

#import "TaskDetailsViewController.h"
#import "Task.h"

@interface TaskDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *taskName;
@property (weak, nonatomic) IBOutlet UITextField *taskDesc;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *statusSegment;
@property Task *task;
@property NSUserDefaults *defaults;
@property NSMutableArray *allTasks;

@end

@implementation TaskDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _defaults = [NSUserDefaults standardUserDefaults];
    _allTasks = [[_defaults objectForKey:@"allTasks"] mutableCopy];
    
    _task = [[Task alloc] initWithDictionary:_taskData];
    NSLog(@"=== Details Page: task name is: %@", _task.name);
    NSLog(@"=== Details Page: task desc is: %@", _task.desc);
    NSLog(@"=== Details Page: task prio is: %ld", _task.priority);
    NSLog(@"=== Details Page: task isDone is: %d", _task.isDone);
    NSLog(@"=== Details Page: task isInProgress is: %d", _task.isInProgress);
    
    _taskName.text = _task.name;
    _taskDesc.text = _task.desc;
    
    [_prioritySegment setSelectedSegmentIndex:_task.priority];
    
    if (_task.isDone == YES) {
        [_statusSegment setSelectedSegmentIndex:2];
    }
    else if (_task.isInProgress == YES) {
        [_statusSegment setSelectedSegmentIndex:1];
    }
    else {
        [_statusSegment setSelectedSegmentIndex:0];
    }
    
    if (_task.priority == 2) {
        [_prioritySegment setSelectedSegmentIndex:2];
    }
    else if (_task.priority == 1) {
        [_prioritySegment setSelectedSegmentIndex:1];
    }
    else {
        [_prioritySegment setSelectedSegmentIndex:0];
    }
    
    // disable
    if (_task.isDone == YES) {
        [_statusSegment setEnabled:NO forSegmentAtIndex:0];
        [_statusSegment setEnabled:NO forSegmentAtIndex:1];
    } else if (_task.isInProgress == YES) {
        [_statusSegment setEnabled:NO forSegmentAtIndex:0];
    }
}


-(IBAction)saveEdits:(id)sender{
    if (_taskName.text != nil && _taskName.text.length != 0) {
        _task.name = _taskName.text;
        _task.desc = _taskDesc.text;
        _task.priority = [_prioritySegment selectedSegmentIndex];
        
        if ([_prioritySegment selectedSegmentIndex] == 0) {
            _task.priority = 0;
        }
        else if ([_prioritySegment selectedSegmentIndex] == 1) {
            _task.priority = 1;
        }
        else {
            _task.priority = 2;
        }
        if ([_statusSegment selectedSegmentIndex] == 0) {
            _task.isDone = 0;
            _task.isInProgress = 0;
        }
        else if ([_statusSegment selectedSegmentIndex] == 1) {
            _task.isDone = 0;
            _task.isInProgress = 1;
        }
        else {
            _task.isDone = 1;
            _task.isInProgress = 0;
        }
        NSInteger index = [_allTasks indexOfObject:_taskData];
        
        _taskData = [_task toDictionary];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle: [@"Edit: " stringByAppendingString:_task.name] message: @"Are u sure u want to Edit Task." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *conferButton = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self->_allTasks replaceObjectAtIndex:index withObject:self->_taskData];
            [self->_defaults setObject:self->_allTasks forKey:@"allTasks"];
            
            NSLog(@"Deleted task");
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"NO clicked");
        }];
        
        [alertController addAction:conferButton];
        [alertController addAction:cancelButton];
        [self presentViewController: alertController animated:YES completion:nil];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"Empty Field" message: @"You can't Edit by Empty Task or Empty description." preferredStyle:UIAlertControllerStyleAlert];
            
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okButton];
        [self presentViewController: alertController animated:YES completion:nil];
    }
}

-(IBAction)deleteTask:(id)sender {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: [@"Delete: " stringByAppendingString:_task.name] message: @"Are u sure u want to delete Task." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *conferButton = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self->_allTasks removeObject:self->_taskData];
        [self->_defaults setObject:self->_allTasks forKey:@"allTasks"];
        NSLog(@"Deleted task");
        [self.navigationController popViewControllerAnimated:YES];
    }];
        
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"NO clicked");
    }];
    
    [alertController addAction:conferButton];
    [alertController addAction:cancelButton];
    [self presentViewController: alertController animated:YES completion:nil];
}

@end
