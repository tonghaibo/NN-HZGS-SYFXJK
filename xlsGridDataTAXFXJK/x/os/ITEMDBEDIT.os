function x_ITEMDBEDIT(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
//================================================================// 
// ������MoveFromDfxd
// ˵��������ϵͳ�����ݿ�������DFXD����������
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�03/21/06 23:11:13
// �޸���־��
//================================================================// 
function MoveFromDfxd()
{
      var db = null;
      var msg = "";
      var sql = "insert into item ( id,refid,name,endflg,unit,spec,smlunt,untnum,tonnum,itmtyp,bascat1 )" +
            "select id,refid,name,endflg,unit,spec,smlunt,untnum,tonnum,itmtyp,decode(substr(id,5,1),'1','1 ���װ��','2 С��װ��') "+
            " from item@dfxd where " +
            " id not in ( select id from item ) and id like '00%'";
      try {
            db = new pubpack.EADatabase();
            var ret = db.ExcecutSQL(sql);
            db.Commit();
            msg="�����ɹ�,�ɹ�������" +ret +"����¼" ;
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