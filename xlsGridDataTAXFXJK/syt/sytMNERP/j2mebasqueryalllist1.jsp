<%@ page contentType="text/vnd.wap.wml;charset=gb2312" import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*"%> 
<?xml version="1.0" encoding="gb2312"?>
<!DOCTYPE wml PUBLIC "-//WAPFORUM//DTD WML 1.1//EN" "http://www.wapforum.org/DTD/wml_1.1.xml">
<%   

    String name = "";
    String corpid = "";
    String sUsrnam="";
    EAXmlDS ds = null;
    String sNo=(String)session.getAttribute("sNo");//session保存用户的手机号码
    EAUserinfo usrinfo = new MobileLogin().GetUsrinfo(request); 
    if ( usrinfo ==null ) 
    {
      usrinfo = new EAUserinfo();
      usrinfo.setUsrid(sNo);
    }
     // 得到登陆的USER ID
    String sUID  = usrinfo.getUsrid();
    
    
 //   String sql = "select shtnam as 商品,sctype 分类,ceil(qty/untnum)-decode(mod(qty,untnum),0,0,1)||unit||mod(qty,untnum)||smlunt as 数量 "+
 //     "from ( "+
 //     "select i.shtnam ,i.untnum,i.unit,i.smlunt,c.name sctype,sum(qty) qty "+
 //     "from item i,curord h,v_sctype c where h.sctype=c.id and h.item=i.guid and h.crtusr='"+sUID+"' and h.subtyp='2'"+
 ///     "group by i.id,i.refid,i.sortid,i.shtnam,i.untnum,i.unit,i.smlunt,c.name order by i.refid,i.sortid )";




    String sql = "select shtnam as 商品,sctype 分类,ceil(qty/untnum)-decode(mod(qty,untnum),0,0,1)||unit||mod(qty,untnum)||smlunt as 数量 "+
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
    sOut +="共"+cc+"笔订单<br/>";          
   // sOut +="<br/>共"+EADbTool.GetSQL("SELECT COUNT(DISTINCT CORP) FROM CURORD WHERE crtusr='"+sUID+"' ") + "个网点<br/>";          
    sOut +="商品汇总：<br/>";
    for ( int i=0;i<c;i ++ ) {
        sOut += ds.getStringAt(i,"商品")+":<br/>"+ds.getStringAt(i,"分类")+ds.getStringAt(i,"数量")+"<br/>";     
    }
    sOut +="<br/><a href=\"bas_query.jsp\">返回上页</a>";          
    sOut +="<br/><a href=\"main.jsp\">返回主页</a>";

%>


<wml>
<card id="card1" title="网点列表">
<p align="center">
<%=sOut%>
</p>
</card>
</wml>

