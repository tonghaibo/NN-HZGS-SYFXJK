function x_WEBCVS(){var pub = new JavaPackage("com.xlsgrid.net.pub");
//var cvsclient = pub.EAOption.get("cvsclient");
//if(cvsclient=="") 
//var cvsclient="/usr/bin/cvs";
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

//================================================================// 
// 函数：cvsAction
// 说明：基本cvs命令入口
// 参数：
// 返回：cvs -d :pserver:gld@222.72.61.165:/cvsroot
// 样例：
// 作者：
// 创建日期：12/01/06 14:28:23
// 修改日志：
//================================================================//
var lastCvsState=0; 
function cvsAction(cmds,path,msg)
{
   var err=new java.util.ArrayList();
   try
   {
      var cmd = [cvsclient,"-z","6"];
      if(root!="") 
        cmd = cmd.concat(["-d",root]);
      lastCvsState = pub.EAFunc.run(cmd.concat(cmds),path,msg,err);
      if(lastCvsState<0)
      {
        var emsg=arrayList2Str(err);
        if(msg!=null)
          emsg += arrayList2Str(msg);
        throw new Exception(emsg);
      }
      return arrayList2Str(err);//err.toString();
   }
   finally
   {
      err.clear();
   }
}

function cvslogin()
{
  var errmsg = cvsAction(["login","-p",pwd],cvshome,null);
  if(lastCvsState!=0)
    throw new Exception(errmsg);
}

function cvslogout()
{
cvsAction(["logout"],cvshome,null);
}

//================================================================// 
// 函数：trans
// 说明：翻译cvs返回的状态，并给出建议操作
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：12/01/06 14:27:46
// 修改日志：
//================================================================// 
function trans(state)
{
  if(state=="Up-to-date")
    return "= 已同步;0";
  else if(state=="Needs Checkout")
    return "-+ 未取出;4";
  else if(state=="Needs Patch")
    return "-u 未同步;4";
  else if(state=="Needs Merge")
    return "#  有冲突;7";
  else if(state=="Locally Modified")
    return "+ 已修改;3";
  else if(state=="Locally Added")
    return "++已加入;3";
  else if(state=="?")
    return "+-未加入;1";
  else if(state=="-")
    return "--缺少;2";
  else// if(state=="!")
    return state+";4";//! 已删除;3";
}

//================================================================// 
// 函数：getFileState
// 说明：获取某个目录下的文件状态
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：12/01/06 14:27:25
// 修改日志：
//================================================================// 

function getFileState()
{
  var msg=new java.util.ArrayList();
  var sSUBFLD="-R";
  if(SUBFLD==0)
  sSUBFLD="-l";
  var errmsg = cvsAction(["-Q","status",sSUBFLD],path,msg);
  if(lastCvsState!=0)
    throw new Exception(errmsg);
  
  //throw new Exception(msg.toString());
  var ds = new pub.EAXmlDS();
  var c = msg.size();
  var rc = -1;
  var filestatemsg="Status:";
  var 仓库路径 = pub.EAFunc.Replace(path,"\\","/");//path.replace("/\\\\/","/");
  仓库路径 = 仓库路径.substring(仓库路径.indexOf("/"));
  //throw new Exception(仓库路径);
  for(var i=0;i<c;i++)
  //for(var i=c-1;i>=0;i--)
  {
    var tmp = msg.get(i);
    var file="";
    var stat="?";
    if(tmp!="")
    if(tmp.elementAt(0)=="?")
    {
      file = tmp.substring(2);
    }
    else
    {
      var p = tmp.indexOf(filestatemsg);
      if(p>0)
      {
        file=tmp.substring(6,p);
        //throw new Exception(";"+file.substring(0,7)+";");
        if(file.substring(0,7)=="no file")//test "no file"
        {
          stat=tmp.substring(p+1+filestatemsg.length());
          if(stat=="Locally Removed")
          stat="!";
          else
          stat="-";
          file=file.substring(8);
        }
        else
        stat=tmp.substring(p+1+filestatemsg.length());
      }
      if(file!="") 
      {
        i+=3;
        var tmp = msg.get(i);
        var p = tmp.indexOf(仓库路径);
        var p1 = tmp.indexOf(",");
        if(p>0)
        file = tmp.substring(p+仓库路径.length()+1,p1);  
        //throw new Exception(仓库路径+","+p+","+tmp+","+file);
      }
    }
    if(file!="")
    {
      ds.AddRow(rc++);
      var action = pub.EAFunc.SplitString(trans(stat),";");
      ds.setValueAt(rc,"stat",action[0]);
      ds.setValueAt(rc,"file",file.replace("/\\s*$/",""));//trimRight
      ds.setValueAt(rc,"action",action[1]);
    }
  }
  return ds.GetXml();
}


var foldid;
//================================================================// 
// 函数：getTreeCtlXml
// 说明：取目录结构
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：12/01/06 14:27:04
// 修改日志：
//================================================================// 
function getTreeCtlXml(root,xml)
{
  var f = root;
  var folds = f.listFiles();
  java.util.Arrays.sort(folds);
  var c = folds.length();
  //throw new Exception(c);
  for(var i=0;i<c;i++)
  {
    f=folds[i];
    if(f.isDirectory())
    {
      foldid++;
      xml += "<"+f.getName() +" "+f.getAbsolutePath()+","+foldid+">"  
            + getTreeCtlXml(f,"")
            + "</"+f.getName() +">";
    }
  }
  return xml;
}

//================================================================// 
// 函数：getFolderTreeXml
// 说明：取cvs根目录下的目录结构
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：12/01/06 14:26:21
// 修改日志：
//================================================================// 
function getFolderTreeXml()
{
  foldid=0;
  if(root=="")
    root = cvshome;
  var f = new java.io.File(root);
  var xml = "<"+f.getName() +" "+root+","+foldid+">"  
      + getTreeCtlXml(f,"")
      + "</"+f.getName() +">";
  return xml;
}


//================================================================// 
// 函数：fileAction
// 说明：cvs操作入口
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：12/01/06 14:25:46
// 修改日志：
//================================================================// 
function fileAction(basicCMD,root,files,delfiles)
{
  var fArray = pub.EAFunc.SplitString(files,",");
  if(delfiles)
  {
    for(var i=0;i<fArray.length();i++)
    {
      var file = new java.io.File(root+"/"+fArray[i]);
      var r=file.delete();
      //throw new Exception(r);
    }
  }
  basicCMD = basicCMD.concat(fArray);
  var msg = new java.util.ArrayList();
  var ret = cvsAction(basicCMD,root,msg);
  if(msg.size()>0)
    ret += "\n" + msg.toString();
  return ret+arrayList2Str(msg);//ret;
}

//================================================================// 
// 函数：doaction
// 说明：执行客户端的操作请求
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：12/01/06 14:25:42
// 修改日志：
//================================================================// 
function doaction()
{
  var ret = "";
  if (comment=="") comment="\"\"";
  if(f0!="")
    ret+= fileAction(["add","-kb"],fileroot,f0,false);
  if(f1!="")
    ret+= fileAction(["add"],fileroot,f1,false);
  if(f2!="")
    ret+= fileAction(["update"],fileroot,f2,false);
  if(f3!="")
    ret+= fileAction(["commit","-m", comment],fileroot,f3,false);
  if(f4!="")
    ret+= fileAction(["update"],fileroot,f4,false);
  if(f5!="")
    ret+= fileAction(["remove","-f"],fileroot,f5,false);
  if(f6!="")
    ret+= fileAction(["update","-C"],fileroot,f6,true);
  return ret;
}

function checkout()
{
   //var outpath = dbpath;
   return fileAction(["checkout","-d",outpath,dbpath],fileroot,"",false);
}

function cvsdiff()
{
  var msg = new java.util.ArrayList();
  var ret = cvsAction(["diff","-N","-c",fn],fileroot,msg);
  //throw new Exception("ddd:"+msg.size());
//  if(msg.size()>0)   ret += "\n" + msg.toString();
  return ret+arrayList2Str(msg);
}


}