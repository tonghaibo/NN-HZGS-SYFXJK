function x_NLS_TBTODB(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var mutil = new JavaPackage("java.util");
var javaio=new JavaPackage("java.io");
function modify2()
{
    	 var oldpath ="";
    	 var prom="";
    	 var path ="/"+pubpack.EAOption.get("xlsgrid.file.dynadata.root")+"xmldb/grddb/syt"+thissytid;//动态路径
         var len=getf(path,thissytid);
    	 
    	 if(prom==""){
    	 	return len;
    	 }
    	 else{
    	 	return len;
    	 }
}
function getf(oldpath1,thissytid1)
{
	var arong="";
        var oldpath=oldpath1;
        var thissytid=thissytid1;
        //先把批注信息放到map中，在插入到数据库中
        var file = new java.io.File(oldpath);//目录
	var fold = file.listFiles(); //文件列表
	fold =pub.EAFunc.sort(fold);
	var len = fold.length();//文件数
	var filename ="";//文件名
	var nofixname ="";//不包括后缀的文件名
	var prefix="";//文件后缀
	var content="";//要读取的内容
	var cnstr="";
	var enstr="";
	//创建临时文件夹
        var dempath="/"+pubpack.EAOption.get("xlsgrid.file.dynadata.root")+"xmldb/grddb/syt"+thissytid+"_demp/";
        pub.EAFunc.WriteToFile(dempath+"demp.xml"," ");//保存新文件
        var map = new mutil.LinkedHashMap();//有序
        var arong="";
        var in=0;
        var flg="";
        //flg="abasad";    
        //flg= pub.EAFunc.Replace(flg,"a","*");//全部替换
        //throw new Exception(flg);
	for(var i=0;i<len;i++){
		file = fold[i];
	    	if(file.isDirectory()){
	        	arong="无法读取文件夹";
	        }
		else{
	    		filename =file.getName();//文件名
	    		nofixname =filename.substring(0,filename.lastIndexOf("."));//不包括后缀的文件名
	        	prefix=filename.substring(filename.lastIndexOf(".")+1);//文件后缀
	          	if(prefix=="zxg"){       	
	          		pub.EAZip.deCompressFileToFile(file.getAbsolutePath(),dempath+"/demp.xml");//解压文件    
	          		content=pub.EAFunc.readFile(dempath+"/demp.xml","UTF-8");//读取解压后的文件
                                //判断是否存在批注
	                	in=0;
	          	 while(content.indexOf("<Comment>")>-1 &&content.indexOf("<Data ss:Type=\"String\">")>-1 && content.indexOf("</Data>")>-1){       
	          	
	          	        try{                                                                                         
                                                                                                                             
		          	        if(content.substring(content.indexOf("</Data>")+7,content.indexOf("</Data>")+18).indexOf("Comment")>-1){
			                	cnstr=content.substring(content.indexOf("<Data ss:Type=\"String\">")+23,content.indexOf("</Data>"));//中文
			                	enstr=content.substring(content.indexOf("html:Color")+21,content.indexOf("</Font>"));//注释
			                }
		                }
		                catch(e){
		                	throw new Exception(e);
		                }
		                if(map.containsKey(cnstr)){
		          		arong="重复的值";
		          	}
		          	else{
		          	        enstr=enstr+"+"+nofixname;
		          		map.put(cnstr,enstr);
		          	}
		          	if(content.indexOf("</Comment></Cell>")>-1){	
		          		content=content.substring(content.indexOf("</Comment></Cell>")+17);
		          	}
		          	in++;
	          		if(in>800){
	          			break;//防止出现循环
	          		}	          		
	          	}
                  }
             }
         }
         var f = new java.io.File(dempath+"/demp.xml");
         f.delete();//删除文件
	 pub.EAFunc.deltree(dempath);//删除目录
	 //把map中的数据插入到数据库中
	 
	 var db = new pubpack.EADatabase();
	 var set = map.keySet();
	 var it = set.iterator();
	 var sql="";
	 var title=0;
	 var key = "";
	 var value="";
	 var classid ="";
	 
	 while(it.hasNext()){
	         key = it.next();
	         value=map.get(key);
	         classid=value.substring(value.lastIndexOf("+")+1);
	         value=value.substring(0,value.lastIndexOf("+"));
	         if(value.indexOf("&#10")>-1){
	         	value=pub.EAFunc.Replace(value,"&#10;"," ");
	         }
	        
	         sql="select * from nls where cnstr='"+key+"' and classid='"+classid+"' ";
	         var ds=db.QuerySQL(sql);
	         try{
		        if(ds.getRowCount()<= 0 && key !=" "){
		                sql="insert into nls (sytid,cnstr,nls,deststr,crtdat,classid)values('"+thissytid+"','"+key+"','en','"+value+"',sysdate,'"+classid+"')";
		        	db.ExcecutSQL(sql);                  		
		        	title=8;
		        }
		        else if(ds.getRowCount()> 0 && key !=" "){
		        	 sql="update nls set crtdat=sysdate,deststr='"+value+"' where cnstr='"+key+"'  and classid='"+classid+"'";
		        	 db.ExcecutSQL(sql);
		        	 title=9;
		        }
	        }
	        catch(e){
	        	throw new Exception(e);
	        }
	  }
	  db.Commit();//提交
	  db.Close();//关闭数据连接
          return title; 
}














}