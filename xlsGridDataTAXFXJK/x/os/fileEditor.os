function x_fileEditor(){/* 使用顶层中间件目录
var realpath = pub.EAOption.getRealpath();
    var a = realpath.indexOf(java.io.File.separatorChar);
    var r = java.io.File.separator; 
    if(a>=0)
      r = realpath.substring(0,a+1);
var cvshome = r+pub.EAOption.get("xlsgrid.file.dynadata.root");
*/
var pub = new JavaPackage("com.xlsgrid.net.pub");
var pubpack = new JavaPackage("com.xlsgrid.net.pubpack");

//使用实例的中间件目录
var cvshome = pub.EAOption.dynaDataRoot;
var roolen = cvshome.length();
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
function normal(val)
{
  return pub.EAFunc.Replace(val," ","_");
}

function getTreeCtlXml(root,xml)
{
  var f = root;
  //throw new Exception(f);
  var folds = f.listFiles();
  if(folds==null) return "";
  //java.util.Arrays.sort(folds);
  folds=pub.EAFunc.sort(folds);
  var c = folds.length();
  //throw new Exception(c);
  for(var i=0;i<c;i++)
  {
    f=folds[i];
    if(f.isDirectory())
    {
      foldid++;
	xml += "<目录 path=\"%s\" imageid=\"0\" >%s</目录>".format([f.getAbsolutePath().substring(roolen),f.getName()]);
    }
  }
  for(var i=0;i<c;i++)
  {
    f=folds[i];
    if(f.isDirectory())
    {
    }
    else
      xml += "<"+normal(f.getName()) +" "+f.getAbsolutePath().substring(roolen)+" />";
  }
  
  return xml;
}

//================================================================// 
// 函数：getFolderTreeXml
// 说明：取cvs根目录和web根目录下的目录结构
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：12/01/06 14:26:21
// 修改日志：
//================================================================// 
//var roolen = 0;
function getFolderTreeXml()
{
  foldid=0;
  var isroot=root=="";
  if(isroot)
    root = cvshome;
  else root = cvshome + root;
 // throw new Exception(root);
  var f = new java.io.File(root);
  var xml = getTreeCtlXml(f,"");
  if(isroot)
    xml = "<"+f.getName() +" "+root+">" //"<"+f.getName() +" "+root+","+foldid+">"  
      + xml
      + "</"+f.getName() +">";
  return xml;
}

function getFile()
{
  //throw new Exception(cvshome+file);
  return pub.EAFunc.readFile(cvshome+file);
}

function savefile()
{
  pub.EAFunc.WriteToFile(cvshome+file,content);
  return "保存成功："+cvshome+file;
}

function addHeaderHtml(mwobj,request,sb,usrinfo)
{
//  sb.append("<SCRIPT src=fckeditor.js type=text/javascript></SCRIPT>");
}

//作为.sp服务时的入口
//预定义变量：request,response
function Response()
{
	function doupload(path)
	{
	    var up = new pub.EAUpload();
	    up.setOverwrite(true);
	    up.setFilesizelimit(1024*1024);   // limited upload size <=10M
	    up.setFolderstore(path);

	    file = pub.EAFunc.encodeString(mrequest.getParameter("file"),ubp.MultipartFormDataRequest.DEFAULTENCODING,"GBK");

	    file = pub.EAFunc.Replace(file,"\\","/");
	    var f=new java.io.File(file);
	    //throw new Exception(file+";"+path+";"+f.getName());
	    up.store(mrequest,f.getName());
	    return f.getName();
	}
  var action = request.getParameter("action");
 
  var filematch= request.getParameter("filematch");// 文件匹配 如262*.*
  if ( filematch== null ) filematch = "";
  var mrequest=null;
  var ubp=null;

  if(action==null||mrequest==null)
  {
  	try{
		ubp = new JavaPackage("javazoom.upload");
		request.setCharacterEncoding(ubp.MultipartFormDataRequest.DEFAULTENCODING);
		mrequest = new ubp.MultipartFormDataRequest(request);
		action = mrequest.getParameter("action");
	}catch(e){
		pub.EAFunc.Log(e.toString());
	}
  }
    
  var file = request.getParameter("file");
  if(action=="down"){
      var fullfile = cvshome+file;
      fullfile =pub.EAFunc.Replace(fullfile ,"\\","/"); 
      pub.EAFunc.file2Response(response,fullfile );
  }
  else//目录压缩下载
  if(action=="subzipdown")
  {
      var f = new java.io.File(cvshome+file);
      if(f.isFile())
        file = f.getParent();
      pub.EAFunc.zip2Response(response,f.getName()+".zip",f.getPath(),filematch,"*.os",true);
  }
  else//完整打包下载
  if(action=="zipdown")
  {
      var f = new java.io.File(cvshome);
      pub.EAFunc.zip2Response(response,f.getName()+".zip",cvshome,"","*.os",true);
  }
  else
  if(action=="upload")
  {
    var path = mrequest.getParameter("path");
    if(path==cvshome+"/")//传入根目录
    	path="";
    path = cvshome+pub.EAFunc.encodeString(path,ubp.MultipartFormDataRequest.DEFAULTENCODING,"GBK");

    var f=new java.io.File(path);
    if(!f.isDirectory())
      path = f.getParent()+"/";
    doupload(path);
    return 1;
  }
  else//目录压缩上传后，解包
  if(action=="subzipup")
  {
    var path = mrequest.getParameter("path");
    
    try{
	    if(path==cvshome+"/")//传入根目录
	    	path="";
	
	      var path = pub.EAFunc.encodeString(path,ubp.MultipartFormDataRequest.DEFAULTENCODING,"GBK");
	      //throw new Exception(path);
	      var fn = doupload(cvshome);//保存上传的文件到中间件根目录
	     
	      var f = new java.io.File(cvshome+path);
	      if(f.isFile())
	        path = f.getParent();
	      else path = f.getPath();
	    //pub.EAFunc.zip2Response(response,f.getName()+".zip",f.getPath(),"","*.os",true);
	
	    pub.EAJarResource.ExtractZipFiles("",path+"/",cvshome+fn,true);
     //throw new Exception ( "目录压缩上传后，解包"+path+"/"+cvshome+fn);
     }catch(ee){
     	return path+"/"+ee;
     }
    return 1;
  }
  else//整个中间件目录压缩上传后，解包
  if(action=="zipup")
  {
    //上传前先做备份
    //bakcup();
    var fn = doupload(cvshome);
    pub.EAJarResource.ExtractZipFiles("",cvshome,cvshome+fn,true);
    return 1;
  }
  else
  if(action=="delfile")
  {
    var f=new java.io.File(cvshome+file);
    return f.delete()?1:-1;
  }
  else return "unknow action";
}

function bakcup()
{
    var f = new java.io.File(cvshome);
    var bakname = cvshome+f.getName()+
    	pub.EAFunc.DateToStr(new java.util.Date()," yyyy-MM-dd hh_mm")+".zip";
    var ez = new pub.EAstdZipFile(f.getPath(),"","*.os,*.zip,*.rar",true);
    ez.zip2File(cvshome,bakname);
    return "备份成功。";
}

//复制资源到web目录
function syncRes()
{
        pub.EAFunc.copyDirectiory(cvshome+"org",pub.AppStartListener.approot+"org","","CVS",true );
        pub.EAFunc.copyDirectiory(cvshome+"syt/",pub.AppStartListener.approot,"","CVS",true );
        return "同步到web目录成功。";
}

//页面BODY处理完毕后事件
//sb里面是body元素及前面的head内容
//bodysb里面是body的innerHTML
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
  bodysb.insert(0,"<form id=\"myfilef\"><input type=\"file\" id=\"myfile\" style=\"display:none\"></input></form>");
  var base =request.getParameter("base");
  if(base==null) base = "";
//  //如果base=/打开，表示打开一个绝对目录，否则打开一个相对目录
  var fullfile = "";
  if(base.length()>0&&base.substring(0,1)=="/"){
  	fullfile = base.substring(1);
  }
  else {
  	fullfile =base;
  }
  if(fullfile.indexOf("/")>0)
  	bodysb.insert(0,"<script>alert('传入的base=参数不能带/或\\,请用|来代替')</script>");

  fullfile =pub.EAFunc.Replace(fullfile ,"\\","/");
  fullfile =pub.EAFunc.Replace(fullfile ,"|","/");
  bodysb.insert(0,"<script>var ROOT=\""+fullfile +"\";</script>");
  

}

function deltree()
{
  var file = request.getParameter("file");
  pub.EAFunc.deltree(cvshome+file);
  return "删除"+cvshome+file+"成功。";
}

function unzip()
{
  var file = request.getParameter("file");
  var path = request.getParameter("path");
  //return cvshome+file+", "+cvshome+path;
  var src = cvshome+file;
  var dst = cvshome+path;
  pub.EAJarResource.ExtractZipFiles("",dst,src,true);
  return "成功解压 "+src+" 到 "+dst;
}

//复制某个目录下的所有文件到另外一个目录
//调用 x.fileEditor.CopyDir.osp?srcdir=/u/userdata/abc&destdir=/u/userdata/abcnew
//参数 srcdir:  "/u/userdata/abc/"
//     destdir: "/u/userdata/abcnew/"
function CopyDir()
{
	var ret = 0;
//	pubpack.EAFunc.Log("开始复制"+srcdir+"到"+destdir);
	pub.EAFunc.copyDirectiory(srcdir,destdir,"","",true);
//	pubpack.EAFunc.Log("复制"+srcdir+"到"+destdir+"结束");
//	var msg =  "复制"+srcdir+"到"+destdir+"结束";
	ret = 1;
	return ret;
}

}