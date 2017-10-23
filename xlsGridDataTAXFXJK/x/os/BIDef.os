function x_BIDef(){var pub = new JavaPackage ( "com.xlsgrid.net.pub" );

//在Head区引用额外脚本
function addHeaderHtml(mwobj,request,sb,usrinfo)
//var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	try { pub.EADbTool.ExcecutSQL("alter table DIM_MODEL add ROWCOUNT NUMBER(20) default 5"); } catch ( e ) { }
	try { pub.EADbTool.ExcecutSQL("comment on column DIM_MODEL.ROWCOUNT is '每行显示主题数'"); } catch ( e ) { }
	try { pub.EADbTool.ExcecutSQL("alter table DIM_MODEL add JSGUID CHAR(32)"); } catch ( e ) { }
	try { pub.EADbTool.ExcecutSQL("comment on column DIM_MODEL.JSGUID is '附加脚本唯一键'"); } catch ( e ) { }
	
	try { pub.EADbTool.ExcecutSQL("alter table dim_dim add ISFW char(1) default '0'"); } catch ( e ) { }
	try { pub.EADbTool.ExcecutSQL("alter table dim_dim add ISXS char(1) default '1'"); } catch ( e ) { }
	try { pub.EADbTool.ExcecutSQL("alter table dim_dim add HSTR char(1) default '0'"); } catch ( e ) { }
	
	try { pub.EADbTool.ExcecutSQL("alter table dim_target add SUPERNAME varchar2(256)"); } catch ( e ) { }
	try { pub.EADbTool.ExcecutSQL("alter table dim_target add FORMATSTR char(1)"); } catch ( e ) { }
	try { pub.EADbTool.ExcecutSQL("alter table dim_target add HALIGNSTR char(1) default '0'"); } catch ( e ) { }
}

// 客户端param传入的参数可以直接使用
function save()
{
	var db = null;
	var msg = "";
	var sql = "";
	var sql_1 = "";
	
	try {
		db = new pub.EADatabase();
		
		//更新维度表
		if (dimxml != "") {
			var ds = new pub.EAXmlDS(dimxml);
			sql = "delete from dim_dim where refmod='%s'".format([modguid]);
			db.ExcecutSQL(sql);
			
			for ( var row=0;row<ds.getRowCount();row ++ ) {
				var id = ds.getStringAt(row,"ID");
				var name = ds.getStringAt(row,"NAME");
				var datatyp = ds.getStringAt(row,"TYP");
				var control = ds.getStringAt(row,"COLTYP");
				var keyval = ds.getStringAt(row,"KEY");
				var defval = pub.EAFunc.Replace(ds.getStringAt(row,"DEF"),"'","''");
				var wher = pub.EAFunc.Replace(ds.getStringAt(row,"WHERE"),"'","''");
				var seq = ds.getStringAt(row,"SORT");
				var isfw = ds.getStringAt(row,"ISFW");
				var isxs = ds.getStringAt(row,"ISXS");
				var hstr = ds.getStringAt(row,"HSTR");
				
				sql_1 = "select count(1) from dim_dim where id='"+id+"' and refmod='"+modguid+"'";
				sql = "insert into dim_dim(id,name,datatyp,refmod,control,keyval,defval,wher,seq,isfw,isxs,hstr) values('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s')".format([id,name,datatyp,modguid,control,keyval,defval,wher,seq,isfw,isxs,hstr]);
				if (id != null && id != "") {
					var count = 1.0 * db.GetSQL(sql_1);
					if (count == 0) db.ExcecutSQL(sql);
				}
			}
		}
		
		//更新目标表
		if (tarxml != "") {
			var ds = new pub.EAXmlDS(tarxml);
			sql = "delete from dim_target where refmod='%s'".format([modguid]);
			db.ExcecutSQL(sql);
			
			for ( var row=0;row<ds.getRowCount();row ++ ) {
				var id = ds.getStringAt(row,"ID");
				var name = ds.getStringAt(row,"NAME");
				var supername = ds.getStringAt(row,"SUPERNAME");
				var formatstr = ds.getStringAt(row,"FORMATSTR");
				var halignstr = ds.getStringAt(row,"HALIGNSTR");
				
				sql_1 = "select count(1) from dim_target where id='"+id+"' and refmod='"+modguid+"'";
				sql = "insert into dim_target(id,name,refmod,supername,formatstr,halignstr) values('%s','%s','%s','%s','%s','%s')".format([id,name,modguid,supername,formatstr,halignstr]);
				if (id != null && id != "") {
					var count = 1.0 * db.GetSQL(sql_1);
					if (count == 0) db.ExcecutSQL(sql);	
				}
			}
		}
		
		db.Commit();
		return "成功";
	} catch ( ee ) {
		db.Rollback();
		throw new pub.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
}

//删除表的时候，一并把维度和目标删除掉
function delete()
{
	var db = null;
	var sql = "";
	
	try {
		db = new pub.EADatabase();
		sql = "delete from dim_model where guid='"+modguid+"'";
		db.ExcecutSQL(sql);
		sql = "delete from dim_dim where refmod='"+modguid+"'";
		db.ExcecutSQL(sql);
		sql = "delete from dim_target where refmod='"+modguid+"'";
		db.ExcecutSQL(sql);
		
		db.Commit();
		return "成功";
	} catch ( ee ) {
		db.Rollback();
//		throw new Exception( ee.toString() );
	}
	finally {
		if(db != null) db.Close();
	}
}

}