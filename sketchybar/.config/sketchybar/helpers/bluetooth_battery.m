// Read only the standard Battery Service on devices already connected to macOS.
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@interface BatteryReader : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>
@property(nonatomic, strong) CBCentralManager *central;
@property(nonatomic, strong) NSMutableArray<CBPeripheral *> *devices;
@property(nonatomic, strong) NSMutableDictionary *values;
@property(nonatomic, strong) NSMutableSet *pending;
@property(nonatomic) BOOL ready;
@end
@implementation BatteryReader
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
 self.ready=YES;
 if(central.state!=CBManagerStatePoweredOn)return;
 NSArray *devices=[central retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"180F"],[CBUUID UUIDWithString:@"1812"]]];
 self.devices=[devices mutableCopy];
 for(CBPeripheral *device in devices)[self.pending addObject:device.identifier];
 for(CBPeripheral *device in devices){device.delegate=self; [central connectPeripheral:device options:nil];}
}
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)device {
 [device discoverServices:@[[CBUUID UUIDWithString:@"180F"]]];
}
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)device error:(NSError *)error {
 [self.pending removeObject:device.identifier];
}
- (void)peripheral:(CBPeripheral *)device didDiscoverServices:(NSError *)error {
 if(error || !device.services.count){[self.pending removeObject:device.identifier];return;}
 for(CBService *service in device.services) [device discoverCharacteristics:@[[CBUUID UUIDWithString:@"2A19"]] forService:service];
}
- (void)peripheral:(CBPeripheral *)device didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
 if(error || !service.characteristics.count){[self.pending removeObject:device.identifier];return;}
 for(CBCharacteristic *characteristic in service.characteristics) [device readValueForCharacteristic:characteristic];
}
- (void)peripheral:(CBPeripheral *)device didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
 if(!error && characteristic.value.length && device.name){
  unsigned char value=((const unsigned char*)characteristic.value.bytes)[0];
  if(value<=100) self.values[device.name]=@(value);
 }
 [self.pending removeObject:device.identifier];
}
@end
int main(void){@autoreleasepool{
 BatteryReader *reader=[BatteryReader new];reader.values=[NSMutableDictionary dictionary];reader.pending=[NSMutableSet set];
 reader.central=[[CBCentralManager alloc] initWithDelegate:reader queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:@NO}];
 NSDate *end=[NSDate dateWithTimeIntervalSinceNow:5];
 while(end.timeIntervalSinceNow>0 && (!reader.ready || reader.pending.count>0))[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.05]];
 NSData *data=[NSJSONSerialization dataWithJSONObject:reader.values options:0 error:nil];
 puts([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding].UTF8String);
 for(CBPeripheral *device in reader.devices)[reader.central cancelPeripheralConnection:device];
}}
