function x_SelBilFlw(){var grd= new JavaPackage("com.xlsgrid.net.grd");
var pub= new JavaPackage("com.xlsgrid.net.pub");
var xmldb= new JavaPackage("com.xlsgrid.net.xmldb");

//================================================================// 
// ������getAviableBill
// ˵����
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�12/28/05 16:14:30
// �޸���־��
//================================================================//
var totalBils=0;
function getAviableBill(db, sytid, accid,usrloc, bilFlwID, ExtraWhere,page,pagesize,�ֿ����)
{
    //ȡ��ָ������������xmlds�е��к�
    var FlwDefds = xmldb.EAXmlDB.getFlwLnkDestDs(sytid);
    
    var colidx = FlwDefds.getColumnLoc(xmldb.EAXmlDB.flwLnkID);
    var rowidx = FlwDefds.Find(bilFlwID,colidx);
    var MappedMode = FlwDefds.getStringDef(rowidx,xmldb.EAXmlDB.flwLnkMapMod,"0"); 
    //ȡ��ָ�������������ϸ��xmlds�е��кż���
    var flwsrcds = xmldb.EAXmlDB.getFlwLnkSrcDs(sytid);


    var list = flwsrcds.getRowList(xmldb.EAXmlDB.flwLnkID,bilFlwID);
    pub.EAFunc.assertsFmt(list.size()>0,"%sû�ж���������:%s",sytid,bilFlwID);
    var srcBilTypCol = flwsrcds.getColumnLoc(xmldb.EAXmlDB.flwLnkSrcBil);
    //pub.EAFunc.WriteToFile( "/u/1.txt", flwsrcds.GetXml() );
    
    var iterator = list.iterator();
    //EADatabase db = new EADatabase();
    var result = new pub.EAXmlDS();
    //String[] hdrFields = EAOption.get("FlwHdrFields").split(",");
    //���δ������������ϸ
    var datflwsql="";
    var servlet = new JavaPackage("com.xlsgrid.net.servlet");
    var stawhere =" flw='"+bilFlwID+"' and (endflg is null or endflg='0') and ";
    if(!�ֿ����)
      stawhere += " a.acc='"+accid+"' and ";
    //gld: 07-1-5;MOMJ2MCʱ����ҪMO��ǰ���������������ٿ������Ӷ������������
    var order0 = " order by srcbiltyp desc,srcbil desc";
    //var dtlfilter="";
    var ConvertMod="";
    while(iterator.hasNext())
    {
      var row = iterator.next();
      ConvertMod = flwsrcds.getValueAt(row,"ConvertMod");
      var srcbiltyp = flwsrcds.getValueAt(row,srcBilTypCol);
      var ValueMod = flwsrcds.getStringDef(row,"ValueMod","0");
      var ConvertTimes = flwsrcds.getStringDef(row,"ConvertTimes","0");
      var filter = flwsrcds.getValueAt(row,xmldb.EAXmlDB.flwLnkSrcFilter);
      if (pub.EAFunc.isEmptyStr(filter))
        filter = "valleft<>0";
      if(datflwsql!="")
        datflwsql += "\nunion all\n";
      datflwsql += 
         pub.EAFunc.format("select distinct a.acc,srcbil,srcbiltyp,"+
            "'%s' MappedMode,'%s' ConvertMod,'%s' ValueMod,'%s' ConvertTimes from datflwsta a,bilhdr b \n",
          [MappedMode,ConvertMod,ValueMod,ConvertTimes]);
      if(�ֿ����)
        datflwsql += ",(select id,subacc from loc) c where b.locid=c.id and c.subacc='"+accid+"'\n and ";
      else datflwsql += " where ";
      //������Դ���ݵ�onFilterLoc�¼�����ȡ�ֿ�Ĺ���sql�Ӿ�
      var locfil = "b.locid is null or b.locid like '"+usrloc+"%'";
      var ret=servlet.RunScript.ExecMwOsEx(sytid,srcbiltyp,"onFilterLoc",[request,srcbiltyp,bilFlwID,usrloc,locfil]);
      if(!pub.EAFunc.isEmptyStr(ret))
        locfil=ret;      
      //2008-04 �޸Ŀ��������ɵ�����,���������Ҫ��datflwsta������һ��SRCACC�ֶΣ����ֶ���ִ�е�����˴���datflwsta���Զ����ӣ�
     // datflwsql += "nvl(a.srcacc,a.acc)=b.acc and a.srcbil=b.bilid and a.srcbiltyp=b.biltyp and ("+locfil+") and "
     
      datflwsql += "a.acc=b.acc and a.srcbil=b.bilid and a.srcbiltyp=b.biltyp and ("+locfil+") and " 
         +stawhere + filter + " and srcbiltyp = '"+srcbiltyp+"' " + ExtraWhere;
         //+ pub.EAFunc.format(" and(SRCBILTYP='%s' and %s)",srcbiltyp,filter);
      //dtlfilter += pub.EAFunc.format(" and(a.SRCBILTYP='%s' and %s)",srcbiltyp,filter);
    }
    //System.out.println(datflwsql);
    var order1 = ",CRTDAT desc,srcbilseq";
    
    //refid1,refid2,refid3,srcsubtyp���ֶο������������з���
    //ConvertMod,MappedMode ���ͻ��˽ű���
    var fields = "a.SRCBILTYP, a.srcbil,SRCBILSEQ,VALLEFT,0 as val2Convert, MEMO1,MEMO2,SRCBILDAT,ConvertMod,MappedMode, a.GUID, a.untnum,a.refid1,a.refid2,a.refid3,srcsubtyp,ConvertTimes,ValueMod,a.acc dataAcc ";
    var stasql = "";
// 2014������ǵ���ͷת��������Ҫ����Դ��bildtl����Ӧ
	if(ConvertMod=="2"){
		stasql = 
		"select " + fields +" from datflwsta a,(select * from(select rownum-1 rid, t.* from("
		+datflwsql +order0
		+pub.EAFunc.format(") t where rownum<=%s*%s)where rid>=(%s-1)*%s)", [page,pagesize,page,pagesize])
		// 2008/11 ���˵�һ���������Ѿ����ּ�¼������Ϊ0�����
		+pub.EAFunc.format("b where a.acc=b.acc and a.srcbil=b.srcbil and a.srcbiltyp=b.srcbiltyp and (endflg is null or endflg='0') and flw='%s' and a.VALLEFT<>0 ",bilFlwID)
		//+dtlfilter
		+order0 + order1 ;
	}else{
	      stasql =
	      "select " + fields +" from datflwsta a,(select * from(select rownum-1 rid, t.* from("
               +datflwsql +order0
               +pub.EAFunc.format(") t where rownum<=%s*%s)where rid>=(%s-1)*%s)", [page,pagesize,page,pagesize])
               // 2008/11 ���˵�һ���������Ѿ����ּ�¼������Ϊ0�����
               +pub.EAFunc.format("b,bildtl c where a.acc=b.acc and a.srcbil=b.srcbil and a.srcbiltyp=b.srcbiltyp and a.srcbil=c.bilid and a.acc=c.acc and a.srcbiltyp=c.biltyp and a.srcbilseq=c.seqid and (endflg is null or endflg='0') and flw='%s' and a.VALLEFT<>0 ",bilFlwID)
               //+dtlfilter
               +order0 + order1 ;

	}



    //System.out.println(stasql); 
    stasql = pub.EAFunc.XmlToStd(stasql );
    //throw new Exception(stasql);
    var flwsta = db.QuerySQL(stasql );
    result.Append(flwsta);
      
    var countsql ="select count(*) from(select distinct acc,srcbil,srcbiltyp from ("+datflwsql+") )t ";
    //throw new Exception(countsql);
    totalBils = db.GetSQL(countsql);
    
    return result;
  }
  
//================================================================// 
// ������getBillDsXml
// ˵�����õ������������ݼ�
// ������
// ���أ�xml
// ������
// ���ߣ�
// �������ڣ�11/04/05 15:40:57
// �޸���־��
//================================================================// 
function getBillDsXml()
{

    var db=null;
    try{
//throw new Exception(osfunc);
    var �ֿ���� = "loctyp3" == osfunc;
      db = new pub.EADatabase();
      var retds = getAviableBill(db,sytid,accid,usrloc,bilflwcls,where,curpage,corpsperpage,�ֿ����);
      var r = retds.getRowCount();
      var pos = 1 * curpage * corpsperpage;
      if(r>0)
      {
        //if( (1 * curpage > 1) || (pos < totalBils) )
          retds.AddNullRow(r-1);
        if(1 * curpage > 1)
          retds.setValueAt(r,0,"��һҳ");
        if(pos<totalBils)
          retds.setValueAt(r,1,"��һҳ");
      }
      return retds.GetXml();
    }
    catch(e)
    {
      return pub.EAFunc.formatClientMsg(e.toString(),-1,"");
    }
    finally
    {
      if(db!=null)
        db.Close();
    }
}

//================================================================// 
// ������runbilFlw
// ˵����ִ��������ת������
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�01/11/06 12:38:32
// �޸���־��
//================================================================// 
function runbilFlw()
{
    try
    {
      var msg = grd.EABilflw.ExecBilFlw(request,bilflwid,bilxml);
      return msg;
    }
    catch(e)
    {
      throw e;
      //return pub.EAFunc.formatClientMsg(e.toString(),-1,"");
    }
}

function forcedel()
{
  return grd.EABilflw.forcedel(bilxml);
}

function checkPWD(usr,usrpwd)
{
  try
  {
    pub.EADbTool.GetSQL("select id from usr where id='"+usr+"' and passwd='"+usrpwd+"'");
    return true;
  }
  catch(e)
  {
    return false;
  }
}

function forceclose()
{
  var chk = checkPWD("DATFLWMGR",pwd);
  if(!chk)
  {
    var db = new xmldb.EASYTXmlDB(sytid);
    var adminusr = db.getAdminUsr();
    chk = checkPWD(adminusr,pwd);
  }
  if(!chk)
    throw new pub.EAException("��Ȩ�����������ϵ����Ա��ȡ��Ȩ���롣");
  return grd.EABilflw.forceclose(bilxml);
}

//================================================================// 
// ������batchconv
// ˵��������ת����ÿ����Դ��������һ��Ŀ�굥�ݡ�
// ����Ĵ����������ɽ��㵥�Ŀ�Ŀ�����������д���
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�01/11/06 12:31:29
// �޸���־��
//================================================================// 
function batchconv()
{
    var msg = "";
    try
    {
      var ds = new pub.EAXmlDS(bilxml);
      var c = ds.getRowCount();
      var i=0;
      var oldmw="";
      var oldbil="";
      while(i<c)
      {
        if(ds.getStringAt(i,"SELECTFLG")!="1")
        {
          i++;
          continue;
        }
        var mwid = ds.getStringAt(i,"SRCBILTYP");
        var bilid = ds.getStringAt(i,"SRCBIL");
        var beginBil = (oldmw!=mwid)||(oldbil!=bilid);
        
        var tmpds = new pub.EADS();
        if(beginBil)
        {
          oldmw=mwid;
          oldbil=bilid;
          beginBil=false;
          while(!beginBil && i<c)
          {
            tmpds.copyOneRow(ds,i);
            i++;
            if(i>=c)
              break;
            mwid = ds.getStringAt(i,"SRCBILTYP");
	    bilid = ds.getStringAt(i,"SRCBIL");
            beginBil = (oldmw!=mwid)||(oldbil!=bilid);
          }
          i--;
          //�ѿͻ��˴��ݹ����Ĳ������ݸ�������
          //throw new Exception(tmpds.GetXml());
          msg += grd.EABilflw.ExecBilFlw(request,bilflwid,tmpds.GetXml());
          
        }
        i++;
      }
      //var msg = grd.EABilflw.ExecBilFlw(request,bilflwid,bilxml);
      return msg;
    }
    catch(e)
    {
      return pub.EAFunc.formatClientMsg(msg+"\r\n"+e.toString(),-1,"");
    }
}

//��ȡ���ࣻ��������������note�ֶλ�ȡ
function loadclasstyp()
{
  var ds = pub.EADbTool.QuerySQL("select note id,name from V_BASCAT1");
  return ds.GetXml();
}



}