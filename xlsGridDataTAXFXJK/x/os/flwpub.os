function x_flwpub(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var grd= new JavaPackage("com.xlsgrid.net.grd");
var utilpack = new JavaPackage("java.util");
var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
// �ͻ���param����Ĳ�������ֱ��ʹ��
// ����  ���ɵ���ϸ����
// Ҫ�� xmlstr��Ҫ����ITMID SRCBILTYP SRCBIL, QTY�ֶ�
// ��Զ֧࣬�ֲ����������� Gen121
function GenN2N(db,flw,acc,xmlstr)
{
	return GenN2NClose(db,flw,acc,xmlstr,false);
}
// ��Զ�ӿڣ�����֧��ǿ�н���������
// bClose=true ǿ�н���
function GenN2NClose(db,flw,acc,xmlstr,bClose)
{
	return GenN2NClose0(db,flw,flw,acc,xmlstr,bClose);

}	
// ֧����Դ��������Ŀ����������һ��
function GenN2NClose0(db,srcflw,destflw,acc,xmlstr,bClose)
{
	var ds = null;
	var sql = "";		
// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		ds = new pubpack.EAXmlDS(xmlstr);				
		var seq = db.GetSQL("select HF001SEQ.nextval from dual");
		sql = " create table SELBFPUB_"+seq+" as SELECT acc,SRCBILTYP,SRCBIL,SRCBILDAT,SRCBILSEQ,VALLEFT,0 val2Convert,guid FROM DATFLWSTA where rownum<1 \n";
		db.ExcecutSQL(sql);		
//		throw new Exception(xmlstr);
		for(var row=0;row< ds.getRowCount();row++){			
			var qty = ds.getStringAt(row,"QTY");
			var srcseq = ds.getStringAt(row,"SRCBILSEQ");
			var selflg = ds.getStringDef(row,"SELECTFLAG", "1" );	// �������SELECTFLAG������ѡ��
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
				throw new Exception("ִ�������쳣!"+e.toString());
			}	
		}
		
		if ( bClose == true ) {
			db.ExcecutSQL("update datflwsta set endflg='1' where guid  in ( select guid from SELBFPUB_"+seq+" )" );
		
		}
		
		sql = "drop table SELBFPUB_"+seq+"\n";
		db.ExcecutSQL(sql);
		
		return retbil ;//xmlds.getRowCount();
}
//֧������ת���Ӷ����Դ�������ת�����Ŀ��
//Ҫ�� xmlstr��Ҫ����ITMID SRCBILTYP SRCBIL, QTY�ֶ�
function GenN2M(db,flw,acc,xmlstr)
{
	return GenN2M(db,flw,acc,xmlstr,"",false);
}	
// bCheck : =1 ����Ŀ�굥�ݵ�ʱ��������
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
			var selflg = ds.getStringDef(row,"SELECTFLAG", "1" );	// �������SELECTFLAG������ѡ��
			
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
			
			if( bCheck == true ) {	// ���ɵĵ���ͬʱ���
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
//֧������ת���Ӷ����Դ�������ת�����Ŀ��,����ֻת������ͷ
//Ҫ�� xmlstr��Ҫ����SRCBILTYP SRCBIL,QTY�ֶ�
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
			var selflg = ds.getStringDef(row,"SELECTFLAG", "1" );	// �������SELECTFLAG������ѡ��
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