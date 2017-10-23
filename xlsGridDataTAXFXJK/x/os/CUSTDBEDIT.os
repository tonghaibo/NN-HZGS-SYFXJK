function x_CUSTDBEDIT(){var pub = new JavaPackage("com.xlsgrid.net.pub");
function getNextID()
{
  var newNo = "";
  try
  {
    var sql = "select id,id+"+inc+" from corp v where refid='"+clsid
      +"' and id+1=(select max(id+1) from corp where refid='"+clsid+"' and id like '"+clsid+"%')";
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

//================================================================// 
// 函数：MoveFromDfxd
// 说明：从外系统（数据库连接名DFXD）更新数据
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：03/21/06 23:11:13
// 修改日志：
//================================================================// 
function MoveFromDfxd()
{
      var db = null;
      var msg = "";
      var sql = "INSERT INTO CORP (       ID	,NAME	,LONNAME	,SHTNAM	,CORPTYP	,REFID	,ENDFLG	,ADS	,ZIP	,          TEL	,FAX	,EML	,MAN	,BANK	,ACCOUNT	,TAXNO	,CORMAN	,CRDSUM	,CRDDAY	,          CRTUSR	,CRTDAT          )"+
          " SELECT           '01'||ID ,    NAME     ,LONNAME  ,SHTNAM   ,TYPE     ,          DECODE(REFID,NULL,'','01'||REFID),ENDFLG   ,ADS      ,          ZIP      ,TEL      ,FAX      ,EML      ,MAN      ,          BANK     ,ACCOUNT  ,TAXNO    ,CORMAN   ,CRDSUM   ,          CRDDAY   ,'SYSTEM' ,SYSDATE          FROM CORP@dfxd where id not like '8%' and '01'||id not in ( select id from corp );";
      try {
            db = new pubpack.EADatabase();
            var ret = db.ExcecutSQL(sql);
            sql ="update corp a set maxdis=NVL((select maxdis from corp@dfxd b where a.id='01'||b.id ),1) where substr(id,1,2)='01'";
            db.ExcecutSQL(sql);

            db.Commit();
            msg="操作成功,成功插入了" +ret +"条记录" ;
      }
      catch ( ee ) {
            if( db!=null) db.Rollback();
            throw new pubpack.EAException ( ee.toString() );
      }
      finally {
            if (db!=null) db.Close();
      }
      return msg;
      


}
}