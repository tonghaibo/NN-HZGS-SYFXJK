function x_procStat(){//��������
var pub = new JavaPackage("com.xlsgrid.net.pub");

//1. �޸ĵ���״̬
//2. ������ϵͳ��Ϊ��������˽�������
function process()
{
  if(bilid=="")
    throw new Exception("�Ҳ������ݡ�");
  pub.EAFunc.asserts(tousr!="","��ָ����������ˡ�");
  var usr=web.EASession.GetLoginInfo(request);
  //todo: tousr��org
  var toorg=usr.getOrgid();
  var accid=usr.getAccid();
  var usrid=usr.getUsrid();
  var db = new pub.EADatabase();
  try 
  {
    var action="";
    if(stat==1 && tostat==2) action="CHECK";
    if(stat==2 && tostat==1) action="UNCHECK";
    //1. ���µ���״̬
    if(action!="")
    {
      var eaContext = new pub.EAContext(request);
      eaContext.setEADatabase(db);
      var servlet = new JavaPackage("com.xlsgrid.net.servlet");
      ret=servlet.EAGridAction.doAction(action, eaContext);
      throw new Exception(ret);
    }
    else
    {
      var sql = "update %s set stat='%s' where acc='%s' and biltyp='%s' and bilid='%s' and stat='%s'".
      	format(["%s",tostat,accid,biltyp,bilid,stat]);
      var c=db.ExcecutSQL(sql.format(["bilhdr"]));
      if(c<=0)
        throw new Exception("\n�������ѽ������뵽����ϵͳ�в�ѯ��������");
      db.ExcecutSQL(sql.format(["bildtl"]));
    }
    //2 ������ϵͳ��Ϊ��������˽�������
    var grd = new JavaPackage("com.xlsgrid.net.grd");
    var mwname = grd.EAMidWareUtil.mwid2nameByAcc(accid,biltyp);
    var sql = "select guid from trkhdr where acc='%s' and id='%s.%s'".format([accid,biltyp,bilid]);
    var trkguid;
    var ����id = biltyp+"."+bilid;
    var newtask = false;
    try
    {
      trkguid = db.GetSQL(sql);
    }
    catch(e)
    {
      newtask = true;
      //var inssql = "insert into trkhdr(project,id,title,note,syt,org,acc,stat,prio,show,crtusr,dtlusr)"+
      //  "values('BILFLW','%s','%s[%s] %s','������������','%s','%s','%s',0,1,0,'%s','%s')"
      //  "format([����id,mwname,biltyp,bilid,usr.getSytid(),usr.getOrgid(),accid,usrid,usrid]);
      //db.ExcecutSQL(inssql);
      //trkguid = db.GetSQL(sql);
    }
    var dtlkey = title+"```"+mwname+"."+biltyp+"."+bilid+".";
    if(!newtask)
    {
      //����ԭ����Ϊ�����״̬
      //var oldkey = dtlkey+stat;
      sql = "update trkdtl set style=2,tousr='%s' where trkguid='%s' and crtusr='%s' and review='%s'".
      	format([tousr,trkguid,usrid,stat]);
      var c = db.ExcecutSQL(sql);
      pub.EAFunc.asserts(c==1,"�޸�����״̬������ȷ�ϸ������Ƿ��������ġ�"+sql);
    }
    dtlkey += tostat;
    sql = "select guid from trkdtl where acc='%s' and title='%s' and crtusr='%s' and crtusrorg='%s'".
    	format([accid,dtlkey,tousr,toorg]);
 //   sql = "insert into trkdtl(trkguid,pro_note,tousr,style,crtusr,crtusrorg,project,title,syt,org,acc,id,result,review)
  //  	values('%s','%s','','1','%s','%s','BILFLW','%s','%s','%s','%s','%s','1','%s')".
  //  	format([trkguid,note,tousr,toorg,dtlkey,usr.getSytid(),usr.getOrgid(),accid,����id,tostat]);
  //  db.ExcecutSQL(sql);
//    sql = "update trkhdr set dtlusr='%s' where guid='%s'".format([usrid,trkguid]);
 //   db.ExcecutSQL(sql);
    db.Commit();
    return 1;
  }
  catch(e)
  {
    db.Rollback();
    throw e;
  }
  finally
  {
    db.Close();
  }
}

//ҳ��BODY������Ϻ��¼�
//sb������bodyԪ�ؼ�ǰ���head����
//bodysb������body��innerHTML
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
  var biltyp = request.getParameter("biltyp");
  var actionid = request.getParameter("actionid");
  var usr=web.EASession.GetLoginInfo(request);
  var wsds= xmldb.EAXmlDB.getActionDs(usr.getSytid(),biltyp);
  if(wsds==null)
    throw new Exception("ȱ�ٹ��������塣");
  wsds = wsds.filterDS("ID",actionid);
  var user = wsds.getStringAt(0,"TOUSR");
  var rol = wsds.getStringAt(0,"TOROL");
  bodysb.append("<script>var to_usr='%s'; var to_rol='%s'</script>".format([user,rol]));
}

}