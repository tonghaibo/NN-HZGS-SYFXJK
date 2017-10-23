function x_CMDCON(){var pub = new JavaPackage("com.xlsgrid.net.pub");

var cvshome = pub.EAOption.dynaDataRoot;

function arrayList2Str(al)
{
  var i = al.iterator();
  var hasNext = i.hasNext();
  var ret="";
  while (hasNext)
  {
      ret += i.next()+"\n";
      hasNext = i.hasNext();
  }  
  return ret;
}

var lastState=0; 
function doHostCMD(cmds,workpath,msg)
{
   var err=new java.util.ArrayList();
   try
   {
      lastState = //pub.EAFunc.
      	run(cmds,workpath,msg,err);
      /*if(lastState <0)
      {
        var emsg=arrayList2Str(err);
        if(msg!=null)
          emsg += arrayList2Str(msg);
        throw new Exception(emsg);
      }*/
      return arrayList2Str(err);//err.toString();
   }
   finally
   {
      err.clear();
   }
}

function docmd()
{
  var cmds= cmd.split(" ");
  //throw new Exception(cmds);
  var msg = new java.util.ArrayList();
  var errmsg = doHostCMD(cmds,cvshome,msg);
  //if(lastState!=0) throw new Exception(errmsg);
  return errmsg+arrayList2Str(msg);
}

function cvslogin()
{
  var errmsg = cvsAction(["login","-p",pwd],cvshome,null);
  if(lastState!=0)
    throw new Exception(errmsg);
}

//var taskTimeout = 1000 * 60 * 5;//time out 5 min
var taskTimeout = 1000 * 20;

function run(cmd,workdirectory, out, err)// throws EAException
  {
      function destroyTask(p) extends java.util.TimerTask() {
        var proc=p;
        
        function run() {
          if(proc != null)
            proc.destroy();
          proc = null;
        }
      }
    var line=null;
    var result=-1;
    //try {
      //set working directory
      var proc = java.lang.Runtime.getRuntime().exec(cmd,null,new java.io.File(workdirectory));
      var in=proc.getInputStream();
      if(err!=null)
      {
        var errout = new StreamGobbler(proc.getErrorStream(), err);            
        errout.start();
      }
      if(out!=null)
      {
        var stdout = new StreamGobbler(proc.getInputStream(), out);
        stdout.start();
      }
      var timer = new java.util.Timer(false);
      timer.schedule(new destroyTask(proc), new java.util.Date(System.currentTimeMillis() + taskTimeout));
      result = proc.waitFor();
      timer.cancel();
//    } catch (ex) {
//        throw new Exception(ex.toString());
//    }
    return result;
  }


function StreamGobbler(ais,aal) extends java.lang.Thread()
{
    var is;
    //var type;
    var al;
    
        this.is = ais;
        //this.type = type;
        this.al = aal;
    
    function run()
    {
        try
        {
            var isr = new java.io.InputStreamReader(is);
            var br = new  java.io.BufferedReader(isr);
            var line=null;
            while ( (line = br.readLine()) != null)
            {
              al.add(line);
            }
        } catch (ioe)
          {
            ioe.printStackTrace();  
          }
    }
}
}