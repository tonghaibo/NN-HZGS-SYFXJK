function x_ETLRun(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var timepack = new JavaPackage( "com.xlsgrid.net.time" );
var rs = new JavaPackage ( "com.xlsgrid.net.servlet" );
//页面BODY处理完毕后事件
//sb里面是body元素及前面的head内容
//bodysb里面是body的innerHTML
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	bodysb.append("<iframe style=\"position:absolute; top:0px; left:0px; display:none;\" id=framecall scrolling=\"no\" frameborder=\"0\"></iframe>");  //
}

// 客户端param传入的参数可以直接使用
// 传入 jobid :thisorgid
function genbatch()
{
	var db = null;
	var jobseqid  = "";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		jobseqid = jobid;
		
		var tim = new timepack.EARunOSTimer(); 

		tim.init(   jobseqid , jobnam,   "x",  "ETLRun",  "run", "etlid="+etlid+"&jobid="+jobid+"&thisorgid="+thisorgid+"&jobseqid="+jobseqid +"&thisaccid="+thisaccid+"&thissytid="+thissytid);
	}
	catch ( ee ) {
		
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return jobseqid  ;// 返回后台分配的作业编号

}

//"etlid= jobid="+thisjobid+"&thisorgid="+G_ORGID+"&jobnam=分析作业"+_this.GetCellText(0,row,2)+"&usrid="+G_USRID+"&thisaccid="+G_ACCID+"&thissytid="+G_SYTID;
function run () 
{
	
	var db = null;var dbfrom = null; var dbto=null;

	var msg= "";
	var sql = "";
	var itemds= null;
	var jobds = null;
	var jobguid = "";
	var num = 0;
	var usrid = "";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var etl = new pubpack.EAEtl(etlid,db);// 从数据库中取得ETL定义，包括hdr和dtl信息,db只能是默认的数据库
		//etl.setInsertUpdateMode(InsertUpdateMode);
		if ( etl.getSrcDb().length() != 0 ) dbfrom = new pubpack.EADatabase(etl.getSrcDb());    
	        else dbfrom = new pubpack.EADatabase();
	        if ( etl.getDstDb().length() != 0 ) dbto = new pubpack.EADatabase(etl.getDstDb());   
	        else dbto = new  pubpack.EADatabase();
	        
		if ( etl.getExpTyp().length() != 0 ){
		        //etl.createTable(dbfrom); 
		        notify(jobid,10,"载入数据","Run");//后台通知外部
		        Export(etl,dbfrom);   //从远程机器下载文件到本地目录 ,request,response
		        notify(jobid,40,"数据转换处理","Run");//后台通知外部
		        //Trans(etl,dbfrom,request,response); //从文件加载到临时库
		        notify(jobid,70,"启动后台ＥＴＬ进程","Run");//后台通知外部
		        
		}
		notify (jobid , 100, "操作完毕" ,"end") ;
		db.Commit();
		msg="操作成功";	
		
	}
	catch ( ee ) {
		pubpack.EAFunc.Log( ee.toString() );
		//通知外面执行到哪里了
		notify(jobid,100,ee.toString(),"error");
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();

	}
	return msg;
}
/**
   * 从远程下载文件到本地
   * @param etl
   * @param request
   * @param response
   * @throws java.lang.Exception
   */
function Export(etl, db) //,request, response
{
    var etlid = etl.getEtlId();
    var expTyp = etl.getExpTyp();
    var expFmt = etl.getExpFmt();
    var expDiv = etl.getExpDiv();
    var expCon = etl.getExpCon();
    var expConfile = etl.getExpConFile();
    var expLocal = etl.getExpLocal();
    var expLocalfile = etl.getExpLocalFile();
    var expDel = etl.getExpDel();
    var expFunc = etl.getExpFunc();
    
    if (expTyp.trim().equals("ftp"))
    {
 /*     
      var ftp = new pubpack.EAFtpClient();
    
      //远程FTP的用户名，密码和远程目录
    var user = getFtpInfo(etl,"user");
      var pwd = getFtpInfo(etl,"pwd");
      var expConPath = getFtpInfo(etl,"path"); 
      
      ftp.connectServer(expCon,user,pwd);      

      ftp.download(expConPath,expConfile,expLocal+"/"+expLocalfile);

      ftp.closeServer();
*/      
    }
    else if (expTyp.trim().equals("web"))
    {
      var http = new pubpack.EAHttp(expCon);
      //var str = http.getvar();
      if ( expLocalfile=="") expLocalfile = etlid ;
      http.downLoadFile(expLocal);//
    } 
    
    //log("ETL("+etl.getEtlId()+")info:从远程机器" + expCon + " FTP下载文件到本地目录" + expLocal);
    //notify(35,"执行倒入数据后触发程序","Run");//后台通知外部  
    //下载后触发服务器端OS函数
    //execOSFunc(etl,expFunc,db,request,response);
    
}
 
// 通知外部当前的运行情况
function notify(jobseqid,percent,note,stat)
{
	var db = null;
	if ( percent < 0 ) return "";
	try{
		db = new pubpack.EADatabase();
		note = pubpack.EAFunc.Replace( note, "'","‘" );
		if(note==""){
			db.ExcecutSQL("update RunOSTimer set percent="+(percent) +",stat='"+stat+"' where id='"+jobseqid+"'");
		}
		else {
			db.ExcecutSQL("update RunOSTimer set percent="+(percent) +",percentnote='"+note+"',stat='"+stat+"' where id='"+jobseqid+"'");
			db.ExcecutSQL("insert into RunOSTimerDTL(id,name ) values('"+jobseqid+"','"+note+"')" );
		}
		db.Commit();
	}
	catch ( e ) {
		//pubpack.EAFunc.Log( e.toString() );
		db.Rollback();
		return "ERROR" ;
	}
	finally {
		if (db!=null) db.Close();
	}
	return "OK";
}

}