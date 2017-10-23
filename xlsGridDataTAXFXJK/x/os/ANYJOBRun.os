function x_ANYJOBRun(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var timepack = new JavaPackage( "com.xlsgrid.net.time" );
var rs = new JavaPackage ( "com.xlsgrid.net.servlet" );
// 客户端param传入的参数可以直接使用
// 传入 jobid :thisorgid
function genbatch()
{
	var db = null;
	var jobseqid  = "";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
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
	return jobseqid  ;// 返回后台分配的作业编号

}
// 通知外部当前的运行情况
function notify(jobseqid,percent,note,stat)
{
	var db = null;
	if ( percent < 0 ) return "";
	try{
		db = new pubpack.EADatabase();
		note = pubpack.EAFunc.Replace( note, "'","‘" );
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
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		
		jobds = db.QuerySQL("select * from SCM_ANYJOB where jobid='"+jobid + "' ");
		if ( jobds.getRowCount()==0 ) 
			throw new pubpack.EAException ( "该jobid("+jobid+")不存在" );
		jobguid = jobds.getStringAt(0,"GUID");
		var REQMOD = jobds.getStringAt(0,"REQMOD");// 预测模型
		var PRODIS= jobds.getStringAt(0,"PRODIS");// 概率方法
		var WORKDAY= jobds.getStringAt(0,"WORKDAY");// 工作时间
		var bzsp = jobds.getStringAt(0,"BZSP");//保障水平 ==========================
		var locid = jobds.getStringAt(0,"LOCID");//仓库 ==========================	
		var strdat =  jobds.getStringAt(0,"STRDAT");//预测开始日期
		var enddat = jobds.getStringAt(0,"ENDDAT");//预测截至日期
		var anytyp = jobds.getStringAt(0,"ANYTYP");//预测截至日期
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
		var bzsj = jobds.getStringAt(0,"BZSJ");//保障天数 ==========================
		var ssDzsj = bzsj.split(",");
		var bzmny = jobds.getStringAt(0,"MAXMNY");//金额 ==========================
		var ssMny = bzmny .split(",");
		itemds = db.QuerySQL("select * from SCM_ANYJOB_REQLIST where jobid='"+jobid + "' order by itmid");
		if ( itemds.getRowCount()==0 ) 
			throw new pubpack.EAException ( "该jobid还没有导入需求清单" );
			
		db.ExcecutSQL("delete from  SCM_ANYJOB_RUNJOG where jobid= '"+jobid+"'" );
		db.ExcecutSQL("delete from  SCM_ANYJOB_INVCOSTSUM where jobid= '"+jobid+"'" );
		db.ExcecutSQL("delete from  SCM_ANYJOB_INVCOST where jobid= '"+jobid+"'" );
			
		var subjobid = 0;
		
		if (ssDzsp.length()==0 && ssDzsp[0]=="" ){// 计算保障水平

		}
		else if (ssDzsj.length()==0 && ssDzsj[0]=="" ){// 计算保障天数
		
		}
		else {//if (ssMny.length()==0 && ssMny[0]=="" ){// 计算金额
			
			
			var percent = 100.0/(1.00*ssDzsp.length()*ssDzsj.length());
			
//			locds = db.QuerySQL("select * from v_loc where id='"+locid + "' order by id");
			
			for( var j = 0;j<ssDzsp.length();j++) {
				for( var k = 0;k<ssDzsj.length();k++) {
					//通知外面执行到哪里了
					if(notify(jobseqid,(percent*(subjobid )),"正在计算：保障率"+ssDzsp[j]+",保障天数"+ssDzsj[k],"run")=="ERROR" ) throw new Exception ( "进程已经中断" );
					
					//pubpack.EAFunc.Log("保障率"+ssDzsp[j]+",保障天数"+ssDzsj[k]);
	
				
					subjobid ++;
					sql ="insert into SCM_ANYJOB_INVCOSTSUM(jobid,subjobid,MAXMNY,BZSP,BZSJ,formguid,org,locid,strdat,enddat,crtusr,invtyp,xhid) 
							values('"+jobid+"','"+subjobid+"',0,'"+ssDzsp[j]+"','"+ssDzsj[k]+"','"+jobguid+"',
							'"+thisorgid+"','"+locid+"',to_date('"+strdat+"','yyyy-mm-dd'),to_date('"+enddat+"','yyyy-mm-dd'),
							decode('"+usrid+"','','xlsgrid'),'"+anytyp+"','"+xhid+"') ";// 							
					
					db.ExcecutSQL(sql );
					
					//log( db,jobid,"　<B><p align=center><font size=3>"+subjobid +". 条件：保障水平="+ssDzsp[j]+"保障天数="+ssDzsj[k]+"</font></p></B>" );
					
					var itemcount = itemds.getRowCount();
					var subpercent = percent/itemcount ;
					for( var i=0;i<itemcount ;i++ ) {
						var itmid = itemds.getStringAt(i,"ITMID" );
						var itmnam = itemds.getStringAt(i,"ITMNAM" );
						var qty = itemds.getStringAt(i,"QTY" );
						//throw new Exception ( "subpercent  ="+subpercent +","+(1*percent*(subjobid )+1.0*subpercent *i ));
						if(i%(itemcount /20)==0 )  
							notify(jobseqid,(1*percent*(subjobid-1 )+1.0*subpercent *i ),"","run");//名称为空表示只要更新进度

						//log( db,jobid,"　<B>"+(i+1)+")"+itmnam+"("+itmid+")　需求量"+qty+"</B>"  );
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

		if (notify(jobseqid,100,"操作完成","end")=="ERROR") throw new Exception ( "进程已经中断" );
		
		db.Commit();
		msg="操作成功";	
		
	}
	catch ( ee ) {
		pubpack.EAFunc.Log( ee.toString() );
		//通知外面执行到哪里了
		notify(jobseqid,100,ee.toString(),"error");
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();

	}
	return msg;
}
// 计算某个品种需求量
// percent:开始进度的百分比，用于在子进程里面细化
function calOneItem( db,jobid,subjobid,jobguid , REQMOD,PRODIS,WORKDAY,thisorgid,itmid,itmnam , qty ,bzdj, bzsj ) 
{
	var r= 0.0;
	var r1 ;
	if( qty == "" ) return ;
	
	var itemds = db.QuerySQL("select * from fracas_item where id='"+itmid + "' and org='"+thisorgid+"' " );
	if ( REQMOD=="0") {// 可靠性参数
		var MTBUR = itemds.getStringAt(0,"MTBUR");//MTBUR	平均不定期更换时间_小时
		var MSPT = itemds.getStringAt(0,"MSPT");//MSPT	平均零件修理时间
		if (!(MTBUR ==""||MSPT =="")) {
			if( qty == "" ) qty = "0";
			r= 0.0;
			if (itemds.getStringAt(0,"ITMCLASS" ) =="P") { //消耗件不需要计算MSPT
				r = ((1.0*qty * WORKDAY)/(1.0*MTBUR ) );// * (1.0*MSPT /365)
				r = pubpack.EAFunc.Round(r,2);
				log( db,jobid,subjobid,itmid,"　　计算 λ="+qty+"*"+WORKDAY+"/("+MTBUR+") ="+r+"，(其中：MTBUR="+MTBUR+",消耗件不需要计算MSPT) "  );				
			}
			else {
				r = ((1.0*qty * WORKDAY)/(1.0*MTBUR ) ) * (1.0*MSPT /365);
				r = pubpack.EAFunc.Round(r,2);
				log( db,jobid,subjobid,itmid,"　　计算 λ="+qty+"*"+WORKDAY+"*"+MSPT+"/("+MTBUR+"*365) ="+r+"，(其中：MTBUR="+MTBUR+",MSPT="+MSPT +") "  );
			}
		}
		else {log( db,jobid,subjobid,itmid,"　　出错，可靠性参数缺失，MTBUR="+MTBUR+",MSPT="+MSPT  );return ;}	
	}
	else if(REQMOD=="1"||REQMOD=="2"||REQMOD=="3") {// 根据历史来加权统计
		var invmovds = db.QuerySQL("select to_char(dat,'YYYY') yyyy,sum(qty) qty from V_SCM_INVMOV where itmid='" + itmid + "' and org='"+thisorgid+"' group by to_char(dat,'YYYY')" );
		// 先求平均值
		var invmsg = "";
		var sum= 0.0; var avg= 0.0;
		var tmp1 = 0.0;var phxs =0.7;//指数平滑法的值
		for ( var ii = 0;ii<invmovds.getRowCount();ii++ ) {
			sum+=1.0*invmovds.getStringAt(ii,"qty");
			invmsg += invmovds.getStringAt(ii,"yyyy")+"年 "+ invmovds.getStringAt(ii,"qty") +"　";
			// 平滑常数0.3，
			if ( ii==0 ) tmp1 =  1.0*invmovds.getStringAt(ii,"qty");
			else tmp1=phxs *invmovds.getStringAt(ii,"qty")+(1-phxs )*tmp1;
			
		}
		r = sum/invmovds;
		invmsg += "平均值 "+ r  ;
		if (REQMOD=="2") {//平均增长率
			//平均增长率＝[（年末总额/n年前年末利润总额)∧n －1]×100% ，即 g=（Yn/Yo）开n次方-1 预估n年后的值=当年年度*增长率∧3
			var gx = (1.0*invmovds.getStringAt(invmovds.getRowCount()-1,"qty"))/(1.0* invmovds.getStringAt(0,"qty")	);
			for ( var i=1;i<invmovds.getRowCount()-1;i++ ) 
				gx = gx*gx;
			g = gx-1;
			r = 1.0*invmovds.getStringAt(invmovds.getRowCount()-1,"qty")*g;
			invmsg += "平均增长率"+g+",预计需求值="+r;
		}
		else if (REQMOD=="3") {//指数平滑法 St=ayt+(1-a)St-1  a--平滑常数，其取值范围为[0,1]； 
			r = tmp1;
			invmsg += "指数平滑法，取平滑系数"+phxs +",预计需求值="+r;		
		}		
	}	
	else{	// 使用自定义算法来扩展
		var osfunc = db.GetSQL( "select OSFUNC from SCM_AnalyzerFunc where id='"+REQMOD+"' ");
		var s = new rs.RunScript();
		var eaScripter = new pubpack.EAScript(null);
		if(REQMOD == "9"){
			
			var ss = new Array(thisorgid,db,itmid,jobid,subjobid,bzsj,bzdj);	//第一个参数改为orgid
			r1 = eaScripter.CallClassFunc("A3SCM_Analyzer",osfunc,ss).castToString();	
			r = 1.0 * r1;
			//r = s.ExecMwOsEx("A3SCM","Analyzer",osfunc,ss)*1.0;	
		}
		else{
			var ss = new Array(thisorgid,db,itmid,jobid,subjobid,bzsj,bzdj);			//第一个参数改为orgid
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
		log( db,jobid,subjobid,itmid,"根据可靠性参数公式计算出E="+r+",在保障水平="+bzdj+"的情况下查泊松分布，得到需求量="+invqty);
	}
	//if( invqty>0 ) {
		var price = itemds.getStringAt(0,"PRICE");
		if ( price=="" ) price = 0;
		var sql = "insert into SCM_ANYJOB_INVCOST(jobid,subjobid,itmid,itmnam,qty,price,mny,cost,formguid,sotype) 
			values('"+jobid+"','"+subjobid+"','"+itmid+"','"+itmnam+"',"+invqty +","+price +","+invqty *price +",0,'"+jobguid+"','1' )	";// 		
		db.ExcecutSQL(sql );
	//}	
}
// 插入到日志表
function log(db,jobid,subjobid,itmid,str )
{
	db.ExcecutSQL("insert into SCM_ANYJOB_RUNJOG(jobid,seqid,LOGSTR,subjobid,itemid) values( '"+jobid+"' ,seq_scm_anyjob_seqid.nextval,'"+str+"','"+subjobid+"','"+itmid+"')" );
	
}

}