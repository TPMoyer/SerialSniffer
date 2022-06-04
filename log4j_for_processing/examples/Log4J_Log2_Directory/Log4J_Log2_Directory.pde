/**
 * Log4J_Log2_Directory
 * implementation of log4j for processing 
 * This file is modest jog4j code 
 * laminated onto    examples/data/CharacterStrings
 *
 * It creates a    timeStampUnique_SketchDirectory.log    file in c:\logs       on windows machines
 * It creates a    timeStampUnique_SketchDirectory.log    file in /home/pi/logs on non-windows machines
 *
 * if the target directory does not exist, it will be created.
 *
 * it also creates a SketchDirectory.log file (name never changes run after run) in that same target directory. 
 *
 * log4j is an offering from the Apache Software Foundataion https://logging.apache.org/log4j/2.x/
 * Thank you Jake Seigel for having been the pathfinder into Processing:   https://jestermax.wordpress.com/2014/06/09/log4j-4-you/
 */
import org.apache.log4j.*;
import java.util.Date;
import java.text.SimpleDateFormat;
Logger logM  = Logger.getLogger("Master");
Logger log  = Logger.getLogger("Ancillary0");
Level thresholdLevel=Level.TRACE;

/**
 * Characters Strings. 
 *  
 * The character datatype, abbreviated as char, stores letters and 
 * symbols in the Unicode format, a coding system developed to support 
 * a variety of world languages. Characters are distinguished from other
 * symbols by putting them between single quotes ('P').<br />
 * <br />
 * A string is a sequence of characters. A string is noted by surrounding 
 * a group of letters with double quotes ("Processing"). 
 * Chars and strings are most often used with the keyboard methods, 
 * to display text to the screen, and to load images or files.<br />
 * <br />
 * The String datatype must be capitalized because it is a complex datatype.
 * A String is actually a class with its own methods, some of which are
 * featured below. 
 */

char letter;
String words = "Begin...";
String priorWords="";

void setup() {
  size(640, 360);
  initLog4j();

  // Create the font
  textFont(createFont("SourceCodePro-Regular.ttf", 36));
}

void draw() {
  background(0); // Set background to black

  // Draw the letter to the center of the screen
  textSize(14);
  text("Click on the program, then type to add to the String", 50, 50);
  text("Current key: " + letter, 50, 70);
  text("The String is " + words.length() +  " characters long", 50, 90);
  
  textSize(36);
  text(words, 50, 120, 540, 300);
  
  /* need some criterion to prevent logging durring every execution of draw() */ 
  if(!words.equals(priorWords)){
    log.info(String.format("frameCount=%6d String is now %3d char long. String=%s",frameCount,words.length(),words));
    priorWords=words;
  }  
}

void keyTyped() {
  // The variable "key" always contains the value 
  // of the most recent key pressed.
  if ((key >= 'A' && key <= 'z') || key == ' ') {
    letter = key;
    words = words + key;
    // Write the letter to the console
    println(key);
  }
}

/*********************************************************************************************************************************/
void initLog4j(){
  /* follows the pathfinding from Jake Seigel:   https://jestermax.wordpress.com/2014/06/09/log4j-4-you/ 
   *
   * The ultimate success for a debugger-logger is when 
   * a client sees your debug log, 
   * and requests you redirect a portion of your log 
   * become customer requested output. 
   *
   * The SublimeText editor is recommended for viewing log files, as it will automatically update it's display of a file when the underlying file changes. 
   */
   
  String[] commandWords=System.getProperty("sun.java.command").split(" ");
  SimpleDateFormat sdf = new SimpleDateFormat("yyyy_MM_dd.HH_mm_ss");
  String logFileNamePrepender= String.format("%s_",sdf.format(new Date()));
  String logFileNameEndPart=commandWords[commandWords.length-1]+".log";
  
  /* Several output patterns are log4j supported. 
   * Pattern documentation is at: 
   * https://www.codejava.net/coding/common-conversion-patterns-for-log4js-patternlayout
   */
  //String masterPattern = "[%c{1}], %d{HH:mm:ss}, %-5p, {%C}, %m%n"; /* category_firstMember time debug_level Fully_qualified_class_name */
  //String masterPattern = "%-5p %8r %3L %c{1} - %m%n";  /* debug_level miliseconds lineNumber category_firstMember  - message    */
  //String masterPattern = "%-5p - %m%n"; /* debug_level - message */
  //String masterPattern = "%-5p %8r - %m%n"; /* debug_level miliseconds - message  */
  String masterPattern = "%-5p %8r %M - %m%n"; /* debug_level miliseconds Originating_Method  - message    */
  
  /* the following line is instanced in the app header for the main processing app, so as to have app wide scope */
  //Logger log  = Logger.getLogger("Master"); /* Thank you Jake Seigel   https://jestermax.wordpress.com/2014/06/09/log4j-4-you/   */
  FileAppender fa0 = new FileAppender();
  fa0.setFile((System.getProperty("os.name").toLowerCase().startsWith("win")?"c:\\logs\\":sketchPath("/home/pi/logs/"))+logFileNamePrepender+logFileNameEndPart);  
  fa0.setLayout(new PatternLayout(masterPattern));
  fa0.setThreshold(Level.DEBUG);
  fa0.setAppend(false);
  fa0.activateOptions();  
  Logger.getRootLogger().addAppender(fa0); /* this causes all loggers to be collected into the file pointed to by fa0 */
  //log.addAppender(fa0); /* this causes the fa0 file to get only the content sent to log */
 
  FileAppender fa1 = new FileAppender();
  fa1.setFile((System.getProperty("os.name").toLowerCase().startsWith("win")?"c:\\logs\\":sketchPath("/home/pi/logs/"))+logFileNameEndPart);  
  fa1.setLayout(new PatternLayout(masterPattern));
  fa1.setThreshold(Level.DEBUG);
  fa1.setAppend(false);
  fa1.activateOptions();  
  log.addAppender(fa1); /* this causes the fa1 file to get only the content sent to log */
  
  log.trace("log checking ability to write at trace level"); /* not believed to be part of log4j, included here for future compatiblity, as is IS part of log4j2  */
  log.debug("log checking ability to write at debug level");
  log.info ("log checking ability to write at info  level");
  log.warn ("log checking ability to write at warn  level");
  log.error("log checking ability to write at error level");
  log.fatal("log checking ability to write at fatal level\n");
  
  /* useful line iff (if and only if) you are doing the advanced thing of running processing from within the Eclipse IDE 
   * log.fatal("log checking ability to write at fatal level\nIf you see this in the Eclipse console, your log4j2.xml was not active (it should be in /src/main/resources)\n"); 
   */
  
  try{    
    String pathOnward=System.getProperty("sun.java.command").substring(System.getProperty("sun.java.command").indexOf("path=")+5);
    String[] words=pathOnward.split(" ");
    /* trying to leave a trail of breadcrumbs as to the source of the log file */
    log.info("this log file was created by "+words[0]+File.separator+words[words.length-1]+".pde\n");
    
    //  Here is a trick for those wishing to become adept logger-debuggers :
    //  toggle sections of debug code OFF by using an editor to change /**/ to //    
    //  toggle sections of debug code ON  by using an editor to change //   to /**/
    //
    //  Tom Moyer found it useful to leave legacy // commented debug code sections scattered throughout his code for two reasons.
    //     1) These sections serve in partial fullfilment of the inevitable failing to leave enough comments.
    //     2) Later when you come upon someone else's code (or come back to your own code after a long absence) and wonder:    WTF was going on here?
    //         The logging was adequate to diagnose whatever concern the author had while writing/debugging the code,
    //             so that same legacy debug section might serve to elucidate the code function.
    //         So re-activating these sections by changing // to /**/  can help figure it out.
    //         Changing // to /**/ is prefered over simply erasing the // because 
    //            you leave markers as to which rows can be re-commented after you are done with debugging that section of code

    /* this is an "ON" section of code. */
    /**/log.debug("\n\n\n\nNotice the difference between the behavior of the set of four \"\\n\"s at the beginning of this line vs\nthe behavior at the end of the log.fatal() above");
    /**/log.debug("Also notice the different logger threshold (DEBUG) for this section\n");
    /**/for(int ii=0;ii<commandWords.length;ii++){
    /**/ //log.debug(String.format("%2d %s",ii,commandWords[ii]));
    /**/   log.debug(String.format("%2d %s",ii,commandWords[ii]+(ii==commandWords.length-1?"\n":"")));   /* sorry; couldnt resist a bit of admittadly show-offish (tending toward write-only) code to add line return to the last row of this indexed output block */
    /**/}
    
    /* this is an "OFF" section of code.  */
    //log.debug("\n\nNotice the difference between the behavior of the pair of \"\\n\"s at the beginning of this line vs\nthe behavior at the end of the log.fatal() above");
    //log.debug("Also notice the different logger threshold (DEBUG) for this section ");
    //for(int ii=0;ii<commandWords.length;ii++){
    // //log.debug(String.format("%2d %s",ii,commandWords[ii]));
    //   log.debug(String.format("%2d %s",ii,commandWords[ii]+(ii==commandWords.length-1?"\n":"")));   /* sorry; couldnt resist a bit of admittadly show-offish (tending toward write-only) code to add line return to the last row of this indexed output block */
    //}
     
  } catch (Exception e) {     
    e.printStackTrace();
  }
}
