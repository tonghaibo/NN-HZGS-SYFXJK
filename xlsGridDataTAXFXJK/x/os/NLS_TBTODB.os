function x_NLS_TBTODB(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var mutil = new JavaPackage("java.util");
var javaio=new JavaPackage("java.io");
function modify2()
{
    	 var oldpath ="";
    	 var prom="";
    	 var path ="/"+pubpack.EAOption.get("xlsgrid.file.dynadata.root")+"xmldb/grddb/syt"+thissytid;//��̬·��
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
        //�Ȱ���ע��Ϣ�ŵ�map�У��ڲ��뵽���ݿ���
        var file = new java.io.File(oldpath);//Ŀ¼
	var fold = file.listFiles(); //�ļ��б�
	fold =pub.EAFunc.sort(fold);
	var len = fold.length();//�ļ���
	var filename ="";//�ļ���
	var nofixname ="";//��������׺���ļ���
	var prefix="";//�ļ���׺
	var content="";//Ҫ��ȡ������
	var cnstr="";
	var enstr="";
	//������ʱ�ļ���
        var dempath="/"+pubpack.EAOption.get("xlsgrid.file.dynadata.root")+"xmldb/grddb/syt"+thissytid+"_demp/";
        pub.EAFunc.WriteToFile(dempath+"demp.xml"," ");//�������ļ�
        var map = new mutil.LinkedHashMap();//����
        var arong="";
        var in=0;
        var flg="";
        //flg="abasad";    
        //flg= pub.EAFunc.Replace(flg,"a","*");//ȫ���滻
        //throw new Exception(flg);
	for(var i=0;i<len;i++){
		file = fold[i];
	    	if(file.isDirectory()){
	        	arong="�޷���ȡ�ļ���";
	        }
		else{
	    		filename =file.getName();//�ļ���
	    		nofixname =filename.substring(0,filename.lastIndexOf("."));//��������׺���ļ���
	        	prefix=filename.substring(filename.lastIndexOf(".")+1);//�ļ���׺
	          	if(prefix=="zxg"){       	
	          		pub.EAZip.deCompressFileToFile(file.getAbsolutePath(),dempath+"/demp.xml");//��ѹ�ļ�    
	          		content=pub.EAFunc.readFile(dempath+"/demp.xml","UTF-8");//��ȡ��ѹ����ļ�
                                //�ж��Ƿ������ע
	                	in=0;
	          	 while(content.indexOf("<Comment>")>-1 &&content.indexOf("<Data ss:Type=\"String\">")>-1 && content.indexOf("</Data>")>-1){       
	          	
	          	        try{                                                                                         
                                                                                                                             
		          	        if(content.substring(content.indexOf("</Data>")+7,content.indexOf("</Data>")+18).indexOf("Comment")>-1){
			                	cnstr=content.substring(content.indexOf("<Data ss:Type=\"String\">")+23,content.indexOf("</Data>"));//����
			                	enstr=content.substring(content.indexOf("html:Color")+21,content.indexOf("</Font>"));//ע��
			                }
		                }
		                catch(e){
		                	throw new Exception(e);
		                }
		                if(map.containsKey(cnstr)){
		          		arong="�ظ���ֵ";
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
	          			break;//��ֹ����ѭ��
	          		}	          		
	          	}
                  }
             }
         }
         var f = new java.io.File(dempath+"/demp.xml");
         f.delete();//ɾ���ļ�
	 pub.EAFunc.deltree(dempath);//ɾ��Ŀ¼
	 //��map�е����ݲ��뵽���ݿ���
	 
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
	  db.Commit();//�ύ
	  db.Close();//�ر���������
          return title; 
}














}