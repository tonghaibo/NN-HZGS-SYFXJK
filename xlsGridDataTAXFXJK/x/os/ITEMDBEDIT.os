function x_ITEMDBEDIT(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
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
      var sql = "insert into item ( id,refid,name,endflg,unit,spec,smlunt,untnum,tonnum,itmtyp,bascat1 )" +
            "select id,refid,name,endflg,unit,spec,smlunt,untnum,tonnum,itmtyp,decode(substr(id,5,1),'1','1 大包装糖','2 小包装糖') "+
            " from item@dfxd where " +
            " id not in ( select id from item ) and id like '00%'";
      try {
            db = new pubpack.EADatabase();
            var ret = db.ExcecutSQL(sql);
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