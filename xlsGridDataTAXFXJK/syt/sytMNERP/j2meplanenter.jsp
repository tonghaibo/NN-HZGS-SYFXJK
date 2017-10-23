<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*,java.util.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>保存计划</title>
</head>
<body>
<%
         String item = "";
         String qty = "";
         int c = 0;
         String sql = "";
         String sql2 = "";
         String sql3 = "";
         String sql4 ="";
         EADatabase db = null;
         EAXmlDS ds = null;
         EAXmlDS ds2 = null;
         String sUID = (String)session.getAttribute("sUID");//用户ID 
//         String bascat = (String)session.getAttribute("bascat");//EAFunc.NVL(request.getParameter("bascat"),"");//条线及卖场ID
//         bascat = bascat.replaceAll("BQ","北区");//因为区字会引起链接失效故在此还原参数
//         out.print("还原后的bascat"+bascat);
         String number = EAFunc.NVL(request.getParameter("number"),"");//判断是哪一个session
         String mobtyp = EAFunc.NVL(request.getParameter("mobtyp"),"");
          /* mobtyp 20090421修改为5类
            * 11 利乐包
            * 12 利乐枕
            * 21 保鲜奶
            * 22 优益C
            * 23 酸奶 
          */
         String locid = EAFunc.NVL(request.getParameter("locid"),"");//仓库ID
         String brand = EAFunc.NVL(request.getParameter("brand"),"");//MN
         String itemtype = EAFunc.NVL(request.getParameter("itemtype"),"");//常低温
         String dat = EAFunc.NVL(request.getParameter("dat"),"");//按天录入时的日期
         String data = EAFunc.NVL(request.getParameter("data"),"");//构造表格的字符串
         String action = EAFunc.NVL(request.getParameter("action"),"");//action= save
         String bascat = (String)session.getAttribute("bascat1"+number);
         String y1 = EAFunc.NVL(request.getParameter("y1"),"");
         String y2 = EAFunc.NVL(request.getParameter("y2"),"");
         String m1 = EAFunc.NVL(request.getParameter("m1"),"");
         String m2 = EAFunc.NVL(request.getParameter("m2"),"");
         String d1 = EAFunc.NVL(request.getParameter("d1"),"");
         String d2 = EAFunc.NVL(request.getParameter("d2"),"");
         String date1 = EAFunc.NVL(request.getParameter("date1"),"");//起始日期
         String date2 =  EAFunc.NVL(request.getParameter("date2"),"");//截至日期
         
         //out.print("locid"+locid);
          //out.print(date2);
         try{
           db = new EADatabase();
           //check if date format is error
           if ( date1.length() > 0&& !action.equalsIgnoreCase("save")){
             try {
                date1 = db.GetSQL("select to_char(to_date('"+date1+"','YYYYMMDD'),'YYYY-MM-DD') from dual");
                date2 = db.GetSQL("select to_char(to_date('"+date2+"','YYYYMMDD'),'YYYY-MM-DD') from dual");
             }
             catch ( EAException e ) {
                
                  throw new EAException ("日期格式不符，正确的格式是YYYYMMDD，4位年，2位月，2位日！！！");
                
             }
           }
           //如果按天录入
           if ( dat.length() > 0 ) {
              date1 = dat; date2 = dat;
           }
           if(action.equalsIgnoreCase("save")){
              
              sql3 = "select to_char(日期,'YYYY-MM-DD') dat2 from 日历 "//取出时间段内的所有日期
                   +"where 日期>=to_date('"+date1+"','YYYY-MM-DD') "
                  +"and 日期<=to_date('"+date2+"','YYYY-MM-DD') order by 日期";
              //out.println( sql3 );
              ds2 = EADbTool.QuerySQL(sql3);     
              String[] itemlist = data.split("~n");
              int n = 0;
              String sItemguid = "";
              String sPlanqty = "";
              String sFlag = "";
                        
             
              int cc = ds2.getRowCount();//判断时间段为几天
              int cnt = 0;
              for(int k = 0;k<cc;k++){//把所有日期插入到数据库
              
                    for ( int i=1;i<itemlist.length;i++ ) {
                             n = i-1;
                             String[] vl = itemlist[i].split(",");
                         //itemguid,商品名称,数量,常低温
                        //   0         1     2    3
                            sItemguid= vl[0];
                            sPlanqty = vl[2];
                            sFlag = vl[3];

                            String guid = "";
                            String untnum = db.GetSQL("select untnum from item where guid='"+sItemguid+"'");
                            try {
                              sql2 = "select guid from wapplan where item='"+sItemguid+"' and sctype='"+locid+"' and dat=to_date('"+ds2.getStringAt(k,"dat2")+"','YYYY-MM-DD') and flag='"+sFlag+"' and bascat='"+bascat+"'";
                              guid=db.GetSQL(sql2);
                              //out.println( sql2 );
                            }
                            catch( Exception e ) {}// 没有找到记录out.println( e.toString() );
                            if ( sPlanqty.length()==0){
                              sql2 = "delete from wapplan where guid='"+guid+"'" ;
                            }
                            else if ( guid.length() > 0 ) {
                              sql2 = "update wapplan set qty="+sPlanqty+"*"+untnum+"/"+cc+" where guid='"+guid+"'" ;
                              //out.println("update:"+sql2);
                              cnt++;
                            }
                            else {
                              sql2 = "insert into wapplan ( item ,qty,CRTUSR,bascat,dat,sctype,flag,brand) "
                                 +"values('"+sItemguid+"',"+sPlanqty+"*"+untnum+"/"+cc+",'"+sUID+"' ,'"+bascat+"',to_date('"+ds2.getStringAt(k,"dat2")+"','yyyy-mm-dd'),'"+locid+"','"+sFlag+"','"+brand+"')";
                                 //out.println("insert:"+sql2);
                                 cnt++;
                            }
                            db.ExcecutSQL(sql2);
                     }                                                
              }
              out.println( "操作了"+cnt+"笔记录<BR>" );
              
              db.Commit();
          }//save                    
         sql = "SELECT ITEM.guid itemguid,item.name itemname,"+
            "NVL(( select sum(qty) from WAPPLAN b where b.item=item.guid and b.dat>=to_date('"+date1+"','YYYY-MM-DD') "+
            "      and b.dat<=to_date('"+date2+"','YYYY-MM-DD') and sctype='"+locid+"'  and flag='"+itemtype+"' and bascat='"+bascat+"' )"+
            " /item.untnum,'0' ) planqty,item.refid flag FROM ITEM "
           +"WHERE  item.brand='MN' "
           +"and item.EXTCAL1 = '1' "//20090409修改加入是否计划的商品条件，防止报错商品
//           +"and item.refid = '"+itemtype+"'  "
           +"and item.mobtyp='"+mobtyp+"' "
           +" order by item.sortid" ;    
           
//          if(mobtyp.equalsIgnoreCase("21")||mobtyp.equalsIgnoreCase("22")){
//                // out.print("ddddddd");
//                   sql = "SELECT ITEM.guid itemguid,item.name itemname,"
//                     +"NVL(wapplan.qty/untnum,'0') planqty,item.refid flag FROM wapplan,ITEM "
//                     +"WHERE wapplan.ITEM(+)=ITEM.GUID and item.brand='MN' "
//                     +"and item.refid = '2' and wapplan.dat(+) = to_date('"+dat+"','yyyy-mm-dd')"
//                     +"and wapplan.sctype(+) ='"+locid+"' order by item.sortid";
//          }else {
//              //out.print("ddddddd"+itemtype);
//                  sql = "SELECT ITEM.guid itemguid,item.name itemname,"
//                  +"NVL(wapplan.qty/untnum,'0') planqty,item.refid flag FROM wapplan,ITEM "
//                  +"WHERE wapplan.ITEM(+)=ITEM.GUID and item.brand='MN' "
//                  +"and item.refid = '1' and wapplan.dat(+) >= to_date('"+date1+"','yyyy-mm-dd') "
//                  +"and wapplan.dat(+) <= to_date('"+date2+"','yyyy-mm-dd') "
//                  +"and wapplan.sctype(+) ='"+locid+"'  order by item.sortid";
//            }
//            out.print(sql);
            ds = EADbTool.QuerySQL(sql);
         //ds = EADbTool.QuerySQL(sql);
            c = ds.getRowCount();
              //out.print("ccc"+c);
              
           if(c>0){
                 String itemguid = "";
                 String itemname = "";
                 String planqty = "";
                 String flag = "";
                 String newline = "~n";
                 out.println( "<FORM action=\"j2meplanenter.jsp\" method=\"post\" >" );
                 out.println( "<SINGLETABLE name=\"data\" width=\"90%\" height=\"90%\"  FIXEDROW=\"1\" FIXEDCOL=\"2\"" );
                 out.print("COLWIDTH=\"0,170,90,0\" COLEDITABLE=\"0,1,1,0\">");
                 out.print("编号,商品,数量,常低温");
                 out.print(newline);
                 for(int i = 0;i<c;i++){
                   itemguid = ds.getStringAt(i,"itemguid");
                   itemname = ds.getStringAt(i,"itemname");
                   planqty = ds.getStringAt(i,"planqty");
                   if ( planqty.equals("0") ) planqty = "";
                   flag = ds.getStringAt(i,"flag");
                   out.print(itemguid+","+itemname+","+planqty+","+flag);
                   out.print(newline);
                 }
                  out.println("</SINGLETABLE>");
                  //item ,qty,CRTUSR,bascat,dat,sctype,flag,brand
                  out.println( "<input type=\"hidden\" name=\"action\" value=\"save\">" );
                  out.println( "<input type=\"hidden\" name=\"itemguid\" value=\""+itemguid+"\">" );
                  out.println( "<input type=\"hidden\" name=\"planqty\" value=\""+planqty+"\">" );
                  out.println( "<input type=\"hidden\" name=\"flag\" value=\""+flag+"\">" );
                  out.println( "<input type=\"hidden\" name=\"mobtyp\" value=\""+mobtyp+"\">" );
                  out.println( "<input type=\"hidden\" name=\"brand\" value=\""+brand+"\">" );
                  out.println( "<input type=\"hidden\" name=\"bascat\" value=\""+bascat+"\">" );
                  out.println( "<input type=\"hidden\" name=\"locid\" value=\""+locid+"\">" );
                  out.println( "<input type=\"hidden\" name=\"number\" value=\""+number+"\">" );
                  out.println( "<input type=\"hidden\" name=\"itemtype\" value=\""+itemtype+"\">" );
                  out.println( "<input type=\"hidden\" name=\"dat\" value=\""+dat+"\">" );
                  out.println( "<input type=\"hidden\" name=\"date1\" value=\""+date1+"\">" );
                  out.println( "<input type=\"hidden\" name=\"date2\" value=\""+date2+"\">" );
//                  out.println( "<input type=\"hidden\" name=\"y1\" value=\""+y1+"\">" );
//                  out.println( "<input type=\"hidden\" name=\"y2\" value=\""+y2+"\">" );
//                  out.println( "<input type=\"hidden\" name=\"m1\" value=\""+m1+"\">" );
//                  out.println( "<input type=\"hidden\" name=\"m2\" value=\""+m2+"\">" );
//                  out.println( "<input type=\"hidden\" name=\"d1\" value=\""+d1+"\">" );
//                  out.println( "<input type=\"hidden\" name=\"d2\" value=\""+d2+"\">" );                  
                  out.println( "<input type=\"submit\" value=\"【保 存】\" name=\"com_ok\">" );
                  out.println("提示：仓库"+locid+",商品大类"+itemtype+",中心"+bascat+",产品系列"+mobtyp);
                  out.print("</form>");
          }
       }catch ( Exception e ){ 
            if ( db!= null ) db.Rollback(); 
            out.println( "运行出错："+e.toString());//
            
    }finally{ 
           if (db!= null ) db.Close(); 
    } 
%>
</body>
</html>