function x_SelBilFlw(){var grd= new JavaPackage("com.xlsgrid.net.grd");
var pub= new JavaPackage("com.xlsgrid.net.pub");
var xmldb= new JavaPackage("com.xlsgrid.net.xmldb");

//================================================================// 
// 函数：getAviableBill
// 说明：
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：12/28/05 16:14:30
// 修改日志：
//================================================================//
var totalBils=0;
function getAviableBill(db, sytid, accid,usrloc, bilFlwID, ExtraWhere,page,pagesize,仓库代储)
{
    //取得指定数据流类在xmlds中的行号
    var FlwDefds = xmldb.EAXmlDB.getFlwLnkDestDs(sytid);
    
    var colidx = FlwDefds.getColumnLoc(xmldb.EAXmlDB.flwLnkID);
    var rowidx = FlwDefds.Find(bilFlwID,colidx);
    var MappedMode = FlwDefds.getStringDef(rowidx,xmldb.EAXmlDB.flwLnkMapMod,"0"); 
    //取得指定数据流类的明细在xmlds中的行号集合
    var flwsrcds = xmldb.EAXmlDB.getFlwLnkSrcDs(sytid);


    var list = flwsrcds.getRowList(xmldb.EAXmlDB.flwLnkID,bilFlwID);
    pub.EAFunc.assertsFmt(list.size()>0,"%s没有定义数据流:%s",sytid,bilFlwID);
    var srcBilTypCol = flwsrcds.getColumnLoc(xmldb.EAXmlDB.flwLnkSrcBil);
    //pub.EAFunc.WriteToFile( "/u/1.txt", flwsrcds.GetXml() );
    
    var iterator = list.iterator();
    //EADatabase db = new EADatabase();
    var result = new pub.EAXmlDS();
    //String[] hdrFields = EAOption.get("FlwHdrFields").split(",");
    //依次处理各个单据明细
    var datflwsql="";
    var servlet = new JavaPackage("com.xlsgrid.net.servlet");
    var stawhere =" flw='"+bilFlwID+"' and (endflg is null or endflg='0') and ";
    if(!仓库代储)
      stawhere += " a.acc='"+accid+"' and ";
    //gld: 07-1-5;MOMJ2MC时，需要MO在前。特殊的情况另外再考虑增加额外的排序条件
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
      if(仓库代储)
        datflwsql += ",(select id,subacc from loc) c where b.locid=c.id and c.subacc='"+accid+"'\n and ";
      else datflwsql += " where ";
      //触发来源单据的onFilterLoc事件，获取仓库的过滤sql子句
      var locfil = "b.locid is null or b.locid like '"+usrloc+"%'";
      var ret=servlet.RunScript.ExecMwOsEx(sytid,srcbiltyp,"onFilterLoc",[request,srcbiltyp,bilFlwID,usrloc,locfil]);
      if(!pub.EAFunc.isEmptyStr(ret))
        locfil=ret;      
      //2008-04 修改跨帐套生成的问题,如果报错，需要在datflwsta中增加一个SRCACC字段（该字段在执行单据审核创建datflwsta会自动增加）
     // datflwsql += "nvl(a.srcacc,a.acc)=b.acc and a.srcbil=b.bilid and a.srcbiltyp=b.biltyp and ("+locfil+") and "
     
      datflwsql += "a.acc=b.acc and a.srcbil=b.bilid and a.srcbiltyp=b.biltyp and ("+locfil+") and " 
         +stawhere + filter + " and srcbiltyp = '"+srcbiltyp+"' " + ExtraWhere;
         //+ pub.EAFunc.format(" and(SRCBILTYP='%s' and %s)",srcbiltyp,filter);
      //dtlfilter += pub.EAFunc.format(" and(a.SRCBILTYP='%s' and %s)",srcbiltyp,filter);
    }
    //System.out.println(datflwsql);
    var order1 = ",CRTDAT desc,srcbilseq";
    
    //refid1,refid2,refid3,srcsubtyp等字段可以在数据流中访问
    //ConvertMod,MappedMode 给客户端脚本用
    var fields = "a.SRCBILTYP, a.srcbil,SRCBILSEQ,VALLEFT,0 as val2Convert, MEMO1,MEMO2,SRCBILDAT,ConvertMod,MappedMode, a.GUID, a.untnum,a.refid1,a.refid2,a.refid3,srcsubtyp,ConvertTimes,ValueMod,a.acc dataAcc ";
    var stasql = "";
// 2014，如果是单据头转换，不需要和来源的bildtl做对应
	if(ConvertMod=="2"){
		stasql = 
		"select " + fields +" from datflwsta a,(select * from(select rownum-1 rid, t.* from("
		+datflwsql +order0
		+pub.EAFunc.format(") t where rownum<=%s*%s)where rid>=(%s-1)*%s)", [page,pagesize,page,pagesize])
		// 2008/11 过滤掉一个单据中已经部分记录可用数为0的情况
		+pub.EAFunc.format("b where a.acc=b.acc and a.srcbil=b.srcbil and a.srcbiltyp=b.srcbiltyp and (endflg is null or endflg='0') and flw='%s' and a.VALLEFT<>0 ",bilFlwID)
		//+dtlfilter
		+order0 + order1 ;
	}else{
	      stasql =
	      "select " + fields +" from datflwsta a,(select * from(select rownum-1 rid, t.* from("
               +datflwsql +order0
               +pub.EAFunc.format(") t where rownum<=%s*%s)where rid>=(%s-1)*%s)", [page,pagesize,page,pagesize])
               // 2008/11 过滤掉一个单据中已经部分记录可用数为0的情况
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
// 函数：getBillDsXml
// 说明：得到数据流的数据集
// 参数：
// 返回：xml
// 样例：
// 作者：
// 创建日期：11/04/05 15:40:57
// 修改日志：
//================================================================// 
function getBillDsXml()
{

    var db=null;
    try{
//throw new Exception(osfunc);
    var 仓库代储 = "loctyp3" == osfunc;
      db = new pub.EADatabase();
      var retds = getAviableBill(db,sytid,accid,usrloc,bilflwcls,where,curpage,corpsperpage,仓库代储);
      var r = retds.getRowCount();
      var pos = 1 * curpage * corpsperpage;
      if(r>0)
      {
        //if( (1 * curpage > 1) || (pos < totalBils) )
          retds.AddNullRow(r-1);
        if(1 * curpage > 1)
          retds.setValueAt(r,0,"上一页");
        if(pos<totalBils)
          retds.setValueAt(r,1,"下一页");
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
// 函数：runbilFlw
// 说明：执行数据流转换操作
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：01/11/06 12:38:32
// 修改日志：
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
    throw new pub.EAException("授权密码错误，请联系管理员获取授权密码。");
  return grd.EABilflw.forceclose(bilxml);
}

//================================================================// 
// 函数：batchconv
// 说明：批量转换。每个来源单据生成一个目标单据。
// 特殊的处理，例如生成结算单的科目，在数据流中处理。
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：01/11/06 12:31:29
// 修改日志：
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
          //把客户端传递过来的参数传递给数据流
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

//获取分类；数据流的条件从note字段获取
function loadclasstyp()
{
  var ds = pub.EADbTool.QuerySQL("select note id,name from V_BASCAT1");
  return ds.GetXml();
}



}