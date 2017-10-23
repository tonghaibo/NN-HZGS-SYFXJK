<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*,java.util.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>计划</title>
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
         String bascat = (String)session.getAttribute("bascat1");//卖场ID
         String mobtyp = EAFunc.NVL(request.getParameter("mobtyp"),"");//11常温，21低温1类，22低温2类
         String locid = EAFunc.NVL(request.getParameter("locid"),"");//仓库ID
         String brand = EAFunc.NVL(request.getParameter("brand"),"");//MN
         String itemtype = EAFunc.NVL(request.getParameter("itemtype"),"");//常低温
         String dat = EAFunc.NVL(request.getParameter("dat"),"");//按天录入时的日期
         String data = EAFunc.NVL(request.getParameter("data"),"");//构造表格的字符串
         String action = EAFunc.NVL(request.getParameter("action"),"");//action= save
         String y1 = EAFunc.NVL(request.getParameter("y1"),"");
         String y2 = EAFunc.NVL(request.getParameter("y2"),"");
         String m1 = EAFunc.NVL(request.getParameter("m1"),"");
         String m2 = EAFunc.NVL(request.getParameter("m2"),"");
         String d1 = EAFunc.NVL(request.getParameter("d1"),"");
         String d2 = EAFunc.NVL(request.getParameter("d2"),"");
         String date1 = y1+"-"+m1+"-"+d1;//起始日期
         String date2 = y2+"-"+m2+"-"+d2;//截至日期
         //out.print("locid"+locid);
          //out.print(date2);
         
      try{
           db = new EADatabase();
            
              if(action.equalsIgnoreCase("save")){
               
                   String[] itemlist = data.split("~n");
                   int n = 0;
                   String sItemguid = "";
                   String sPlanqty = "";
                   String sFlag = "";
                   
                    if(mobtyp.equalsIgnoreCase("11")){
                          if (itemlist.length > 1 ) {
                             sql3 = "select to_char(日期,'YYYY-MM-DD') dat2 from 日历 "//取出时间段内的所有日期
                                    +"where 日期>=to_date('"+date1+"','YYYY-MM-DD') "
                                    +"and 日期<=to_date('"+date2+"','YYYY-MM-DD') order by 日期";
                             ds2 = EADbTool.QuerySQL(sql3);
                             int cc = ds2.getRowCount();//判断时间段为几天
                                  for(int k = 0;k<cc;k++){//把所有日期插入到数据库
                                       for ( int i=1;i<itemlist.length;i++ ) {
                                                 n = i-1;
                                               String[] vl = itemlist[i].split(",");
                                               //itemguid,商品名称,数量,常低温
                                              //   0         1     2    3
                                                  sItemguid= vl[0];
                                                  sPlanqty = vl[2];
                                                  sFlag = vl[3];
                                                  int iPlanqty = Integer.parseInt(sPlanqty);
                                                  if(iPlanqty>0){
                                                  sql2 = "insert into wapplan ( item ,qty,CRTUSR,bascat,dat,sctype,flag,brand) "
                                                     +"values('"+sItemguid+"','"+sPlanqty+"','"+sUID+"' ,'"+bascat+"',to_date('"+ds2.getStringAt(k,"dat2")+"','yyyy-mm-dd'),'"+locid+"','"+sFlag+"','"+brand+"')";
                                                       // db.ExcecutSQL(sql2);
//                                                    String sql5 ="select count (distinct(item)) from wapplan"
//                                                                   +" where wapplan.dat >= to_date('"+date1+"','yyyy-mm-dd')"
//                                                                   +" wapplan.dat <= to_date('"+date2+"','yyyy-mm-dd')"
//                                                                   +" and wapplan.CRTUSR = '"+sUID+"'"
//                                                                   +" and wapplan.bascat like '"+bascat+"%'"
//                                                                   +" and wapplan.sctype='"+locid+"'" ; 
//                                                        String cnt = db.GetSQL(sql5);
//                                                            if(cnt!=null){
//                                                                     //out.print("执行成功，共录入了"+cnt+"个商品");
//                                                                     // db.Commit();
//                                                                  }else{
//                                                                    // out.print("执行失败，请重新操作！");
//                                                                     //db.Rollback();
//                                                              }
                                                      }
                                                 }                                                
                                            }
                                              //db.Commit();
                                              //out.print("执行成功");
                                       }  
                                  }else {
                          if (itemlist.length > 1 ) {
                                for ( int i=1;i<itemlist.length;i++ ) {
                                            n = i-1;
                                            String[] vl = itemlist[i].split(",");
                                            //itemguid,商品名称,数量,常低温
                                            //   0         1     2    3
                                           sItemguid= vl[0];
                                           sPlanqty = vl[2];
                                           sFlag = vl[3];
                                           int iPlanqty = Integer.parseInt(sPlanqty);
                                             if(iPlanqty>0){
                                                   sql2 = "insert into wapplan ( item ,qty,CRTUSR,bascat,dat,sctype,flag,brand) "
                                                    +"values('"+sItemguid+"',"+sPlanqty+",'"+sUID+"' ,'"+bascat+"',to_date('"+dat+"','yyyy-mm-dd'),'"+locid+"','"+sFlag+"','"+brand+"')";
                                                    db.ExcecutSQL(sql2);
                                                    sql4 = "select count (distinct(item)) from wapplan"
                                                           +" where wapplan.dat = to_date('"+dat+"','yyyy-mm-dd')"
                                                           +" and wapplan.CRTUSR = '"+sUID+"'"
                                                           +" and wapplan.bascat like '"+bascat+"%'"
                                                           +" and wapplan.sctype='"+locid+"'" ;
                                                    String cnt = db.GetSQL(sql4);
                                                        if(cnt!=null){
                                                             out.print("执行成功，共录入了"+cnt+"个商品");
                                                             //db.Commit();
                                                 }else{
                                                    out.print("执行失败，请重新操作！");
                                                    //db.Rollback();
                                             }
                                         }
                                      }
                                   }
                                }
                              }
      
      //out.print("ddddddd"+itemtype);
           if(mobtyp.equalsIgnoreCase("21")||mobtyp.equalsIgnoreCase("22")){
          // out.print("ddddddd");
               sql = "SELECT ITEM.guid itemguid,item.name itemname,"
                 +"NVL(wapplan.qty/untnum,'0') planqty,item.refid flag FROM wapplan,ITEM "
                 +"WHERE wapplan.ITEM(+)=ITEM.GUID and item.brand='MN' "
                 +"and item.refid = '2' and wapplan.dat(+) = to_date('"+dat+"','yyyy-mm-dd')"
                 +"and wapplan.sctype(+) ='"+locid+"' ";
              }
              else {
              //out.print("ddddddd"+itemtype);
                 sql = "SELECT ITEM.guid itemguid,item.name itemname,"
                 +"NVL(wapplan.qty/untnum,'0') planqty,item.refid flag FROM wapplan,ITEM "
                 +"WHERE wapplan.ITEM(+)=ITEM.GUID and item.brand='MN' "
                 +"and item.refid = '1' and wapplan.dat(+) >= to_date('"+date1+"','yyyy-mm-dd') "
                 +"and wapplan.dat(+) <= to_date('"+date2+"','yyyy-mm-dd') "
                 +"and wapplan.sctype(+) ='"+locid+"'";
              }
              //out.print(sql);
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
                 out.println( "<SINGLETABLE name=\"data\" width=\"100%\" height=\"90%\"  FIXEDROW=\"1\" FIXEDCOL=\"2\"" );
                 out.print("COLWIDTH=\"0,110,60,0\" COLEDITABLE=\"0,1,1,0\">");
                 out.print("编号,商品,数量,常低温");
                 out.print(newline);
                 for(int i = 0;i<c;i++){
                 itemguid = ds.getStringAt(i,"itemguid");
                 itemname = ds.getStringAt(i,"itemname");
                 planqty = ds.getStringAt(i,"planqty");
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
                  out.println( "<input type=\"submit\" value=\"【保 存】\" name=\"com_ok\">" );
                  out.print("</form>");
          }
       }catch ( Exception e ){ 
            if ( db!= null ) db.Rollback(); 
            //out.println( "运行出错：");//+e.toString()
            
    }finally{ 
           if (db!= null ) db.Close(); 
    } 
%>
</body>
</html>