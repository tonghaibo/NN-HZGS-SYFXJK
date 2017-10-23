function x_flwpub(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var grd= new JavaPackage("com.xlsgrid.net.grd");
var utilpack = new JavaPackage("java.util");
var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
// 客户端param传入的参数可以直接使用
// 返回  生成的明细数量
// 要求： xmlstr需要存在ITMID SRCBILTYP SRCBIL, QTY字段
// 多对多，支持部分数量核销 Gen121
function GenN2N(db,flw,acc,xmlstr)
{
	return GenN2NClose(db,flw,acc,xmlstr,false);
}
// 多对多接口，并且支持强行结束数据流
// bClose=true 强行结束
function GenN2NClose(db,flw,acc,xmlstr,bClose)
{
	return GenN2NClose0(db,flw,flw,acc,xmlstr,bClose);

}	
// 支持来源数据流和目标数据流不一致
function GenN2NClose0(db,srcflw,destflw,acc,xmlstr,bClose)
{
	var ds = null;
	var sql = "";		
// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		ds = new pubpack.EAXmlDS(xmlstr);				
		var seq = db.GetSQL("select HF001SEQ.nextval from dual");
		sql = " create table SELBFPUB_"+seq+" as SELECT acc,SRCBILTYP,SRCBIL,SRCBILDAT,SRCBILSEQ,VALLEFT,0 val2Convert,guid FROM DATFLWSTA where rownum<1 \n";
		db.ExcecutSQL(sql);		
//		throw new Exception(xmlstr);
		for(var row=0;row< ds.getRowCount();row++){			
			var qty = ds.getStringAt(row,"QTY");
			var srcseq = ds.getStringAt(row,"SRCBILSEQ");
			var selflg = ds.getStringDef(row,"SELECTFLAG", "1" );	// 如果不存SELECTFLAG当作已选择
			if ( selflg == "1" ) {
				if(qty==null ||qty==""){
					qty=0;
				}
				else{
					qty = qty*1.0;				
				}	
				sql = " insert into SELBFPUB_"+seq+" \n"+
				      " SELECT acc,SRCBILTYP,SRCBIL,SRCBILDAT,SRCBILSEQ,VALLEFT,"+qty+" val2convert,guid \n"+
				      " from datflwsta where flw='"+srcflw+"' \n"+ 
				      " AND SRCBILTYP ='"+ ds.getStringAt(row,"SRCBILTYP")+"' AND ACC='"+acc+"' \n"+
				      " and srcbil = '"+ds.getStringAt(row,"SRCBIL")+"' AND nvl(REFID3,' ') like '"+ ds.getStringAt(row,"ITMID")+"%'\n"+
				      " and srcbilseq = '"+srcseq+"'\n";
//				      throw new Exception(sql);			      
				db.ExcecutSQL(sql);	
			}
		} 
		
		sql = " select '1' SELECTFLG,A.*,B.val2Convert val2Convert FROM DATFLWSTA A,SELBFPUB_"+seq+" B \n"+
		      " where a.srcbil = b.srcbil and a.srcbiltyp = b.srcbiltyp and a.acc = b.acc \n"+	      
		      " AND A.SRCBILSEQ = B.SRCBILSEQ and a.flw='"+srcflw+"' and a.acc='"+acc+"'\n"+		      
		      " and a.valleft<>0  ORDER BY A.SRCBILTYP DESC \n";    
//		      throw new Exception(sql); 
		var xmlds = db.QuerySQL(sql); 	
		var retbil = "";		
		if( xmlds.getRowCount()>0){     		
			var xml = xmlds.GetXml();
			try{			
				retbil = grd.EABilflw.ExecBilFlw(db,request,destflw,xml);								
			}catch(e){
				throw new Exception("执行数据异常!"+e.toString());
			}	
		}
		
		if ( bClose == true ) {
			db.ExcecutSQL("update datflwsta set endflg='1' where guid  in ( select guid from SELBFPUB_"+seq+" )" );
		
		}
		
		sql = "drop table SELBFPUB_"+seq+"\n";
		db.ExcecutSQL(sql);
		
		return retbil ;//xmlds.getRowCount();
}
//支持批量转换从多个来源单据相对转换多个目标
//要求： xmlstr需要存在ITMID SRCBILTYP SRCBIL, QTY字段
function GenN2M(db,flw,acc,xmlstr)
{
	return GenN2M(db,flw,acc,xmlstr,"",false);
}	
// bCheck : =1 生成目标单据的时候进行审核
function GenN2M(db,flw,acc,xmlstr,usrid,bCheck)
{
	var ds = null;
	var sql = "";
		ds = new pubpack.EAXmlDS(xmlstr);
//		throw new Exception(usrid);	
		var seq = db.GetSQL("select HF001SEQ.nextval from dual");
//		throw new Exception(seq);	
		sql = " create table SELBFPUB_"+seq+" as SELECT acc,SRCBILTYP,SRCBIL,SRCBILDAT,SRCBILSEQ,VALLEFT,0 val2Convert,guid FROM DATFLWSTA where rownum<1 \n";
		db.ExcecutSQL(sql);	
		for(var row=0;row< ds.getRowCount();row++){			
			var qty = ds.getStringAt(row,"QTY");
			var selflg = ds.getStringDef(row,"SELECTFLAG", "1" );	// 如果不存SELECTFLAG当作已选择
			
			if ( selflg == "1" ) {
				if(qty==null ||qty==""){
					qty=0;
				}
				else{
					qty = qty*1.0;				
				}	
				sql = " insert into SELBFPUB_"+seq+" \n"+
				      " SELECT acc,SRCBILTYP,SRCBIL,SRCBILDAT,SRCBILSEQ,VALLEFT,"+qty+" val2convert,guid \n"+
				      " from datflwsta where flw='"+flw+"' \n"+ 
				      " AND SRCBILTYP ='"+ ds.getStringAt(row,"SRCBILTYP")+"' AND ACC='"+acc+"' \n"+
				      " and srcbil = '"+ds.getStringAt(row,"SRCBIL")+"' AND REFID3='"+ ds.getStringAt(row,"ITMID")+"'\n";
//				   throw new Exception(sql);  
				db.ExcecutSQL(sql);
			}
		}
		
		sql = " select distinct SRCBIL from SELBFPUB_"+seq+" \n";

		var bilds = db.QuerySQL(sql);
		var bils = "";
		for(var c=0;c<bilds.getRowCount();c++){
			var srcbil = bilds.getStringAt(c,"SRCBIL");
			sql = " select '1' SELECTFLG,A.*,B.val2Convert val2Convert FROM DATFLWSTA A,SELBFPUB_"+seq+" B \n"+
			      " where a.srcbil = b.srcbil and a.srcbiltyp = b.srcbiltyp and a.acc = b.acc \n"+	      
			      " AND A.SRCBILSEQ = B.SRCBILSEQ and a.flw='"+flw+"' and a.acc='"+acc+"'\n"+		      
			      " and a.valleft<>0  and a.srcbil='"+srcbil+"'\n"; 
			
			var xmlds = db.QuerySQL(sql);      		
			var xml = xmlds.GetXml();
			var retbillist = grd.EABilflw.ExecBilFlw(db,request,flw,xml);
			
			var DESTBil = retbillist.split(",")[1];
			var DESTBiltyp = retbillist.split(",")[0];
			
			if( bCheck == true ) {	// 生成的单据同时审核
				var billgrd = new grd.EABillGrid();// var grd= new JavaPackage("com.xlsgrid.net.grd");  
				try{
				
					billgrd.CheckOneBill(db,acc,DESTBiltyp ,DESTBil,usrid);
	
				}catch(ex){
//					throw new pubpack.EAException(ex);

						 db.ExcecutSQL(" delete from bilhdr where biltyp='"+DESTBiltyp+"' and bilid='"+DESTBil+"' and acc='"+acc+"'");										
				
						 db.ExcecutSQL(" delete from bildtl where biltyp='"+DESTBiltyp+"' and bilid='"+DESTBil+"' and acc='"+acc+"'");										
//						db.Commite();
						throw new pubpack.EAException(ex);
				}
			}
			bils+=DESTBil+",";	   
			   				 
		}
	 	sql = "drop table SELBFPUB_"+seq+"\n";
		db.ExcecutSQL(sql);
//		db.Commit();
//		throw new Exception(bils);
		return bils ;//xmlds.getRowCount();
}
////////////////////
//支持批量转换从多个来源单据相对转换多个目标,但是只转换单据头
//要求： xmlstr需要存在SRCBILTYP SRCBIL,QTY字段
function GenN2NHead(db,flw,acc,xmlstr)
{
	var ds = null;
	var sql = "";
		ds = new pubpack.EAXmlDS(xmlstr);				
		var seq = db.GetSQL("select HF001SEQ.nextval from dual");
		sql = " create table SELBFPUB_"+seq+" as SELECT acc,SRCBILTYP,SRCBIL,VALLEFT,0 val2Convert FROM DATFLWSTA where rownum<1 \n";
//		throw new Exception(sql);
		db.ExcecutSQL(sql);		
		for(var row=0;row< ds.getRowCount();row++){			
			var qty = ds.getStringAt(row,"QTY");
			var selflg = ds.getStringDef(row,"SELECTFLAG", "1" );	// 如果不存SELECTFLAG当作已选择
			if ( selflg == "1" ) {
				if(qty==null ||qty==""){
					qty=0;
				}
				else{
					qty = qty*1.0;				
				}	
				sql = " insert into SELBFPUB_"+seq+" \n"+
				      " SELECT acc,SRCBILTYP,SRCBIL,SRCBILDAT,SRCBILSEQ,VALLEFT,"+qty+" val2convert,guid \n"+
				      " from datflwsta where flw='"+flw+"' \n"+ 
				      " AND SRCBILTYP ='"+ ds.getStringAt(row,"SRCBILTYP")+"' AND ACC='"+acc+"' \n"+
				      " and srcbil = '"+ds.getStringAt(row,"SRCBIL")+"'\n";
//				      throw new Exception(sql);
				db.ExcecutSQL(sql);	
			}
		}
		sql = " select distinct SRCBIL from SELBFPUB_"+seq+" \n";
		var bilds = db.QuerySQL(sql);
		var bils = "";
		for(var c=0;c<bilds.getRowCount();c++){
			var srcbil = bilds.getStringAt(c,"SRCBIL");
			sql = " select '1' SELECTFLG,A.*,B.val2Convert val2Convert FROM DATFLWSTA A,SELBFPUB_"+seq+" B \n"+
			      " where a.srcbil = b.srcbil and a.srcbiltyp = b.srcbiltyp and a.acc = b.acc \n"+	      
			      " AND A.SRCBILSEQ = B.SRCBILSEQ and a.flw='"+flw+"' and a.acc='"+acc+"'\n"+		      
			      " and a.valleft<>0  and a.srcbil='"+srcbil+"'\n"; 
//			      throw new Exception(sql);
			var xmlds = db.QuerySQL(sql);      		
			var xml = xmlds.GetXml();
//			throw new Exception("@@@@@"+xml);
			var DESTBil = grd.EABilflw.ExecBilFlw(db,request,flw,xml).split(",")[1];
			bils+=DESTBil+",";	
//			throw new Exception(bils);		      				 
		}
	 	sql = "drop table SELBFPUB_"+seq+"\n";
		db.ExcecutSQL(sql);
		db.Commit();
		return bils ;//xmlds.getRowCount();
}
}