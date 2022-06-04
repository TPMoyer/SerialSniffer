
/**
 * Log4J_A Minimal 
 * implementation of log4j for processing * 
 * This file is minimal jog4j code added to one of the core Processing examples: 
 *       Basics/Data/CharacterStrings
 *
 * It creates an   always_Same_Name.log     file in the processing sketch source directory 
 *
 * log4j is an offering from the Apache Software Foundataion https://logging.apache.org/log4j/2.x/
 * Thank you Jake Seigel for having been the pathfinder into Processing:   https://jestermax.wordpress.com/2014/06/09/log4j-4-you/
 */
import org.apache.log4j.*;
Logger log  = Logger.getLogger("Master"); 
Level thresholdLevel=Level.TRACE;
String logFID="always_Same_Name.log";

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
  /* 
   * The ultimate success for a debugger-logger is when 
   * a client sees your debug log, 
   * and requests you redirect a portion of your log to
   * become customer requested output. 
   *
   * The SublimeText editor is recommended for viewing log files, as it will automatically update it's display of a file when the underlying file changes. 
   */
  
  /* get the directory of the source .pde    */
  String sourceDir=System.getProperty("sun.java.command").substring(System.getProperty("sun.java.command").indexOf("path=")+5).substring(0,System.getProperty("sun.java.command").substring(System.getProperty("sun.java.command").indexOf("path=")+5).indexOf(" "));
  
  /* Several output patterns are log4j supported. 
   * Pattern documentation is at: 
   * https://www.codejava.net/coding/common-conversion-patterns-for-log4js-patternlayout
   */
  //String masterPattern = "[%c{1}], %d{HH:mm:ss}, %-5p, {%C}, %m%n"; /* category_firstMember time debug_level Fully_qualified_class_name */
  //String masterPattern = "%-5p %8r %3L %c{1} - %m%n";  /* debug_level miliseconds lineNumber category_firstMember  - message    */
  //String masterPattern = "%-5p - %m%n"; /* debug_level - message */
  //String masterPattern = "%-5p %8r - %m%n"; /* debug_level miliseconds - message  */
  String masterPattern = "%-5p %8r %M - %m%n"; /* debug_level miliseconds Originating_Method  - message    */

  FileAppender fa0 = new FileAppender();
  fa0.setFile(sourceDir+File.separator+logFID);  
  fa0.setLayout(new PatternLayout(masterPattern));
  fa0.setThreshold(thresholdLevel);
  fa0.setAppend(false);
  fa0.activateOptions();  
  log.addAppender(fa0); /* this causes the fa0 file to get the content sent to fileAppender0 */
  
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
    print(pathOnward);
    String[] words=pathOnward.split(" ");
    /* trying to leave a trail of breadcrumbs as to the source of the log file */
    log.debug("this log file was created by "+words[0]+File.separator+words[words.length-1]+".pde\n");
    
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
    /**/String[] commandWords=System.getProperty("sun.java.command").split(" ");
    /**/log.debug("\n\n\n\nNotice the difference between the behavior of the set of four \"\\n\"s at the beginning of this line vs\nthe behavior at the end of the log.fatal() above");
    /**/log.debug("Also notice the different logger threshold (DEBUG) for this section\n");
    /**/for(int ii=0;ii<commandWords.length;ii++){
    /**/ //log.debug(String.format("%2d %s",ii,commandWords[ii]));
    /**/   log.debug(String.format("%2d %s",ii,commandWords[ii]+(ii==commandWords.length-1?"\n":"")));   /* sorry; couldnt resist a bit of admittadly show-offish (tending toward write-only) code to add line return to the last row of this indexed output block */
    /**/}
    
    /* this is an "OFF" section of code.  */
    //String[] commandWords=System.getProperty("sun.java.command").split(" ");
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
