function x_MsgView(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var pubpack = new JavaPackage("com.xlsgrid.net.pub");

//================================================================// 
// 函数：getUsrMsg
// 说明：得到某个用户的所有消息列表
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：04/12/06 17:43:53
// 修改日志：
//================================================================// 
function getUsrMsg()
{
  var sql = "select GUID,to_char(crtdat,'MM/DD') dat,to_char(crtdat,'hh24:mi') tim,crtdat,crtusr,crtusracc,trim(crtusrnam) crtusrnam,title,url,tousr from msg where ";
  //if(subtyp==1)
  //  sql += "tousr='' or tousr is null";
  //else
    sql += "tousr='"+usrid+"' or ((tousr='' or tousr is null) and crtdat>add_months(sysdate,-1)) ";
  sql += " order by crtdat desc";
  var newsql = "SELECT * FROM ("+
            "SELECT ROWNUM AS NUM ,BASETABLE.*  FROM ( "+
             sql+") BASETABLE"+
             " WHERE ROWNUM <= "+page+"*"+nrow + ")" + 
             " WHERE NUM > ("+page+"-1)*"+nrow;
             //throw new pub.EAException( newsql );
  var xml = pub.EADbTool.QuerySQL(newsql).GetXml();
  return xml;  
}
//================================================================// 
// 函数：getOneMsg
// 说明：得到一个消息详细内容
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：04/12/06 17:44:10
// 修改日志：
//================================================================// 
function getOneMsg()
{
  var sql = "select note from msg where GUID='"+guid+"'";
  var xml = pub.EADbTool.GetSQL(sql);
  return xml;  
}

function sendSMS()
{
  var sql = "";
//  throw new Exception("sql ="+sql);
  var db = null;
  try
  {
  	var touserid = tousr.split(",");
	//循环发给用户信息
	db = new pub.EADatabase();
	var wheres = null;
	
  	for(var i=0;i<touserid.length();i++){
  		sql = "insert into msg(crtusracc,crtusr,crtusrnam,tousr,title,note) " +
        		pub.EAFunc.format("values('%s','%s','%s','%s','%s','%s')", 
              		[crtusracc,crtusrid,crtusrnam,touserid[i],msg,note]);
		//db.ExcecutSQL(sql);
		//throw new Exception(sql);
		//建立查询出用户移动电话的sql语句 
		if(wheres==null){
			wheres = " id='"+touserid[i]+"'";
		}else{
			wheres += " or id='"+touserid[i]+"'";
		}
  	}
//  	throw new Exception("插入"+touserid.length());
  	var sql = "select wm_concat(mobile) mobile from usr where  "+wheres ; 
  	//throw new Exception(sql);
  	var balance = "";
//  	throw new Exception("ifsms="+ifsms);
    	if(ifsms=="1"){
    		var ds = db.QuerySQL(sql);
    		var phones = "";
    		if(ds.getRowCount()>0 )phones=ds.getStringAt(0,"mobile");//获取电话号码
    		//http://dev.xlsgrid.net/xlsgrid/ROOT_XLSGRID/Http_SMS.sp?usrid=xlsgrid&userpwd=0&moblies=13023171375&msg=test&note=www.xlsgrid.net/xlsgrid/asdf&crtusrnam=xlsgrid&org=A3mobile
    		var getUrl = "http://dev.xlsgrid.net/xlsgrid/ROOT_XLSGRID/Http_SMS.sp?usrid=xlsgrid&userpwd=0&moblies="+phones+"&msg="+msg+"&note="+note+"&crtusrnam="+crtusrnam+"&org="+org; 
//  		throw new Exception(getUrl);
  		var result = "";
		try {
			var myhttp = new pubpack.EAHttp(getUrl ); 
			result = myhttp.send(); 
		}
		catch(e) {
			pubpack.EAFunc.Log("SendMessage:"+e.toString());
			throw new Exception(e);
		}


  		
    		return result;
    	}else {
    		return "";
    	}
    	//throw new Exception("末尾"+sql);
	
  }
  catch(e)
  {
  if( db!= null ) db.Rollback();
  throw new Exception(e);
    return e.toString();
  }finally {
		if (db!=null) db.Close();
  }
}

function DelMsg()
{
  var msglst = pub.EAFunc.SplitString(msgs,",");
  var c = msglst.length();
  for(var i=0;i<c;i++)
  {
    var sql = "delete msg where guid='"+msglst[i]+"' and tousr is not null ";
    pub.EADbTool.ExcecutSQL(sql);
  }
  return 1;
}


//获取该组织的所有用户
function getOrgUsr(){
	
	//throw new Exception("服务端"+org);
	var db = null;
	var ids = "";
	try
	{
		db = new pub.EADatabase();
		var sql = "select wm_concat(id) ids from usr where org='"+org+"'";
		var ds = db.QuerySQL(sql);

		if(ds.getRowCount()>0){
			ids = ds.getStringAt(0,"ids");
		}
	}
	catch(e)
	{
		if( db!= null ) db.Rollback();
		throw e;
	}
	finally
	{
		if(db!=null)db.Close(); 
	} 
	return ids;
}

function getMobile(){

	
	return "";
}

}