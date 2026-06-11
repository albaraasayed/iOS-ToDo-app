//
//  NewTaskViewController.m
//  ToDo App
//
//  Created by albaraa alsayed on 10/11/1447 AH.
//

#import "NewTaskViewController.h"
#import "Task.h"


@interface NewTaskViewController ()
@property (weak, nonatomic) IBOutlet UITextField *taskName;
@property (weak, nonatomic) IBOutlet UITextField *taskDescription;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property Task *task;
@property NSUserDefaults *defaults;
@property NSMutableArray<NSDictionary*> *allTasks;
@end

@implementation NewTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _task = [Task new];
    _defaults = [NSUserDefaults standardUserDefaults];
    
    if ([_defaults objectForKey:@"allTasks"] != nil) {
        _allTasks = [[_defaults objectForKey:@"allTasks"] mutableCopy];
        
    } else {
        _allTasks = [NSMutableArray new];
    }
}

-(IBAction)addTaskToDB:(id)sender {
    if (_taskName.text != nil && _taskName.text.length != 0) {
        _task.name = _taskName.text;
        _task.desc = _taskDescription.text;
        _task.priority = [_segmentControl selectedSegmentIndex];
        _task.date = [NSDate now];
        
        [_allTasks addObject:[_task toDictionary]];
        [_defaults setObject:_allTasks forKey:@"allTasks"];
        
        NSLog(@"User Defaults: %@", _allTasks);
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"Empty Field" message: @"You can't add Empty Task or Empty description." preferredStyle:UIAlertControllerStyleAlert];
            
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okButton];
        [self presentViewController: alertController animated:YES completion:nil];
    }
}

@end
