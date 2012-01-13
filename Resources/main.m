
/*	Infanticide - NSTask "Watchdog" Keeps children processes happy (until their Parent should have killed them) — Read more
 ©2012 mrGray.com - Creative Commons Copy Left   ***   "Stay Sexy.  Loves It." - xoxo, Alex Gray    */

#import <Foundation/Foundation.h>

int main (int argc, const char * argv[])
{
	@autoreleasepool {

/** GO CUSTOM */
	/** change this to the path and arguments of your child daemon */
	NSString *child = @"telnet google.com "; 
	/** how long should the watchdog sleep?  aka: how aggressively should it watch your processes? */	
	int sleepyTime = 5; 
/** FIN CONF  */
	
	int parentPID = [[NSProcessInfo processInfo] processIdentifier]; 		// get parent PID (this app) to pass to watchdog
	NSString *theBabyKiller = [NSString stringWithFormat:@"SLEEPYTIME=%i; PARENTPID=%i; GoSubProcess () { %@ & CHILDPID=$!;	if kill -0 $!; then echo \"Child is alive at $!\"; else echo \"couldnt start child.  dying.\"; exit 2; fi; babyRISEfromtheGRAVE; }; babyRISEfromtheGRAVE () { echo \"PARENT is $PARENTPID\";	while kill -0 $PARENTPID; do echo \"Parent is alive, $PARENTPID is it's PID\"; sleep $SLEEPYTIME; if kill -0 $CHILDPID;	then echo \"Child is $CHILDPID and is alive.\"; sleep $SLEEPYTIME;	else echo \"Baby, pid $CHILDPID died!  Respawn!\"; GoSubProcess; fi; done; logger \"My Parent Process, aka $PARENTPID died!\"; logger \"I'm killing my baby, $CHILDPID, and myself.\"; kill -9 $CHILDPID; exit 1; }; GoSubProcess; exit 0",sleepyTime,parentPID,child]; 

	NSTask *watchdog = [[[NSTask alloc] init] autorelease]; // setup task
	[watchdog setLaunchPath:@"/bin/sh"];
	[watchdog setArguments:	[NSArray arrayWithObjects:@"-c", theBabyKiller, nil]];
	
	[watchdog launch];
	[watchdog waitUntilExit];

    return 0;
	}
}