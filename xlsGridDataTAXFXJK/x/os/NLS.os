function x_NLS(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var mutil = new JavaPackage("java.util");
var timepack = new JavaPackage( "com.xlsgrid.net.time" );
var rs = new JavaPackage ( "com.xlsgrid.net.servlet" );
var webget = new JavaPackage("com.xlsgrid.net.webget");//httpcall的包
function genbatch()
{
	var db = null;
	var jobseqid  = "";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
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
	return jobseqid  ;// 返回后台分配的作业编号

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

//根据syt表中的系统号翻译xmldb/grddb下不同的系统
//手动配置系统的中文路径和英文路径客户端不传入参数
function modify2()
{
	var db = null;
	var sql = "";
	
	try {
	        db = new pubpack.EADatabase();
		sql ="select distinct(id) from syt";//查系统号
	    	var ds =db.QuerySQL(sql);
	    	var thisorgid="";//组织号
	    	var oldpath ="";
	    	var newpath ="";
	        var ifper=0;
	        var filesum=0;
	        var thissum=0;
	        var language=lan;
	        var iflayout=0;
	    	var path ="/"+pubpack.EAOption.get("xlsgrid.file.dynadata.root")+"xmldb/grddb/syt";//动态路径（中间件）
	    	//alert(path);
       	 	//翻译系统中间件对象
    	 	oldpath =path +thissytid;
    	 	newpath ="/"+pubpack.EAOption.get("xlsgrid.file.dynadata.root")+"/"+"EN";
	        newpath= pub.EAFunc.Replace(newpath,"//","_")+"/xmldb/grddb/syt"+thissytid+"/";//从原来的路径得出英文路径
	        ifper=0;
	        notify(jobid,0,"第一步：中间件对象翻译开始 ...","Run");//后台通知外部
	        thissum=getf(oldpath,newpath,thissytid,ifper,language)*1.0;
	        filesum=filesum*1.0+thissum*1.0;
	        //翻译组织的布局（一个系统可能有多个组织，逐个翻译）
	        var tablename ="sysurl"+lan;
	        //建表
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
	        	newpath= pub.EAFunc.Replace(newpath,"//","_")+"/org/"+thisorgid+"/layout/";//从原来的路径得出英文路径
	        	notify(jobid,85,"第二步：组织"+thisorgid+"的布局翻译开始 ...","Run");//后台通知外部
	        	//翻译布局不翻译只替换
	        	iflayout=1;
	        	thissum=getf(oldpath,newpath,thissytid,ifper,language)*1.0;
	        	iflayout=0;
	        	filesum=filesum*1.0+thissum*1.0;	
	        	//替换数据库中的菜单布局数据（表名动态构造）
                        sql="select * from "+tablename+" where org='"+thisorgid+"'";
			var ds1=db.QuerySQL(sql);
                        if(ds1.getRowCount()>0){//有此系统的数据就清空，否则不执行
                        	sql="delete from "+tablename+" where org='"+thisorgid+"'";
		        	db.ExcecutSQL(sql);//清空表中这个系统的数据
                        }
		        sql="insert into sysurlen  select * from sysurl  where org='"+thisorgid+"'";
			db.ExcecutSQL(sql);//插入这个系统的数据（从中文版中取）
			//db.Commit();//清空和插入提交一次
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
			notify(jobid,86,"更新"+rownum+"条数据","Run");//后台通知外部
	        }
	        ifper=1;
	        //翻译配置
	        oldpath ="/"+pubpack.EAOption.get("xlsgrid.file.dynadata.root")+thissytid+"/";
    	 	newpath ="/"+pubpack.EAOption.get("xlsgrid.file.dynadata.root")+"/"+"EN";
	        newpath= pub.EAFunc.Replace(newpath,"//","_")+"/"+thissytid+"/";//从原来的路径得出英文路径
	        ifper=1;
	        notify(jobid,90,"第三步：基础信息(菜单等)翻译开始...","Run");//后台通知外部
	        thissum=getf(oldpath,newpath,thissytid,ifper,language)*1.0; 
	        filesum=filesum*1.0+thissum*1.0;
	        db.Close();
	        notify(jobid,95,"翻译共更新文件数"+filesum,"Run");
	        //重载所有中间件和系统定义(用户名密码是必须要的)
	        htp=pub.EAFunc.Replace(htp,"xlsgrid","xlsgriden");//因为是在中文系统里重载英文系统的中间件，路径要改成英文的路径
	        var thishtp=htp+"ROOT_0/xlsgrid/jsp/design/reload.jsp?hiddenField=0&sytid="+thissytid+"&mwid=&usrid=xlsgrid&userpwd=0";
	        //var thishtp=htp+"ROOT_0/xlsgrid/jsp/design/reload.jsp?hiddenField=2&usrid=xlsgrid&userpwd=0";                         
	        notify(jobid,97,"第四步：重载本系统中的所有中间件,请耐心等候 ..."+thishtp,"Run");
	        try {
		        var httpcall = new webget.HttpCall();        
		        var ret = httpcall.Get(thishtp,"GBK");//重载所有中间件
		        
		        notify(jobid,98,"第五步：重载系统定义..."+thishtp,"Run");
	    		thishtp=htp+"ROOT_0/xlsgrid/jsp/design/reload.jsp?hiddenField=1&usrid=xlsgrid&userpwd=0";
		        ret =  httpcall.Get(thishtp,"GBK");//重载系统定义
		        
		        notify(jobid,99,"第六步：重载子系统定义..."+thishtp,"Run");
		        thishtp=htp+"ROOT_0/xlsgrid/jsp/design/reload.jsp?hiddenField=5&usrid=xlsgrid&userpwd=0";
		        ret =  httpcall.Get(thishtp,"GBK");//重载子系统定义
		        ret=ret.substring(2,ret.lastIndexOf("]"));
		}
		catch (e) {
		
		}
	       	        
	        notify(jobid,100,"操作完成","end");
	}
	catch (e) {
		if (db != null) db.Rollback();
		throw new Exception(e.toString());
	}
	finally {
		if (db != null) db.Close();
	}
}
//  中文路径oldpath
//  英文路径newpath
//  系统号thissytid
//  是否计算进度条ifper
//  目标语言lan
function getf(oldpath1,newpath1,thissytid1,ifper,lan){

         var sumf =0;
         var oldpath=oldpath1;
         var newpath=newpath1;
         var thissytid=thissytid1;
         var sql ="select * from NLS where sytid ='"+thissytid+"' and nls='"+lan+"' order by lengthb(cnstr) desc";//获取对照表信息
    	 var db = new pubpack.EADatabase();
    	 var ds =db.QuerySQL(sql);
         var map = new mutil.LinkedHashMap();//有序
         var mkey="";
         var mvalue="";
         var arong="";
         if(ds.getRowCount()<=0){
         	notify(jobid,1,"数据库中无此系统的对照表 !" ,"Run");
         }
         else{
	         for(var j=0;j<ds.getRowCount();j++){
	         	mkey=ds.getStringAt(j,"cnstr");//中文
	            	mvalue=ds.getStringAt(j,"deststr");//英文
	            	map.put(mkey,mvalue);
	          }      
	       	  var file = new java.io.File(oldpath);//目录
		  var fold = file.listFiles(); //文件列表
		  fold =pub.EAFunc.sort(fold);
		  var len = fold.length();//文件数
		  var filename ="";//文件名
		  var prefix="";//文件后缀
		  var content="";//要写入的内容
		  //创建临时文件夹
        	  var dempath="/"+pubpack.EAOption.get("xlsgrid.file.dynadata.root")+"xmldb/grddb/syt"+thissytid+"_demp/";
        	  pub.EAFunc.WriteToFile(dempath+"demp.xml"," ","UTF-8");//保存新文件
        	  if(ifper==0){
        	  	notify(jobid,1,"文件总数： "+len ,"Run");//后台通知外部
		  }
		  for(var i=0;i<len;i++){
		  	file = fold[i];
		  	if(file.isDirectory()){
		        	arong="无法翻译文件夹";
		    	}
		   	 else{
		    		filename =file.getName();//文件名
		    		//nofixname =filename.substring(0,filename.lastIndexOf("."));//不包括后缀的文件名
		    		if(ifper==0){
			    		var temp=len/80;
			    		var per=(sumf/temp);
				    	if(sumf%5 == 0){
				    		notify(jobid,per,"文件： "+file.getAbsolutePath(),"Run");//后台通知外部
				    	}
		    		}
		        	prefix=filename.substring(filename.lastIndexOf(".")+1);//文件后缀
		        	
		        	if(prefix=="zxg" ){   //对于压缩文件要单独处理 
			        	pub.EAZip.deCompressFileToFile(file.getAbsolutePath(),dempath+"/demp.xml");//解压文件    
		          		content=pub.EAFunc.readFile(dempath+"/demp.xml","UTF-8");//读取解压后的文件
		          		var set = map.keySet();
					var it = set.iterator();
					while(it.hasNext()){
					        var key = it.next();
					        var value=map.get(key);
					        if(content.indexOf(key)>-1){
					        	try{
					        		content=pub.EAFunc.Replace(content,key,value);//替换中文
					        	}
					        	catch(e){
					        		notify(jobid,per,"错误： "+e.toString(),"Run");//后台通知外部
					        	}
					        }
				        }	   
				        pub.EAFunc.WriteToFile(dempath+"/demp.xml",content,"UTF-8");//保存新文件
				        pub.EAZip.compressFileToFile(dempath+"/demp.xml",newpath+filename);//压缩文件       		
		          	}
				else if(prefix!="zxg"){
			          	content=pub.EAFunc.readFile(file.getAbsolutePath(),"GBK");//要写入的内容
			          	var set = map.keySet();
					var it = set.iterator();
					while(it.hasNext()){
						var key = it.next();
						var value=map.get(key);
					        if(content.indexOf(key)>-1){
					        	try{
					        		content=pub.EAFunc.Replace(content,key,value);//替换中文
					        	}
					        	catch(e){
					        		notify(jobid,per,"错误： "+e.toString(),"Run");//后台通知外部
					        	}
					        }
					  }
					  pub.EAFunc.WriteToFile(newpath+filename,content,"GBK");//保存新文件
			        }
			        sumf=sumf*1.0+1;     
		    }           
		                     	    
		}//for
		 //删除临时文件，和临时目录
		 var f = new java.io.File(dempath+"/demp.xml");
		 f.delete();//删除文件
		 pub.EAFunc.deltree(dempath);//删除目录
		 db.Close();
		 return sumf;
    }
}
//由路径计算文件数量（忽略子文件夹）
function getfilesum(path)
{
	var sum=0;
        var file = new java.io.File(path);//目录
        var fold = file.listFiles(); //文件列表
        fold =pub.EAFunc.sort(fold);
        sum = fold.length();//文件数
	return sum;
}



}