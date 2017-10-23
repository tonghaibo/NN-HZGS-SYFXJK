function x_SelFlw(){var pub = new JavaPackage("com.xlsgrid.net.pub");

function addBottomHtml(mwobj,request,sb,usrinfo)
{
   sb.append("<script>");//function initXlsGridToolsBar() { _this.ShowToolBar(1);}");
   sb.append("function DoQuery(where,key){myDoQuery(where,key,event)} </script>");
}

var grd= new JavaPackage("com.xlsgrid.net.grd");
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
function getAviableBill(db, sytid, accid,bilFlwID, ExtraWhere,page,pagesize)
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
    var iterator = list.iterator();
    //EADatabase db = new EADatabase();
    var result = new pub.EAXmlDS();
    //String[] hdrFields = EAOption.get("FlwHdrFields").split(",");
    //依次处理各个单据明细
    var datflwsql="";
    var stawhere = pub.EAFunc.format(" a.acc='%s' and flw='%s' and (endflg is null or endflg='0') and ",
          accid,bilFlwID); 
    var order0 = " order by srcbil desc,srcbiltyp desc";
    //var dtlfilter="";
    //var headeronlyfilter=" and a.srcbilseq<=1 "; //只取表头的信息
    //var headeronlyfilter=" and rownum<=1 "; //只取表头的信息
    
    var servlet = new JavaPackage("com.xlsgrid.net.servlet");
    while(iterator.hasNext())
    {
      var row = iterator.next();
      var ConvertMod = flwsrcds.getValueAt(row,"ConvertMod");
      var srcbiltyp = flwsrcds.getValueAt(row,srcBilTypCol);
      var ValueMod = flwsrcds.getStringDef(row,"ValueMod","0");
      var ConvertTimes = flwsrcds.getStringDef(row,"ConvertTimes","0");
      var filter = flwsrcds.getValueAt(row,xmldb.EAXmlDB.flwLnkSrcFilter);
      if (pub.EAFunc.isEmptyStr(filter))
        filter = "valleft<>0";
      if(datflwsql!="")
        datflwsql += "\nunion all\n";
      datflwsql += 
         pub.EAFunc.format("select a.acc,srcbil,srcbiltyp,min(a.srcbilseq) seqid,"+
            "'%s' MappedMode,'%s' ConvertMod,'%s' ValueMod,'%s' ConvertTimes from datflwsta a,bilhdr b "+
            "where a.acc=b.acc and a.srcbil=b.bilid and a.srcbiltyp=b.biltyp and ",
          [MappedMode,ConvertMod,ValueMod,ConvertTimes]);
      //触发来源单据的onFilterLoc事件，获取仓库的过滤sql子句
      var locfil = "b.locid is null or b.locid like '"+usrloc+"%'";
      var ret=servlet.RunScript.ExecMwOsEx(sytid,srcbiltyp,"onFilterLoc",[request,srcbiltyp,bilFlwID,usrloc,locfil]);
      if(!pub.EAFunc.isEmptyStr(ret))
        locfil=ret;            
      datflwsql += "("+locfil+") and "
         +stawhere + filter + " and srcbiltyp = '"+srcbiltyp+"' " + ExtraWhere
         //+headeronlyfilter
         +" group by  a.acc,srcbil,srcbiltyp ";
         //+ pub.EAFunc.format(" and(SRCBILTYP='%s' and %s)",srcbiltyp,filter);
      //dtlfilter += pub.EAFunc.format(" and(a.SRCBILTYP='%s' and %s)",srcbiltyp,filter);
    }
//    System.out.println(datflwsql);
    var order1 = ",CRTDAT desc,srcbilseq";
    
    //refid1,refid2,refid3,srcsubtyp等字段可以在数据流中访问
    //ConvertMod,MappedMode 给客户端脚本用
    var fields = "a.SRCBILTYP, a.srcbil,SRCBILSEQ,VALLEFT,0 as val2Convert, MEMO1,MEMO2,SRCBILDAT,ConvertMod,MappedMode, GUID, untnum,refid1,refid2,refid3,srcsubtyp,ConvertTimes,ValueMod ";
    var stasql = 
"select " + fields +" from datflwsta a,(select * from(select rownum-1 rid, t.* from("
+datflwsql +order0
+pub.EAFunc.format(") t where rownum<=%s*%s)where rid>=(%s-1)*%s)", [page,pagesize,page,pagesize])
+pub.EAFunc.format("b where a.acc=b.acc and a.srcbil=b.srcbil and a.srcbiltyp=b.srcbiltyp  and a.srcbilseq=b.seqid  and (endflg is null or endflg='0') and flw='%s' ",bilFlwID)
//+dtlfilter
//+headeronlyfilter //只取表头的信息
+order0 + order1 ;
    //System.out.println(stasql); 
    stasql = pub.EAFunc.XmlToStd(stasql );
    //throw new Exception(dtlfilter);
    var flwsta = db.QuerySQL(stasql );
    result.Append(flwsta);
      
    var countsql ="select count(*) from(select distinct acc,srcbil,srcbiltyp from ("+datflwsql+") )t ";
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
      db = new pub.EADatabase();
      var retds = getAviableBill(db,sytid,accid,bilflwcls,where,curpage,corpsperpage);
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
      var ds = new pub.EAXmlDS(bilxml);
      //throw new Exception(bilxml);
      var newds = new pub.EAXmlDS();//pub.EAXmlDS.cloneEADS(ds);
      var c = ds.getRowCount();
      for(var i=0;i<c;i++)
      {
         if(ds.getStringAt(i,"SELECTFLG")=="1")
         {
               //var accid = ds.getStringAt(i,"acc");
               var biltype=ds.getStringAt(i,"srcbiltyp");
               var srcbilid=ds.getStringAt(i,"srcbil");
               //var flwid = ds.getStringAt(i,"");
               var dtlsql = pub.EAFunc.format("select * from datflwsta where acc='%s' and srcBILTYP='%s' and  srcBIL='%s' and flw='%s' order by srcbilseq",
                  [accid,biltype, srcbilid,bilflwid]);
               var dtlds = pub.EADbTool.QuerySQL(dtlsql);
               var c1=dtlds.getRowCount();
               for(var j=0;j<c1;j++)
               {
                 var val = dtlds.getStringAt(j,"VALLEFT");
                 var nr  = newds.copyOneRow(ds,i);
                 //var nr  = newds.getRowCount()-1;
                 newds.setValueAt(nr,"SRCBILSEQ",dtlds.getStringAt(j,"SRCBILSEQ"));
                 newds.setValueAt(nr,"VALLEFT",val);
                 newds.setValueAt(nr,"val2Convert",val);
                 var guid = dtlds.getStringAt(j,"GUID");
                 newds.setValueAt(nr,"GUID",guid);
               }
         }      
      }
      bilxml = newds.GetXml();
      //throw new Exception(bilxml);
      //var msg = grd.EABilflw.ExecBilFlw(request,bilflwid,bilxml);
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
      var oldbil="";
      var oldmw="";
      var i=0;
      while(i<c)
      {
        if(ds.getStringAt(i,"SELECTFLG")!="1")
        {
          i++;
          continue;
        }
        var mwid = ds.getStringAt(i,0);
        var bilid = ds.getStringAt(i,1);
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
            mwid = ds.getStringAt(i,0);
            bilid = ds.getStringAt(i,1);
            beginBil = (oldmw!=mwid)||(oldbil!=bilid);
          }
          i--;
          //把客户端传递过来的参数传递给数据流
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