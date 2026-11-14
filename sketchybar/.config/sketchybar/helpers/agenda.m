#import <EventKit/EventKit.h>
#import <Foundation/Foundation.h>
int main(int argc,const char **argv){@autoreleasepool{
 EKEventStore *store=[EKEventStore new];
 if(argc>1 && strcmp(argv[1],"--authorize")==0){
  __block BOOL done=NO;
  [store requestFullAccessToEventsWithCompletion:^(BOOL granted,NSError *error){done=YES;}];
  NSDate *deadline=[NSDate dateWithTimeIntervalSinceNow:45];
  while(!done && deadline.timeIntervalSinceNow>0)[[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.1]];
 }
 EKAuthorizationStatus auth=[EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
 NSMutableDictionary *result=[NSMutableDictionary dictionary];
 if(auth!=EKAuthorizationStatusFullAccess){result[@"status"]=@"permission";}
 else{
  result[@"status"]=@"ok";NSDate *now=[NSDate date];NSCalendar *calendar=[NSCalendar currentCalendar];
  NSDate *start=[calendar startOfDayForDate:now];NSDate *end=[calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:start options:0];
  NSArray *events=[[store eventsMatchingPredicate:[store predicateForEventsWithStartDate:start endDate:end calendars:nil]] sortedArrayUsingComparator:^NSComparisonResult(EKEvent *a,EKEvent *b){return [a.startDate compare:b.startDate];}];
  NSMutableArray *rows=[NSMutableArray array];
  for(EKEvent *event in events){if(event.status==EKEventStatusCanceled)continue;
   [rows addObject:@{@"title":event.title?:@"Untitled event",@"start":@([event.startDate timeIntervalSince1970]),@"end":@([event.endDate timeIntervalSince1970]),@"allDay":@(event.allDay)}];
  }result[@"events"]=rows;
 }
 NSData *data=[NSJSONSerialization dataWithJSONObject:result options:0 error:nil];puts([[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding].UTF8String);
}}
