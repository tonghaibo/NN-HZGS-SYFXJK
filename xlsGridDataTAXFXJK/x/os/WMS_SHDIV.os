function x_WMS_SHDIV(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//加载类包 
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" ); 
function getSQL()
{
	var sql = " select id,crtusr,to_char(crtdat,'yyyy-mm-dd hh24:mi:ss') crtdat,\n"+
	          " decode(stat,0,'已生成',1,'已试算',2,'未试算') state,NOTE FROM wms_shdiv_seq \n"+       
	          " where stat in (999999999";         
        if (build==1){
		sql = sql + ",0"; 
        }
        if (trial==1){
      		sql = sql + ",1";
        }
        if (untrial==1){
      		sql = sql + ",2";
        }
        sql = sql+")";
        if (shseqid!=null && shseqid!=""){
       		sql = sql + "and id like '%"+shseqid+"%'\n";
        }
        sql = sql+" order by stat desc,crtdat desc,id desc";
//      throw new Exception(sql);
      return sql;
}

function getPaginationXML(){
   var db=new pubpack.EADatabase();
   var xmlID = db.GetXMLSQL(runsql,pageno,pagesize).GetXml();
   var xmlds = new pubpack.EAXmlDS(xmlID);
   xmlds.removeColumn("num");
   xmlds.removeColumn("RID_");
   var xml = xmlds.GetXml();
   return xml;	
}
function insertTable()
{
	var db = null;
	var sql="";
	var sequ = "";
	try{	
		db = new pubpack.EADatabase();
		sequ = db.GetSQL("select to_char(SEQ_SHDIV.nextval)||'-'||to_char(sysdate,'YYYYMMDDHH24MISS') seq from dual");
//		throw new Exception(sttyp);
		sql =   " insert into WMS_SHDIV_SHINFO (bilid,item,itmid,itmnam,dat,spec,qty,corpid,owner,shnam,styp,shseq,bilseqid)\n"+ 
			" select bl.bilid,item.guid item,bl.itmid,bl.itmnam,bl.dat,bl.itmspc,bl.qty,owner.id corpid,"+
			" owner.guid owner,styp.name shnam,styp.guid styp,'"+sequ+"',bl.seqid \n"+
			" from bildtl bl,bilhdr bh,v_wms_sttyp styp,v_wms_owner owner,wms_item item \n"+
			" where bl.acc = bh.acc \n"+
			" and bl.bilid = bh.bilid \n"+
			" and bl.biltyp = bh.biltyp \n"+
			" and bh.refid1 = styp.id \n"+
			" and owner.id = bh.corpid \n"+
			" and item.id = bl.itmid \n"+
			" and bh.biltyp='ST' \n"+
			" and bh.stat='2' \n"+
			//kyo add 2008/07/28 14:00
//			" and nvl(bh.refnam3,'2999-01-01')>=to_char(sysdate,'yyyy-mm-dd')"+
			//end
			" and bh.corpid like '"+corpid+"%'\n"+
			" and (bh.refid6 <>'2' or refid6 is null)\n";
			if(!startdat.equals("")) sql+=" and bh.dat>=to_date('"+startdat+"','yyyy-mm-dd') \n";
			if(!enddat.equals("")) sql+=" and bh.dat<=to_date('"+enddat+"','yyyy-mm-dd')\n";
			
			sql+=" and bh.bilid like '"+bilid+"%'\n"+
			" and styp.id like '"+sttyp+"%'\n"+
			" and nvl(bh.refnam2,0)>=decode('"+staLine+"','',0,to_number('"+staLine+"')) \n"+
			" and nvl(bh.refnam2,0)<=decode('"+endLine+"','',999999999999,to_number('"+endLine+"')) \n"+
			" and nvl(bh.refnam1,0)>=decode('"+staSeq+"','',0,to_number('"+staSeq+"')) \n"+
			" and nvl(bh.refnam1,0)<=decode('"+endSeq+"','',999999999999,to_number('"+endSeq+"')) \n";
//			throw new Exception(sql);
		db.ExcecutSQL(sql);	
		sql = " insert into WMS_SHDIV_SLTINFO (SEQ,FNAME,FGUID,SLOT,SLTID,ITEM,ITMID,ITMNAM,SPEC,QTY,shseq) \n"+
			" select wt.seq,func.name fname,func.guid fguid,wt.slot,ws.id sltid,wt.item,wi.id itmid,wi.name itmnam,wi.spec,wt.qty+wt.adqty-wt.udqty qty,'"+sequ+"' \n"+
			" from wms_itmslt wt,wms_slot ws,wms_item wi,v_wms_slotfunc func \n"+
			" where wt.slot = ws.guid \n"+
			" and wi.guid = wt.item \n"+
			" and wi.guid in (select item from wms_shdiv_shinfo where shseq='"+sequ+"')\n"+
			" and ws.slotfunc = func.guid \n";
//		throw new Exception(sql);
		db.ExcecutSQL(sql);
		
		sql = "insert into wms_shdiv_seq(org,id,crtdat,stat,note,crtusr) values('"+org+"','"+sequ+"',sysdate,2,'','"+user+"') ";
		db.ExcecutSQL(sql);
	db.Commit();
	return sequ;
	}catch(Exception e)
	{
		throw new pubpack.EAException(e.toString());
	}finally{
		if (db!=null) db.Close();
	}		
}

function deleteTable()
{
	var db=null;
	var sql="";
	var ret = 0;
	try{
		db = new pubpack.EADatabase();
		sql = "update bilhdr set refid6='0' where bilid in (select bilid from wms_shdiv_shinfo where shseq='"+G_SEQU+"') and biltyp='ST' and acc='"+acc+"'";
		db.ExcecutSQL(sql);		
		sql = "delete from bildtl where refnam5='"+G_SEQU+"' and acc='"+acc+"' and biltyp in ('BS','RP','BC','SX')";
		db.ExcecutSQL(sql);
		sql = "delete from bilhdr where refnam5='"+G_SEQU+"' and acc='"+acc+"' and biltyp in ('BS','RP','BC','SX')";
		db.ExcecutSQL(sql);		
		sql = "delete from WMS_SHDIV_SHINFO where shseq='"+G_SEQU+"'";
		db.ExcecutSQL(sql);
		sql = "delete from WMS_SHDIV_SLTINFO where shseq='"+G_SEQU+"'";
		db.ExcecutSQL(sql);
		sql = "delete from WMS_SHDIV_TRIAL where shseq = '"+G_SEQU+"'";
		db.ExcecutSQL(sql);
		sql = "delete from WMS_SHDIV_LOG where shseq = '"+G_SEQU+"'";
		db.ExcecutSQL(sql);
		sql = "delete from WMS_SHDIV_SEQ where id= '"+G_SEQU+"'";
		db.ExcecutSQL(sql);
		unUpdateSltQty(G_SEQU,db);
		ret++;
		db.Commit();
		return ret;
	}catch(Exception e){
		db.Rollback();
		throw new pubpack.EAException(e.toString());
	}finally{
		if (db!=null) db.Close();
	}
	
}

//================================================================// 
// 函数：buildBilid
// 说明：
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：06/23/08 10:46:06
// 修改日志：
//================================================================// 
function buildBilid()
{
//	var xmlds = new pubpack.EAXmlDS(rpxml);
	var db = null;
	var stat = null;
	var rs = null;
	var sql = "";
	var srczone = "";
	var aimzone = "";
	var newbil = "";
//	var locid ="";
//	var line = "";
	var BSzoneguid ="";
	var corpguid ="";
//	var corpid = "";
	var bil="";
	var zds =null;
//	var corpidds= null;
	var srclocidds =null;
	var srclocid ="";
	var aimlocidds = null;
	var aimlocid ="";
	try{
	db = new pubpack.EADatabase();
	stat = db.GetConn().createStatement();
	// 1. 创建补货单, 根据保管区跟集货区来分单
	sql = "select distinct b.zone srczone,c.zone aimzone from WMS_SHDIV_TRIAL a,wms_slot b,wms_slot c \n"
		+" where ACTION='补货' and a.srcsltid = b.id and a.aimsltid =c.id and a.shseq = '"+G_SEQU+"'";
	zds = db.QuerySQL(sql );
//	throw new Exception (sql);
	for (var i = 0 ;i<zds.getRowCount();i++){
		srczone = zds.getStringAt(i,"srczone");//源储区
		srclocidds = db.QuerySQL("select distinct b.id srclocid from wms_zone a,wms_loc b where a.loc =b.guid and a.guid = '"+srczone+"'");
		if(srclocidds.getRowCount()==0){
			throw new Exception("生成补货单时未发现源储区"+srczone+"所在的仓库！\n 操作取消！");
		}
		srclocid = srclocidds.getStringAt(0,"srclocid");//源储区所在仓库
				
		aimzone = zds.getStringAt(i,"aimzone");//目标储区
		aimlocidds = db.QuerySQL("select distinct b.id aimlocid from wms_zone a,wms_loc b where a.loc =b.guid and a.guid = '"+aimzone+"'");
		if(srclocidds.getRowCount()==0){
			throw new Exception("生成补货单时未发现目标储区"+aimczone+"所在的仓库！\n 操作取消！");
		}
		aimlocid = aimlocidds .getStringAt(0,"aimlocid");//目标储区所在仓库
		
		if(!srclocid.equals(aimlocid)){
			throw new Exception("生成补货单时源储区所在仓库"+srclocid+"和目标储区所在仓库"+aimlocid+"不一致！\n 操作取消！");
		}
		newbil = getMaxBilid(db,"RP",acc,"bilid","RP");//补货单号

		sql = InsHdrSQL(selectRP2HdrSQL(newbil,srczone,aimzone));
//		throw new Exception (sql);
		db.ExcecutSQL(sql);	
//		if(i==1){
		sql = InsDtlSQL(selectRP2DtlSQL(newbil,srczone,aimzone));
//		throw new Exception (sql);
		db.ExcecutSQL(sql);
//		}
	}		
	// 2. 创建捡货单, 根据拣货分区和终端分单
	sql = "select distinct refid2 corpguid,c.zone BSzoneguid from bilhdr a,WMS_SHDIV_TRIAL b,wms_slot c where acc ='"+acc+"' and biltyp='ST' \n"+
		"and a.bilid= b.bilid and b.ACTION='捡货' and b.shseq = '"+G_SEQU+"' and trim(b.srcslt) = c.guid";
//	throw new Exception(sql);
	zds = db.QuerySQL(sql);
	for (var i=0;i< zds.getRowCount();i++)
	{
		corpguid = zds.getStringAt(i,"corpguid");
//		srclocidds = db.QuerySQL("select distinct locid srclocid from bilhdr where bilid = '"+bilid+"'");
		BSzoneguid = zds.getStringAt(0,"BSzoneguid");
//		if(srclocid.equals("")){
//			throw new Exception ("生成捡货单时未发现出货通知单["+bilid+"]指定的仓库为空！ \n 操作取消！");
//		}
//		if(i==1){
		newbil = getMaxBilid(db,"BS",acc,"bilid","BS");
		sql = InsHdrSQL(selectBS2HdrSQL(newbil,corpguid,BSzoneguid));
//		throw new Exception (sql);
		db.ExcecutSQL(sql);
		sql = InsDtlSQL(selectBS2DtlSQL(newbil,corpguid,BSzoneguid));
//		throw new Exception (sql);
		db.ExcecutSQL(sql);
//		}
	}	
	// 2. 创建合流单,根据路线来分单
//	bds = db.QuerySQL("select distinct refid2 line from bilhdr where refnam5='"+G_SEQU+"' and acc='"+acc+"' biltyp ='BS' and a.");
//	for (var i=0;i< bds.getRowCount();i++)
//	{
//		line = bds.getStringAt(i,"line");
//		newbil = getMaxBilid(db,"BC",acc,"bilid","BC");
//		sql = InsHdrSQL(selectBC2HdrSQL(newbil,line,G_SEQU));	
//		db.ExcecutSQL(sql);
//		sql = InsDtlSQL(selectBC2DtlSQL(newbil,bilid));
//		db.ExcecutSQL(sql);
//		}
	//3.创建配送单,根据配送路线来分单
//	var sql = "select distinct b.refid2 corpid,b.locid locid FROM WMS_SHDIV_TRIAL a,bilhdr b \n"+
//		"  where a.bilid = b.bilid and b.biltyp='ST' and b.acc='"+acc+"' and a.shseq = '"+G_SEQU+"'";
//	corpidds= db.QuerySQL(sql);
//	throw new Exception(lineseqds.getRowCount());
//	for(var i=0;i< corpidds.getRowCount();i++)
//	{
//		corpid = corpidds.getStringAt(i,"corpid");
//		locid = corpidds.getStringAt(i,"locid");	

//		newbil = getMaxBilid(db,"SX",acc,"bilid","SX");
//		sql = InsDtlSQL(selectSX2DtlSQL(newbil,corpid));
//		throw new Exception(sql);
//		db.ExcecutSQL(sql);
	
//		sql = InsHdrSQL(selectSX2HdrSQL(newbil,corpid,locid ));
//		throw new Exception(sql);
//		db.ExcecutSQL(sql);

//	}
//      修改涉及到的出货通知单的状态（１或null为未做分配，２为已做分配）	
	updateSTStat(db,G_SEQU);
	
//	修改wms_itmslt表中的待下架或待上架数量	
	updateSltQty(G_SEQU,db);
	
//	得到返回的本次货源分配所生成的单据集	
	rs = stat.executeQuery("select bilid from bilhdr where biltyp='BS' and refnam5='"+G_SEQU+"'");
	while(rs.next()){bil += rs.getString("bilid")+",";}
	bil = bil+"-";
	rs = stat.executeQuery("select bilid from bilhdr where biltyp='RP' and refnam5='"+G_SEQU+"'");
	while(rs.next()){bil += rs.getString("bilid")+",";}
	bil = bil+"~";
//	rs = stat.executeQuery("select bilid from bilhdr where biltyp='BC' and refnam5='"+G_SEQU+"'");
//	while(rs.next()){bil+= rs.getString("bilid")+",";}
//	bil = bil+"*";
//	rs = stat.executeQuery("select bilid from bilhdr where biltyp='SX' and refnam5='"+G_SEQU+"'");
//	while(rs.next()){bil+= rs.getString("bilid")+",";}
	
	stat.executeUpdate("update wms_shdiv_seq t set t.stat = '0' where t.id = '"+G_SEQU+"'");
//	var pw = new streampack.PrintWriter(new streampack.BufferedWriter(new streampack.FileWriter("d://a.txt")));
	db.Commit();
	}catch(ee){
		db.Rollback();
		throw new pubpack.EAException(ee.toString());
	}
	finally{
		if (db!=null) db.Close();
	}	
	return bil;
}
//================================================================// 
// 函数：InsDtlSQL
// 说明：INSERT INTO BILDTL
// 参数：sql字符串
// 返回：
// 样例：
// 作者：
// 创建日期：06/17/08 16:52:24
// 修改日志：
//================================================================// 
function InsDtlSQL(listSQL)
{
	var sql = " INSERT INTO BILDTL ( ACC,SYT,ORG,BILID,BILTYP,SUBTYP,CORPID,LOCID,DAT,STAT,SEQID,ITMID,\n"+
	     	  " ITMNAM,ITMSPC,UNIT,UNTNUM,TONNUM,PRICE,QTY,TAXTYP,NOTAXMNY,TAXMNY,MNY,REFID1,REFNAM1,\n"+
	     	  " REFID2,REFNAM2,SMLUNT,ITEMPC,REFID3,REFNAM3,REFID4,REFNAM4,REFID5,REFNAM5 ) \n"+
		  " SELECT * FROM ( \n"+listSQL+" \n)"; 
//	throw new Exception(sql);	
	return sql;	     	  
}
//================================================================// 
// 函数：InsHdrSQL
// 说明：INSERT INTO BILHDR
// 参数：sql字符串
// 返回：
// 样例：
// 作者：
// 创建日期：06/17/08 16:52:30
// 修改日志：
//================================================================// 
function InsHdrSQL(listSQL)
{
	var sql = " INSERT INTO BILHDR ( ACC,SYT,ORG,BILID,BILTYP,SUBTYP,CORPID,CORPNAM,LOCID,LOCNAM,DAT,STAT,CRTUSR, \n"+
		  " CRTUSRNAM,NOTE,SUMQTY,SUMMNY,REFID1,REFNAM1,REFID2,REFNAM2,DATFLW,REFID3,REFNAM3,REFID4,REFNAM4, \n"+
		  " REFID5,REFNAM5,REFID6,REFNAM6) \n"+
		  " SELECT * FROM ( \n"+listSQL+"\n) ";
//	throw new Exception(sql);
	return sql;
}

//================================================================// 
// 函数：selectRP2DtlSQL(newbil,zone)
// 说明：插入DTL表的select语句(补货单)
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：06/23/08 14:03:05
// 修改日志：
//================================================================// 
function selectRP2DtlSQL(newbil,srczone,aimzone)
{	
	var listSQL = " select ACC,SYT,ORG,BILID,BILTYP,SUBTYP,CORPID,LOCID,DAT,STAT,min(SEQID) SEQID,ITMID, \n"+
 		      " ITMNAM,ITMSPC,UNIT,UNTNUM,TONNUM,PRICE,sum(QTY) QTY,sum(TAXTYP) TAXTYP,NOTAXMNY,TAXMNY,MNY,REFID1,refnam1, \n"+
                      " REFID2,REFNAM2,SMLUNT,ITEMPC,refid3,REFNAM3,sum(refid4) REFID4,sum(refnam4) REFNAM4,REFID5,REFNAM5 \n"+
		      " from ( \n"+
	 	      " select '"+acc+"' ACC,'"+syt+"' SYT,'"+org+"' ORG ,'"+newbil+"' BILID,'RP' BILTYP,'ST' SUBTYP,b.corpid CORPID,b.locid LOCID,sysdate DAT, \n"+
		      " 1 STAT,a.seqid,a.itmid ITMID,a.itmnam ITMNAM,a.spec ITMSPC,c.unit UNIT,c.untnum UNTNUM,c.tonnum TONNUM,0 PRICE,a.qty QTY,\n"+
		      " a.qty TAXTYP,0 NOTAXMNY,0 TAXMNY,0 MNY,'' REFID1,'0' REFNAM1, \n"+
		      " '' REFID2,a.srcslt REFNAM2,c.smlunt SMLUNT, (select itempc from wms_itmslt where slot = a.srcslt and item = a.item)  ITEMPC,\n"+
		      " (select distinct q.guid from wms_item p,wms_slot q where trim(p.repbuf) = q.id and p.guid = a.item ) REFID3,\n"+
		      " a.aimslt REFNAM3, a.qty REFID4,a.qty REFNAM4,'' REFID5,'"+G_SEQU+"' REFNAM5 from \n"+
	 	      " (select a.*,b.zone from  wms_shdiv_trial a,wms_slot b where a.shseq='"+G_SEQU+"' and a.action='补货' and a.srcsltid = b.id) a, \n"+
	 	      " (select a.*,b.zone from  wms_shdiv_trial a,wms_slot b where a.shseq='"+G_SEQU+"' and a.action='补货' and a.aimsltid = b.id) d, \n"+
	 	      " bilhdr b,wms_item c where b.	biltyp='ST'and a.item = c.guid and b.acc='"+acc+"' and a.zone = '"+srczone+"' and a.bilid = b.bilid \n"+
	 	      " and b.bilid = d.bilid and d.zone='"+aimzone+"' and d.item = c.guid and a.seqid = d.seqid \n"+
	 	      " ) group by ACC,SYT,ORG,BILID,BILTYP,SUBTYP,CORPID,LOCID,DAT,STAT,ITMID,\n"+
		      " ITMNAM,ITMSPC,UNIT,UNTNUM,TONNUM,PRICE,NOTAXMNY,TAXMNY,MNY,REFID1,REFNAM1,\n"+
		      " REFID2,REFNAM2,SMLUNT,ITEMPC,REFID3,REFNAM3,REFID5,REFNAM5  \n";
//		throw new Exception (listSQL);
	return listSQL;	 	       
}
//================================================================// 
// 函数：selectRP2HdrSQL(newbil,zone,locid)
// 说明：插入HDR表的select 语句(补货单)
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：06/23/08 14:02:15
// 修改日志：
//================================================================// 
function selectRP2HdrSQL(newbil,srczone,aimzone)
{
	var listSQL = " select distinct '"+acc+"' ACC,'"+syt+"' SYT ,'"+org+"' ORG,'"+newbil+"' BILID,'RP' BILTYP,'ST' SUBTYP,'' CORPID, \n"+
		      " '' CORPNAM,'"+locid+"' LOCID,(select name from wms_loc where id like '"+locid+"%') LOCNAM, \n"+
		      " sysdate DAT,1 STAT,'"+crtusr+"' CRTUSR,'"+crtusrnam+"' CRTUSRNAM,'' NOTE,0 SUMQTY,0 SUMMNY,''REFID1,'"+crtusrnam+"' REFNAM1,'' REFID2, \n"+
		      " '"+srczone+"' REFNAM2,'' DATFLW,'"+aimzone+"' REFID3,'' REFNAM3,'' REFID4, to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss') REFNAM4,'' REFID5,'"+G_SEQU+"'　REFNAM5,'' REFID6,'' REFNAM6 \n"+
		      " from dual/*bilhdr a where biltyp='ST' and acc=*/";
//	throw new Exception (listSQL);
	return listSQL;		      
} 
//================================================================// 
// 函数：selectBS2DtlSQL()
// 说明：插入DTL表的select语句(捡货单)
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：06/23/08 14:39:11
// 修改日志：
//================================================================//
function selectBS2DtlSQL(newbil,corpguid,BSzoneguid)
{
	var listSQL = " select ACC,SYT,ORG,BILID,BILTYP,SUBTYP,CORPID,LOCID,DAT,STAT,min(SEQID) SEQID,ITMID, \n"+
 		      " ITMNAM,ITMSPC,UNIT,UNTNUM,TONNUM,PRICE,sum(QTY) QTY,sum(TAXTYP) TAXTYP,NOTAXMNY,TAXMNY,MNY,REFID1,REFNAM1, \n"+
                      " REFID2,REFNAM2,SMLUNT,ITEMPC,refid3,REFNAM3,REFID4,REFNAM4,REFID5,REFNAM5 \n"+
		      " from ( \n"+
		      " select '"+acc+"' ACC,'"+syt+"' SYT,'"+org+"' ORG,'"+newbil+"' BILID,'BS' BILTYP, \n"+
		      " '' SUBTYP, b.corpid CORPID,B.LOCID LOCID,sysdate DAT,1 STAT,A.seqid SEQID,a.itmid ITMID,a.itmnam ITMNAM ,\n"+
		      " a.spec ITMSPC ,c.unit UNIT,c.untnum UNTNUM,c.tonnum TONNUM,0 PRICE,a.qty QTY,a.qty TAXTYP,0 NOTAXMNY,0 TAXMNY,0 MNY, \n"+
		      " /*(SELECT to_char(prodat,'yyyy-mm-dd') from v_wms_bsprodat m,v_wms_srcslt n where m.shseq =n.shseq and m.item =n.item \n "+
		      " and m.slot = n.srcslt and m.shseq=a.shseq and m.bilid =a.bilid and a.item =m.item and rownum=1)*/'' REFID1,\n"+
		      " '' REFNAM1,'' REFID2, a.srcslt REFNAM2,c.smlunt SMLUNT,/*d.refnam1*/'' ITEMPC, \n"+  
		      " oprseq REFID3,'' REFNAM3, '' REFID4,'' REFNAM4,'' REFID5,'"+G_SEQU+"' REFNAM5 \n"+
		      " from (select a.*,b.zone,b.oprseq from wms_shdiv_trial a,wms_slot b where a.srcsltid = b.id and a.action='捡货' and a.shseq='"+G_SEQU+"') a,\n"+
		      " bilhdr b,wms_item c,bildtl d where b.biltyp='ST' and b.acc = d.acc and b.biltyp =d.biltyp and b.bilid =d.bilid 	and a.itmid =d.itmid and a.item = c.guid \n"+
		      " and a.item = c.guid and b.acc='"+acc+"' and a.bilid = b.bilid  and a.zone = '"+BSzoneguid+"' and b.refid2='"+corpguid+"' \n"+
		      " ) group by ACC,SYT,ORG,BILID,BILTYP,SUBTYP,CORPID,LOCID,DAT,STAT,ITMID,\n"+
		      " ITMNAM,ITMSPC,UNIT,UNTNUM,TONNUM,PRICE,NOTAXMNY,TAXMNY,MNY,REFID1,REFNAM1,\n"+
		      " REFID2,REFNAM2,SMLUNT,ITEMPC,REFID3,REFNAM3,REFID4,REFNAM4,REFID5,REFNAM5  \n";
	throw new Exception(listSQL);	
	return listSQL;
}

//================================================================// 
// 函数：selectBS2HdrSQL(newbil,zone,locid)
// 说明：插入HDR表的select语句(捡货单)
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：06/23/08 16:24:46
// 修改日志：
//================================================================// 
function selectBS2HdrSQL(newbil,corpguid,BSzoneguid)
{
	var listSQL = " select distinct '"+acc+"' ACC,'"+syt+"' SYT,'"+org+"' ORG, '"+newbil+"' BILID,'BS' BILTYP, \n"+
		      " 'ST' SUBTYP,(select id from wms_owner where guid = (select owner from wms_corp where guid = '"+corpguid+"')) CORPID, \n"+
		      "(select name from wms_owner where guid = (select owner from wms_corp where guid = '"+corpguid+"')) CORPNAM,'"+locid+"' LOCID, \n"+
		      " (select name from wms_loc where id like '"+locid+"') LOCNAM, \n"+
		      " sysdate DAT,1 STAT, '"+crtusr+"' CRTUSR,'"+crtusrnam+"' CRTUSRNAM,'' NOTE,0 SUMQTY,0 SUMMNY,'"+corpguid+"' REFID1,\n"+
		      " (select id from wms_zone where guid = '"+BSzoneguid+"') REFNAM1,"+
		      " (select disline from wms_corp where guid = '"+corpguid+"') REFID2, \n"+
		      " (select disseq from wms_corp where guid = '"+corpguid+"') REFNAM2,'' DATFLW, \n"+
		      " (select ctzone from wms_corp where guid = '"+corpguid+"') REFID3, \n"+
		      	" '' REFNAM3,''  REFID4,'' REFNAM4,'' REFID5,\n"+
		      " '"+G_SEQU+"' REFNAM5,''  REFID6,'' REFNAM6 \n"+
		      " FROM dual/*bilhdr a where acc='"+acc+"' and bi	ltyp = 'ST' and refid2 ='"+corpguid+"'*/";
//		      throw new Exception(listSQL);
	return listSQL;	
}

//================================================================// 
// 函数：selectBC2DtlSQL()
// 说明：插入DTL表的select语句(合流单)根据WMS_SHDIV_SLTINFO的【单据编号】（通知单）来创建合流单，来源货位都是商品所在的出货分区。
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：06/23/08 16:46:59
// 修改日志：
//================================================================// 
//function selectBC2DtlSQL(newbil,bilid)
//{
//	var listSQL = " select '"+acc+"' ACC,'"+syt+"' SYT,'"+org+"' ORG,'"+newbil+"' BILID,'BC' BILTYP, \n"+
//		      " 'ST' SUBTYP,b.corpid CORPID,b.locid LOCID,sysdate DAT,1 STAT,a.seqid SEQID,a.itmid ITMID,a.itmnam ITMNAM ,\n"+
//		      " a.spec ITMSPC ,c.unit UNIT,c.untnum UNTNUM,c.tonnum TONNUM,0 PRICE,a.qty QTY,0 TAXTYP,0 NOTAXMNY,0 TAXMNY,0 MNY,\n"+
//		      " (select guid from wms_loc where id=b.locid) REFID1,\n"+
//		      " (select SHPCAT from wms_item where id = a.itmid and owner = (select guid from wms_owner where id=b.corpid)) REFNAM1, \n"+
//		      " '' REFID2,'' REFNAM2,c.smlunt SMLUNT,'' ITEMPC,'' REFID3,'' REFNAM3,'' REFID4,'' REFNAM4,'' REFID5,'"+G_SEQU+"' REFNAM5 \n"+
//		      " FROM WMS_SHDIV_TRIAL A,BILHDR B,wms_item c where a.item = c.guid and \n"+
//		      " a.bilid = b.bilid and b.biltyp='ST' and a.bilid = '"+bilid+"' and b.acc = '"+acc+"' and a.shseq='"+G_SEQU+"' AND a.action='捡货'\n"; 
//	return listSQL;
//}
//================================================================// 
// 函数：selectBC2HdrSQL()
// 说明：插入HDR表的select语句(合流单)根据WMS_SHDIV_SLTINFO的【单据编号】（通知单）来创建合流单，来源货位都是商品所在的出货分区。
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：06/23/08 16:48:07
// 修改日志：
//================================================================// 
//function selectBC2HdrSQL(newbil,bilid)
//{
//	var listSQL = " select distinct '"+acc+"' ACC,'"+syt+"' SYT,'"+org+"' ORG, '"+newbil+"' BILID,'BC' BILTYP, \n"+
//		      " 'ST' SUBTYP,'"+ownerID+"' CORPID,(select name from wms_owner where id = '"+ownerID+"' ) CORPNAM, \n"+
//		      " (select id from wms_vendor where name =b.refid2 ) LOCID,b.refid2 LOCNAN,sysdate DAT,1 STAT,'"+crtusr+"' CRTUSR,\n"+
//		      " '"+crtusrnam+"' CRTUSRNAM,'' NOTE,0 SUMQTY,0 SUMMNY,'"+bilid+"' REFID1,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') REFNAM1,\n"+
//		      " b.refid2 REFID2,'"+crtusrnam+"' REFNAM2,'' DATFLW,b.refnam2 REFID3,b.refnam1 REFNAM3,b.refid3 REFID4,'' REFNAM4,b.refid5 REFID5,'"+G_SEQU+"' REFNAM5,b.refid1 REFID6,'' REFNAM6 \n"+
//		      " from wms_shdiv_trial a,bilhdr b where a.bilid = b.bilid and b.biltyp='ST' and a.bilid='"+bilid+"' and b.acc = '"+acc+"' and a.shseq='"+G_SEQU+"'\n";
//	return listSQL;		      
//}
//
//================================================================// 
// 函数：selectSX2HdrSQL(newbil,line)
// 说明：
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：06/24/08 18:21:31
// 修改日志：
//================================================================// 
//function selectSX2HdrSQL(newbil,corpid,locid )
//{
//	var listSQL = " select distinct '"+acc+"' ACC,'"+syt+"' SYT,'"+org+"' ORG,'"+newbil+"' BILID,'SX' BILTYP,\n"+
//		      " 'ST' SUBTYP,a.corpid CORPID,a.corpnam CORPNAM, \n"+
//		      " '"+locid+"' LOCID,'' LOCNAM,sysdate DAT,1 STAT,'"+crtusr+"' CRTUSR,'"+crtusrnam+"' CRTUSRNAM,'' NOTE,\n"+
//		      " (select sum(qty) from bildtl where acc='"+acc+"' and biltyp ='SX' and bilid='"+newbil+"') SUMQTY, \n"+
//		      " (select sum(mny) from bildtl where acc='"+acc+"' and biltyp ='SX' and bilid='"+newbil+"') SUMMNY, \n"+
//		      "  a.refnam2 REFID1,a.refid2  REFNAM1,refid4 REFID2,'' REFNAM2,'' DATFLW,'' REFID3,a.refnam5 REFNAM3,\n"+
//		      " (select sum(qty) from bildtl where acc='"+acc+"' and biltyp ='SX' and bilid='"+newbil+"') REFID4,\n"+
//		      " a.refnam1 REFNAM4,'' REFID5,'"+G_SEQU+"' REFNAM5, '' REFID6,'' REFNAM6 \n"+
//		      " from bilhdr a where biltyp='ST' \n"+
//		      " and bilid in (SELECT DISTINCT BILID FROM WMS_SHDIV_TRIAL WHERE SHSEQ='"+G_SEQU+"') \n"+
//		      " and a.refid2 = '"+corpid+"' \n"+
//		      " and a.acc ='"+acc+"'";
//		      throw new Exception (listSQL );
//	return listSQL;		      
//}

//function selectSX2DtlSQL(newbil,corpname )
//{
//	var listSQL = " select '"+acc+"' ACC,'"+syt+"' SYT,'"+org+"' ORG,'"+newbil+"' BILID,'SX' BILTYP, \n"+
//		      " 'ST' SUBTYP,bl.corpid CORPID,bl.locid LOCID,sysdate DAT,1 STAT,ROWNUM SEQID,bl.itmid ITMID,bl.itmnam ITMNAM ,\n"+
//		      " bl.itmspc ITMSPC ,wi.unit UNIT,wi.untnum UNTNUM,wi.tonnum TONNUM,0 PRICE,bl.qty QTY,0 TAXTYP,0 NOTAXMNY,0 TAXMNY,bl.mny MNY,\n"+
//		      " bl.bilid REFID1,'' REFNAM1,'' REFID2,'' REFNAM2,wi.smlunt SMLUNT,'' ITEMPC,'' REFID3,\n"+
//		      " '' REFNAM3,'' REFID4,'' REFNAM4,'' REFID5,'"+G_SEQU+"' REFNAM5 \n"+
//		      " from bilhdr bh,bildtl bl,(select distinct bilid,item,shseq from wms_shdiv_trial)  sh,wms_item wi\n"+
//		      " where bh.acc = bl.acc and bl.biltyp = bh.biltyp and bl.bilid = bh.bilid and bl.itmid = wi.id  and sh.item = wi.guid \n"+
//		      " and bh.refid2='"+corpname +"' and bh.biltyp='ST' \n"+
//		      " and sh.bilid=bh.bilid and sh.shseq= '"+G_SEQU+"'and bh.acc='"+acc+"'\n";    
// 	throw new Exception (listSQL );
//	return listSQL;	
//}

//
function GetBills(){
	var bil ="";
	var db = null;
	var stat = null;
	var rs = null;
	try{
	db = new pubpack.EADatabase();
	stat = db.GetConn().createStatement();

	rs = stat.executeQuery("select bilid from bilhdr where biltyp='BS' and refnam5='"+G_SEQU+"'");
	while(rs.next()){bil += rs.getString("bilid")+",";}
	bil = bil+"-";
	rs = stat.executeQuery("select bilid from bilhdr where biltyp='RP' and refnam5='"+G_SEQU+"'");
	while(rs.next()){bil += rs.getString("bilid")+",";}
	bil = bil+"~";
	rs = stat.executeQuery("select bilid from bilhdr where biltyp='BC' and refnam5='"+G_SEQU+"'");
	while(rs.next()){bil+= rs.getString("bilid")+",";}
	bil = bil+"*";
	rs = stat.executeQuery("select bilid from bilhdr where biltyp='SX' and refnam5='"+G_SEQU+"'");
	while(rs.next()){bil+= rs.getString("bilid")+",";}
	
	return bil;
//	throw new Exception(bil);

	}catch(ee){
		throw new Exception(ee.toString());
	}
	finally{
		if (db!=null) db.Close();
	}	
}

//修改库位库存的待上架或待下架数量
function updateSltQty(G_SEQU,db)
{
//	var stat = db.GetConn().createStatement();
//	var rs = stat.executeQuery("select distinct srcslt from wms_shdiv_trial where shseq='"+G_SEQU+"'");
//	var rltslt = "";
//	var sql = "";
//	if (rs.next()){
//		rltslt = rs.getString("srcslt");
//		if(rltslt==nlll){rltslt=""}
//		sql = "update wms_itmslt set udqty = udqty+(select sum(qty) from wms_shdiv_trial where srcslt=rltslt and shseq = '"+G_SEQU+"')";
//		db.ExcecutSQL(sql);
//	}
//	rs = stat.executeQuery("select distinct aimslt from wms_shdiv_trial where shseq = '"+G_SEQU+"'");
//	if(rs.next()){
//		rltslt = rs.getString("aimslt");
//		sql = "update wms_itmslt set adqty = adqty +(select sum(qty) from wms_shdiv_trial where aimslt =nvl( '"+rltslt+"','') and shseq='"+G_SEQU+"')";
//		db.ExcecutSQL(sql);
//	}	    	
}

//还原库存中待上架各下架数量
function unUpdateSltQty(G_SEQU,db){
//	var stat = db.GetConn().createStatement();
//	var rs = stat.executeQuery("select distinct srcslt from wms_shdiv_trial where shseq='"+G_SEQU+"'");
//	var rltslt = "";
//	var sql = "";
//	if (rs.next()){
//		rltslt = rs.getString("srcslt");
//		sql = "update wms_itmslt set udqty = udqty-(select sum(qty) from wms_shdiv_trial where srcslt=nvl('"+rltslt+"','') and shseq = '"+G_SEQU+"')";
//		db.ExcecutSQL(sql);
//	}
//	rs = stat.executeQuery("select distinct aimslt from wms_shdiv_trial where shseq = '"+G_SEQU+"'");
//	if(rs.next()){
//		rltslt = rs.getString("aimslt");
//		sql = "update wms_itmslt set adqty = adqty -(select sum(qty) from wms_shdiv_trial where aimslt =nvl( '"+rltslt+"','') and shseq='"+G_SEQU+"')";
//		db.ExcecutSQL(sql);
//	}	
}


//================================================================// 
// 函数：getMaxBilid(db,biltyp,G_ACCID,field,prefix)
// 说明：生成单据号
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：06/24/08 09:27:31
// 修改日志：
//================================================================// 
function getMaxBilid(db,biltyp,G_ACCID,field,prefix)
{
        var No="0000000";
        var bilid=null;
	var num=null;
       	var tmpnum; 
        bilid=prefix; 
        var sql="select 1*substr(max(trim("+field+")),3) from bilhdr a where acc='"+G_ACCID+"' and biltyp='"+biltyp+"' \n";  
        if (biltyp=="SX"){
        	sql ="select  1*substr(max(trim("+field+")),3) from bildtl a where acc='"+G_ACCID+"' and biltyp='"+biltyp+"' \n" ;
        }
        tmpnum=db.GetSQL(sql);
        if(tmpnum==""||tmpnum==null) {
        	bilid=bilid+"00000001";                  
        	
        } else {                  
        	num=1*tmpnum; 
        	num=num+1;         
        	num=""+num;
                bilid=bilid+No.substring(0,8-num.length())+num;
        }	
        return bilid;
}

//修改已做货源分配的出货通知单的状态
function updateSTStat(db,G_SEQU)
{
	var sql = "update bilhdr set refid6='2' where biltyp='ST' and bilid in (select distinct bilid from wms_shdiv_trial where shseq='"+G_SEQU+"')";
	db.ExcecutSQL(sql);
}

//function SaveTrialNote(){
//	try{
//	db = new pubpack.EADatabase();
//	stat = db.GetConn().createStatement();
//	db.ExcecutSQL("update wms_shdiv_seq set note = '"+note+"' where shseq='"+G_SEQU+"'");
//	db.Commit();
//	}catch(Exception e){
//		db.Rollback();
//		throw new pubpack.EAException(e.toString());
//	}finally{
//		if (db!=null) db.Close();
//	}
//
//}



}