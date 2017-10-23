<%@ page contentType="text/vnd.wap.wml;charset=gb2312" import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*,java.util.*"%>
<?xml version="1.0" encoding="gb2312"?> 
<!DOCTYPE wml PUBLIC "-//WAPFORUM//DTD WML 1.1//EN" "http://www.wapforum.org/DTD/wml_1.1.xml">
<%
    response.setHeader("Pragma","No-cache"); 
    response.setHeader("Cache-Control","no-cache"); 
    response.setDateHeader("Expires", 0);  
    EADatabase db=null; 
    String sItemList = "";
    String sItemEntry = "";
    String action = EAFunc.NVL(request.getParameter("action"),"");//action= save
    String type = EAFunc.NVL(request.getParameter("type"),"");
    String itemid = "";    
    String number = EAFunc.NVL(request.getParameter("number"),"");
    String itemidlist = EAFunc.NVL(request.getParameter("itemidlist"),""); 
    String valuelist = EAFunc.NVL(request.getParameter("valuelist"),"");     
    String y1 = EAFunc.NVL(request.getParameter("y1"),"");
    String m1 = EAFunc.NVL(request.getParameter("m1"),"");
    String d1 = EAFunc.NVL(request.getParameter("d1"),"");
    String daytime = y1+"-"+m1+"-"+d1;
    String _daytime = EAFunc.NVL(request.getParameter("daytime"),"");
    String curtime = y1+m1+d1;
    String _d = EAFunc.NVL(request.getParameter("_d"),"");
    //String _daytime = daytime;
    String days = EAFunc.NVL(request.getParameter("days"),"");
    String flag = EAFunc.NVL(request.getParameter("flag"),"");
    String brand = EAFunc.NVL(request.getParameter("brand"),"");
    String itemtype = EAFunc.NVL(request.getParameter("itemtype"),"1");
    String _date = EAFunc.NVL(request.getParameter("_date"),"");
    //String num = EAFunc.NVL(request.getParameter("num"),"");
    String bascat = (String)session.getAttribute("bascat1"+number);//条线
    //利乐包，利乐枕
    String bascal =  EAFunc.NVL(request.getParameter("bascal"),"");
    String bascal4 = EAFunc.NVL((String)session.getAttribute(bascal),"");
        //低温一类和低温二类
    String extcat8 = EAFunc.NVL(request.getParameter("extcat8"),"");
    String itemextcat8 =  EAFunc.NVL((String)session.getAttribute(extcat8),"");

    String sOnTime= "";
    String curdat = "";
    String sTemp = "";
    String sTemp1 = "";
    String sTemp2 = "";
    String locid = EAFunc.NVL(request.getParameter("locid"),"");

	String daycount = EAFunc.NVL(request.getParameter("daycount"),"");
    try
    { 
          EAUserinfo usrinfo = new MobileLogin().GetUsrinfo(request); 
          String sUID = "";
          if ( _d.length()>0 && curtime.length()>0)
          {
             if ( Double.parseDouble(curtime)!=Double.parseDouble(_d))
               throw new EAException("计划天数设置有误<br/><a href='main.jsp'>返回主页</a>");
          }
//          if ( days!="")
//          { 
//          int sDay = Integer.parseInt(days);
//          if ( sDay > 7)
//             throw new EAException("超过周计划天数，请返回<br/><a href='main.jsp'>返回主页</a>");
//          else if(sDay<7)
//             throw new EAException("小于周计划天数，请返回<br/><a href='main.jsp'>返回主页</a>");
//         }
          if ( usrinfo != null ) 
            sUID = usrinfo.getUsrid();
          else
            throw new EAException("你尚未登陆，或登陆超时，请返回重新登陆<br/><a href='logon.jsp'>重新登录</a>");
          db = new EADatabase (); 
          curdat = db.GetSQL("SELECT TO_CHAR(SYSDATE,'HH24MIss') FROM DUAL");
          SCInterceptor sc= new SCInterceptor();
          EAXmlDS ds2 = new EAXmlDS ();
          if ( action.equalsIgnoreCase("save")) 
          {//保存
            if ( itemidlist.length() > 0  )
            {
               int row = 0;
               String[] aItemidList = itemidlist.split(",");    
               String[] aValueList = valuelist.split(",");    
               if (aItemidList.length!=aValueList.length) 
                  throw new EAException ( "运行出错aItemidList.length("+aItemidList.length+")!=aValueList.length("+aValueList.length+")" );
               int nLength = aItemidList.length;
               for ( int n=0;n<nLength ;n++) 
               {
                  String str = aValueList[n];
                  String[] aValueItemList = str.split("~");                  
                  ds2.AddNullRow(ds2.getRowCount()-1);
                  ds2.setValueAt(n,"itemid",aItemidList[n]);
                  int p = aValueItemList.length;
                  for ( int m=0;m<p;m++ ) 
                  { 
                   // int mm = m/2;
                   // if ( m%2 == 0 ) 
                      //ds2.setValueAt(n,"QTY_"+(mm+1),aValueItemList[mm*2]);
                    //else 
                     // ds2.setValueAt(n,"QTY_"+(mm+1),aValueItemList[mm*2+1]);    
                     ds2.setValueAt(n,"QTY_"+(m+1),aValueItemList[m]);
                  }                 
               }
               String xml = ds2.GetXml();
               if ( days != "" || days.length()>0)
               {
                    int _days = Integer.parseInt(days);
                    //int ret = sc.savePlan(db,sUID,"",xml,bascat,_daytime,_days);//按一段时间录入，需要overwrite这个方法
                    
///////////////////////////////////////---------------------------按一段时间录
int nStartCol = 1;  //QTY_x 从第2列开始    
//      String s = "delete from wapplan where dat=to_date('"+_daytime+"','yyyy-mm-dd') ";
//      int p =   db.ExcecutSQL(s);
    EAXmlDS ds = new EAXmlDS(xml);    
    EAXmlDS sctypds = db.QuerySQL("select id,name from v_loc where org='SHMN' and id>'0'");
    //以前库位的
//    int nScCount =  sctypds.getRowCount();
//    String sql = "";
//    String[] a_sctyp = new String[nScCount];
//    for ( int j=0;j<nScCount;j++ )
//    {
//      a_sctyp[j]=sctypds.getStringAt(j,"ID");
//    }
    int nRet = 0 ;
    int cnt = ds.getRowCount();
    String sUntnum = "";
    String sItemGUID = "";   
    String sql = "";
    for ( int i=0;i<cnt;i++)
    {
      String sItemid = ds.getStringAt(i,"ITEMID");
      if (ds.getColumnLoc("ITEMGUID") >=0 ) 
      {
        sUntnum = ds.getStringAt(i,"UNTNUM");
        sItemGUID = ds.getStringAt(i,"ITEMGUID");
      }
      else  {
        sql = "SELECT GUID,UNTNUM FROM ITEM WHERE ID='"+sItemid+"'";
        EAXmlDS itemds = db.QuerySQL(sql);
        if( itemds.getRowCount()==0 ) { // 可能是促销商品
          throw new EAException ( "商品"+sItemid+"不存在" );
        }
        sUntnum = itemds.getStringAt(0,"UNTNUM");
        sItemGUID = itemds.getStringAt(0,"GUID");
      }
      
//      for ( int j=0;j<nScCount;j++ )
//      {
//        String sScid = a_sctyp[j];// sctypds.getStringAt(j,"ID");
        String sQty = "0";
        String sQEX = "0";        
        sQty = ds.getStringDef(i,"QTY_"+"1","");// 默认值不能为0, 因为有可能留空来判断是大单位\还是小单位
        if ( sQty != "")
        {
        
//         if ( itemtype.equalsIgnoreCase("1"))
//          sQty = Integer.parseInt(sQty)/10+"";
//          else if ()
//          sQty = Integer.parseInt(sQty)/7+"";
            sQty =  Integer.parseInt(sQty)/_days+"";
          
        }
       // sQEX = ds.getStringDef(i,"QEX_"+sScid,"");
        //nRet += updatePlan(db,sItemGUID,sScid,sQty,sUntnum,usrid,bascat,dat,days,flag);
    Calendar ca = Calendar.getInstance();
    ca.set(Integer.parseInt(y1),Integer.parseInt(m1)-1,Integer.parseInt(d1));
    ca.add(Calendar.DATE,_days-1);
    String yea = (ca.getTime().getYear()+1900)+"";
    String mont = (ca.getTime().getMonth()+1)+"";
    String da = ca.getTime().getDate()+"";
    String _da = yea+"-"+mont+"-"+da;
     sql = "select guid from wapplan where sctype='"+locid+"' and " +//需要用财务单位
                  "item='"+sItemGUID+"'  and "+
                  "crtusr='"+sUID+"' and dat>=to_date('"+_daytime+"','yyyy-mm-dd') "+
                  " and dat<= to_date('"+_da+"','yyyy-mm-dd') "+
                  "and bascat like '"+bascat+"%' and flag='2'";
      String locguid = "";
      String sGuid = "";//取出商品在wapplan表中对应的guid
      ArrayList al  = null;
       EAXmlDS sqlds = null;
      try 
      {
        for ( int b=0;b<_days;b++)
        {
             //sGuid = db.GetSQL(sql);
             sGuid += db.QuerySQL(sql).getStringAt(b,"guid")+",";
             //if ( sGuid.length() == 0 ) break;
        }

      }
      catch ( EAException e )
      { // 记录已存在，不用做任何事   
      }
      String str = "";
        if ( sQty.length() == 0 ) 
          {
           sQty = "0";
           str = sQty;
         }
         else if ( sQty.length() > 0 ) 
            str = sQty+"*"+sUntnum;
      String _sguid[] = sGuid.split(",");

      if ( sGuid.length() > 0 ) 
      {// 更新
      for(int c=0;c<_sguid.length;c++)
      {
          if ( _sguid[c].length()>0)
          {
          sql = "update wapplan set qty="+str+" where guid='"+_sguid[c]+"'";  
          db.ExcecutSQL(sql);
          nRet ++;
          
          }
//          else
//          {
//          sql = "insert into wapplan ( item ,qty,CRTUSR,bascat,dat,sctype,flag) values('"+_sguid[c]+"',"+str+",'"+sUID+"' ,'"+bascat+"',to_date('"+_da+"','yyyy-mm-dd'),'"+sScid+"','2') ";
//           db.ExcecutSQL(sql);
//          }
      }
//        sql = "update curord set qty="+str+" where guid='"+sGuid+"'";          
//        db.ExcecutSQL(sql);
//        nRet ++;
      }
      else
      {    // 插入
        // 如果不存在记录，并且整包数量 零包数量为0       
        if(    (sQty.length()==0||sQty.equals("0"))){     
        }
       else
      {
          Calendar cal = Calendar.getInstance();
          String _date1[] = _daytime.split("-");                 
          for ( int m=0;m<_days;m++)
          {    
             cal.set(Integer.parseInt(_date1[0]),Integer.parseInt(_date1[1])-1,Integer.parseInt(_date1[2]));//此处月份要减1       
             cal.add(Calendar.DATE,m);          
             String year = (cal.getTime().getYear()+1900)+"";
             String month = (cal.getTime().getMonth()+1)+"";//此处月份要加1
             String date = cal.getTime().getDate()+"";
             String _dat = year+"-"+month+"-"+date;        
             sql = "insert into wapplan ( item ,qty,CRTUSR,bascat,dat,sctype,flag,brand) values('"+sItemGUID+"',"+str+",'"+sUID+"' ,'"+bascat+"',to_date('"+_dat+"','yyyy-mm-dd'),'"+locid+"','2','"+brand+"') ";
             db.ExcecutSQL(sql);
             cal = Calendar.getInstance();
             nRet++;
          }
        }
      }   
//      }
    }// End Loop
//////////////////////////////////////-----------------------------按一段时间录
                 
               }
               else
               {
                    //int ret = sc.savePlan(db,sUID,"",xml,bascat,_date);////
///////////////////////////////////---------------------按天录
    int nStartCol = 1;  //QTY_x 从第2列开始    
    EAXmlDS ds = new EAXmlDS(xml);    
    //EAXmlDS sctypds = db.QuerySQL("select id,name from v_sctype order by id");
//    EAXmlDS sctypds = db.QuerySQL("select id,name from v_loc where org='SHMN'");
//    int nScCount =  sctypds.getRowCount();
//    String sql = "";
//    String[] a_sctyp = new String[nScCount];
//    for ( int j=0;j<nScCount;j++ )
//    {
//      a_sctyp[j]=sctypds.getStringAt(j,"ID");
//    }
String sql = "";
    int nRet = 0 ;
    int cnt = ds.getRowCount();
    String sUntnum = "";
    String sItemGUID = "";   
    for ( int i=0;i<cnt;i++)
    {
      String sItemid = ds.getStringAt(i,"ITEMID");
      if (ds.getColumnLoc("ITEMGUID") >=0 ) 
      {
        sUntnum = ds.getStringAt(i,"UNTNUM");
        sItemGUID = ds.getStringAt(i,"ITEMGUID");
      }
      else  {
        sql = "SELECT GUID,UNTNUM FROM ITEM WHERE ID='"+sItemid+"'";
        EAXmlDS itemds = db.QuerySQL(sql);
        if( itemds.getRowCount()==0 ) { // 可能是促销商品
          throw new EAException ( "商品"+sItemid+"不存在" );
        }
        sUntnum = itemds.getStringAt(0,"UNTNUM");
        sItemGUID = itemds.getStringAt(0,"GUID");
      }
      
//      for ( int j=0;j<nScCount;j++ )
//      {
//        String sScid = a_sctyp[j];// sctypds.getStringAt(j,"ID");
        String sQty = "0";
        String sQEX = "0";        
        sQty = ds.getStringDef(i,"QTY_"+"1","");// 默认值不能为0, 因为有可能留空来判断是大单位\还是小单位
        //sQEX = ds.getStringDef(i,"QEX_"+sScid,"");
        //nRet += updatePlan(db,sItemGUID,sScid,sQty,sUntnum,usrid,bascat,dat,flag);
        sql = "select guid from wapplan where sctype='"+locid+"' and " + //需要用财务单位
                  "item='"+sItemGUID+"'  and "+
                  "crtusr='"+sUID+"' and dat=to_date('"+_date+"','yyyy-mm-dd')"+
                  "and bascat like '"+bascat+"%'";
      String locguid = "";
      String sGuid = "";//取出商品在wapplan表中对应的guid
      try 
      {
        sGuid = db.GetSQL(sql);
      }
      catch ( EAException e )
      { // 记录已存在，不用做任何事   
      }
      String str = "";
      int flg = 1;
//      if ( flg == 1 ) 
//      {
        if ( sQty.length() == 0 ) 
          sQty = "0";
        str = sQty;
        
//      }
//      else
//      {
          if ( sQty.length() > 0 ) 
            str = sQty+"*"+sUntnum;
//      }
      if ( sGuid.length() > 0 ) 
      {// 更新
        sql = "update wapplan set qty="+str+" where guid='"+sGuid+"'";
        try{
        db.ExcecutSQL(sql);
        }
        catch(EAException e){}
        nRet ++;
      }
      else
      {    // 插入
        // 如果不存在记录，并且整包数量 零包数量为0       
        if(    (sQty.length()==0||sQty.equals("0")))
        {          
        }
       else
      {
          sql = "insert into wapplan ( item ,qty,CRTUSR,bascat,dat ,sctype,flag,brand) values('"+sItemGUID+"',"+str+",'"+sUID+"' ,'"+bascat+"',to_date('"+_date+"','yyyy-mm-dd'),'"+locid+"','1','"+brand+"') ";
          db.ExcecutSQL(sql);
          nRet++;
        }
      }   
 // }
      }  
///////////////////////////////////---------------------按天录                    
                    
               }
             }
           String sql="select count(distinct wapplan.item) from wapplan,item "+
                      "where wapplan.item=item.guid and wapplan.qty<>'0' and "+
                      "item.refid='"+itemtype+"' "+
                      "and item.brand='"+brand+"' and wapplan.bascat='"+bascat+"' and wapplan.sctype='"+locid+"'";
		    if ( bascal4.length() > 0 ) sql += " and item.bascal4 like '"+bascal4+"%'";
 if (itemextcat8.length() > 0 ) sql += "and item.extcat8 like '"+itemextcat8+"%' ";
            if ( flag.equalsIgnoreCase("day"))
            {
                sql += " and wapplan.dat=to_date('"+_date+"','yyyy-mm-dd')";
            }
            else
            {
              
            
            }
           String cnt = db.GetSQL(sql);
           db.Commit();

             sItemList+="操作成功,到目前共录入了"+cnt+"个";
             sItemList+="商品<br/>";//,页面在1秒后自动跳转
             //sItemList += "<a href=\"planByDay.jsp?flag="+flag+"&amp;brand="+brand+"&amp;itemtype="+itemtype+"&amp;number="+number+"&amp;bascal="+bascal+"&amp;locid="+locid+"\">返回</a><br/>";
             sItemList += "<a href=\"checkType.jsp?number="+number+"&amp;locid="+locid+"&amp;type="+type+"\">返回</a><br/>";

          }
          else
          {
              // 查询
              EAXmlDS ds = null;
              if ( flag.equalsIgnoreCase("day") ){
             // ds = sc.GetCorpItemWithPlan(db,itemtype,"",brand,sUID,bascat,_date,bascal4);//sc.GetCorpItemWithWapINV(db,itemtype,"",sUID);
////////////////////////////////////////按天      
     if ( itemtype== null ) itemtype = "";
      if ( itemid== null ) itemid = "";
      String sql = "";
      sql = " SELECT ITEM.SORTID 顺序号,ITEM.NAME 商品名称,ITEM.SPEC 规格,"+
            " 0 QTY_1,ITEM.UNIT unit1 ,0 QEX_1 ,ITEM.SMLUNT smlunt1 ,"+
            " 0 QTY_2,ITEM.UNIT unit2 ,0 QEX_2 ,ITEM.SMLUNT smlunt2 ,"+
            " 0 QTY_3,ITEM.UNIT unit3 ,0 QEX_3 ,ITEM.SMLUNT smlunt3 ,"+
            " 0 QTY_4,ITEM.UNIT unit4 ,0 QEX_4 ,ITEM.SMLUNT smlunt4 ,"+
            " 0 QTY_5,ITEM.UNIT unit5 ,0 QEX_5 ,ITEM.SMLUNT smlunt5 ,"+
            " 0 QTY_6,ITEM.UNIT unit6 ,0 QEX_6 ,ITEM.SMLUNT smlunt6 , "+
            " ITEM.ID 商品编号,ITEM.GUID ITEMGUID,ITEM.UNTNUM UNTNUM,"+
            " DECODE(ITEM.REFID,'1','常温','2','低温','其他') 大类,ITEM.BASCAT2 系列, substrb(ITEM.SHTNAM,1,12) as 商品简称 "+//, FLAG2 as 大小单位标志 " +
            " FROM fiitem item ,item b "+   
            " WHERE "+
            " item.refid like '"+itemtype+"%' and item.brand='"+brand+"' and item.guid=b.guid and b.useflg='1'";
      if ( itemid.length() > 0 ) 
          sql += "and item.id='"+itemid+"' ";
	  if ( bascal4.length() > 0 )
          sql += "and b.bascal4 like '"+bascal4+"%' ";
if ( itemextcat8.length() > 0 )
         sql += "and b.extcat8 like '"+itemextcat8+"%' ";
         // System.out.println("sql="+""+sql);
      sql+=" order by ITEM.REFID,NVL(ITEM.SORTID,99999999),ITEM.id ";
      ds = db.QuerySQL(sql);
      HashMap map = ds.GetHashMap("商品编号");
            sql = "SELECT ITEM.ID ITEMID,"+
            "NVL(wapplan.qty/untnum,0) 数量 FROM wapplan,ITEM "+
            "WHERE "+
            "wapplan.ITEM(+)=ITEM.GUID and item.brand='"+brand+"' and wapplan.CRTUSR like '"+sUID+"%' "+
            " and wapplan.bascat like '"+bascat+"%'  and wapplan.dat = to_date('"+_date+"','yyyy-mm-dd') "+
            "and wapplan.sctype='"+locid+"'";
			//System.out.println("sql="+sql);
      EAXmlDS curordds = db.QuerySQL(sql );
      for ( int n =0;n<curordds.getRowCount();n++ ) {
           // String sSCType = curordds.getStringAt(n,"SCTYPE");
            String sMyItemid = curordds.getStringAt(n,"ITEMID");
            Object o =map.get(sMyItemid);
            if ( o!= null ) {
              int i = Integer.parseInt( ""+ o);
//              ds.setValueAt(i,"QTY_"+sSCType,curordds.getStringAt(n,"整包数量") );
//              ds.setValueAt(i,"QEX_"+sSCType,curordds.getStringAt(n,"零包数量") );
                ds.setValueAt(i,"QTY_"+"1",curordds.getStringAt(n,"数量") );
             // ds.setValueAt(i,"QEX_"+sSCType,curordds.getStringAt(n,"零包数量") );
            }            
      }
////////////////////////////////////////按天}  
              }else if ( flag.equalsIgnoreCase("time")){
              //ds = sc.GetCorpItemWithPlan(db,itemtype,"",brand,sUID,bascat,_daytime,bascal4);
////////////////////////////////////////按一段时间 {    

     if ( itemtype== null ) itemtype = "";
      if ( itemid== null ) itemid = "";
      String sql = "";
      sql = " SELECT ITEM.SORTID 顺序号,ITEM.NAME 商品名称,ITEM.SPEC 规格,"+
            " 0 QTY_1,ITEM.UNIT unit1 ,0 QEX_1 ,ITEM.SMLUNT smlunt1 ,"+
            " 0 QTY_2,ITEM.UNIT unit2 ,0 QEX_2 ,ITEM.SMLUNT smlunt2 ,"+
            " 0 QTY_3,ITEM.UNIT unit3 ,0 QEX_3 ,ITEM.SMLUNT smlunt3 ,"+
            " 0 QTY_4,ITEM.UNIT unit4 ,0 QEX_4 ,ITEM.SMLUNT smlunt4 ,"+
            " 0 QTY_5,ITEM.UNIT unit5 ,0 QEX_5 ,ITEM.SMLUNT smlunt5 ,"+
            " 0 QTY_6,ITEM.UNIT unit6 ,0 QEX_6 ,ITEM.SMLUNT smlunt6 , "+
            " ITEM.ID 商品编号,ITEM.GUID ITEMGUID,ITEM.UNTNUM UNTNUM,"+
            " DECODE(ITEM.REFID,'1','常温','2','低温','其他') 大类,ITEM.BASCAT2 系列, substrb(ITEM.SHTNAM,1,12) as 商品简称 "+//, FLAG2 as 大小单位标志 " +
            " FROM fiitem item ,item b "+   
            " WHERE "+
            " item.refid like '"+itemtype+"%' and item.brand='"+brand+"' and item.guid=b.guid ";
      if ( itemid.length() > 0 ) 
          sql += "and item.id='"+itemid+"' ";
	  if ( bascal4.length() > 0 )
          sql += "and b.bascal4 like '"+bascal4+"%' ";
if ( itemextcat8.length() > 0 )
         sql += "and b.extcat8 like '"+itemextcat8+"%' ";
      sql+=" order by ITEM.REFID,NVL(ITEM.SORTID,99999999),ITEM.id ";
       ds = db.QuerySQL(sql);
       
    Calendar ca2 = Calendar.getInstance();
    ca2.set(Integer.parseInt(y1),Integer.parseInt(m1)-1,Integer.parseInt(d1));
    ca2.add(Calendar.DATE,Integer.parseInt(days)-1);
    String yea2 = (ca2.getTime().getYear()+1900)+"";
    String mont2 = (ca2.getTime().getMonth()+1)+"";
    String da2 = ca2.getTime().getDate()+"";
    String _da2 = yea2+"-"+mont2+"-"+da2;
    HashMap map = ds.GetHashMap("商品编号");
            sql = "SELECT ITEM.ID ITEMID,"+
            "NVL(wapplan.qty/untnum,0) 数量 FROM wapplan,ITEM "+
            "WHERE "+
            "wapplan.ITEM(+)=ITEM.GUID and item.brand='"+brand+"' and wapplan.CRTUSR like '"+sUID+"%' "+
            " and wapplan.bascat like '"+bascat+"%'  and wapplan.dat >= to_date('"+daytime+"','yyyy-mm-dd') "+
            " and wapplan.dat<=to_date('"+_da2+"','yyyy-mm-dd') and wapplan.sctype='"+locid+"'";
      EAXmlDS curordds = db.QuerySQL(sql );
      for ( int n =0;n<curordds.getRowCount();n++ ) {
            //String sSCType = curordds.getStringAt(n,"SCTYPE");
            String sMyItemid = curordds.getStringAt(n,"ITEMID");
            Object o =map.get(sMyItemid);
            if ( o!= null ) {
              int i = Integer.parseInt( ""+ o);
//              ds.setValueAt(i,"QTY_"+sSCType,curordds.getStringAt(n,"整包数量") );
//              ds.setValueAt(i,"QEX_"+sSCType,curordds.getStringAt(n,"零包数量") );
                if ( itemtype.equalsIgnoreCase("1"))
                ds.setValueAt(i,"QTY_"+"1",curordds.getStringAt(n,"数量")+"" );
                else
                ds.setValueAt(i,"QTY_"+"1",curordds.getStringAt(n,"数量")+"" );
             // ds.setValueAt(i,"QEX_"+sSCType,curordds.getStringAt(n,"零包数量") );
            }            
      }
////////////////////////////////////////按一段时间 }  
              }
              else
              {
                 if ( itemtype== null ) itemtype = "";
                 if ( itemid== null ) itemid = "";
                 String sql = "";
                sql = " SELECT ITEM.SORTID 顺序号,ITEM.NAME 商品名称,ITEM.SPEC 规格,"+
                      " 0 QTY_1,ITEM.UNIT unit1 ,0 QEX_1 ,ITEM.SMLUNT smlunt1 ,"+
                      " 0 QTY_2,ITEM.UNIT unit2 ,0 QEX_2 ,ITEM.SMLUNT smlunt2 ,"+
                      " 0 QTY_3,ITEM.UNIT unit3 ,0 QEX_3 ,ITEM.SMLUNT smlunt3 ,"+
                      " 0 QTY_4,ITEM.UNIT unit4 ,0 QEX_4 ,ITEM.SMLUNT smlunt4 ,"+
                      " 0 QTY_5,ITEM.UNIT unit5 ,0 QEX_5 ,ITEM.SMLUNT smlunt5 ,"+
                      " 0 QTY_6,ITEM.UNIT unit6 ,0 QEX_6 ,ITEM.SMLUNT smlunt6 , "+
                      " ITEM.ID 商品编号,ITEM.GUID ITEMGUID,ITEM.UNTNUM UNTNUM,"+
                      " DECODE(ITEM.REFID,'1','常温','2','低温','其他') 大类,ITEM.BASCAT2 系列, substrb(ITEM.SHTNAM,1,12) as 商品简称 "+//, FLAG2 as 大小单位标志 " +
                      " FROM fiitem item ,item b "+   
                      " WHERE "+
                      " item.refid like '"+itemtype+"%' and item.brand='"+brand+"' and item.guid=b.guid ";
                      if ( itemid.length() > 0 ) 
                            sql += "and item.id='"+itemid+"' ";
                      if ( bascal4.length() > 0 )
                            sql += "and b.bascal4 like '"+bascal4+"%' ";
  if ( itemextcat8.length() > 0 )
         sql += "and b.extcat8 like '"+itemextcat8+"%' ";
                        sql+=" order by ITEM.REFID,NVL(ITEM.SORTID,99999999),ITEM.id ";
                         ds = db.QuerySQL(sql);
                         
                      Calendar ca3 = Calendar.getInstance();
                      ca3.set(Integer.parseInt(y1),Integer.parseInt(m1)-1,Integer.parseInt(d1));
                      ca3.add(Calendar.DATE,Integer.parseInt(days)-1);
                      String yea2 = (ca3.getTime().getYear()+1900)+"";
                      String mont2 = (ca3.getTime().getMonth()+1)+"";
                      String da2 = ca3.getTime().getDate()+"";
                      String _da2 = yea2+"-"+mont2+"-"+da2;
                      HashMap map = ds.GetHashMap("商品编号");
                      sql = "SELECT ITEM.ID ITEMID,"+
                      "NVL(wapplan.qty/untnum,0) 数量 FROM wapplan,ITEM "+
                      "WHERE "+
                      "wapplan.ITEM(+)=ITEM.GUID and item.brand='"+brand+"' and wapplan.CRTUSR like '"+sUID+"%' "+
                      " and wapplan.bascat like '"+bascat+"%'  and wapplan.dat >= to_date('"+daytime+"','yyyy-mm-dd') "+
                      " and wapplan.dat<=to_date('"+_da2+"','yyyy-mm-dd') and wapplan.sctype='"+locid+"'";
                      EAXmlDS curordds = db.QuerySQL(sql );
                        for ( int n =0;n<curordds.getRowCount();n++ ) 
                        {
                              String sMyItemid = curordds.getStringAt(n,"ITEMID");
                              Object o =map.get(sMyItemid);
                              if ( o!= null ) {
                              int i = Integer.parseInt( ""+ o);
                             // if ( itemtype.equalsIgnoreCase("1"))
                                ds.setValueAt(i,"QTY_"+"1",Integer.parseInt(curordds.getStringAt(n,"数量"))*Integer.parseInt(days)+"" );
//                              else
//                                ds.setValueAt(i,"QTY_"+"1",Integer.parseInt(curordds.getStringAt(n,"数量"))*7+"" );
                              }            
                        }                               
              }
              int cc = ds.getRowCount();
              for ( int i=0;i<cc;i++) 
              {
                  String untnum = ds.getStringAt(i,"UNTNUM");  
                 // String untflg = ds.getStringAt(i,"大小单位标志");  
                  int flag1 = 1;  
                  int flag2 = 1;  
                  //int flag2 = Integer.parseInt(ds.getStringDef(i,"SCTYPE","0"));
                  if ( untnum.equals("1") ) 
                    flag2 = 1;
                  //else if ( untflg.equals("0") ) 
                   // flag2 = 2;                   
                  // 因为不可能大小单位共存，所以QEX是小单位的数量，而不是零头的数量
                  String[] qty={"","","",""};
                  String[] qex={"","","",""};
                  for ( int nn=0;nn<4; nn++ )
                  {   
//                     if ( flag2 ==1 ) qty[nn] = ds.getStringDef(i,"QTY_"+(nn+1),"");
//                     else if ( flag2 == 2 ) qty[nn] = ds.getStringDef(i,"QTY_"+(nn+1),"");
//                     else if (flag2 == 3) qty[nn] = ds.getStringDef(i,"QTY_"+(nn+1),"");
                     
                    if ( nn== 3 && flag1==0 )continue;
                    if ( flag2 == 1 ) {// 只录入大单位(untnum=1)
                       qty[nn] = ds.getStringDef(i,"QTY_"+(nn+1),"");              
                       if( qty[nn].equals("0") ) qty[nn]="";
                   }  
                    else if ( flag2 == 2 && nn== 0)
                    {// 销售,录入大单位
                       qty[nn] = ds.getStringDef(i,"QTY_"+(nn+1),"");    
                       if( qty[nn].equals("0") ) qty[nn]="";
                    }

                }
                
                       ///之前未变单位的
//                  sTemp += "<setvar name=\"ITEM"+ ds.getStringAt(i,"商品编号") +"\" value=\""+
//                            qty[0]+"~"+qex[0]+"~"+
//                            qty[1]+"~"+qex[1]+"~"+
//                            qty[2]+"~"+qex[2]+"~"+
//                            qty[3]+"~"+qex[3]+ "\"/>\n";         
                  sTemp += "<setvar name=\"ITEM"+ ds.getStringAt(i,"商品编号") +"\" value=\""+
                            qty[0]+"~"+
                            qty[1]+"~"+
                            qty[2]+"~"+//"\"/>\n";
                            qty[3]+"\"/>\n";  
                if ( i!=0) sTemp1+=",";
                sTemp1+= ds.getStringAt(i,"商品编号");
                if ( i!=0) sTemp2+=",";
                //sTemp2+= qty[0]+"~"+qex[0]+"~"+ qty[1]+"~"+qex[1]+"~"+ qty[2]+"~"+qex[2]+"~"+ qty[3]+"~"+qex[3];
                sTemp2+= qty[0]+"~"+ qty[1]+"~"+ qty[2]+"~"+ qty[3];
                sItemList += "<anchor>"+ds.getStringAt(i,"商品简称")+"<go href=\"itementry1.wmls#entry('"+
                  ds.getStringAt(i,"商品编号")+"','"+ds.getStringAt(i,"商品名称")+"','"+
                  //ds.getStringAt(i,"UNIT1")+"','"+ds.getStringAt(i,"SMLUNT1")+"','"+
                  ds.getStringAt(i,"UNIT1") +"','"+flag2+"')\"/>\n</anchor><br/>"; 

              }
              //////此处要有判断，判断是按天录，还是按周期录
              sItemList += "<br/><anchor>全部一次提交";
              sItemList += "<go href=\"planEnter.jsp\" method=\"post\">";
              sItemList += "<postfield name=\"action\" value=\"save\"/>";
              sItemList += "<postfield name=\"itemidlist\" value=\"$(ITEMIDLIST)\"/>";
              sItemList += "<postfield name=\"valuelist\" value=\"$(VALUELIST)\"/>";
              sItemList += "<postfield name=\"itemtype\" value=\""+itemtype+"\"/>";
              sItemList += "<postfield name=\"curdat\" value=\""+curdat+"\"/>";
              sItemList += "<postfield name=\"brand\" value=\""+brand+"\"/>";
              sItemList += "<postfield name=\"flag\" value=\""+flag+"\"/>";
              sItemList += "<postfield name=\"number\" value=\""+number+"\"/>";
              sItemList += "<postfield name=\"bascal\" value=\""+bascal+"\"/>";
              sItemList += "<postfield name=\"locid\" value=\""+locid+"\"/>";
              sItemList += "<postfield name=\"type\" value=\""+type+"\"/>";
              sItemList += "<postfield name=\"extcat8\" value=\""+extcat8+"\"/>";
              sItemList += "<postfield name=\"daycount\" value=\""+daycount+"\"/>";
              if ( flag.equalsIgnoreCase("day"))
              {
                  sItemList += "<postfield name=\"_date\" value=\""+_date+"\"/>";
              }
              else
              {
                  sItemList += "<postfield name=\"days\" value=\""+days+"\"/>";
                  sItemList += "<postfield name=\"y1\" value=\""+y1+"\"/>";
                  sItemList += "<postfield name=\"d1\" value=\""+d1+"\"/>";
                  sItemList += "<postfield name=\"m1\" value=\""+m1+"\"/>";
                  sItemList += "<postfield name=\"daytime\" value=\""+daytime+"\"/>";                             
              }
              sItemList += "</go>";
              sItemList += "</anchor><br/>";    
              if ( flag.equalsIgnoreCase("day"))
              {
              sItemList += "<a href=\"planByDay.jsp?brand="+brand+"&amp;itemtype="+itemtype+"&amp;flag="+flag+"&amp;number="+number+"&amp;locid="+locid+"&amp;type="+type+"&amp;bascal="+bascal+"&amp;extcat8="+extcat8+"\">返回日期选择</a><br/>";
              
              }
              else
              {             
                sItemList += "<a href=\"plan.jsp?brand="+brand+"&amp;itemtype="+itemtype+"&amp;number="+number+"&amp;locid="+locid+"&amp;type="+type+"&amp;bascal="+bascal+"&amp;extcat8="+extcat8+"\">返回</a><br/>";
              }
              sItemList += "<a href=\"logon.jsp\">重新登录</a><br/>";
         }
    } 
    catch ( Exception e ) 
    { 
            if ( db!= null ) db.Rollback(); 
            sItemList = "运行出错："+e.toString();
    } 
    finally
    { 
           if (db!= null ) db.Close();     
    } 

%>
<wml>
<head>
<meta forua="true" http-equiv="Cache-Control" content="max-age=-1"/>
</head>
<card id="itemlist" title="商品清单" >
<onevent type="onenterforward" >
  <refresh>
      <%=sTemp%><setvar name="ITEMIDLIST" value="<%=sTemp1%>"/><setvar name="VALUELIST" value="<%=sTemp2%>"/>
  </refresh>
</onevent>
<p align="center"><%=sItemList%><br/>
</p>
</card>

<%    // 生成3种情况的card
//int f1[]= {0,0,0,1,1,1}; // =0  没品尝 =1 有品尝 
int f2[]= {1,2,3}; //意思是分3个库


//for( int n=0;n<f2.length;n++ ) {  // 6个组合
  //out.println( "<card id=\"card"+f2[n]+"\" newcontext=\"false\">" );
  out.println( "<card id=\"card1\" newcontext=\"false\">" );
  out.println( "<p align=\"center\">" );
  String locname[] = {"数量","2号库","3号库"};
  for ( int i=0;i<1; i++ ) {
   // if ( i== 3 && f1[n]==0 )continue;
//    if ( f2[n] == 1 )
//    {
      out.println("$(THISNAME)<br/>"+"$(THISUNIT)"+locname[i]+"<input type=\"text\" name=\"QTY"+(i+1)+"\" format=\"*N\" size=\"4\" /><br/>");
//    }
//   else if ( f2[n] == 2 && i== 0)
//    {
//        out.println("$(THISNAME)<br/>"+locname[i]+"$(THISUNIT)数<input type=\"text\" name=\"QTY"+(i+1)+"\" format=\"*N\" size=\"4\" /><br/>");
//    }
//    else 
//    {
//        out.println("$(THISNAME)<br/>"+locname[i]+"$(THISSMLUNT)数<input type=\"text\" name=\"QEX"+(i+1)+"\" format=\"*N\" size=\"4\" /><br/>");    
//    }
} 
  out.println( "<br/><anchor>返回<go href=\"itementry1.wmls#gobak()\"/></anchor>" );
  out.println( "<br/></p></card>" );
//} 
%>
</wml>