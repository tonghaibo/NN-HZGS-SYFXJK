function x_ANYJOBRun(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var timepack = new JavaPackage( "com.xlsgrid.net.time" );
var rs = new JavaPackage ( "com.xlsgrid.net.servlet" );
// �ͻ���param����Ĳ�������ֱ��ʹ��
// ���� jobid :thisorgid
function genbatch()
{
	var db = null;
	var jobseqid  = "";
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		jobseqid = "SCMANY"+jobid;
		
		var tim = new timepack.EARunOSTimer(); 
		tim.init(   jobseqid , jobnam,   "A3SCM",  "SCM_AnyJOBList",  "gen", "jobid="+jobid+"&thisorgid="+thisorgid+"&jobseqid="+jobseqid +"&thisaccid="+thisaccid+"&thissytid="+thissytid);
	}
	catch ( ee ) {
		
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return jobseqid  ;// ���غ�̨�������ҵ���

}
// ֪ͨ�ⲿ��ǰ���������
function notify(jobseqid,percent,note,stat)
{
	var db = null;
	if ( percent < 0 ) return "";
	try{
		db = new pubpack.EADatabase();
		note = pubpack.EAFunc.Replace( note, "'","��" );
		if(note==""){
			db.ExcecutSQL("update RunOSTimer set percent="+(percent) +",stat='"+stat+"' where id='"+jobseqid+"'");
		}
		else {
			db.ExcecutSQL("update RunOSTimer set percent="+(percent) +",percentnote='"+note+"',stat='"+stat+"' where id='"+jobseqid+"'");
			db.ExcecutSQL("insert into RunOSTimerDTL(id,name ) values('"+jobseqid+"','"+note+"')" );
		}
		db.Commit();
	}
	catch ( e ) {
		//pubpack.EAFunc.Log( e.toString() );
		db.Rollback();
		return "ERROR" ;
	}
	finally {
		if (db!=null) db.Close();
	}
	return "OK";
}
function gen () 
{
	var db = null;

	var msg= "";
	var sql = "";
	var itemds= null;
	var jobds = null;
	var jobguid = "";
	var num = 0;
	var usrid = "";
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		
		jobds = db.QuerySQL("select * from SCM_ANYJOB where jobid='"+jobid + "' ");
		if ( jobds.getRowCount()==0 ) 
			throw new pubpack.EAException ( "��jobid("+jobid+")������" );
		jobguid = jobds.getStringAt(0,"GUID");
		var REQMOD = jobds.getStringAt(0,"REQMOD");// Ԥ��ģ��
		var PRODIS= jobds.getStringAt(0,"PRODIS");// ���ʷ���
		var WORKDAY= jobds.getStringAt(0,"WORKDAY");// ����ʱ��
		var bzsp = jobds.getStringAt(0,"BZSP");//����ˮƽ ==========================
		var locid = jobds.getStringAt(0,"LOCID");//�ֿ� ==========================	
		var strdat =  jobds.getStringAt(0,"STRDAT");//Ԥ�⿪ʼ����
		var enddat = jobds.getStringAt(0,"ENDDAT");//Ԥ���������
		var anytyp = jobds.getStringAt(0,"ANYTYP");//Ԥ���������
		var xhid = jobds.getStringAt(0,"XHID");//
		var ssDzsp = bzsp.split(",");
		if ( bzsp.indexOf( "-" )>=0 ){
			var ss = bzsp.split("-");
			var start = 0.8;
			var end = 1.0;
			if ( ss.length() == 2 ){
				if( ss[0]=="") ss[0]="0.99";
				start = 1.0*ss[0];
				end = 1.0*ss[1];
			}
			else if ( ss.length() == 1 ) {
				start = 1.0*ss[0];
			}	
			// from start to end 
			var sss ="";
			for ( var n = start*100;n<=end*100;n++ ) {
				if ( n != start*100 ) sss+=",";
				sss+=""+n/100; 
			}
			ssDzsp = sss.split(",");
		}
		var bzsj = jobds.getStringAt(0,"BZSJ");//�������� ==========================
		var ssDzsj = bzsj.split(",");
		var bzmny = jobds.getStringAt(0,"MAXMNY");//��� ==========================
		var ssMny = bzmny .split(",");
		itemds = db.QuerySQL("select * from SCM_ANYJOB_REQLIST where jobid='"+jobid + "' order by itmid");
		if ( itemds.getRowCount()==0 ) 
			throw new pubpack.EAException ( "��jobid��û�е��������嵥" );
			
		db.ExcecutSQL("delete from  SCM_ANYJOB_RUNJOG where jobid= '"+jobid+"'" );
		db.ExcecutSQL("delete from  SCM_ANYJOB_INVCOSTSUM where jobid= '"+jobid+"'" );
		db.ExcecutSQL("delete from  SCM_ANYJOB_INVCOST where jobid= '"+jobid+"'" );
			
		var subjobid = 0;
		
		if (ssDzsp.length()==0 && ssDzsp[0]=="" ){// ���㱣��ˮƽ

		}
		else if (ssDzsj.length()==0 && ssDzsj[0]=="" ){// ���㱣������
		
		}
		else {//if (ssMny.length()==0 && ssMny[0]=="" ){// ������
			
			
			var percent = 100.0/(1.00*ssDzsp.length()*ssDzsj.length());
			
//			locds = db.QuerySQL("select * from v_loc where id='"+locid + "' order by id");
			
			for( var j = 0;j<ssDzsp.length();j++) {
				for( var k = 0;k<ssDzsj.length();k++) {
					//֪ͨ����ִ�е�������
					if(notify(jobseqid,(percent*(subjobid )),"���ڼ��㣺������"+ssDzsp[j]+",��������"+ssDzsj[k],"run")=="ERROR" ) throw new Exception ( "�����Ѿ��ж�" );
					
					//pubpack.EAFunc.Log("������"+ssDzsp[j]+",��������"+ssDzsj[k]);
	
				
					subjobid ++;
					sql ="insert into SCM_ANYJOB_INVCOSTSUM(jobid,subjobid,MAXMNY,BZSP,BZSJ,formguid,org,locid,strdat,enddat,crtusr,invtyp,xhid) 
							values('"+jobid+"','"+subjobid+"',0,'"+ssDzsp[j]+"','"+ssDzsj[k]+"','"+jobguid+"',
							'"+thisorgid+"','"+locid+"',to_date('"+strdat+"','yyyy-mm-dd'),to_date('"+enddat+"','yyyy-mm-dd'),
							decode('"+usrid+"','','xlsgrid'),'"+anytyp+"','"+xhid+"') ";// 							
					
					db.ExcecutSQL(sql );
					
					//log( db,jobid,"��<B><p align=center><font size=3>"+subjobid +". ����������ˮƽ="+ssDzsp[j]+"��������="+ssDzsj[k]+"</font></p></B>" );
					
					var itemcount = itemds.getRowCount();
					var subpercent = percent/itemcount ;
					for( var i=0;i<itemcount ;i++ ) {
						var itmid = itemds.getStringAt(i,"ITMID" );
						var itmnam = itemds.getStringAt(i,"ITMNAM" );
						var qty = itemds.getStringAt(i,"QTY" );
						//throw new Exception ( "subpercent  ="+subpercent +","+(1*percent*(subjobid )+1.0*subpercent *i ));
						if(i%(itemcount /20)==0 )  
							notify(jobseqid,(1*percent*(subjobid-1 )+1.0*subpercent *i ),"","run");//����Ϊ�ձ�ʾֻҪ���½���

						//log( db,jobid,"��<B>"+(i+1)+")"+itmnam+"("+itmid+")��������"+qty+"</B>"  );
						try {
							calOneItem(db,jobid,subjobid,jobguid ,REQMOD,PRODIS,WORKDAY,thisorgid,itmid,itmnam ,qty ,ssDzsp[j],ssDzsj[k]);
						}
						catch ( eee ) {
							notify(jobseqid,100,eee.toString(),"error");
						}
						num++;
					}					
				}
			}
		} 
		db.ExcecutSQL("update SCM_ANYJOB_INVCOSTSUM a set acc='"+thisaccid+"' , syt='"+thissytid+"' ,mny = ( select sum(mny) from SCM_ANYJOB_INVCOST b where a.jobid=b.jobid and a.subjobid=b.subjobid ) where jobid='"+jobid+"'" );

		db.ExcecutSQL("update SCM_ANYJOB a set anystat='2'  where jobid='"+jobid+"'" );

		db.ExcecutSQL("update scm_anyjob_invcost a set formguid=(select guid from SCM_ANYJOB_INVCOSTSUM b where a.jobid=b.jobid and a.subjobid=b.subjobid ) where jobid='"+jobid+"'");

		if (notify(jobseqid,100,"�������","end")=="ERROR") throw new Exception ( "�����Ѿ��ж�" );
		
		db.Commit();
		msg="�����ɹ�";	
		
	}
	catch ( ee ) {
		pubpack.EAFunc.Log( ee.toString() );
		//֪ͨ����ִ�е�������
		notify(jobseqid,100,ee.toString(),"error");
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();

	}
	return msg;
}
// ����ĳ��Ʒ��������
// percent:��ʼ���ȵİٷֱȣ��������ӽ�������ϸ��
function calOneItem( db,jobid,subjobid,jobguid , REQMOD,PRODIS,WORKDAY,thisorgid,itmid,itmnam , qty ,bzdj, bzsj ) 
{
	var r= 0.0;
	var r1 ;
	if( qty == "" ) return ;
	
	var itemds = db.QuerySQL("select * from fracas_item where id='"+itmid + "' and org='"+thisorgid+"' " );
	if ( REQMOD=="0") {// �ɿ��Բ���
		var MTBUR = itemds.getStringAt(0,"MTBUR");//MTBUR	ƽ�������ڸ���ʱ��_Сʱ
		var MSPT = itemds.getStringAt(0,"MSPT");//MSPT	ƽ���������ʱ��
		if (!(MTBUR ==""||MSPT =="")) {
			if( qty == "" ) qty = "0";
			r= 0.0;
			if (itemds.getStringAt(0,"ITMCLASS" ) =="P") { //���ļ�����Ҫ����MSPT
				r = ((1.0*qty * WORKDAY)/(1.0*MTBUR ) );// * (1.0*MSPT /365)
				r = pubpack.EAFunc.Round(r,2);
				log( db,jobid,subjobid,itmid,"�������� ��="+qty+"*"+WORKDAY+"/("+MTBUR+") ="+r+"��(���У�MTBUR="+MTBUR+",���ļ�����Ҫ����MSPT) "  );				
			}
			else {
				r = ((1.0*qty * WORKDAY)/(1.0*MTBUR ) ) * (1.0*MSPT /365);
				r = pubpack.EAFunc.Round(r,2);
				log( db,jobid,subjobid,itmid,"�������� ��="+qty+"*"+WORKDAY+"*"+MSPT+"/("+MTBUR+"*365) ="+r+"��(���У�MTBUR="+MTBUR+",MSPT="+MSPT +") "  );
			}
		}
		else {log( db,jobid,subjobid,itmid,"���������ɿ��Բ���ȱʧ��MTBUR="+MTBUR+",MSPT="+MSPT  );return ;}	
	}
	else if(REQMOD=="1"||REQMOD=="2"||REQMOD=="3") {// ������ʷ����Ȩͳ��
		var invmovds = db.QuerySQL("select to_char(dat,'YYYY') yyyy,sum(qty) qty from V_SCM_INVMOV where itmid='" + itmid + "' and org='"+thisorgid+"' group by to_char(dat,'YYYY')" );
		// ����ƽ��ֵ
		var invmsg = "";
		var sum= 0.0; var avg= 0.0;
		var tmp1 = 0.0;var phxs =0.7;//ָ��ƽ������ֵ
		for ( var ii = 0;ii<invmovds.getRowCount();ii++ ) {
			sum+=1.0*invmovds.getStringAt(ii,"qty");
			invmsg += invmovds.getStringAt(ii,"yyyy")+"�� "+ invmovds.getStringAt(ii,"qty") +"��";
			// ƽ������0.3��
			if ( ii==0 ) tmp1 =  1.0*invmovds.getStringAt(ii,"qty");
			else tmp1=phxs *invmovds.getStringAt(ii,"qty")+(1-phxs )*tmp1;
			
		}
		r = sum/invmovds;
		invmsg += "ƽ��ֵ "+ r  ;
		if (REQMOD=="2") {//ƽ��������
			//ƽ�������ʣ�[����ĩ�ܶ�/n��ǰ��ĩ�����ܶ�)��n ��1]��100% ���� g=��Yn/Yo����n�η�-1 Ԥ��n����ֵ=�������*�����ʡ�3
			var gx = (1.0*invmovds.getStringAt(invmovds.getRowCount()-1,"qty"))/(1.0* invmovds.getStringAt(0,"qty")	);
			for ( var i=1;i<invmovds.getRowCount()-1;i++ ) 
				gx = gx*gx;
			g = gx-1;
			r = 1.0*invmovds.getStringAt(invmovds.getRowCount()-1,"qty")*g;
			invmsg += "ƽ��������"+g+",Ԥ������ֵ="+r;
		}
		else if (REQMOD=="3") {//ָ��ƽ���� St=ayt+(1-a)St-1  a--ƽ����������ȡֵ��ΧΪ[0,1]�� 
			r = tmp1;
			invmsg += "ָ��ƽ������ȡƽ��ϵ��"+phxs +",Ԥ������ֵ="+r;		
		}		
	}	
	else{	// ʹ���Զ����㷨����չ
		var osfunc = db.GetSQL( "select OSFUNC from SCM_AnalyzerFunc where id='"+REQMOD+"' ");
		var s = new rs.RunScript();
		var eaScripter = new pubpack.EAScript(null);
		if(REQMOD == "9"){
			
			var ss = new Array(thisorgid,db,itmid,jobid,subjobid,bzsj,bzdj);	//��һ��������Ϊorgid
			r1 = eaScripter.CallClassFunc("A3SCM_Analyzer",osfunc,ss).castToString();	
			r = 1.0 * r1;
			//r = s.ExecMwOsEx("A3SCM","Analyzer",osfunc,ss)*1.0;	
		}
		else{
			var ss = new Array(thisorgid,db,itmid,jobid,subjobid,bzsj,bzdj);			//��һ��������Ϊorgid
			//r = 1.0*  .castToString()
			eaScripter.CallClassFunc("A3SCM_Analyzer",osfunc,ss);	
//			throw new Exception(eaScripter.CallClassFunc("A3SCM_Analyzer",osfunc,ss));
		}		
	}
	var invqty = 0.0; 
	if ( r != 0.0 ) {
		var str = "" + r1;
		var strl = 0;
		var strpow = 1;
		if(r > 100 ) { 
			strl = str.length()-4;
			var mathpack = new JavaPackage("java.lang");    	 	
	    	 	strpow = mathpack.Math.pow(100,strl);
	    	 	r = r/strpow;    
    	 	}	 		 
		var qsql ="select max(qty) from  Poisson where E = "+r+" and  P >= (1 - 1 * nvl( '"+bzdj+"' , 0)) ";
		try { invqty  = 1.0*db.GetSQL(qsql); }	catch ( e ) { }
		invqty = invqty * strpow;
		log( db,jobid,subjobid,itmid,"���ݿɿ��Բ�����ʽ�����E="+r+",�ڱ���ˮƽ="+bzdj+"������²鲴�ɷֲ����õ�������="+invqty);
	}
	//if( invqty>0 ) {
		var price = itemds.getStringAt(0,"PRICE");
		if ( price=="" ) price = 0;
		var sql = "insert into SCM_ANYJOB_INVCOST(jobid,subjobid,itmid,itmnam,qty,price,mny,cost,formguid,sotype) 
			values('"+jobid+"','"+subjobid+"','"+itmid+"','"+itmnam+"',"+invqty +","+price +","+invqty *price +",0,'"+jobguid+"','1' )	";// 		
		db.ExcecutSQL(sql );
	//}	
}
// ���뵽��־��
function log(db,jobid,subjobid,itmid,str )
{
	db.ExcecutSQL("insert into SCM_ANYJOB_RUNJOG(jobid,seqid,LOGSTR,subjobid,itemid) values( '"+jobid+"' ,seq_scm_anyjob_seqid.nextval,'"+str+"','"+subjobid+"','"+itmid+"')" );
	
}

}