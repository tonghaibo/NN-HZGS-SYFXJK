function x_orgusrrol(){var pub= new JavaPackage("com.xlsgrid.net.pub");
var pubpack= new JavaPackage("com.xlsgrid.net.pub");
var xmldb= new JavaPackage("com.xlsgrid.net.xmldb");
var xmldbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var iopack = new JavaPackage ( "java.io" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
var utilpack = new JavaPackage ( "java.util");
var basePath = pubpack.EAOption.dynaDataRoot;

  function  XmlToStd(xml)
  {
      xml = pub.EAFunc.Replace(xml, "&"+"quot;", "\"" );
      xml = pub.EAFunc.Replace(xml, "&"+"amp;quot;", "\"" );
      xml = pub.EAFunc.Replace(xml, "&"+"apos;", "'"  );
    return xml;
  }
//查询某个org下的节点
//传入参数 thisorgid， thisid
function GetOrgList()
{
        var xml = "";
        var sytds = null;
        var sql = "select a.id, name from loc a where org ='"+thisorgid+"' ";
        if ( thisid == "" ) sql += " and refid is null ";
        else if ( thisid=="all" ) sql += " and 1<0 ";//不分部门

        else sql += " and refid='"+thisid+"'";
	
        sql+=" order by a.id ";
	
        try {	
	        sytds=pubpack.EADbTool.QuerySQL(sql);
	}catch ( e ){
		
		pubpack.EADbTool.ExcecutSQL("alter table loc add refid varchar2(20) ");
	        sytds=pubpack.EADbTool.QuerySQL(sql);

	}
        for( var i=0;i< sytds.getRowCount(); i ++ ) {
              
              var name = sytds.getStringAt(i,"NAME");
              xml+="<"+name +" imageid=\"0\" deptid=\""+sytds.getStringAt(i,"id")+"\" orgid=\""+thisorgid+"\" flag=\"dept\" >";      // sytflg说明该节点是一个系统
              
              xml+="</"+name +">";
        }  
        if ( thisid == "" ) { 
              xml+="<不分部门所有用户 imageid=\"0\" deptid=\"all\" orgid=\""+thisorgid+"\" flag=\"dept\" ></不分部门所有用户>";      
              xml+="<部门信息维护 imageid=\"1\"  orgid=\""+thisorgid+"\" flag=\"modifydept\" ></部门信息维护>";      
	}
	
	if (sytds.getRowCount()==0){//说明没有部门了，需要查询
		
        	sql ="select id,name from usr where org='"+thisorgid+"' and useflg='1' ";
        	if  ( thisid=="all" ) sql += " ";//不分部门
        	else	sql += " and deptid='"+thisid+"' " ;
		
        	sytds=pubpack.EADbTool.QuerySQL(sql+" order by id " );
    	
		
		for( var i=0;i< sytds.getRowCount(); i ++ ) {
	              var id = sytds.getStringAt(i,"ID");

	              var name = sytds.getStringAt(i,"NAME");
	              xml+="<"+name+"("+id+")" +" imageid=\"1\" deptid=\""+thisid+"\" orgid=\""+thisorgid+"\" usrid=\""+id+"\" flag=\"usr\" >";      // sytflg说明该节点是一个系统
	              
	              xml+="</"+name+"("+id+")" +">";
	        }    
	        //if ( sytds.getRowCount() >0){
		        xml+="<新增用户 imageid=\"1\" deptid=\""+thisid+"\" orgid=\""+thisorgid+"\" usrid=\"\" flag=\"usr\" >";      // sytflg说明该节点是一个系统
	                xml+="</新增用户>";
		//}
        
        } 
        return xml;
}
// 得到某一个数据流图
function loadDataflwGraph()
{

  var path = pub.EAOption.dynaDataRoot+ pub.EAOption.get("xmldb.file.grddb")+"/syt" + selsytid + "/" + filename;
 
    return pub.EAFunc.readFile(path);
}

// 得到单据列表
function GetItemList()
{
	var xml = "<?xml version='1.0' encoding='GBK'>";
	var ds = pubpack.EADbTool.QuerySQL("select a.PCH,b.id,b.name from fracas_pcitem a,v_fracas_item b where a.jc='"+jc+"' and a.xh='"+xh+"' and a.itmid=b.id and b.refid='"+itemclass+"' order by a.itmid ");

	
	if ( ds == null ) return "";
	for ( var i=0;i<ds.getRowCount() ; i ++ ) {
		var id =ds.getStringAt(i,"ID");
		var name = ds.getStringAt(i,"NAME");
		var pch =ds.getStringAt(i,"PCH");
		xml+="<"+id + " name=\""+name+"\" itmid=\""+id+"\" pch =\""+pch +"\" xh=\""+xh +"\"  jc=\""+jc +"\" />";

	}
	return xml;
}

// 得到某一个工作流process
function loadWorkflw()
{
  var path = pub.EAOption.dynaDataRoot+ pub.EAOption.get("xmldb.file.grddb")+"/syt" + selsytid + "/" + mwid+"."+type;
  try
  {
    return pub.EAFunc.readFile(path);
  }
  catch(e)
  {
  	return "";
  }
}

var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

// 客户端param传入的参数可以直接使用
function saveusr()
{
	var db = null;
	var msg= "";
	
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		
		try {
		  pub.EADbTool.ExcecutSQL("create view V_DESKTOP as select * from param where typ='DESKTOP'");
		}
		catch ( e ){}
		try {
		  pub.EADbTool.ExcecutSQL("create view V_ORGDEPT as select * from loc where useflg='1' and loctyp in ( '0','1','2')");
		}
		catch ( e ){}

		
		
		try {
		  pub.EADbTool.ExcecutSQL("create view V_USERPOST as select * from param where typ='USERPOST'");
		}
		catch ( e ){}
	
		var ds = new pubpack.EAXmlDS(xmlstr);	// 客户端可以传入一个xml
		
		if(ds.getRowCount()==1){
			var guid = ds.getStringAt(0,"GUID");
	
			if ( guid=="") {//新增
				var sql ="";
				var collist1="";
				var collist2="";
				guid=db.GetSQL("select sys_guid() from dual" );
				for (var c=0;c<ds.getColumnCount();c++){
					if ( ds.getColumnName(c)!="GUID" ){
						if(c!=0) {collist1+=",";collist2+=",";}
						collist1+=ds.getColumnName(c);
						collist2+="'"+ds.getStringAt(0,c)+"'";
					}
					
				}
				sql= "insert into usr(guid,"+collist1+") values('"+guid+"',"+collist2+")";
				try{
					db.ExcecutSQL(sql);
				}
				catch ( e ){
					if ( 1*db.GetSQL("select count(*) from usr where org='"+ds.getStringAt(0,"ORG")+"' and id='"+ds.getStringAt(0,"ID")+"' " ) >= 1 ) {
						throw new pubpack.EAException ( "该编码重复，请分配另外一个编码" );
					
					}
					
					try {
						db.ExcecutSQL("alter table usr add email varchar2(256)");
					
						db.ExcecutSQL(sql);
					}catch ( e1 ){
						throw new pubpack.EAException ( "操作失败" +e.toString() );

					}

				}
				msg+=guid;
			
			}
			else{//保存
				var sql ="";
				var collist1="";
				var collist2="";
				for (var c=0;c<ds.getColumnCount();c++){
					if ( ds.getColumnName(c)!="GUID" ){
						if(c!=0) {collist1+=",";collist2+=",";}
						collist1+=ds.getColumnName(c)+"='"+ds.getStringAt(0,c)+"'";
					}
					
				}
				sql= "update usr set "+collist1+" where guid='"+ds.getStringAt(0,"guid")+"'";
				try{
					db.ExcecutSQL(sql);
				}
				catch ( e ){
					db.ExcecutSQL("alter table usr add email varchar2(256)");
					db.ExcecutSQL(sql);

				}
//				throw new pubpack.EAException	("xhj\n"+ds.GetXml());
				msg+="保存成功";			
			}
			
			db.Commit();
		}
			
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}
function saveusrrol()
{
	var db = null;
	var msg= "";
	
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var ds = new pubpack.EAXmlDS(xmlstr);	// 客户端可以传入一个xml
		db.ExcecutSQL("delete from usrrol where usr ='"+usrguid+"'");
		
		for ( var i=0;i<ds.getRowCount();i++){
			var guid = ds.getStringAt(i,"GUID");
			var checkid = ds.getStringAt(i,"CHECKID");
			if ( checkid=="1")
				db.ExcecutSQL("insert into usrrol(usr,rol,acc) values('"+usrguid+"','"+guid+"','"+thisaccid+"') ");
		}
		db.Commit();
		
		msg="操作成功";	
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}


function deleteusr()
{
	var db = null;
	var msg= "";
	
	try {
		db = new pubpack.EADatabase();	
		db.ExcecutSQL("delete from usrrol where usr ='"+usrguid+"'");
		db.ExcecutSQL("delete from usr where guid ='"+usrguid+"'");

		db.Commit();
		
		msg="操作成功";	
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}
}