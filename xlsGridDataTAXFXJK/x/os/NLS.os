function x_NLS(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var mutil = new JavaPackage("java.util");
var timepack = new JavaPackage( "com.xlsgrid.net.time" );
var rs = new JavaPackage ( "com.xlsgrid.net.servlet" );
var webget = new JavaPackage("com.xlsgrid.net.webget");//httpcall�İ�
function genbatch()
{
	var db = null;
	var jobseqid  = "";
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		jobseqid = jobid;
		var tim = new timepack.EARunOSTimer(); 
		tim.init(   jobseqid , jobnam,   "x",  "NLS",  "modify2", "jobid="+jobid+"&lan="+lan+"&htp="+htp+"&isorgid="+thisorgid+"&jobseqid="+jobseqid +"&thisaccid="+thisaccid+"&thissytid="+thissytid);
	}
	catch ( ee ) {
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return jobseqid  ;// ���غ�̨�������ҵ���

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

//����syt���е�ϵͳ�ŷ���xmldb/grddb�²�ͬ��ϵͳ
//�ֶ�����ϵͳ������·����Ӣ��·���ͻ��˲��������
function modify2()
{
	var db = null;
	var sql = "";
	
	try {
	        db = new pubpack.EADatabase();
		sql ="select distinct(id) from syt";//��ϵͳ��
	    	var ds =db.QuerySQL(sql);
	    	var thisorgid="";//��֯��
	    	var oldpath ="";
	    	var newpath ="";
	        var ifper=0;
	        var filesum=0;
	        var thissum=0;
	        var language=lan;
	        var iflayout=0;
	    	var path ="/"+pubpack.EAOption.get("xlsgrid.file.dynadata.root")+"xmldb/grddb/syt";//��̬·�����м����
	    	//alert(path);
       	 	//����ϵͳ�м������
    	 	oldpath =path +thissytid;
    	 	newpath ="/"+pubpack.EAOption.get("xlsgrid.file.dynadata.root")+"/"+"EN";
	        newpath= pub.EAFunc.Replace(newpath,"//","_")+"/xmldb/grddb/syt"+thissytid+"/";//��ԭ����·���ó�Ӣ��·��
	        ifper=0;
	        notify(jobid,0,"��һ�����м�������뿪ʼ ...","Run");//��̨֪ͨ�ⲿ
	        thissum=getf(oldpath,newpath,thissytid,ifper,language)*1.0;
	        filesum=filesum*1.0+thissum*1.0;
	        //������֯�Ĳ��֣�һ��ϵͳ�����ж����֯��������룩
	        var tablename ="sysurl"+lan;
	        //����
	        try{ 
	        	sql="select  count(*)  from "+tablename+"";
                        var dst=db.QuerySQL(sql);
	        }
	        catch(e){
                        sql="create table "+tablename+" as  select * from sysurl";
			db.ExcecutSQL(sql);
	        }
	        sql="select org from acc where syt='"+thissytid+"'";
    	        var newds =db.QuerySQL(sql);
                ifper=1;
	        for( var o=0;o<newds.getRowCount();o++){
	                thisorgid=newds.getStringAt(o,"org");
	        	oldpath ="/"+pubpack.EAOption.get("xlsgrid.file.dynadata.root")+"org/"+thisorgid+"/layout/";
	        	newpath ="/"+pubpack.EAOption.get("xlsgrid.file.dynadata.root")+"/"+"EN";
	        	newpath= pub.EAFunc.Replace(newpath,"//","_")+"/org/"+thisorgid+"/layout/";//��ԭ����·���ó�Ӣ��·��
	        	notify(jobid,85,"�ڶ�������֯"+thisorgid+"�Ĳ��ַ��뿪ʼ ...","Run");//��̨֪ͨ�ⲿ
	        	//���벼�ֲ�����ֻ�滻
	        	iflayout=1;
	        	thissum=getf(oldpath,newpath,thissytid,ifper,language)*1.0;
	        	iflayout=0;
	        	filesum=filesum*1.0+thissum*1.0;	
	        	//�滻���ݿ��еĲ˵��������ݣ�������̬���죩
                        sql="select * from "+tablename+" where org='"+thisorgid+"'";
			var ds1=db.QuerySQL(sql);
                        if(ds1.getRowCount()>0){//�д�ϵͳ�����ݾ���գ�����ִ��
                        	sql="delete from "+tablename+" where org='"+thisorgid+"'";
		        	db.ExcecutSQL(sql);//��ձ������ϵͳ������
                        }
		        sql="insert into sysurlen  select * from sysurl  where org='"+thisorgid+"'";
			db.ExcecutSQL(sql);//�������ϵͳ�����ݣ������İ���ȡ��
			//db.Commit();//��պͲ����ύһ��
			sql="select * from "+tablename+"";
			var ds2=db.QuerySQL(sql);
			var ds3="";
			var cn="";
			var guid="";
			var rownum=0;
			if(ds2.getRowCount()>0){
				for(var i=0;i<ds2.getRowCount();i++){
					cn=ds2.getStringAt(i,"name");
					guid=ds2.getStringAt(i,"guid");
					sql="select * from nls where nls='"+language+"' and cnstr='"+cn+"'";
					ds3=db.QuerySQL(sql);
					if(ds3.getRowCount()>0){
						sql="update "+tablename+" set name =(select deststr from nls where nls='"+language+"' and cnstr='"+cn+"' and  rownum <2) where guid ='"+guid+"' ";
						db.ExcecutSQL(sql);
						rownum=rownum+1;
					}
				}
			}
			db.Commit();
			notify(jobid,86,"����"+rownum+"������","Run");//��̨֪ͨ�ⲿ
	        }
	        ifper=1;
	        //��������
	        oldpath ="/"+pubpack.EAOption.get("xlsgrid.file.dynadata.root")+thissytid+"/";
    	 	newpath ="/"+pubpack.EAOption.get("xlsgrid.file.dynadata.root")+"/"+"EN";
	        newpath= pub.EAFunc.Replace(newpath,"//","_")+"/"+thissytid+"/";//��ԭ����·���ó�Ӣ��·��
	        ifper=1;
	        notify(jobid,90,"��������������Ϣ(�˵���)���뿪ʼ...","Run");//��̨֪ͨ�ⲿ
	        thissum=getf(oldpath,newpath,thissytid,ifper,language)*1.0; 
	        filesum=filesum*1.0+thissum*1.0;
	        db.Close();
	        notify(jobid,95,"���빲�����ļ���"+filesum,"Run");
	        //���������м����ϵͳ����(�û��������Ǳ���Ҫ��)
	        htp=pub.EAFunc.Replace(htp,"xlsgrid","xlsgriden");//��Ϊ��������ϵͳ������Ӣ��ϵͳ���м����·��Ҫ�ĳ�Ӣ�ĵ�·��
	        var thishtp=htp+"ROOT_0/xlsgrid/jsp/design/reload.jsp?hiddenField=0&sytid="+thissytid+"&mwid=&usrid=xlsgrid&userpwd=0";
	        //var thishtp=htp+"ROOT_0/xlsgrid/jsp/design/reload.jsp?hiddenField=2&usrid=xlsgrid&userpwd=0";                         
	        notify(jobid,97,"���Ĳ������ر�ϵͳ�е������м��,�����ĵȺ� ..."+thishtp,"Run");
	        try {
		        var httpcall = new webget.HttpCall();        
		        var ret = httpcall.Get(thishtp,"GBK");//���������м��
		        
		        notify(jobid,98,"���岽������ϵͳ����..."+thishtp,"Run");
	    		thishtp=htp+"ROOT_0/xlsgrid/jsp/design/reload.jsp?hiddenField=1&usrid=xlsgrid&userpwd=0";
		        ret =  httpcall.Get(thishtp,"GBK");//����ϵͳ����
		        
		        notify(jobid,99,"��������������ϵͳ����..."+thishtp,"Run");
		        thishtp=htp+"ROOT_0/xlsgrid/jsp/design/reload.jsp?hiddenField=5&usrid=xlsgrid&userpwd=0";
		        ret =  httpcall.Get(thishtp,"GBK");//������ϵͳ����
		        ret=ret.substring(2,ret.lastIndexOf("]"));
		}
		catch (e) {
		
		}
	       	        
	        notify(jobid,100,"�������","end");
	}
	catch (e) {
		if (db != null) db.Rollback();
		throw new Exception(e.toString());
	}
	finally {
		if (db != null) db.Close();
	}
}
//  ����·��oldpath
//  Ӣ��·��newpath
//  ϵͳ��thissytid
//  �Ƿ���������ifper
//  Ŀ������lan
function getf(oldpath1,newpath1,thissytid1,ifper,lan){

         var sumf =0;
         var oldpath=oldpath1;
         var newpath=newpath1;
         var thissytid=thissytid1;
         var sql ="select * from NLS where sytid ='"+thissytid+"' and nls='"+lan+"' order by lengthb(cnstr) desc";//��ȡ���ձ���Ϣ
    	 var db = new pubpack.EADatabase();
    	 var ds =db.QuerySQL(sql);
         var map = new mutil.LinkedHashMap();//����
         var mkey="";
         var mvalue="";
         var arong="";
         if(ds.getRowCount()<=0){
         	notify(jobid,1,"���ݿ����޴�ϵͳ�Ķ��ձ� !" ,"Run");
         }
         else{
	         for(var j=0;j<ds.getRowCount();j++){
	         	mkey=ds.getStringAt(j,"cnstr");//����
	            	mvalue=ds.getStringAt(j,"deststr");//Ӣ��
	            	map.put(mkey,mvalue);
	          }      
	       	  var file = new java.io.File(oldpath);//Ŀ¼
		  var fold = file.listFiles(); //�ļ��б�
		  fold =pub.EAFunc.sort(fold);
		  var len = fold.length();//�ļ���
		  var filename ="";//�ļ���
		  var prefix="";//�ļ���׺
		  var content="";//Ҫд�������
		  //������ʱ�ļ���
        	  var dempath="/"+pubpack.EAOption.get("xlsgrid.file.dynadata.root")+"xmldb/grddb/syt"+thissytid+"_demp/";
        	  pub.EAFunc.WriteToFile(dempath+"demp.xml"," ","UTF-8");//�������ļ�
        	  if(ifper==0){
        	  	notify(jobid,1,"�ļ������� "+len ,"Run");//��̨֪ͨ�ⲿ
		  }
		  for(var i=0;i<len;i++){
		  	file = fold[i];
		  	if(file.isDirectory()){
		        	arong="�޷������ļ���";
		    	}
		   	 else{
		    		filename =file.getName();//�ļ���
		    		//nofixname =filename.substring(0,filename.lastIndexOf("."));//��������׺���ļ���
		    		if(ifper==0){
			    		var temp=len/80;
			    		var per=(sumf/temp);
				    	if(sumf%5 == 0){
				    		notify(jobid,per,"�ļ��� "+file.getAbsolutePath(),"Run");//��̨֪ͨ�ⲿ
				    	}
		    		}
		        	prefix=filename.substring(filename.lastIndexOf(".")+1);//�ļ���׺
		        	
		        	if(prefix=="zxg" ){   //����ѹ���ļ�Ҫ�������� 
			        	pub.EAZip.deCompressFileToFile(file.getAbsolutePath(),dempath+"/demp.xml");//��ѹ�ļ�    
		          		content=pub.EAFunc.readFile(dempath+"/demp.xml","UTF-8");//��ȡ��ѹ����ļ�
		          		var set = map.keySet();
					var it = set.iterator();
					while(it.hasNext()){
					        var key = it.next();
					        var value=map.get(key);
					        if(content.indexOf(key)>-1){
					        	try{
					        		content=pub.EAFunc.Replace(content,key,value);//�滻����
					        	}
					        	catch(e){
					        		notify(jobid,per,"���� "+e.toString(),"Run");//��̨֪ͨ�ⲿ
					        	}
					        }
				        }	   
				        pub.EAFunc.WriteToFile(dempath+"/demp.xml",content,"UTF-8");//�������ļ�
				        pub.EAZip.compressFileToFile(dempath+"/demp.xml",newpath+filename);//ѹ���ļ�       		
		          	}
				else if(prefix!="zxg"){
			          	content=pub.EAFunc.readFile(file.getAbsolutePath(),"GBK");//Ҫд�������
			          	var set = map.keySet();
					var it = set.iterator();
					while(it.hasNext()){
						var key = it.next();
						var value=map.get(key);
					        if(content.indexOf(key)>-1){
					        	try{
					        		content=pub.EAFunc.Replace(content,key,value);//�滻����
					        	}
					        	catch(e){
					        		notify(jobid,per,"���� "+e.toString(),"Run");//��̨֪ͨ�ⲿ
					        	}
					        }
					  }
					  pub.EAFunc.WriteToFile(newpath+filename,content,"GBK");//�������ļ�
			        }
			        sumf=sumf*1.0+1;     
		    }           
		                     	    
		}//for
		 //ɾ����ʱ�ļ�������ʱĿ¼
		 var f = new java.io.File(dempath+"/demp.xml");
		 f.delete();//ɾ���ļ�
		 pub.EAFunc.deltree(dempath);//ɾ��Ŀ¼
		 db.Close();
		 return sumf;
    }
}
//��·�������ļ��������������ļ��У�
function getfilesum(path)
{
	var sum=0;
        var file = new java.io.File(path);//Ŀ¼
        var fold = file.listFiles(); //�ļ��б�
        fold =pub.EAFunc.sort(fold);
        sum = fold.length();//�ļ���
	return sum;
}



}