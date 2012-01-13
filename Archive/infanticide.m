/*	Infanticide - NSTask "Watchdog" Keeps children processes happy (until their Parent should have killed them) — Read more
	©2012 mrGray.com - Creative Commons Copy Left   ***   "Stay Sexy.  Loves It." - xoxo, Alex Gray    */

#import <Foundation/Foundation.h>
int main(int argc, char *argv[]) {
	NSAutoreleasePool *parent = [[NSAutoreleasePool alloc] init];

/** GO CUSTOM */
	NSString *child = @"/usr/bin/php -S 0.0.0.0:8001 -t /usr/include/php"; /** change this to the path and arguments of your child daemon */
	int sleepytime = 10;   /** how long should the watchdog sleep?  aka: how aggressively should it watch your processes? */
	BOOL logYESpipeNO = NO;	/** if you send to NSPipe, you can much aroudn withoutput in Cocoa, otherise, it gets logged.
/** FIN CONF  */

	int parentPID = [[NSProcessInfo processInfo] processIdentifier]; 		// get parent PID (this app) to pass to watchdog
	NSTask *watchdog = [[[NSTask alloc] init] autorelease]; 				// setup task
    [watchdog setLaunchPath:@"infanticide.sh"];								// where is the infanticide script?
    [watchdog setArguments:[NSArray arrayWithObjects:child,sleepytime,parentPID,nil]]; //$1-4 for watchdog.
	if (logYESpipeNO == NO) {
 		NSPipe *pipe = [NSPipe pipe];
		NSFileHandle *fileHandle = [pipe fileHandleForReading];
		NSData *data = nil;
		NSMutableData *taskData = [NSMutableData data];
		[watchdog setStandardOutput: pipe];
		[watchdog setStandardError: pipe]];
	}
	[watchdog launch];
	if (logYESpipeNO == NO) {
		while ((data = [fileHandle availableData] && [data length]) {
    		[taskData appendData:data];	// do something with the data
 	}	}
	[watchdog waitUntilExit];
	NSString *taskDataString = [[NSString alloc] initWithData: taskData encoding: NSUnicodeStringEncoding];
	if (logYESpipeNO == NO) {
		if ([testTask terminationStatus] == 0) { 	NSLog(@"taskData = %@", taskDataString);  // success
		} else { NSLog(@"task failed");		 		NSLog(@"error = %@", taskDataString);  // failure
	}	}
	[parent release];
}
