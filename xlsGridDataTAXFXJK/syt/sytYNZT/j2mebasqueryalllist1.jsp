<%@ page contentType="text/vnd.wap.wml;charset=gb2312" import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*"%> 
<?xml version="1.0" encoding="gb2312"?>
<!DOCTYPE wml PUBLIC "-//WAPFORUM//DTD WML 1.1//EN" "http://www.wapforum.org/DTD/wml_1.1.xml">
<%   

    String name = "";
    String corpid = "";
    String sUsrnam="";
    EAXmlDS ds = null;
    String sNo=(String)session.getAttribute("sNo");//session�����û����ֻ�����
    EAUserinfo usrinfo = new MobileLogin().GetUsrinfo(request); 
    if ( usrinfo ==null ) 
    {
      usrinfo = new EAUserinfo();
      usrinfo.setUsrid(sNo);
    }
     // �õ���½��USER ID
    String sUID  = usrinfo.getUsrid();
    
    
 //   String sql = "select shtnam as ��Ʒ,sctype ����,ceil(qty/untnum)-decode(mod(qty,untnum),0,0,1)||unit||mod(qty,untnum)||smlunt as ���� "+
 //     "from ( "+
 //     "select i.shtnam ,i.untnum,i.unit,i.smlunt,c.name sctype,sum(qty) qty "+
 //     "from item i,curord h,v_sctype c where h.sctype=c.id and h.item=i.guid and h.crtusr='"+sUID+"' and h.subtyp='2'"+
 ///     "group by i.id,i.refid,i.sortid,i.shtnam,i.untnum,i.unit,i.smlunt,c.name order by i.refid,i.sortid )";




    String sql = "select shtnam as ��Ʒ,sctype ����,ceil(qty/untnum)-decode(mod(qty,untnum),0,0,1)||unit||mod(qty,untnum)||smlunt as ���� "+
      "from ( "+
      "select i.shtnam ,i.untnum,i.unit,i.smlunt,c.name sctype,sum(qty) qty "+
      "from item i,curord h,v_sctype c, corp d,corpitem e where h.sctype=c.id and h.item=i.guid and h.crtusr='"+sUID+"' and h.subtyp='2'"+
      " and h.corp=d.guid and h.item=e.item and d.refguid=e.corp "+
      "group by i.id,i.refid,i.sortid,i.shtnam,i.untnum,i.unit,i.smlunt,c.name order by i.refid,i.sortid )";





    ds = EADbTool.QuerySQL(sql);
	  String sql1 = "select distinct corpsoid from curord where crtusr='"+sUID+"'";
    int cc = EADbTool.QuerySQL(sql1).getRowCount();
    String sOut = "";
    int c = ds.getRowCount();
    sOut +="��"+cc+"�ʶ���<br/>";          
   // sOut +="<br/>��"+EADbTool.GetSQL("SELECT COUNT(DISTINCT CORP) FROM CURORD WHERE crtusr='"+sUID+"' ") + "������<br/>";          
    sOut +="��Ʒ���ܣ�<br/>";
    for ( int i=0;i<c;i ++ ) {
        sOut += ds.getStringAt(i,"��Ʒ")+":<br/>"+ds.getStringAt(i,"����")+ds.getStringAt(i,"����")+"<br/>";     
    }
    sOut +="<br/><a href=\"bas_query.jsp\">������ҳ</a>";          
    sOut +="<br/><a href=\"main.jsp\">������ҳ</a>";

%>


<wml>
<card id="card1" title="�����б�">
<p align="center">
<%=sOut%>
</p>
</card>
</wml>

