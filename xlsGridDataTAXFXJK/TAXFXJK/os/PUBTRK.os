function TAXFXJK_PUBTRK(){var pub = new JavaPackage ( "com.xlsgrid.net.pub" );
var web = new JavaPackage ( "com.xlsgrid.net.web" );
var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var xlsdb = new JavaPackage ( "com.xlsgrid.net.xlsdb" );

//Ȩ�޼��
function checkGenTask()
{
	//����˰�պ���ɽ�ɫ
	var sql = "select * from usrrol where usr=(select guid from usr where id='"+usrid+"' and org='"+thisorgid+"')
		and rol in (select guid from rol where id='02' and org='"+thisorgid+"')";
	return pub.EADbTool.GetSQLRowCount(sql);
}

//Ȩ�޼��
function checkGenTask2()
{
	//����˰�պ���ɽ�ɫ
	var sql = "select * from usrrol where usr=(select guid from usr where id='"+usrid+"' and org='"+thisorgid+"')
		and rol in (select guid from rol where id='04' and org='"+thisorgid+"')";
	return pub.EADbTool.GetSQLRowCount(sql);
}

//�������ɺ�ʵ���񷽷�
//param.usrids		//����������û����
//param.usrnams 	//�û�����
//param.accids 		//���׺�
//param.orgs	        //��֯��
//param.syts            //ϵͳ��
//param.typ             //��������
//param.yymm1	   	//˰��������
//param.yymm2		//˰��������
//param.swjg_dm		//˰���������
//param.toswjg		//���ɵ��Ĺ���
//param.enddat		//�����ֹ����
//param.tousr		//������ɵ���˰��Ա
//param.note		//����˵��
//param.xmlstr		//������ϸ��
//param.typ		//��������
//param.subtyp		//��������
function createTask()
{
	var db = null;
	var ds = null;
	var sql = "";
	var ret = 0;
	//return xmlstr;
	
	try {		
		db = new pubpack.EADatabase();
		var ds = new pubpack.EAXmlDS(xmlstr);
		for (var i=0;i<ds.getRowCount();i++) {
			var bilid =db.GetBillid(accids,"TK","TK");  //���ɵ��ݺ�
			var nsrsbh = ds.getStringAt(i,"NSRSBH");	
			var nsrmc = ds.getStringAt(i,"NSRMC");
			var fxdj = ds.getStringAt(i,"FXDJ");
			var cyje = ds.getStringAt(i,"CYJE");
			var mynote = ds.getStringAt(i,"NOTE");
			mynote += "\n\n"+note;
			//�ж���˰��ҵ�Ƿ������ɹ���ʵ���񣬲��ظ�����		
			sql = "select * from tax_trkhdr where cmid='"+nsrsbh+"' and nvl(yymm1,' ')=nvl('"+yymm1+"',' ') and nvl(yymm2,' ')=nvl('"+yymm2+"',' ')";
			var count = db.GetSQLRowCount(sql);	
			if (count == 0) {
				if(tousr == ""){
					sql = "select taxman from tax_company where id='"+nsrsbh+"'";
					var tmpds = db.QuerySQL(sql);
					if (tmpds.getRowCount() > 0) {
						tousr = tmpds.getStringAt(0,"TAXMAN");
					}
				}
				
				var newtyp = "";
				var stat = "1";
				sql = "insert into tax_trkhdr(ACC,ORG,SYT,BILID,CRTUSR,CRTUSRNAM,CMID,CMNAM,todept,Tousr,SUBTYP,yymm1,yymm2,dat,stat,enddat,note,newtyp,typ,fxdj,swjg_dm,cyje)
					values('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',trunc(sysdate),'%s',to_date('%s','yyyy-mm-dd'),'%s','%s','%s','%s',substr('%s',0,7),'%s')"
					.format([accids,orgs,syts,bilid,usrids,usrnams,nsrsbh,nsrmc,toswjg,tousr,subtyp,yymm1,yymm2,stat,enddat,mynote,newtyp,typ,fxdj,swjg_dm,cyje]); 
				ret += db.ExcecutSQL(sql);
				
			}
		}

		db.Commit();		
		return "�ɹ�����"+ret+"������!";


	}
	catch(e){
		if(db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if(db != null)	db.Close();
	}
}




}