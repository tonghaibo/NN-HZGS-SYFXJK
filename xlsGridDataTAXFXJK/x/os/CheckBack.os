function x_CheckBack(){var pub = new JavaPackage("com.xlsgrid.net.pub");
//v_chkbak aqty:勾单时的剩余可转数
//bqty:勾兑数量
//原始单据勾兑数在v_popay 中,用aguid关联
function addBottomHtml(mwobj,request,sb,usrinfo)
{
   sb.append("<script>");//function initXlsGridToolsBar() { _this.ShowToolBar(1);}");
   sb.append("function DoQuery(where,key){myDoQuery(where,key,event)} </script>");
}

function loadBil()
{
  var where = "acc='"+accid+"' and biltyp='"+biltyp+"' and " +
    "bilid like '"+BILID+"%' and (corpid is null or corpid like '"+CORPID+"%')and dat between to_date('" +
    DATE1+"','yyyy-mm-dd') and to_date('"+DATE2+"','yyyy-mm-dd') ";
  if(subtyp!="")
    where += " and subtyp='"+subtyp+"' ";
  var mtyp="a";
  if(target==1) mtyp= "b";
  //以目标单据的勾单总数来计算剩余勾单数
  var btable = "(select "+mtyp+"guid,sum(bqty) "+mtyp+"qty from v_chkbak group by "+mtyp+"guid)";
  var qty = "round(qty - nvl(b."+mtyp+"qty,0),2) ";  
  var sql = "select biltyp||'.'||bilid bil,dat,'客户:'||corpid||' '||corpnam||'备注:'||NOTE note,"+
        qty+" qty,a.guid from V_POPAY a,"+btable+" b where a.guid = b."+mtyp+"guid(+) and " + qty + "<>0 and " +
        where + " order by dat";
  
  //throw new Exception( sql);
  sql = pub.EASqlFunc.pageSql(sql,"1",BILCNT);
  //return sql;
  var ds = pub.EADbTool.QuerySQL(sql);
  ds.removeColumn(0);
  return ds.GetXml();
}

function SaveCheckBack()
{
  //return xml;
  var ds = new pub.EAXmlDS(xml);
  var sql = "insert into CHKBAK(AGUID,ABILTYP,AQTY,BGUID,BBILTYP,BQTY) values ('";
  var db = new pub.EADatabase();
  try
  {
    for(var i=0;i<ds.getRowCount();i++)
    {
      var val = ds.getStringAt(i,"AGUID")+"','";
      var abil = ds.getStringAt(i,"ABILTYP");
      val += abil+"','";
      val += ds.getStringAt(i,"AQTY")+"','";

      var p = abil.indexOf(".");
      var abilid = abil.substring(p);
      var bguid = ds.getStringAt(i,"BGUID");
      var updsql = "update bilhdr set refnam1='"+abilid+"' where guid='"+bguid+"'";
//      throw new Exception(updsql);
      db.ExcecutSQL(updsql);
      val += bguid+"','";
      val += ds.getStringAt(i,"BBILTYP")+"','";
      val += ds.getStringAt(i,"BQTY")+"')";
      db.ExcecutSQL(sql + val);
    }
    //保存付款单号码到发票中
    db.Commit();
    return "保存成功。";
  }
  catch(e)
  {
    db.Rollback();
    throw e;
  }
}

}