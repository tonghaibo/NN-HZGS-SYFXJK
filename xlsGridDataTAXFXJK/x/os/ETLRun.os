function x_ETLRun(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var timepack = new JavaPackage( "com.xlsgrid.net.time" );
var rs = new JavaPackage ( "com.xlsgrid.net.servlet" );
//ҳ��BODY������Ϻ��¼�
//sb������bodyԪ�ؼ�ǰ���head����
//bodysb������body��innerHTML
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	bodysb.append("<iframe style=\"position:absolute; top:0px; left:0px; display:none;\" id=framecall scrolling=\"no\" frameborder=\"0\"></iframe>");  //
}

// �ͻ���param����Ĳ�������ֱ��ʹ��
// ���� jobid :thisorgid
function genbatch()
{
	var db = null;
	var jobseqid  = "";
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
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
	return jobseqid  ;// ���غ�̨�������ҵ���

}

//"etlid= jobid="+thisjobid+"&thisorgid="+G_ORGID+"&jobnam=������ҵ"+_this.GetCellText(0,row,2)+"&usrid="+G_USRID+"&thisaccid="+G_ACCID+"&thissytid="+G_SYTID;
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
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var etl = new pubpack.EAEtl(etlid,db);// �����ݿ���ȡ��ETL���壬����hdr��dtl��Ϣ,dbֻ����Ĭ�ϵ����ݿ�
		//etl.setInsertUpdateMode(InsertUpdateMode);
		if ( etl.getSrcDb().length() != 0 ) dbfrom = new pubpack.EADatabase(etl.getSrcDb());    
	        else dbfrom = new pubpack.EADatabase();
	        if ( etl.getDstDb().length() != 0 ) dbto = new pubpack.EADatabase(etl.getDstDb());   
	        else dbto = new  pubpack.EADatabase();
	        
		if ( etl.getExpTyp().length() != 0 ){
		        //etl.createTable(dbfrom); 
		        notify(jobid,10,"��������","Run");//��̨֪ͨ�ⲿ
		        Export(etl,dbfrom);   //��Զ�̻��������ļ�������Ŀ¼ ,request,response
		        notify(jobid,40,"����ת������","Run");//��̨֪ͨ�ⲿ
		        //Trans(etl,dbfrom,request,response); //���ļ����ص���ʱ��
		        notify(jobid,70,"������̨�ţԣ̽���","Run");//��̨֪ͨ�ⲿ
		        
		}
		notify (jobid , 100, "�������" ,"end") ;
		db.Commit();
		msg="�����ɹ�";	
		
	}
	catch ( ee ) {
		pubpack.EAFunc.Log( ee.toString() );
		//֪ͨ����ִ�е�������
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
   * ��Զ�������ļ�������
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
    
      //Զ��FTP���û����������Զ��Ŀ¼
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
    
    //log("ETL("+etl.getEtlId()+")info:��Զ�̻���" + expCon + " FTP�����ļ�������Ŀ¼" + expLocal);
    //notify(35,"ִ�е������ݺ󴥷�����","Run");//��̨֪ͨ�ⲿ  
    //���غ󴥷���������OS����
    //execOSFunc(etl,expFunc,db,request,response);
    
}
 
// ֪ͨ�ⲿ��ǰ���������
function notify(jobseqid,percent,note,stat)
{
	var db = null;
	if ( percent < 0 ) return "";
	try{
		db = new pubpack.EADatabase();
		note = pubpack.EAFunc.Replace( note, "'","��" );
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