function XLSGRID_JM_NEWTRK(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var web = new JavaPackage("com.xlsgrid.net.web");

//��Ϊ.sp����ʱ�����
//Ԥ���������request,response
function Response()
{
      var func = pubpack.EAFunc.NVL(request.getParameter("func"),"");
      var data = pubpack.EAFunc.NVL(request.getParameter("_this"),"");
      var typ = pubpack.EAFunc.NVL(request.getParameter("TYP"),"");
      var usr = web.EASession.GetLoginInfo(request);
      var usrid = usr.getUsrid();
      var accid = usr.getAccid();
      var sytid = usr.getSytid();
      var orgid = usr.getOrgid();
      var db = null;
      var sql = "";
      var ret= "";
      var out = response.getOutputStream();
      response.setContentType("content-type:text/html; charset=UTF-8");
      try {
            db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
            
            if (func == "save"){
		var title = pubpack.EAJ2meUtil.getDataByCellid(data,"title");
		var tousr = pubpack.EAJ2meUtil.getDataByCellid(data,"tousr");
		var contents = pubpack.EAJ2meUtil.getDataByCellid(data,"contents");
//		var title = pubpack.EAJ2meUtil.getDataByRowCol(data,2,0);
//		var tousr = pubpack.EAJ2meUtil.getDataByRowCol(data,4,0);
//		var contents = pubpack.EAJ2meUtil.getDataByRowCol(data,6,0);

		sql = "insert into trkhdr (id,project,title,prousr,note,dtlusr,syt,acc,selforg,stat,crtusr) 
			values (trk_seq.nextval,'%s','%s','%s','%s','%s','%s','%s','%s','4','%s')".format([typ,title,usrid,contents,tousr,sytid,accid,orgid,usrid]);
               	db.ExcecutSQL(sql);
               	ret = "���񱣴�ɹ���";
               	var arrHreftxt = new Array("�����½�����","�����ҵĴ��������б�","�����ҵ�����");
               	var arrHref = new Array("show.sp?grdid=JM_TRKTYP","show.sp?grdid=JM_MYTRK&STAT=4","j2memydesktop.jsp");
               	ret = pubpack.EAJ2meUtil.returnPage("����ɹ���",arrHreftxt,arrHref);
		db.Commit();
            }
            else if (func == "sendMSG"){
            	ret += "���ŷ��͹���δ֧�֣�";
            }

      }
      catch ( ee ) {
            db.Rollback();
            return ee.toString();
            return "save faile!";
            ret = pubpack.EAJ2meUtil.returnErrPage("");
            //throw new pubpack.EAException ( ee.toString() );
      }
      finally {
            if (db!=null) db.Close();
      }
      out.println( ret );      
}


}