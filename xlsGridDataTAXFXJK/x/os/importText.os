function x_importText(){
var pub = new JavaPackage("com.xlsgrid.net.pub");
var xmldb = new JavaPackage("com.xlsgrid.net.xmldb");
var web = new JavaPackage("com.xlsgrid.net.web");


function importText()
{
	if(txt == null || txt == "") return "";
	var db = null;
	var ps = null;
  	var sr = null;
	var br = null;
	var sql = "";  
	var row = 0;

	try {
		var usr = web.EASession.GetLoginInfo(request); //获取操作用户信息
		var acc = usr.getAccid();
		var username = usr.getUsrnam();	
		
		db = new pub.EADatabase();
		sql="insert into cw_jk_rjzb(sbh,zth,lsh,yy,mm,dd,sxh,czyxm,pch,zy,kmbh,lxbh,dwbh,dwmc,je,jsfs,qcbz,fkbz,dybz,xz,jefx,czxh,yefx,OLD_PCH,ORG,ACC)
		values ('"+sbh+"','"+zth+"',seq_rjz_lsh.nextval,?,?,?,0,'"+username+"',0,?,('J'||seq_dwbh_lsh.nextval),'87',?,?,?,'"+jsfs+"',0,0,0,1,'借',seq_jkczxh.nextval,0,0,'"+org+"','"+acc+"') ";
		
		ps = db.prepareStatement(sql); //初始化
		
		var sr = new java.io.StringReader(txt);
		var br = new java.io.BufferedReader(sr);
		var line = "";
		
		line=br.readLine();
		
		while( (line=br.readLine()) != null) { //读取文本行记录
			row++;

			if(line == "") continue;
//			line = String.valueOf(line);
//			var str = line.split(" "); //分隔行记录 处理

//			sql = "select substrb('"+line+"',1,4) yy,trim(substrb('"+line+"',58,100)) dwmc from dual";
//			var ds = db.QuerySQL(sql);
			
//			var dwmc = ds.getStringAt(0,"dwmc");
			var yy = pub.EAFunc.Replace(line.substring(0,4)," ","");
			var mm = pub.EAFunc.Replace(line.substring(4,6)," ","");
			var dd = pub.EAFunc.Replace(line.substring(6,8)," ","");
			var zy = pub.EAFunc.Replace(line.substring(278)," ","");
			var dwbh = pub.EAFunc.Replace(line.substring(47,57)," ","");
			var dwmc = pub.EAFunc.Replace(line.substring(57,157)," ","");
			var je = pub.EAFunc.Replace(line.substring(270,273)," ","");
			
			return yy +","+mm + ","+dd + ","+zy+ ","+dwbh+","+dwmc+","+je;
			
			
			
    			ps.setString(1,yy.trim());
    			ps.setString(2,mm.trim());
    			ps.setString(3,dd.trim());
    			ps.setString(4,zy.trim());
    			ps.setString(5,dwbh.trim());
    			ps.setString(6,dwmc.trim());
    			ps.setString(7,je.trim());
    			ps.execute(); //执行SQL语句

		}
		db.Commit();
		return "导入成功！";
		
	}
	catch(e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
	
	
}
}