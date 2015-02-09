//
//  SearchComplete.m
//  SearchComplete
//
//  Created by Frank Cipollone on 2/6/15.
//  Copyright (c) 2015 Frank Cipollone. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SearchComplete.h"

@implementation SearchComplete

-(UITextField*)searchText{
    if(!_searchText){
        _searchText = [[UITextField alloc] initWithFrame:CGRectMake(50, 50, self.view.bounds.size.width*3/4 -20, 50)];
        _searchText.borderStyle = UITextBorderStyleRoundedRect;
        _searchText.allowsEditingTextAttributes = YES;
        _searchText.text = @"";
        
    }
    return _searchText;
}

-(void)goButtonPressed{
    [self performSegueWithIdentifier:@"SearchToDetail" sender:self];
}

-(UIButton*)goButton{
    if(!_goButton){
        _goButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*3/4,self.searchText.frame.origin.y,self.view.bounds.size.width/4 - 10, self.searchText.frame.size.height)];
        [_goButton setTitle:@"Go" forState:UIControlStateNormal];
        [_goButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [[_goButton layer] setBorderWidth:1.0f];
        _goButton.layer.cornerRadius = 5;
        [_goButton addTarget:self action:@selector(goButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goButton;
}



-(UITableView*)tableView{
    if(!_tableView){
        int tableHeight = 300;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.searchText.frame.origin.x,(self.searchText.frame.origin.y + self.searchText.frame.size.height + 10),self.view.bounds.size.width-20,tableHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = tableHeight/nFields;
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return nFields;
}
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* myCell = [[UITableViewCell alloc] init];
    myCell.textLabel.text = topLocations[indexPath.row];
    return myCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(![[topLocations objectAtIndex:indexPath.row]  isEqual: @""]){
        self.searchText.text = [topLocations objectAtIndex:indexPath.row];
        curField = [topLocations objectAtIndex:indexPath.row];
    }
    [self findTopLocations];
    [self updateTable];
}

-(void)updateTable{
    [self.tableView beginUpdates];
    NSIndexSet *mySet = [[NSIndexSet alloc] initWithIndex:0];
    [self.tableView reloadSections:mySet withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (void)textChanged:(NSNotification *)notification {
    UITextField *textField = [notification object];
    curField = textField.text;
    [self findTopLocations];
    [self updateTable];
}

-(void)findTopLocations{
    int curNumberFound = 0;
    
    for (NSString* loc in locations){
        if([curField  isEqual: @""]){
            while(curNumberFound < nFields){
                [topLocations replaceObjectAtIndex:curNumberFound withObject:@""];
                curNumberFound++;
            }
        }
        if(loc.length >= curField.length){
            int curCharacter = 0;
            while(curCharacter < curField.length && [[loc uppercaseString] characterAtIndex:curCharacter] == [[curField uppercaseString] characterAtIndex:curCharacter]){
                curCharacter++;
            }
            if(curCharacter == curField.length && curNumberFound < nFields){
                [topLocations replaceObjectAtIndex:curNumberFound withObject:loc];
                curNumberFound++;
            }
        }
    }
    while(curNumberFound < nFields){
        [topLocations replaceObjectAtIndex:curNumberFound withObject:@""];
        curNumberFound++;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //This next line needs to be at the top
    nFields = 6;
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.searchText];
    [self.view addSubview:self.goButton];
    //CurField is a representaion of the current entry in the searchText textField.
    curField = @"";
    //Number of fields in the tableView.
    //The following sets topLocations to hold the top locations for the table view.
    topLocations = [[NSMutableArray alloc] init];
    for (int n = 0; n < nFields; n++){
        [topLocations addObject:@""];
    }
    [self findTopLocations];
    locations = [NSArray arrayWithObjects:@"Maryland",@"Virginia",@"District of Columbia",@"Indiana",@"Illinois",@"Texas",@"Michigan",@"Deleware", nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
