# SerialSniffer
Processing 4 https://processing.org/download sketch to collect input from serial ports (both com and uart)

Sketch will sniff all the com and serial (uart) ports on the computer and record the first eventCountLimit (default as 100)
in a log file    //logs/Always_Same_Name_Logger.log

Am in the process of putting the log4j_for_processing up as a tools library in processing, but it has not gone through yet.
Did included the library in this github repo, 
To use the sketch you'll need to copy the log4j_for_processing directory to the location of your Processing libraries.
On my windows machine the log4j_for_processing directory goes under   C:\Users\$your-name-here\Documents\Processing\libraries  
On my raspberry pi's  the log4j_for_processing directory goes under   /home/pi/sketchbook/libraries
