function TAXFXJK_StoneData(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var xlsdb = new JavaPackage ( "com.xlsgrid.net.xlsdb" );

//石材数据导入（包括出卡数据和加工企业收货数据）
function importStone()
{
	var db = null;
	var ds = null;
	var sql = "";
	var tabname = tabnam;
	var typ = typ;
	var ret = "";
	var updcount = 0;
	var inscount = 0;
	try{
		db = new pubpack.EADatabase();
		
		sql = "select * from user_tables where table_name=upper('"+tabname+"')";
		var cnt = db.GetSQLRowCount(sql);
		if(cnt <= 0) return "无数据可以导入";
		
		//增加纳税人登记序号列
		sql = "alter table "+tabname+" add djxh varchar2(30)";
		db.ExcecutSQL(sql);
		
		//纳税人识别号也有可能变更了，但是在石材系统中没有更改 的情况
		

		var mycnt = 0;
		
		if (typ == 1) {
		
			//取得导入数据的年月
			sql = "select substr(co0,6,7) yymm from "+tabname+" where co0 like '%查询年月%'";
			var yymm = db.GetSQL(sql);	
			
			//导入的中间表数据清理，删除文件中的垃圾行数据
			sql = "delete from "+tabname+" where co0 like '%矿企出卡月报表%' or co0 is null or co1 is null or co0 = '纳税人识别号' or co2 is null";
			mycnt = db.ExcecutSQL(sql);		
			if(mycnt == 0) {
				db.Rollback();
				return "导入失败！导入的文件格式不正确"+tabname;
			}
			
			sql = "update "+tabname+" tmp set djxh=(select djxh from TAX_STONE_DZB dzb where (tmp.co0=dzb.nsrsbh or tmp.co1=dzb.qymc) and rownum=1)";
			db.ExcecutSQL(sql);

			//先更新 后插入
			//矿企出卡数据文件格式
			//0年月 1纳税人识别号 2出卡企业名称 3对应企业 4车次 5出卡卡口 6收货企业 7重量合计(吨) 8碎石(吨) 9荒料(吨) 10板材(吨) 11碎石（二类） 12铁矿(吨) 13放行废料(吨) 14建筑用大理石 15建筑用砂
			//0纳税人识别号 1出卡企业名称 2对应企业 3车次 4出卡卡口 5收货企业 6重量合计(吨) 7碎石(吨) 8荒料(吨) 9板材(吨) 10碎石（二类） 11铁矿(吨) 12放行废料(吨) 13建筑用大理石 14建筑用砂
			sql = "update tax_stonedata a set (NSRMC,DYQYMC,CS,KHKZ,QYS,ZLHJ,SS,HL,BC,SS2L,TK,FXFL,JZYDLS,JZYS) =(
					select co1,co2,co3,co4,co5,co6,co7,co8,co9,co10,co11,co12,co13,co14
					from "+tabname+" b 
					where a.YYMM='"+yymm+"' and a.nsrsbh = b.co0 and rownum=1) 
				where a.YYMM='"+yymm+"' and a.crbz='1' and a.nsrsbh in (select co0 from "+tabname+")";	
			updcount = db.ExcecutSQL(sql);
			
			sql = "insert into tax_stonedata(CRBZ,YYMM,NSRSBH,NSRMC,DYQYMC,CS,KHKZ,QYS,ZLHJ,SS,HL,BC,SS2L,TK,FXFL,JZYDLS,JZYS,DJXH)
			       select '1' crbz,'"+yymm+"' yymm,co0,co1,co2,co3,co4,co5,co6,co7,co8,co9,co10,co11,co12,co13,co14,djxh 
			       from "+tabname+" a 
			       where not exists (select 1 from tax_stonedata b where b.yymm='"+yymm+"' and b.nsrsbh=a.co0 and b.crbz='1') ";					
			inscount = db.ExcecutSQL(sql);
		
		}
		//收货加工企业数据
		else if (typ == 2) {
			//增加纳税人登记序号列
			sql = "alter table "+tabname+" add nsrsbh varchar2(30)";
			db.ExcecutSQL(sql);
			
			//更新sbh,djxh
			sql = "update "+tabname+" tmp set (djxh,nsrsbh)=(select djxh,nsrsbh from TAX_STONE_DZB dzb where tmp.co1=dzb.qymc and rownum=1)";
			db.ExcecutSQL(sql);
		
			//取得导入数据的年月
			sql = "select substr(co0,6,7) yymm from "+tabname+" where co0 like '%查询日期%'";
			var yymm = db.GetSQL(sql);
			sql = "update "+tabname+" set co0='"+yymm+"'";
			db.ExcecutSQL(sql);
			
			//导入的中间表数据清理，删除文件中的垃圾行数据
			//sql = "delete from "+tabname+" where co1 is null or co1 like '纳税人识别号%'";
			sql = "delete from "+tabname+" where co1 is null or co1 like '%收货单位%' or co0='企业收货月报表' or co0='收货月份' or co0 like '%查询日期%'";
			mycnt = db.ExcecutSQL(sql);			
			if(mycnt == 0) {
				db.Rollback();
				return "导入失败！导入的文件格式不正确"+tabname+",mycnt="+mycnt ;
			}
			
			
			//先更新 后插入
			//加工企业数据文件格式
			//0年月 1纳税人识别号 2收货单位	3收货次数 4出卡企业 5矿种 6收货合计(吨) 7碎石(吨) 8荒料(吨) 9板材(吨) 10碎石（二类）(吨) 11铁矿 12放行废料(吨)	
			//0收货月份 1收货单位 2收货次数 3出卡企业 4矿种 5收货合计(吨) 6碎石(吨)	7荒料(吨) 8板材(吨) 9碎石（二类）(吨)10铁矿 11放行废料(吨)	

			sql = "update tax_stonedata a set (CS,QYS,KHKZ,ZLHJ,SS,HL,BC,SS2L,TK,FXFL) =(
					select co2,co3,co4,co5,co6,co7,co8,co9,co10,co11
					from "+tabname+" b 
					where a.YYMM = b.co0 and a.nsrmc=b.co1) 
				where crbz='2' and (yymm,nsrmc) in (select co0,co1 from "+tabname+")";	
			updcount = db.ExcecutSQL(sql);
			
			sql = "insert into tax_stonedata(CRBZ,YYMM,NSRSBH,NSRMC,CS,QYS,KHKZ,ZLHJ,SS,HL,BC,SS2L,TK,FXFL,DJXH)
			       select '2' crbz,nvl(co0,' ') co0,nsrsbh,co1,co2,co3,co4,co5,co6,co7,co8,co9,co10,co11,djxh 
			       from "+tabname+" a 
			       where not exists (select 1 from tax_stonedata b where b.yymm=a.co0 and b.nsrmc=a.co1 and b.crbz='2') ";					
			inscount = db.ExcecutSQL(sql);
		
		}
		
		//自动匹配写入对照表
		sql = "insert into tax_stone_dzb(nsrsbh,qymc,djxh)
			select * from (
			select distinct a.nsrsbh,a.nsrmc,dj.djxh 
			from tax_stonedata a,dj_nsrxx dj
			where a.nsrsbh=dj.nsrsbh
			and a.djxh is null
			and a.nsrsbh not in (select nsrsbh from tax_stone_dzb)
			)";
		db.ExcecutSQL(sql);
		
		sql = "insert into tax_stone_dzb(nsrsbh,qymc,djxh)
			select * from (
			select distinct dj.nsrsbh,a.nsrmc,dj.djxh 
			from tax_stonedata a,dj_nsrxx dj
			where a.nsrmc=dj.nsrmc
			and a.djxh is null
			and a.nsrmc not in (select qymc from tax_stone_dzb)
			)";
		db.ExcecutSQL(sql);
		
		//更新石材数据表数据
		sql = "update tax_stonedata a set (nsrsbh,djxh)=(select nsrsbh,djxh from TAX_STONE_DZB b where a.nsrmc=b.qymc and rownum=1)
			where exists (select 1 from TAX_STONE_DZB dzb where a.nsrmc=dzb.qymc)";
		db.ExcecutSQL(sql);

		
		ret = "导入完成！共新增"+inscount+"条记录，更新"+updcount +"条记录";
		//删除临时表
		sql = "drop table "+tabname;
		db.ExcecutSQL(sql);			

		return ret;
	}
	catch(e) {
		if(db != null) db.Rollback();
		return e.toString();
	}
	
	finally {
		if(db != null)	db.Close();
	}
}


}