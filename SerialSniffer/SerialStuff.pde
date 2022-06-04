/**************************************************************************************************************/
void openSerialPorts(boolean sayAllComPortNames){   
  int topOfMethod=getStackJavaLoc()-1; 
  int methodDeclareRow=2;
  //log.debug("returned topOfMethod="+topOfMethod);
    
  //StackTraceElement[] ste=Thread.currentThread().getStackTrace(); 
  //for(int ii=0;ii<ste.length;ii++){
  //  log.debug(String.format("top of method %2d %s",ii,ste[ii].toString()));
  //}
  //if (ports != null) port.stop();
  portNames = Serial.list();
  serialThisNames = new String [portNames.length];
  ports           = new Serial [portNames.length];
  portsBusy       = new boolean[portNames.length];
  for(int ii=0;ii<portNames.length;ii++){
    if(longestPortNameLength < portNames[ii].length()){
      longestPortNameLength = portNames[ii].length();
    }  
    serialThisNames[ii]="";
  }  
  logNCon2(Thread.currentThread().getStackTrace(),topOfMethod,methodDeclareRow,      "portNames has "+portNames.length+" member"+(1<portNames.length?"s":""));
  if(sayAllComPortNames){
    //printArray(portNames);
    for(int ii=0;ii<portNames.length;ii++){
      logNCon2(Thread.currentThread().getStackTrace(),topOfMethod,methodDeclareRow,      String.format("%2d %s",ii,portNames[ii]));
    }  
  } 
    
  int numPortsChecked=0;
  for(int ii=0;ii<portNames.length;ii++){
    //log.debug("doing portNames["+ii+"]="+portNames[ii]);
    //Map<String,String> props = Serial.getProperties(portNames[ii]);
    //log.debug("doing portNames["+ii+"]="+portNames[ii]+" which has "+props.size()+" properties");
    //for(Map.Entry<String, String> entry : props.entrySet()) {
    //  log.debug(String.format("OSP %8s key=%-20s  val=%20s",portNames[ii],entry.getKey(),entry.getValue()));
    //}
    if(knownGoodGrblComPort.equals(portNames[ii])){
      String matcher=portNames[ii];
      for(int jj=ii;jj>0;jj--){
        portNames[ii]=portNames[ii-1];
      }  
      portNames[0]=matcher;
    }
  }  
  for(int ii=0;ii<portNames.length;ii++){
    //log.debug("instancing Serial interface on port "+portNames[ii]);
    try {
      ports[ii] = new Serial(this, portNames[ii], 115200);
      log.debug(portNames[ii]+".active()="+(ports[ii].active()?"true ":"false"));
      log.debug(portNames[ii]+".available()="+ports[ii].available());
      ports[ii].bufferUntil('\n');
      serialThisNames[ii]=String.format("%s",ports[ii]);
      /**/log.debug(String.format("%12s gets serialThisNames[%2d]=%s",portNames[ii],ii,serialThisNames[ii])); 
      numPortsChecked+=1;
      portsBusy[ii]=false;
    } catch (RuntimeException re){
      if(re.getMessage().contains("Port busy"))
      logNCon2(Thread.currentThread().getStackTrace(),topOfMethod,methodDeclareRow,String.format("unable to handshake on port %-"+longestPortNameLength+"s",portNames[ii])+"   Port is busy");
      portsBusy[ii]=true;
      serialThisNames[ii]="none-is-busy";
    }
  } 
  if(0==numPortsChecked){
    logNCon2(Thread.currentThread().getStackTrace(),topOfMethod,methodDeclareRow, "\nwas unable to handshake on any COM port\n");    
  }  
  for(int ii=0;ii<portNames.length;ii++){
    log.debug(String.format("atEndOf openSerialPorts portNames[%2d]=%-"+longestPortNameLength+"s serialThisNames[%2d]= %s",ii,portNames[ii],ii,serialThisNames[ii]));
  }  
  log.debug("atEndOf openSerialPorts");
}
/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/
void serialEvent(Serial p){
  int port=portMatcher(p);
  if(-1!=port){
    String s = p.readStringUntil(10).trim();
    /**/log.debug(String.format("%-10s %s",portNames[port],s));
    
    /* early play around with checking individual characters */
    //String s = p.readStringUntil('$').trim(); /* this would not work, do not know why */
    //String s = p.readStringUntil('$'); /* this would not work, do not know why */    
    //String s = p.readString();
    //String s = p.readStringUntil(10);
    //log.debug("s is length "+s.length()+" s="+s);
    //for(int ii=0;ii<s.length();ii++){
    //  log.debug(String.format("%-10s pre  %2d %3d %c",portNames[port],ii,(byte)s.charAt(ii),s.charAt(ii)));
    //}
    //s=s.replace('$',' ').trim();
    //s=s.trim();
    //for(int ii=0;ii<s.length();ii++){
    //  log.debug(String.format("post %2d %3d %c",ii,(byte)s.charAt(ii),s.charAt(ii)));
    //}    
  
    /* This section output formatted values and response times from a HX711 load cell to the log1 .csv file */
    /* Commented out because it is not generally applicable */
    //time1=System.nanoTime();   
    //if(0<=serialCounter){
    //  String[] values=s.split(",");
    //  StringBuilder sb = new StringBuilder();
    //  for(int ii=0;ii<values.length;ii+=2){
    //    sb.append(values[ii]+","+values[ii+1]+(ii==(values.length-2)?"":"\n"));
    //  }  
    //  log1.debug(String.format("%s,%8.6f,%9.6f",sb,((time1-time0)/1000000000.),((time1-time2)/1000000000.)));
    //}
    //time0=time1;
     
    //if(s.startsWith("Grbl"))logNCon("see Grbl initialization with grblIndex="+grblIndex,"serialEvent",0);
    if( false==seeAnyCom){      
      msg="registering having seen first serialEvent from "+portNames[port];
      log.debug(msg);
      println(msg);
      seeAnyCom=true;
      time2=System.nanoTime();
    }
    if(eventCountLimit<serialCounter++){
      msg="saw the "+eventCountLimit+" serial evens in eventCountLimit";
      log.debug(msg);
      println(msg);
      exit();
    }
  } else {
    log.debug("got a SerialEvent before "+String.format("%s",p)+" was opened");
  }  
}
/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/
int portMatcher(Serial p){
  String target=String.format("%s",p);
  //log.debug("portMatcher="+target);
  int match=-1;
  for(int ii=0;ii<portNames.length;ii++){
    if(false==portsBusy[ii]){
      //log.debug(String.format("checking %2d %-33s vs %-33s",ii,serialThisNames[ii],target));
      //if(  (serialThisNames[ii] != null)
      //   &&(serialThisNames[ii].equals(target))
      //  ){
      if(serialThisNames[ii].equals(target)){    
        //log.debug("match");
        match=ii;
      } // else {
        //log.debug("no match");
      //}  
    } //else {
      //log.debug("port["+ii+"] is busy");
    //}  
  }
  //log.debug("@endOf PortMatcher match="+match);
  return(match);
}      
/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/
int getStackJavaLoc(){
  StackTraceElement[] ste=Thread.currentThread().getStackTrace();
  //for(int ii=0;ii<ste.length;ii++){
  //  log.debug(String.format("getStackJavaLoc() %2d %s",ii,ste[ii].toString()));
  //}
  int javaLoc;
  try {
     javaLoc = Integer.parseInt(ste[2].toString().substring(0,ste[2].toString().length()-1).substring(1+ste[2].toString().lastIndexOf(':')));
  }
  catch (NumberFormatException e) {
     javaLoc = 0;
  }
  //log.debug("javaLoc="+javaLoc);
  return(javaLoc);
}
/**************************************************************************************************************/
int getStackDeltaJavaLoc(StackTraceElement[] ste,int topOfMethod,int methodDeclareRow){
  int javaLoc;
  try {
     javaLoc = Integer.parseInt(ste[1].toString().substring(0,ste[1].toString().length()-1).substring(1+ste[1].toString().lastIndexOf(':')));
  }
  catch (NumberFormatException e) {
     javaLoc = 0;
  }
  //log.debug("inside getStackDeltaJavaLoc returning "+(javaLoc-topOfMethod+methodDeclareRow)+" javaLoc="+javaLoc+" topOfMethod="+topOfMethod+" methodDeclareRow="+methodDeclareRow);
  return(javaLoc-topOfMethod+methodDeclareRow);
}
/**************************************************************************************************************/
/* send to the log file and to the console, a string what was pushed to the port */
void logNCon2(StackTraceElement[] ste,int topOfMethod,int methodDeclareRow,   String s){
  println(s);
  //for(int ii=0;ii<ste.length;ii++){
  //  log.debug(String.format("%2d %s",ii,ste[ii].toString()));
  //}
  /*  ste[1]=  UsbSniffer.openSerialPorts(UsbSniffer.java:204)  */
  String nameOfCallingMethod=ste[1].toString().substring(1+ste[1].toString().indexOf('.'),ste[1].toString().indexOf('('));
  int rowWithinFileFromWhichThisWasCalled=getStackDeltaJavaLoc(ste,topOfMethod,methodDeclareRow);
  log.debug(
    String.format(
      "%2d %s   %s",
      rowWithinFileFromWhichThisWasCalled,
      nameOfCallingMethod, 
      s
    )
  );
}  
/**************************************************************************************************************/
