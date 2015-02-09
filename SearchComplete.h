//
//  SearchComplete.h
//  SearchComplete
//
//  Created by Frank Cipollone on 2/6/15.
//  Copyright (c) 2015 Frank Cipollone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchComplete : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSArray *locations;
    NSMutableArray *topLocations;
    NSString* curField;
    int nFields;
}

@property (strong, nonatomic) UITextField* searchText;
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) UIButton* goButton;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
-(BOOL)searchText:(UITextField *)searchText shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
-(BOOL)textFieldShouldBeginEditing:(UITextField*)searchText;
-(void)textChanged:(NSNotification *)notification;
-(void)findTopLocations;
-(void)updateTable;
-(void)goButtonPressed;
@end
