/* Thank you Jake Seigel for the processing log4j connectivity!    
 * I'm a logggerDebugger and this was key to being able to 
 * dig myself out of several/many  holes/traps/mistakes/typos:   https://jestermax.wordpress.com/2014/06/09/log4j-4-you/    */
 
/* note that you do need to put an instance of
 *    initLog4j();
 * in your code, before logging can occur.  
 * Somewhere early in setup is recommended 
 */
 
import org.apache.log4j.*;
Logger log  = Logger.getLogger("Master");
//Logger log1  = Logger.getLogger("PureReadings");

/*********************************************************************************************************************************/
void initLog4j(){
  /* Log stuff follows the input from Jake Seigel:   https://jestermax.wordpress.com/2014/06/09/log4j-4-you/ */
  
  /* Tried out several message patterns till I found one I liked   */
  //String masterPattern = "[%c{1}], %d{HH:mm:ss}, %-5p, {%C}, %m%n";
  //String masterPattern = "%-5p %8r %3L %c{1} - %m%n";  
  //String masterPattern = "%-5p - %m%n"; /* source - message */
  //String masterPattern = "%-5p %8r - %m%n"; /* source miliseconds - message *?  */
  String masterPattern = "%-5p %8r %M - %m%n"; /* priority miliseconds Originating_Method  - message *?  */
  
  SimpleDateFormat sdf = new SimpleDateFormat("yyyy_MM_dd.HH_mm_ss");
  String logFileNamePrepender= String.format("%s_",sdf.format(new Date()));
  String logFileNameEndPart="Grbl_Logger.log";
  logFileNamePrepender="";
  logFileNameEndPart="Always_Same_Name_Logger.log";
  
  /* the following line is instanced in the app header for the main processing app, so as to have app wide scope */
  //Logger log  = Logger.getLogger("Master"); /* Thank you Jake Seigel   https://jestermax.wordpress.com/2014/06/09/log4j-4-you/   */
  FileAppender fa0 = new FileAppender();
  //String fileName="Grbl_Logger.log";
  fa0.setFile((System.getProperty("os.name").toLowerCase().startsWith("win")?"c:\\logs\\":sketchPath("/home/pi/logs/"))+logFileNamePrepender+logFileNameEndPart);  
  fa0.setLayout(new PatternLayout(masterPattern));
  fa0.setThreshold(Level.TRACE);
  fa0.setAppend(false);
  fa0.activateOptions();  
  //Logger.getRootLogger().addAppender(fa0); /* this causes all loggers to be collected into the file pointed to by fa0 */
  log.addAppender(fa0); /* this causes the fa0 file to get only the content sent to log */
  
  log.trace("log checking ability to write at trace level"); /* not believed to be part of log4j, maby it came in with log4j2???  */
  log.debug("log checking ability to write at debug level. note that the log.trace (row above) did not reach the log file");
  log.info ("log checking ability to write at info  level");
  log.warn ("log checking ability to write at warn  level");
  log.error("log checking ability to write at error level");
  log.fatal("log checking ability to write at fatal level\nIf you see this in the Eclipse console, your log4j2.xml was not active (it should be in /src/main/resources)\n");
  try{
    log.info("this log file was created by "+System.getProperty("sun.java.command").substring(System.getProperty("sun.java.command").indexOf("path=")+5));
    //log.info("full sun.java.command is on next row:\n"+System.getProperty("sun.java.command"));
   } catch (Exception e) {
    e.printStackTrace();
  }
  
  /* set up a second log file to be .csv   to allow "look at the data" analysis  */
  //String ancillaryPattern="%m%n"; /* message only */
  ///* the following line is instanced in the header for the main processing app, so as to have app wide scope */ 
  ///*Logger log1 = Logger.getLogger("Ancillary0"); /* Thank you Jake Seigel   https://jestermax.wordpress.com/2014/06/09/log4j-4-you/   */
  //logFileNameEndPart="readings.csv";
  //FileAppender fa1 = new FileAppender();
  //fa1.setFile((System.getProperty("os.name").toLowerCase().startsWith("win")?"c:\\logs\\":sketchPath("/home/pi/logs/"))+logFileNamePrepender+logFileNameEndPart); 
  //fa1.setLayout(new PatternLayout(ancillaryPattern));
  //fa1.setThreshold(Level.DEBUG);
  //fa1.setAppend(false);
  //fa1.activateOptions();
  //log1.addAppender(fa1);
 
  
  //FileAppender fa2 = new FileAppender();
  //String fileName2="logger2.log";
  //fa2.setFile(System.getProperty("os.name").toLowerCase().startsWith("win")?"c:\\logs\\"+fileName2:sketchPath("/home/pi/logs/"+fileName2));
  //fa2.setLayout(new PatternLayout(ancillaryPattern));
  //fa2.setThreshold(Level.DEBUG);
  //fa2.setAppend(false);
  //fa2.activateOptions();
  //log2.addAppender(fa2);
  
  //FileAppender fa3 = new FileAppender();
  //String fileName3="logger3.log";
  //fa3.setFile(System.getProperty("os.name").toLowerCase().startsWith("win")?"c:\\logs\\"+fileName3:sketchPath("/home/pi/logs/"+fileName3));
  //fa3.setLayout(new PatternLayout(ancillaryPattern));
  //fa3.setThreshold(Level.DEBUG);
  //fa3.setAppend(false);
  //fa3.activateOptions();
  //log3.addAppender(fa3);
  
  //log1.trace("log1 checking ability to write at trace level"); /* not believed to be part of log4j, maby it came in with log4j2???  */
  //log1.debug("log1 checking ability to write at debug level");
  //log1.info ("log1 checking ability to write at info  level");
  //log1.warn ("log1 checking ability to write at warn  level");
  //log1.error("log1 checking ability to write at error level");
  //log1.fatal("log1 checking ability to write at fatal level\nIf you see this in the Eclipse console, your log4j2.xml was not active (it should be in /src/main/resources)");  
}
/*********************************************************************************************************************************/
//void writeCsvHeader(){
//  log1.debug("reading,delta_us,deltaT Group,cum Time");
//}
/*********************************************************************************************************************************/
