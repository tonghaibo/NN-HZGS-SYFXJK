function XLSGRID_HDRTRK(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//加载类包 
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" ); 
function test(title) 
{	
	//return abc;
	var usr=web.EASession.GetLoginInfo(request);//获取当前用户信息		
	var trkusr=usr.getUsrid();
	
	//throw new Exception("新建事务test 方法"+trkusr+abc);
}

// 新增事务的保存
function save1() 
{
	var browser=pubpack.EAFunc.getBroswerType(request);
	if (browser=="4"){
		//throw new Exception("这是手机浏览器save1");
	}
	
	
	
		
      var ret = 0;
      var db = null;
      var ds = null;
      var sql = "";
      var ps1 = null;
      var ps2 = null;
      var ps3 = null;
      var ps4 = null;
      try
      {
            db = new pubpack.EADatabase();
            sql = "SELECT seq.nextval FROM DUAL" ; 
            var trkid = db.GetSQL(sql);
            sql = "SELECT SYS_GUID() FROM DUAL" ;
            var hdrguid = db.GetSQL(sql);
            if ( edit == "save" )
            {
//                  sql = "insert into trkhdr(guid,id,title,note,prio,crtusrorg,crtusr,stat, " +
//                        " dtlusr,dtlusrorg,project,filepath,filenote,show,proorg,prousr,imagepath,imagenote) values ('"+hdrguid+"','"+trkid+"','"+title+"','"+note+"' ," +
//                        " '"+prio+"','"+crtusrorg+"','"+crtusr+"', "+
//                        " '新建','"+dtlusr+"','"+crtusrorg+"','"+project+"','"+filepath+"','"+filenote+"','"+show+"','"+proorg+"','"+prousr+"','"+imagepath+"','"+imagenote+"')";
                         
                  sql = "insert into trkhdr(guid,id,title,note,prio,crtusr,stat, " +
                        " dtlusr,project,filepath,filenote,show,proorg,prousr,imagepath,imagenote,prodat,msg_sign,mobile_sign,selforg,syt,acc,aimorg,noteblob)  values ( " +
                        " ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,empty_blob())";                              
                  ps1 = db.prepareStatement(sql);
                  ps1.setString(1,hdrguid);//数据库查询的结果
                  ps1.setString(2,trkid);//数据库查询的结果
                  ps1.setString(3,title);
                  ps1.setString(4,"");
                  ps1.setString(5,prio);//0为最低,优先级
                  //ps1.setString(6,crtusrorg);
                  ps1.setString(6,crtusr); //创建人
                  ps1.setString(7,"0"); //修改过的，原来是“新建”
                  ps1.setString(8,dtlusr); 
                 // ps1.setString(10,crtusrorg);
                  ps1.setString(9,project);
                  ps1.setString(10,filepath);
                  ps1.setString(11,filenote);
                  ps1.setString(12,show);
                  ps1.setString(13,proorg);
                  ps1.setString(14,prousr);
                  ps1.setString(15,imagepath);
                  ps1.setString(16,imagenote);
                  ps1.setString(17,prodat);        
                  ps1.setString(18,msg_sign);
                  ps1.setString(19,mobile_sign);      
                  ps1.setString(20,selforg);  
                  ps1.setString(21,syt);  
                  ps1.setString(22,acc);     
                  ps1.setString(23,aimorg);

                  //throw new Exception (note);
                  
                  ret = ps1.executeUpdate();       
                  
                  
                  //throw new Exception(sql);
    
                 //throw new Exception("filepath="+filepath);//用来抛出错误
                  ps1.close();
                  //db.Commit();
                  //if(db!=null)db.Close();//不关闭的话下面更新blob出错 
                  //db = new pubpack.EADatabase();
                  
                   sql = "select noteblob from trkhdr  where id='"+trkid+"' for update";
                   var blob = db.GetSQL(sql);
                  // throw new Exception(note+"|"+blob);
                  db.UpdateBlobWithStr(sql,"noteblob",note);
                  
                  
                  var trktypnam = db.GetSQL( "select name from v_trktyp where id='"+show+"'" );
                  
                  OALOG( db,selforg,crtusr,"TRKHDR","创建"+trktypnam ,hdrguid,title,"",project );
//                  db.ExcecutSQL("insert into usrlog(org,usrid,usrnam,mwtyp,action,bilid)"+
//                  	"select a.org,a.id,a.name,'OALOG','创建'||b.name||'["+title+"]' ,'"+hdrguid+"' from usr a, v_trktyp b where a.id='"+crtusr+"' and a.org='"+selforg+"' and b.id='"+show+"' ");
                  
                  if ( mobile_sign == "1" ) 
                  	
                  	SendSMS( db, aimorg, dtlusr, crtusr, trktypnam+":"+title );
		  if(msg_sign == "1" )
		  	
		  	SendMail(db, aimorg, dtlusr, crtusr, trktypnam+":"+title ,note);
		  	


                  db.Commit();
                	
                	

                	
                	
                  //db.ExcecutSQL(sql);
            }
            if ( edit == "modify" )
            {
//                  sql = "update trkhdr set title='"+title+"',note='"+note+"',prio='"+prio+"',crtusrorg='"+crtusrorg+"',crtusr='"+crtusr+"', " +
//                        "dtlusr='"+dtlusr+"',project='"+project+"',filepath='"+filepath+"',filenote='"+filenote+"' where id='"+id+"' and stat='新建'"; 
                  for ( var i=0;i<num;i++)
                  {
                  	
                  }  
                  
                  sql = "update trkhdr set title=?,note=?,prio=?,crtusr=?, " +
                        "dtlusr=?,project=?,filepath=?,filenote=? ,proorg=?,prousr=?,prodat=?,msg_sign=?,mobile_sign=?,aimorg=? where id=? and stat=?";
                  ps3 = db.prepareStatement(sql);
                  ps3.setString(1,title); 
                  ps3.setString(2,"");
                  ps3.setString(3,prio);
                //  ps3.setString(4,crtusrorg);
                  ps3.setString(4,crtusr);
                  ps3.setString(5,dtlusr);
                  ps3.setString(6,project);
                  ps3.setString(7,filepath);
                  ps3.setString(8,filenote);                  
                  ps3.setString(9,proorg);
                  ps3.setString(10,prousr);
                  ps3.setString(11,prodat);
                  ps3.setString(12,msg_sign);
                  ps3.setString(13,mobile_sign);
                  ps3.setString(14,aimorg);
                  ps3.setString(15,id);
                  ps3.setString(16,"0");  //修改过的，原来是“新建” 

                  ret = ps3.executeUpdate();
                  ps3.close();

                  sql = "select noteblob from trkhdr  where id='"+id+"'and stat='0' for update";
                  

                  db.UpdateBlobWithStr(sql,"noteblob",note);
                  //throw new Exception(sql);
                  var trktypnam = db.GetSQL( "select name from v_trktyp where id='"+show+"'" );
                  
                  OALOG( db,selforg,crtusr,"TRKHDRMODIFY","修改"+trktypnam ,hdrguid,title,note,project );
  
                  
                  //db.ExcecutSQL("insert into usrlog(org,usrid,usrnam,mwtyp,action,bilid)"+
                  //	"select org,id,name,'OALOG','修改事务["+title+"]' ,'"+hdrguid+"' from usr where id='"+crtusr+"' and org='"+selforg+"'");
                  
                  db.Commit();
                 // db.ExcecutSQL(sql); 
            }
            if(browser=="4"){
                	
	                var out=response.getOutputStream();
		        var arrHreftxt = new Array("返回上一页","返回主页","重新登录");
		        var arrHref = new Array("show.sp?grdid=j2me_newtrk&style="+show+"&hdrguid="+hdrguid+"&hdrordtl=2","../Layout.sp?id=OAMainWAP","../j2melogin.jsp");
		        ret = pubpack.EAJ2meUtil.returnPage("成功操作了:"+ret+"条记录！",arrHreftxt,arrHref);
		        //throw new Exception("编辑返回页面");
		        out.println(ret);
		        
                }else{
                	
                }

            
            
           return ret ;
      }
      catch(e)
      {
      	if( db!= null ) db.Rollback();
            throw e;
      }
      finally
      {
            db.Close(); 
      }       
}


// 处理事务的保存
// hdrguid 需要传入
function save2() 
{
	var browser=pubpack.EAFunc.getBroswerType(request);
	if (browser=="4"){
		//throw new Exception("这是手机浏览器save2");
	}
	
      var ret = 0;
      var db = null;
      var ds = null;
      var sql = "";
      var ps1 = null;
      var ps2 = null;
      var ps3 = null;
      var ps4 = null;
      try
      {
            db = new pubpack.EADatabase();
            sql = "SELECT seq.nextval FROM DUAL" ; 
            var trkid = db.GetSQL(sql);
            sql = "SELECT SYS_GUID() FROM DUAL" ;
            var guid = db.GetSQL(sql);
                       
                  sql = "insert into trkdtl(guid,id,title,tousr,crtusr,style, " +
                        " project,result,trkguid,tempusr,acc,syt,selforg,aimorg,pro_note ,filepath, filenote, imagepath , imagenote) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
                  ps2 = db.prepareStatement(sql);
                  ps2.setString(1,guid);
                  ps2.setString(2,trkid);
                  ps2.setString(3,title);
                  ps2.setString(4,dtlusr);
                  //ps2.setString(5,crtusrorg);
                  ps2.setString(5,crtusr);
                  ps2.setString(6,"4"); //修改过的，原来是“未处理”
                  ps2.setString(7,project);
                  ps2.setString(8,"0");
                  ps2.setString(9,hdrguid);//传入
                  ps2.setString(10,"temp");
                  ps2.setString(11,acc);
                  ps2.setString(12,syt);
                  ps2.setString(13,selforg);//处理人的组织应该是事务发起人的aimorg 
                  ps2.setString(14,aimorg);//处理人的aimorg应该是事务发起人的selforg 
                  ps2.setString(15,note);
                  ps2.setString(16,filepath);
                  ps2.setString(17,filenote);
                  ps2.setString(18,imagepath );
                  ps2.setString(19,imagenote);

                  ps2.executeUpdate();
                  ps2.close();
                  
                  sql = "update trkhdr set dtlusr='"+dtlusr+"' , aimorg='"+aimorg+"', stat='"+tostat+"' where guid='"+hdrguid+"' ";
                  
                  	ret=db.ExcecutSQL(sql);
                  
                  //

                  
                  var hdrtitle = db.GetSQL( "select title from trkhdr where guid='"+hdrguid+"' ");
                  var trktypnam = db.GetSQL( "select name from v_trktyp where id='"+show+"'" );
                  
                  OALOG( db,selforg,crtusr,"TRKDTL1","处理"+trktypnam ,hdrguid,hdrtitle ,"",project );
		  if ( mobile_sign == "1" ) 
                  	SendSMS( db, aimorg, dtlusr, crtusr, "已处理："+hdrtitle  );
		  if(msg_sign == "1" )
		  	SendMail(db, aimorg, dtlusr, crtusr, "已处理："+hdrtitle ,note);

                 
                 
                  if(browser!="4"){
                  db.Commit();         
                  }
                           
                  //如果是手机端则返回一个网页回去
                var browser =pubpack.EAFunc.getBroswerType(request);
                //String changeCharset(String str, String oldCharset, String newCharset)
                if(browser=="4"){
                	
	                var out=response.getOutputStream();
		        var arrHreftxt = new Array("返回上一页","返回主页","重新登录");
		        var arrHref = new Array("show.sp?grdid=j2me_newtrk&style="+show+"&hdrguid="+hdrguid+"&hdrordtl=2","../Layout.sp?id=OAMainWAP","../j2melogin.jsp");
		        ret = pubpack.EAJ2meUtil.returnPage("成功操作了:"+ret+"条记录！",arrHreftxt,arrHref);
		        
		        //throw new Exception("编辑返回页面");
		        out.println(ret);
		        
                }else{
                	
                }
		  
		  
		  
              
           return ret ;
      }
      catch(e)
      {
      	if( db!= null ) db.Rollback();

            throw e;
      }
      finally
      {
            db.Close(); 
      }       
}
// 评论
function save3() 
{
      var ret = 0;
      var db = null;
      var ds = null;
      var sql = "";
      var ps1 = null;
      var ps2 = null;
      var ps3 = null;
      var ps4 = null;
      try
      {
            db = new pubpack.EADatabase();
            sql = "SELECT seq.nextval FROM DUAL" ; 
            var trkid = db.GetSQL(sql);
            sql = "SELECT SYS_GUID() FROM DUAL" ;
            var guid = db.GetSQL(sql);
                       
                  sql = "insert into trkdtl(guid,id,title,tousr,crtusr,style, " +
                        " project,result,trkguid,tempusr,acc,syt,selforg,aimorg,pro_note,DTLTYP,filepath, filenote, imagepath , imagenote ) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
                  ps2 = db.prepareStatement(sql);
                  ps2.setString(1,guid);
                  ps2.setString(2,trkid);
                  ps2.setString(3,title);
                  ps2.setString(4,"");
                  //ps2.setString(5,crtusrorg);
                  ps2.setString(5,crtusr);
                  ps2.setString(6,"4"); //修改过的，原来是“未处理”
                  ps2.setString(7,project);
                  ps2.setString(8,"0");
                  ps2.setString(9,hdrguid);//传入
                  ps2.setString(10,"temp");
                  ps2.setString(11,acc);
                  ps2.setString(12,syt);
                  ps2.setString(13,selforg);//处理人的组织应该是事务发起人的aimorg 
                  ps2.setString(14,aimorg);//处理人的aimorg应该是事务发起人的selforg 
                  ps2.setString(15,note);
                  ps2.setString(16,"2");
                  ps2.setString(17,filepath);
                  ps2.setString(18,filenote);
                  ps2.setString(19,imagepath );
                  ps2.setString(20,imagenote);                  
                  ret=ps2.executeUpdate();
                  ps2.close();
                  
                  var hdrtitle = db.GetSQL( "select title from trkhdr where guid='"+hdrguid+"' ");
                  var trktypnam = db.GetSQL( "select name from v_trktyp where id='"+show+"'" );
                  
                  OALOG( db,selforg,crtusr,"TRKDTL2","评论"+trktypnam ,hdrguid,hdrtitle ,"",project );

//                  db.ExcecutSQL("insert into usrlog(org,usrid,usrnam,mwtyp,action,bilid)"+
//                  	"select org,id,name,'OALOG','发表评论["+hdrtitle +"]' ,'"+hdrguid+"' from usr where id='"+crtusr+"' and org='"+selforg+"'");
                  db.Commit();
                
                
                var browser =pubpack.EAFunc.getBroswerType(request);//获取浏览器属性
                if(browser=="4"){//手机
                	
	                var out=response.getOutputStream();
		        var arrHreftxt = new Array("返回上一页","返回主页","重新登录");
		        var arrHref = new Array("show.sp?grdid=j2me_newtrk&style="+show+"&hdrguid="+hdrguid+"&hdrordtl=2","../Layout.sp?id=OAMainWAP","../j2melogin.jsp");
		        ret = pubpack.EAJ2meUtil.returnPage("成功操作了:"+ret+"条记录！",arrHreftxt,arrHref);
		        //throw new Exception("编辑返回页面");
		        out.println(ret);
		        
                }else{
                	
                }

              
           return ret ;
      }
      catch(e)
      {
      if( db!= null ) db.Rollback();

            throw e;
      }
      finally
      {
            db.Close(); 
      }       
}

function file()
{
     // return  "/"+pubpack.EAOption.get("xlsgrid.file.dynadata.root")+"upload/";  
      return  "/"+pubpack.EAOption.get("filestore")+"upload/";  
}

// 插入日志
// logtyp: 日志分类，比如TRKHDR
// logtypnam: 日志分类,如已读
// guid: 参考编号
// name: 事务的说明，比如新建的事务的标题
// note: 事务的详细内容，删除一个事务的时候，这里保存事务的明细
// prj 项目
function OALOG( db,loginorgid ,loginusrid,logtyp,logtypnam,guid,name,note ,prj ) 
{	
	note=pubpack.EAFunc.Replace(note,"'","''");
	var sql = "insert into OALOG(org,usrid,usrnam,mwtyp,action,bilid,name,note,prj)"+
	       "select a.org,a.id,a.name,'"+logtyp+"','"+logtypnam+"' ,'"+guid+"', '"+name+"','"+note+"','"+prj+"' from usr a where a.id='"+loginusrid +"' and a.org='"+loginorgid +"' ";
	//throw new Exception("sql="+sql);
	db.ExcecutSQL(sql);
}


// 找到该用户的信息并发送一条短消息
function SendSMS( db, orgid, usrid, crtusr, msg)
{
	var ds1 = db.QuerySQL( "select name ,mobile from usr where id='"+usrid+"' and org='"+orgid+"'" );
        if ( ds1.getRowCount()> 0 ) {
                  	var phoneid = ds1.getStringAt(0,"mobile" );
                  	if(phoneid != "" ){ 
                  		var ds2 = db.QuerySQL( "select name ,mobile from usr where id='"+crtusr+"' and org='"+orgid+"'"  );
                  		
				if ( ds2.getRowCount()> 0 ) {
					var mobile = ds2.getStringAt(0,"mobile" );
					var crtnam = ds2.getStringAt(0,"name" );
					//mobile=trim(mobile);
					//mobile=new   String(mobile)  
		                  	var eaSms= new pubpack.EASMS();
		                  	//throw new Exception("'"+phoneid+"'"+msg+"'");//用来抛出错误
					var i=eaSms.Send(phoneid,msg+" ("+crtnam +mobile +")");
				}
	                  }
        }
}
// 找到该用户的信息并发送一封邮件
function SendMail(db, orgid, usrid, crtusr, msg ,note)
{
	var ds1 = db.QuerySQL( "select name ,loc from usr where id='"+usrid+"' and org='"+orgid+"'" );
        if ( ds1.getRowCount()> 0 ) {
                  	var sendto = ds1.getStringAt(0,"loc" );

                  	if(sendto != "" ){ 
                  		var ds2 = db.QuerySQL( "select name ,loc from usr where id='"+crtusr+"' and org='"+orgid+"'"  );
                  		
				if ( ds2.getRowCount()> 0 ) {
					var sendfrom = ds2.getStringAt(0,"loc" );
					var crtnam = ds2.getStringAt(0,"name" );
					var eaMail= new pubpack.EAMail();
					//throw new Exception("file="+files);//用来抛出错误
					if (filepath!="")eaMail.setFilepath("D:/u/filestore"+filepath);//把附件地址传给邮件
					var i=eaMail.sendMail(sendto,msg+" ("+crtnam+sendfrom+")",note);
				}
	                  }
        }


}
function getBlob(){
	var db = null;
	var sql = "";
	try {
		db = new pubpack.EADatabase();
		sql = "select noteblob from trkhdr where id='"+id+"'";
		var blob = db.getBlob2String(sql,"noteblob");
		return blob;
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( sql+ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
}
    
  
}