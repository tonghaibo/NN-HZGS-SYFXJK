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
    newNo = zeros.substring(1,l-s.length()+1)+s;//����ǰ��0
  }
  catch(e)
  {
    return clsid+"0001";
    //ȡ��󵥾ݺţ�1���󣬲�����һ������
  }
  return newNo;    
}
}