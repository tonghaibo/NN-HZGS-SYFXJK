function XLSGRID_UPDATEUSR(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
//================================================================// 
// ������GetMaxid
// ˵�����õ����ı��
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�05/27/06 14:08:25
// �޸���־��
//================================================================// 
function GetMaxid()
{
      var ret = "";
      try {
            if ( refid == "2" )       // ҵ��Ա��10000��ʼ���
                  ret = pubpack.EADbTool.GetSQL("SELECT NVL(MAX(to_number(ID))+1,1) FROM USR where isnumber(id)='1' and post='"+refid+"'");
            else
                  ret = pubpack.EADbTool.GetSQL("SELECT NVL(MAX(to_number(ID))+1,1) FROM USR where isnumber(id)='1' and post!='"+refid+"'");
      }
      catch (  e ){
            ret = e.toString();
      }
      
      return ret;
}
}