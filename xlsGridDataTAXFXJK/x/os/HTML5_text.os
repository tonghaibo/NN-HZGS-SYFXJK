function x_HTML5_text(){var xmldb= new JavaPackage("com.xlsgrid.net.xmldb");
var xmldbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );

var pubpack = new JavaPackage("com.xlsgrid.net.pub" );
var grdpack = new JavaPackage("com.xlsgrid.net.grd" );

function copytoweb()
{
	var srcpath = pubpack.EAOption.dynaDataRoot +"org/"+ thisorgid +"/layout/";
	var destpath = pubpack.EAOption.approot+"/org/"+ thisorgid +"/layout/";

	pubpack.EAFunc.copyDirectiory(srcpath,destpath,"","CVS",true );
	return "服务端：文件已从"+ srcpath +"同步到"+destpath ;
}

//var fileurl=pubpack.EAOption.dynaDataRoot + "org/" + thisorgid+"/layout";    
// 得到数据流的定义
function GetSubsyt()
{
	var ret = "";
	var num = 0;
	var ds = new pubpack.EAXmlDS();
	var ds0 = xmldbpack.EAXmlDB.getSubSytDB(thissytid);
	
	if ( ds0 != null ) {
		for ( var i=0;i<=ds0.getRowCount()-1; i++ )
		{
			//循环该组织的所有系统
			var sytType = ds0.getStringAt(i,"TYP");
			var order = ds0.getStringAt(i,"order");
			if (order=="0"&& !(sytType=="PDA" ||sytType=="WAP" || sytType=="J2ME" ) ){
				var row =ds.AddRow(ds.getRowCount()-1);
				
				ds.setValueAt(row,"ID",ds0.getStringAt(i,"subid") );
				var sName = ds0.getStringAt(i,"NAME");

				if(nls=="en"&& ds0.getStringAt(i,"TITLE")!="" ) 
					sName = ds0.getStringAt(i,"TITLE");

				ds.setValueAt(row,"NAME",ds0.getStringAt(i,"subid")+"-"+sName );
			}
		}
	}
        return ds.GetXml();
}

function GetSubsytItem()
{
	var ret = "";
	var num = 0;
	var ds = new pubpack.EAXmlDS();
	var ds0 = xmldbpack.EAXmlDB.getSubSytDB(thissytid);
	
	if ( ds0 != null ) {
		for ( var i=0;i<=ds0.getRowCount()-1; i++ )
		{
			//循环该组织的所有系统
			var sytType = ds0.getStringAt(i,"TYP");
			var order = ds0.getStringAt(i,"order");
			var id = ds0.getStringAt(i,"subid");
			if (order!="0"&& id==subid ){
				var row =ds.AddRow(ds.getRowCount()-1);
				var sName = ds0.getStringAt(i,"NAME");
				
				if(nls=="en"&& ds0.getStringAt(i,"TITLE")!="" ) 
					sName = ds0.getStringAt(i,"TITLE");

				ds.setValueAt(row,"NAME", sName);

				ds.setValueAt(row,"ICON",ds0.getStringAt(i,"ICON") );
				ds.setValueAt(row,"URL",ds0.getStringAt(i,"URL") );

			}
		}
	}
        return ds.GetXml();
}

// 得到数据流的定义
function GetLayoutItem()
{
       var xml = "";
        var sytds = xmldbpack.EAORGXmlDB.getOrgDs();
	var ds = new pubpack.EAXmlDS();
	var num = 0;
        for( var i=0;i< sytds.getRowCount(); i ++ ) {
		var selsytid = sytds.getStringAt(i,"ID");
		
		if ( thissytid == selsytid ) {
			var fileurl=pubpack.EAOption.dynaDataRoot + "org/" + selsytid+"/layout";     
			var folds = (new java.io.File(fileurl)).listFiles();
			if ( folds != null ) {
				folds=pub.EAFunc.sort(folds);
				var c = folds.length();
				for(var i=0;i<c;i++) {
					var f=folds[i];
					if(!f.isDirectory() ) {
						var filename = f.getName();
		            			var index = filename.indexOf(".sxg");	
						if ( index >=0  ) {
							var row= ds.AddRow(ds.getRowCount()-1);
							num++;
							ds.setValueAt(row,"SEQID",num);
							ds.setValueAt(row,"FILENAME",filename);
							ds.setValueAt(row,"NOTE","数据流"+filename);
							ds.setValueAt(row,"SYTID",selsytid );
							ds.setValueAt(row,"ACTION","修改布局" );
							ds.setValueAt(row,"ACTION1","删除布局" );
							
	
	
							
						}	
					}
				}
			}
		}
	}
        return ds.GetXml();
}

// 客户端param传入的参数可以直接使用
function save()
{
	try {
		  layoutxml = XmlToStd(layoutxml );
		  var path = pubpack.EAOption.dynaDataRoot+"org/" + thisorgid + "/layout/" + layoutid+nls+".swflayout";
		  pubpack.EAFunc.WriteToFile(path,layoutxml );	
	}
	catch ( ee ) {

		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		
	}
	return "已保存"+layoutid;
}



function  XmlToStd(xml)
{
      xml = pub.EAFunc.Replace(xml, "&"+"quot;", "\"" );
      xml = pub.EAFunc.Replace(xml, "&"+"amp;quot;", "\"" );
      xml = pub.EAFunc.Replace(xml, "&"+"apos;", "'"  );
    return xml;
}




var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
//作为.sp服务时的入口
//预定义变量：request,response
function Response()
{
      var code = request.getParameter("CODE");
      var vappmenu = pubpack.EAFunc.NVL( request.getParameter("vappmenu"), "");
      var db = null;
      var ret= "";
      var deforg= "";
      var nls= "";
      try {
      	// OS 中如何得到登录的信息
            db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
            var usr=web.EASession.GetLoginInfo(request);
           	nls = usr.getLang();
           
           	deforg = usr.getDeforg();
            // 如果MAINURL定义了这个进入账套的权限，那么采用这个来做WP8的菜单
            var sql= "select mainurl from accmainurl where accid='"+usr.getAccid()+"' and usrid ='"+usr.getUsrid()+"' and usrorgid ='"+usr.getOrgid()+"' " ;
            var myds = db.QuerySQL(sql);
            var loginurl = "";
	    if(myds.getRowCount()>0) 
            	loginurl = myds.getStringAt(0,"MAINURL" );

            if(loginurl!="" ){
            	vappmenu = pubpack.EAFunc.Replace(loginurl ,"EntryCloud.jsp?menu=", "");
           	if (vappmenu .indexOf("&") != -1) vappmenu = vappmenu .substring(0,vappmenu .indexOf("&"));
            }
            else 
            if( vappmenu  == "" ) {
           	var usrds = db.QuerySQL("select mainurl from usr where id='"+usr.getUsrid()+"' and org='"+usr.getOrgid()+"'");
           	if(usrds.getRowCount()>0 ){
           		var mainurl = usrds.getStringAt(0,"mainurl");
           		vappmenu = pubpack.EAFunc.Replace(mainurl,"Entry.jsp?menu=", "");
           		if (vappmenu .indexOf("&") != -1) vappmenu = vappmenu .substring(0,vappmenu .indexOf("&"));
           		
           	}
            }
            if(vappmenu=="")vappmenu = "default";

            var layoutxml = pubpack.EAFunc.readFile(pubpack.EAOption.approot+"/org/"+ deforg +"/layout/"+vappmenu+nls+".swflayout");
            layoutxml = pubpack.EAFunc.Replace(layoutxml ,"bkcolor=\"#", "bkcolor=\"0x" );
            layoutxml = pubpack.EAFunc.Replace(layoutxml ,"fkcolor=\"#", "fkcolor=\"0x" );
            
            
	    return layoutxml;	
            var url = "javascript:f_openWindow(65,30,1000,600,'ROOT_3ASPACE/show.sp?grdid=StartShelf','resource://icon_11','Welcome1','台型分析');";
            var url1 = "javascript:f_openWindow(65,30,1000,600,'http://www.baidu.com/','resource://icon_11','Welcome1','台型分析');";

            ret = "<?xml version = '1.0' encoding=\"GBK\"?> 
<ROWSET width=\"124\" height=\"120\"><!--width:默认每个格子的宽、height:默认每个格子的高（合并格子之前的）-->
	<ROW>
		<C0  height=\"120\" width=\"124\" COLSPAN=\"1\" ROWSPAN=\"1\" bkcolor=\"0x75C215\" fkcolor=\"0xFFFFFF\" url=\""+url+"\" icon= \"xlsgrid/images/11.png\">百度</C0>
		<C1  height=\"120\" width=\"249\" COLSPAN=\"1\" ROWSPAN=\"2\" bkcolor=\"0x6A00FF\" fkcolor=\"0xFFFFFF\" url=\""+url1+"\" icon= \"xlsgrid/images/12.png\">百度</C1>
		<C3  height=\"120\" width=\"200\" COLSPAN=\"1\" ROWSPAN=\"1\" bkcolor=\"0x75C215\" fkcolor=\"0xFFFFFF\" url=\"http://www.baidu.com\"  icon=\"xlsgrid/images/11.png\">豌豆荚</C3>
	</ROW>
	<ROW >
		<C0  height=\"241\" width=\"124\" COLSPAN=\"2\" ROWSPAN=\"1\" bkcolor=\"0x75C215\" fkcolor=\"0xFFFFFF\" url=\"http://www.baidu.com\"  icon=\"xlsgrid/images/entry/2.png\">豌豆荚</C0>
		<C1  height=\"120\" width=\"124\" COLSPAN=\"1\" ROWSPAN=\"1\" bkcolor=\"0x75C215\" fkcolor=\"0xFFFF00\" url=\"http://www.baidu.com\"  icon=\"xlsgrid/images/11.png\">豌豆荚</C1>
		<C2  height=\"120\" width=\"124\" COLSPAN=\"1\" ROWSPAN=\"1\" bkcolor=\"0x75C215\" fkcolor=\"0xFFFFFF\" url=\"http://www.baidu.com\"  icon=\"xlsgrid/images/11.png\">豌豆荚</C2>
		<C3  height=\"120\" width=\"200\" COLSPAN=\"1\" ROWSPAN=\"1\" bkcolor=\"0x75C215\" fkcolor=\"0xFFFFFF\" url=\"http://www.baidu.com\"  icon=\"xlsgrid/images/11.png\">豌豆荚</C3>
	</ROW>
	<ROW >
		<C1  height=\"120\" width=\"124\" COLSPAN=\"1\" ROWSPAN=\"1\" bkcolor=\"0x75C215\" fkcolor=\"0xFFFFFF\" url=\"http://www.baidu.com\"  icon=\"xlsgrid/images/11.png\">豌豆荚</C1>
		<C2  height=\"120\" width=\"124\" COLSPAN=\"1\" ROWSPAN=\"1\" bkcolor=\"0x75C215\" fkcolor=\"0xFFFFFF\" url=\"http://www.baidu.com\"  icon=\"xlsgrid/images/11.png\">豌豆荚</C2>
		<C3  height=\"120\" width=\"200\" COLSPAN=\"1\" ROWSPAN=\"1\" bkcolor=\"0x75C215\" fkcolor=\"0xFFFFFF\" url=\"http://www.baidu.com\"  icon=\"xlsgrid/images/entry/2.png\">豌豆荚</C3>
	</ROW>
</ROWSET>";
      }
      catch ( ee ) {
            db.Rollback();
            throw new pubpack.EAException ( ee.toString() );
      }
      finally {
            if (db!=null) db.Close();
      }
      return ret ;
}


}