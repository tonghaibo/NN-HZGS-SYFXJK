function XLSGRID_JM_MYTRK(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
//��Ϊ.sp����ʱ�����
//Ԥ���������request,response
function Response()
{
      var action = request.getParameter("func");
      response.setContentType("content-type:text/html; charset=UTF-8");
      var out = response.getOutputStream();
      var db = null;
      var ret= "";
      try {
            db = new pubpack.EADatabase();	
            if (action == "modify"){
            	ret = "�������޸İ�ť��";
            }
            else if (action == "delete"){
            	ret = "������ɾ����ť��";
            }
      }
      catch ( ee ) {
            db.Rollback();
            throw new pubpack.EAException ( ee.toString() );
      }
      finally {
            if (db!=null) db.Close();
      }
      out.println(ret);
}
}