/*
  Copyright (c) 2019 2021 Thomas P Moyer

  Program to sniff the serial ports
  It prints minimal startup information to the console
  The stream of input from the serial port(s) is sent to a log file.
  If nothing is recieved for timeOut seconds (currently set at 10), bail out.

  UsbSniffer is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with Grbl4P.  If not, see <http://www.gnu.org/licenses/>.
*/

String knownGoodGrblComPort="COM11";    /* Another version of the SerialEvent was looking for a specific arduino: this allowed that port to be first checked */

import processing.serial.*;
import java.time.Duration;
import java.time.Instant;
import java.awt.Font;
import java.text.NumberFormat;
import java.text.DecimalFormat;
import java.util.Locale;
import java.util.Map;
import java.io.BufferedReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.math.*;

String  frameTitle       = "Serial Sniffer";
int     frameRateLimit=10;  /* the multiple instances of SerialEvent() are where the action happens, so throttle the main window */
boolean heartBeat        = true;
int     framesPerHeartBeat = 30;
int     heartBeatFrameCount=0;

double  timeOut=10.0;
String msg="";

/* these four [] are aligned along the Serial.list of ports */ 
String [] portNames=null;
String [] serialThisNames=null;
Serial [] ports=null;
boolean[] portsBusy;
boolean seeAnyCom=false;
int longestPortNameLength=0;
int numReadingsPerFputf=10;
int serialCounter=-1;
int eventCountLimit=100;

Instant appStart = Instant.now();
Long time0=System.nanoTime(); /* initialized at the end of setup(), reset at end of every draw */
Long time1=System.nanoTime(); /* reset to the beginning of each SerialEvent */
Long time2=System.nanoTime(); /* set at occurance of first SerialEvent */
//Long time3=System.nanoTime(); /* reset at beginning of every instance of verbose logging */

/**********************************************************************************************************/
void setup(){
  size(640,480);
  background(212,208,200);
  boolean windows=System.getProperty("os.name").toLowerCase().startsWith("win");
  //surface.setLocation(windows?1300:1020,windows?200:50);
  surface.setLocation(windows?300:100,windows?0:50);
  initLog4j();
  //writeCsvHeader();
  time0=System.nanoTime();
  time2=time0;
  openSerialPorts(true);  
  /**/frameRate(frameRateLimit);
  textSize(30);  
  fill(0,0,0);
  
  msg="at end of setup";
  println(msg);
  log.debug(msg);
  
}
/**********************************************************************************************************/
void draw(){
  //log.debug("draw 0");
 
  background(212,208,200);
  surface.setTitle(frameTitle+"    "+round(frameRate) + " fps "+(heartBeat?"+":"-"));
  
  if(heartBeatFrameCount > framesPerHeartBeat){
    heartBeat=!heartBeat;
    heartBeatFrameCount=0;
    //log.debug("heartBeat="+(heartBeat?"True":"False"));
  }
  heartBeatFrameCount++;
  
  text("This space intentionally left blank",40,180);
  text("The draw loop, and the console are too slow",40,240);
  text("feedback from the serial port(s) is in",40,280);
  text("   //logs//Always_Same_Name_logger.log",40,320);

  if(  (false==seeAnyCom)
   &&(timeOut < Duration.between(appStart,Instant.now()).toMillis()/1000)
  ){
    msg=String.format("no events from any serial port (com or serial) after %7.3f seconds\n                      exiting",timeOut);
    println(msg);
    log.fatal(msg);
    System.exit(1);
  }
}
/**********************************************************************************************************/
