function x_fileEditor(){/* ʹ�ö����м��Ŀ¼
var realpath = pub.EAOption.getRealpath();
    var a = realpath.indexOf(java.io.File.separatorChar);
    var r = java.io.File.separator; 
    if(a>=0)
      r = realpath.substring(0,a+1);
var cvshome = r+pub.EAOption.get("xlsgrid.file.dynadata.root");
*/
var pub = new JavaPackage("com.xlsgrid.net.pub");
var pubpack = new JavaPackage("com.xlsgrid.net.pubpack");

//ʹ��ʵ�����м��Ŀ¼
var cvshome = pub.EAOption.dynaDataRoot;
var roolen = cvshome.length();
var foldid;
//================================================================// 
// ������getTreeCtlXml
// ˵����ȡĿ¼�ṹ
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�12/01/06 14:27:04
// �޸���־��
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
	xml += "<Ŀ¼ path=\"%s\" imageid=\"0\" >%s</Ŀ¼>".format([f.getAbsolutePath().substring(roolen),f.getName()]);
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
// ������getFolderTreeXml
// ˵����ȡcvs��Ŀ¼��web��Ŀ¼�µ�Ŀ¼�ṹ
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�12/01/06 14:26:21
// �޸���־��
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
  return "����ɹ���"+cvshome+file;
}

function addHeaderHtml(mwobj,request,sb,usrinfo)
{
//  sb.append("<SCRIPT src=fckeditor.js type=text/javascript></SCRIPT>");
}

//��Ϊ.sp����ʱ�����
//Ԥ���������request,response
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
 
  var filematch= request.getParameter("filematch");// �ļ�ƥ�� ��262*.*
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
  else//Ŀ¼ѹ������
  if(action=="subzipdown")
  {
      var f = new java.io.File(cvshome+file);
      if(f.isFile())
        file = f.getParent();
      pub.EAFunc.zip2Response(response,f.getName()+".zip",f.getPath(),filematch,"*.os",true);
  }
  else//�����������
  if(action=="zipdown")
  {
      var f = new java.io.File(cvshome);
      pub.EAFunc.zip2Response(response,f.getName()+".zip",cvshome,"","*.os",true);
  }
  else
  if(action=="upload")
  {
    var path = mrequest.getParameter("path");
    if(path==cvshome+"/")//�����Ŀ¼
    	path="";
    path = cvshome+pub.EAFunc.encodeString(path,ubp.MultipartFormDataRequest.DEFAULTENCODING,"GBK");

    var f=new java.io.File(path);
    if(!f.isDirectory())
      path = f.getParent()+"/";
    doupload(path);
    return 1;
  }
  else//Ŀ¼ѹ���ϴ��󣬽��
  if(action=="subzipup")
  {
    var path = mrequest.getParameter("path");
    
    try{
	    if(path==cvshome+"/")//�����Ŀ¼
	    	path="";
	
	      var path = pub.EAFunc.encodeString(path,ubp.MultipartFormDataRequest.DEFAULTENCODING,"GBK");
	      //throw new Exception(path);
	      var fn = doupload(cvshome);//�����ϴ����ļ����м����Ŀ¼
	     
	      var f = new java.io.File(cvshome+path);
	      if(f.isFile())
	        path = f.getParent();
	      else path = f.getPath();
	    //pub.EAFunc.zip2Response(response,f.getName()+".zip",f.getPath(),"","*.os",true);
	
	    pub.EAJarResource.ExtractZipFiles("",path+"/",cvshome+fn,true);
     //throw new Exception ( "Ŀ¼ѹ���ϴ��󣬽��"+path+"/"+cvshome+fn);
     }catch(ee){
     	return path+"/"+ee;
     }
    return 1;
  }
  else//�����м��Ŀ¼ѹ���ϴ��󣬽��
  if(action=="zipup")
  {
    //�ϴ�ǰ��������
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
    return "���ݳɹ���";
}

//������Դ��webĿ¼
function syncRes()
{
        pub.EAFunc.copyDirectiory(cvshome+"org",pub.AppStartListener.approot+"org","","CVS",true );
        pub.EAFunc.copyDirectiory(cvshome+"syt/",pub.AppStartListener.approot,"","CVS",true );
        return "ͬ����webĿ¼�ɹ���";
}

//ҳ��BODY������Ϻ��¼�
//sb������bodyԪ�ؼ�ǰ���head����
//bodysb������body��innerHTML
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
  bodysb.insert(0,"<form id=\"myfilef\"><input type=\"file\" id=\"myfile\" style=\"display:none\"></input></form>");
  var base =request.getParameter("base");
  if(base==null) base = "";
//  //���base=/�򿪣���ʾ��һ������Ŀ¼�������һ�����Ŀ¼
  var fullfile = "";
  if(base.length()>0&&base.substring(0,1)=="/"){
  	fullfile = base.substring(1);
  }
  else {
  	fullfile =base;
  }
  if(fullfile.indexOf("/")>0)
  	bodysb.insert(0,"<script>alert('�����base=�������ܴ�/��\\,����|������')</script>");

  fullfile =pub.EAFunc.Replace(fullfile ,"\\","/");
  fullfile =pub.EAFunc.Replace(fullfile ,"|","/");
  bodysb.insert(0,"<script>var ROOT=\""+fullfile +"\";</script>");
  

}

function deltree()
{
  var file = request.getParameter("file");
  pub.EAFunc.deltree(cvshome+file);
  return "ɾ��"+cvshome+file+"�ɹ���";
}

function unzip()
{
  var file = request.getParameter("file");
  var path = request.getParameter("path");
  //return cvshome+file+", "+cvshome+path;
  var src = cvshome+file;
  var dst = cvshome+path;
  pub.EAJarResource.ExtractZipFiles("",dst,src,true);
  return "�ɹ���ѹ "+src+" �� "+dst;
}

//����ĳ��Ŀ¼�µ������ļ�������һ��Ŀ¼
//���� x.fileEditor.CopyDir.osp?srcdir=/u/userdata/abc&destdir=/u/userdata/abcnew
//���� srcdir:  "/u/userdata/abc/"
//     destdir: "/u/userdata/abcnew/"
function CopyDir()
{
	var ret = 0;
//	pubpack.EAFunc.Log("��ʼ����"+srcdir+"��"+destdir);
	pub.EAFunc.copyDirectiory(srcdir,destdir,"","",true);
//	pubpack.EAFunc.Log("����"+srcdir+"��"+destdir+"����");
//	var msg =  "����"+srcdir+"��"+destdir+"����";
	ret = 1;
	return ret;
}

}