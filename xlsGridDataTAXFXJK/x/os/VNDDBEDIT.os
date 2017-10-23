function x_VNDDBEDIT(){var pub = new JavaPackage("com.xlsgrid.net.pub");
function getNextID()
{
  var newNo = "";
  try
  {
    var sql = "select id,id+"+inc+" from corp v where refid='"+clsid
      +"' and id+1=(select max(id+1) from corp where refid='"+clsid+"' and id like '"+clsid+"%')";
//      +"' and id+1=(select max(id+1) from corp where refid='"+clsid+"')";
    var ds = pub.EADbTool.QuerySQL(sql);
    var no = ds.getStringAt(0,0);
    var s = ds.getStringAt(0,1);
    var zeros="000000000000000000";
    var l = no.length();
    newNo = zeros.substring(1,l-s.length()+1)+s;//补足前导0
  }
  catch(e)
  {
    return clsid+"0001";
    //取最大单据号＋1错误，不做进一步处理
  }
  return newNo;    
}
}