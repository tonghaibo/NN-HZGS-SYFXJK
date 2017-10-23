<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*,java.util.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>商品录入</title>
</head>
<body>

<%
    String NOEDITFLAG = "*";// 不可修改的显示标志，如果数据不可录入，显示这个字符串
    EADatabase db=null; 
    String sItemList = "";
    String sItemEntry = "";
    String action = EAFunc.NVL(request.getParameter("action"),"");//action= save
    String itemid = "";
    String pageno = EAFunc.NVL(request.getParameter("showpage"),"");
    String corpid = EAFunc.NVL(request.getParameter("corpid"),"");
    String brand = EAFunc.NVL(request.getParameter("brand"),""); 
    String itemtype = EAFunc.NVL(request.getParameter("itemtype"),"1");
    String itemidlist = EAFunc.NVL(request.getParameter("itemidlist"),"");
    String valuelist = EAFunc.NVL(request.getParameter("valuelist"),"");
    String mobtyp = EAFunc.NVL(request.getParameter("mobtyp"),"");	// 手机报单商品分类
    String corpsoid = EAFunc.NVL(request.getParameter("corpsoid"),"");	// 订单号
    String subtyp = EAFunc.NVL(request.getParameter("subtyp"),"1");	// 录入方式：=1 连锁 2 卖场 =3 社区
    
    String data = EAFunc.NVL(request.getParameter("data"),"");	// 提交的数据
    
    String sOnTime= "";
    String curdat = "";
    String sTemp = "";
    String sTemp1 = "";
    String sTemp2 = "";
    //String sUID = (String)session.getAttribute("sUID");
    String sUID = "";
     String TIME =  EAFunc.NVL(request.getParameter("curdat"),"");

 //手机 报单商品分类
    String bascal =  EAFunc.NVL(request.getParameter("bascal"),"");
    String bascal4 = EAFunc.NVL((String)session.getAttribute(bascal),"");
//out.print("sssss"+bascal);
    String katype =  EAFunc.NVL(request.getParameter("katype"),"");


    try
    { 
          //EAUserinfo usrinfo = new MobileLogin().GetUsrinfo(request); 
          EAUserinfo usrinfo = EASession.GetLoginInfo(request);
          
          if ( usrinfo != null ) 
            sUID = usrinfo.getUsrid();
          else
            throw new EAException("你尚未登陆，或登陆超时，请返回重新登陆<br/><a href='j2melogin.jsp'>重新登录</a>");
          db = new EADatabase (); 
          curdat = db.GetSQL("select to_char(sysdate,'hh24miss') dat from dual");


          String t1 = "170000";
          String t2 = "180000";
          String bascatnote = db.GetSQL("select b.note from corp a ,v_corpbascat1 b where a.bascat1=b.id and a.id='"+corpid+"'");
          String timesql = "select * from param where typ='MOBILETIME' ";
          if ( bascatnote.equalsIgnoreCase("A"))
            {
               timesql += " and id in ('STARTA','ENDA') ";
            }
            else if (bascatnote.equalsIgnoreCase("B"))
            {
                timesql += " and id in ('STARTB','ENDB') ";
            }
               timesql += "order by name";
            EAXmlDS timeds = db.QuerySQL(timesql);
            for ( int i=0;i<timeds.getRowCount();i++) 
            {
                String id=timeds.getStringAt(i,"ID");
                String name=timeds.getStringAt(i,"NAME");
        				if ( bascatnote.equalsIgnoreCase("A") )
                  {
                      if ( id.equalsIgnoreCase("STARTA")  ) 
                        t1= name;
                      else if ( id.equalsIgnoreCase("ENDA") ) 
                        t2 = name;
                   }
                   else if (bascatnote.equalsIgnoreCase("B"))
                   {
                   
                       if ( id.equalsIgnoreCase("STARTB")  ) 
                        t1= name;
                      else if ( id.equalsIgnoreCase("ENDB") ) 
                        t2 = name;
                   
                   }
            }
            if ( Double.parseDouble(curdat)>=Double.parseDouble(t1) && Double.parseDouble(curdat) <=Double.parseDouble(t2) ) 
              throw new EAException( "该时间段内为公司数据生成阶段，不允许保存<br/><a href='j2memain.jsp'>返回</a>" );
          
          SCInterceptor sc= new SCInterceptor();

          EAXmlDS ds2 = new EAXmlDS ();

          if ( action.equalsIgnoreCase("save")) 
          {//保存程序，配合j2me重新开发

              // 2008/11 改为从data构造ds
              out.print(data);
              String[] itemlist = data.split("~n");
              int n=0;
              String untflg = "";
              String sItemid = "";
              String sUntnum = "";
              String sItemGUID = "";
              String sCorpGUID = db.GetSQL("SELECT GUID FROM CORP WHERE ID='"+corpid+"'");
              //EAXmlDS sctypds = db.QuerySQL("select id,name from v_sctype order by id");
              //2008年修改，补损放在赠品的前面
              EAXmlDS sctypds = db.QuerySQL("select id,name from v_sctype order by decode(id,'3',1.5,id)");
              
              int nScCount =  sctypds.getRowCount();
              String sGuid = "";
              int nRet = 0;
              String sqlstr = "";
              int startqtyloc = 2;  //第一个数据的位置
              String sQty = "";
              String sScid = "";
              int nnn =0;
              if (itemlist.length > 1 ) {
                for ( int i=1;i<itemlist.length;i++ ) {
                  n = i-1;
                  String[] vl = itemlist[i].split(",");
                  //编号,商品,销售,单位,单位类型,赠品,单位,单位类型,补损,单位,单位类型,品尝,单位,单位类型
                  //0     1    2   3   4      5    6    7     8    9    10     11   12  13
                  //2008年修改，补损放在赠品的前面
                  //编号,商品,销售,单位,单位类型,补损,单位,单位类型,赠品,单位,单位类型,品尝,单位,单位类型
                  //0     1    2   3   4      5    6    7     8    9    10     11   12  13
                  
                  sItemid = vl[0];
                  EAXmlDS itemds = db.QuerySQL("SELECT GUID,UNTNUM FROM ITEM WHERE ID='"+sItemid+"'");
                  if( itemds.getRowCount()==0 ) { // 可能是促销商品
                    throw new EAException ( "商品"+sItemid+"不存在" );
                  }
                  sUntnum = itemds.getStringAt(0,"UNTNUM");
                  sItemGUID = itemds.getStringAt(0,"GUID");
                  
                  for ( int j = 0;j<sctypds.getRowCount();j++ ) {
                    sqlstr = "";
                    if( startqtyloc+j*3 >= vl.length ) break;
                    sQty = vl[startqtyloc+j*3]; 
                    untflg = vl[startqtyloc+j*3+2];//销售单位类型,如果=1表示使用大单位
                    sScid = sctypds.getStringAt(j,"ID");
                    sGuid = "";
                    if ( sQty.equalsIgnoreCase(NOEDITFLAG) ) 
                      sQty = "";
                    if ( untflg.equalsIgnoreCase("1") ) {
                      if ( sQty.length() > 0 )
                        sqlstr = ""+sQty+"*"+sUntnum ;      
                      else sqlstr = "0";
                    }
                    else {
                      if ( sQty.length() > 0 )
                        sqlstr = sQty;
                      else sqlstr = "0";
                    }
                    try {
                      String thissql= "select guid from curord where sctype='"+sScid+"' and " +
                            "item='"+sItemGUID+"'  and "+
                            "crtusr='"+sUID+"'  and "+
                            "corp='"+sCorpGUID+"' and "+
                            "subtyp='"+subtyp+"'";
                      if ( corpsoid.length() > 0 ) {
                        thissql+=" and corpsoid='"+corpsoid+"'";
                      }      
                      sGuid = db.GetSQL( thissql);
                    }
                    catch ( EAException e ) { } // 没有找到记录
                    if ( sGuid.length() > 0 && sQty.length() == 0  ) {// 存在记录，但是sQty是空的
                      db.ExcecutSQL("delete from curord where guid='"+sGuid +"'");
                    }
                    else if (sGuid.length() > 0 ){// 存在记录，
//                      if ( nnn == 0 ) out.println( "update curord set qty="+sqlstr+" where guid='"+sGuid+"'" );
                      nnn ++;
                      
                      db.ExcecutSQL("update curord set qty=abs("+sqlstr+") where guid='"+sGuid+"'");
                    }
                    else {  // 不存在，插入
                      if ( sQty.length() > 0 ) {
                        String thissql = "insert into curord ( item ,corp, qty,sctype,CRTUSR,subtyp ";
                        if ( corpsoid.length() > 0 ) 
                          thissql+=",corpsoid";  
                        thissql+=") values('"+sItemGUID+"','"+sCorpGUID+"',abs("+sqlstr+"),'"+sScid+"','"+sUID+"','"+subtyp+"'";
                        //这里使用abs防止有负数产生
                        if ( corpsoid.length() > 0 ) 
                          thissql+=",'"+corpsoid+"' ";
                        thissql+=")";
                        db.ExcecutSQL(thissql);
                      }
                    }
                  }
                }
              }
              //关于应收帐款的处理
              String baldat = "";
              String balmny = "";
              if ( Double.parseDouble(curdat)>Double.parseDouble(t2) ) //8点之后
              {
                  baldat = db.GetSQL("select to_char(sysdate+2,'yyyy-mm-dd') from dual");                           
              }
              else//8点之前
              {
                  baldat = db.GetSQL("select to_char(sysdate+1,'yyyy-mm-dd') from dual");
              }
              EAXmlDS balds= db.QuerySQL("select arcurbal.corp,arcurbal.bal from arcurbal ,corp where arcurbal.corp=corp.guid and "+
                             " to_char(arcurbal.dat,'yyyy-mm-dd')= '"+baldat+"' and corp.id='"+corpid+"' and rownum=1");            
              int balrow = balds.getRowCount();
              double d_balmny = 0.0;//报单金额
              double d_mny = 0.0;//应付帐款余额
              if ( balrow > 0 )
              {
                    String balsql = " select sum( decode(curord.sctype,'1',nvl(corpitem.price,0)/item.untnum)*curord.qty) balmny from curord,corp,corpitem,item where curord.corp=corp.guid"+
                                      "  and corp.id='"+corpid+"' and curord.item=item.guid "+
                                      " and corpitem.corp=corp.refguid and corpitem.item=curord.item "; 
                    balmny = db.GetSQL(balsql); 
                    d_balmny = Double.parseDouble(balmny);
                    d_mny = Double.parseDouble(balds.getStringAt(0,"bal"));                  
                    if ( d_balmny > d_mny )
                    {
                        db.Rollback();
                        throw new EAException("应付帐款余额为"+(d_mny+"")+"本次报单金额为"+(d_balmny+"")+"，已超出"+(d_balmny-d_mny+"")+"元，不能保存<br/><a href='main.jsp'>返回</a>");
                    }
              }
             //String sql = "select count(distinct item) from curord where qty<>0 and corp=(select guid from corp where id='"+corpid+"')";
  
             String sql="select count(distinct curord.item) from curord,item "+
              "where curord.item=item.guid and curord.qty<>0 and item.refid='"+itemtype+"' and "+
              "curord.corp=(select guid from corp where id='"+corpid+"') and item.brand like '"+brand+"%' and curord.crtusr='"+sUID+"' and curord.subtyp='"+subtyp+"'";
              if ( corpsoid.length() >0 ) 
                sql+=" and curord.corpsoid='"+corpsoid +"'";

             String cnt = db.GetSQL(sql);
             db.Commit();          
             out.println( "操作成功,本网点到目前共录入了"+cnt+"个商品" );  
             if ( subtyp.equalsIgnoreCase("2") ) 
              out.println( "<a href=\"j2mebasitemtype.jsp?corpid="+corpid+"&corpsoid="+corpsoid+"\">返回</a><br>" );
             else 
              out.println( "<a href=\"j2meitemtype.jsp?corpid="+corpid+"&katype="+katype+"\">返回</a><br>" );
        }
        else {
          // 查询
          // EAXmlDS ds = sc.GetCorpItemWithCurORD(db,corpid,itemtype,"",sUID,brand);
/////////////////////////////////////////////----------------GetCorpItemWithCurORD
              String sql = " SELECT refid from corp where id='"+corpid+"'";
              if ( itemtype== null ) itemtype = "";
              if ( itemid== null ) itemid = "";
              String kaid = db.GetSQL( sql );
              
              sql = " SELECT ITEM.SORTID 顺序号,ITEM.NAME 商品名称,ITEM.SPEC 规格,"+
                    " 0 QTY_1,ITEM.UNIT unit1 ,0 QEX_1 ,ITEM.SMLUNT smlunt1 ,"+
                    " 0 QTY_2,ITEM.UNIT unit2 ,0 QEX_2 ,ITEM.SMLUNT smlunt2 ,"+
                    " 0 QTY_3,ITEM.UNIT unit3 ,0 QEX_3 ,ITEM.SMLUNT smlunt3 ,"+
                    " 0 QTY_4,ITEM.UNIT unit4 ,0 QEX_4 ,ITEM.SMLUNT smlunt4 ,"+
                    " 0 QTY_5,ITEM.UNIT unit5 ,0 QEX_5 ,ITEM.SMLUNT smlunt5 ,"+
                    " 0 QTY_6,ITEM.UNIT unit6 ,0 QEX_6 ,ITEM.SMLUNT smlunt6 , "+
                    " ITEM.ID 商品编号,ITEM.GUID ITEMGUID,ITEM.UNTNUM UNTNUM,"+
                    " DECODE(ITEM.REFID,'1','常温','2','低温','其他') 大类,ITEM.BASCAT2 系列, substrb(ITEM.SHTNAM,1,15) as 商品简称, FLAG2 as 大小单位标志, " +
                    " item.scabl1, item.scabl2, item.scabl3, item.scabl4, item.scabl5, item.scabl6 " + 
                    " FROM CORPITEM, V_ITEM ITEM,V_CORP CORP "+   
                    " WHERE  CORPITEM.ITEM=ITEM.GUID AND CORPITEM.CORP=CORP.GUID and CORPITEM.USEFLG='1' and ITEM.brand like '"+brand+"%'"+
                    " AND CORP.ID='"+kaid+"' and item.refid like '"+itemtype+"%' and item.useflg='1' and item.mobtyp like '"+mobtyp+"%'";
            if ( itemid.length() > 0 ) 
                  sql += "and item.id='"+itemid+"' ";
            if ( bascal4.length() > 0 )
                  sql += " and item.extcat8 like '"+bascal4+"%' ";
              sql+=" order by ITEM.REFID,NVL(ITEM.SORTID,99999999),ITEM.id ";
              //sql+=" order by ITEM.REFID,ITEM.id ";
                    //and item.id like decode('"+itemid+"','','%','"+itemid+"')
               
              EAXmlDS ds = db.QuerySQL(sql);
        
              HashMap map = ds.GetHashMap("商品编号");
              sql = "SELECT SCTYPE ,ITEM.ID ITEMID,ceil(NVL(CURORD.qty,0)/ITEM.UNTNUM)-decode(mod(NVL(CURORD.qty,0),ITEM.UNTNUM),0,0,1) 整包数量,mod(NVL(CURORD.qty,0),ITEM.UNTNUM) 零包数量,QTY  FROM CURORD,CORP,ITEM  "+
                    "WHERE CURORD.CORP=CORP.GUID AND CURORD.ITEM=ITEM.GUID AND CORP.ID='"+corpid+"' and CURORD.CRTUSR='"+sUID+"' "+
                    "and curord.subtyp='"+subtyp+"'";
              if ( corpsoid.length() > 0 ) 
                  sql+=" and curord.corpsoid='"+corpsoid+"'";
              EAXmlDS curordds = db.QuerySQL(sql );
              for ( int n =0;n<curordds.getRowCount();n++ ) {
                    String sSCType = curordds.getStringAt(n,"SCTYPE");
                    String sMyItemid = curordds.getStringAt(n,"ITEMID");
                    Object o =map.get(sMyItemid);
                    if ( o!= null ) {
                      int i = Integer.parseInt( ""+ o);
                      //2008年修改，补损放在赠品的前面
                      // sctype=2 和 3 要互换位置
                      String sct = sSCType;
                      if ( sct.equalsIgnoreCase("2") )sct = "3";
                      else if ( sct.equalsIgnoreCase("3") )sct = "2";
                      
                      ds.setValueAt(i,"QTY_"+sct,curordds.getStringAt(n,"整包数量") );
                      ds.setValueAt(i,"QEX_"+sct,curordds.getStringAt(n,"QTY") );//零包数量
                    }
                    
              }
              
              
        /////////////////////////////////////////////----------------GetCorpItemWithCurORD
                    // 是否便利
                    String sKAExtcat2  = db.GetSQL("select v.extcat2  from corp c,v_ka v where c.refid=v.id and c.id='"+corpid+"'"); 
        
                    for ( int i=0;i< ds.getRowCount();i++) {
                      String untnum = ds.getStringAt(i,"UNTNUM");  
                      String untflg = ds.getStringAt(i,"大小单位标志");  
                      int flag1 = 1;  // =0  便利没品尝 =1 有品尝
                      // flag2 的取值
                      // 1.如果untnum=1 只显示大单位
                      // 2 如果是销售，且 大小单位标志=‘0’显示大单位
                      // 3 否则，仅显示小单位
                      int flag2 = 3;  // =1 只录入大单位(untnum=1) =2 非销售录入小单位（冷冻） =3 大小单位都要录入
                      if ( untnum.equals("1") ) //  如果换算单位是1，不需要显示小单位
                        flag2 = 1;
                      else if ( untflg.equals("0") ) 
                        flag2 = 2;
                      if( sKAExtcat2.equals("2") )
                        flag1 = 0;
                        
                      // 因为不可能大小单位共存，所以QEX是小单位的数量，而不是零头的数量
                      String[] qty={"","","",""};
                      String[] qex={"","","",""};
                      for ( int nn=0;nn<4; nn++ ) {   
                        if ( nn== 3 && flag1==0 )continue;
                        if ( flag2 == 1 ) {// 只录入大单位(untnum=1)
                           qty[nn] = ds.getStringDef(i,"QTY_"+(nn+1),"");              
                           if( qty[nn].equals("0") ) qty[nn]="";
                        }  
                        else if ( flag2 == 2 && nn== 0){// 销售,录入大单位
                           qty[nn] = ds.getStringDef(i,"QTY_"+(nn+1),"");    
                           if( qty[nn].equals("0") ) qty[nn]="";
                        }
                        else { //小单位
                          long l = Long.parseLong(ds.getStringDef(i,"QTY_"+(nn+1),"0"))*Long.parseLong(untnum)+Long.parseLong(ds.getStringDef(i,"QEX_"+(nn+1),"0"));
                           qex[nn] =""+ l;
                           if( qex[nn].equals("0") ) qex[nn]="";
                        }
                      }           
                      sTemp += "<setvar name=\"ITEM"+ ds.getStringAt(i,"商品编号") +"\" value=\""+
                        qty[0]+"~"+qex[0]+"~"+
                        qty[1]+"~"+qex[1]+"~"+
                        qty[2]+"~"+qex[2]+"~"+
                        qty[3]+"~"+qex[3]+
                        "\"/>\n";
                      if ( i!=0) sTemp1+=",";
                      sTemp1+= ds.getStringAt(i,"商品编号");
                      if ( i!=0) sTemp2+=",";
                      sTemp2+= qty[0]+"~"+qex[0]+"~"+ qty[1]+"~"+qex[1]+"~"+ qty[2]+"~"+qex[2]+"~"+ qty[3]+"~"+qex[3];
                      sItemList += "<anchor>"+ds.getStringAt(i,"商品简称")+"<go href=\"itementry.wmls#entry('"+
                        ds.getStringAt(i,"商品编号")+"','"+ds.getStringAt(i,"商品名称")+"','"+
                        ds.getStringAt(i,"UNIT1")+"','"+ds.getStringAt(i,"SMLUNT1")+"','"+
                        flag1+"','"+flag2+"')\"/>\n</anchor><br/>";  //"+ds.getStringAt(i,"商品简称")+"
        
        
                    }
        
              //System.out.println(sUID+"---sItemList"+sItemList);
              String newline = "~n";
              out.println( "<FORM action=\"j2meenterAll.jsp\" method=\"post\" >" );
              out.println( "<SINGLETABLE name=\"data\" width=\"100%\" height=\"90%\"  FIXEDROW=\"1\" FIXEDCOL=\"2\"" );
        //      for ( int cc = 0 ;cc<ds.getColumnCount();cc ++ ) {
        //        if ( cc!= 0 ) out.print(",");
        //        out.print( ds.getColumnName(cc) );
        //      }
              sKAExtcat2 = "1";
              //编号,商品,销售,单位,单位类型,赠品,单位,单位类型,补损,单位,单位类型,品尝,单位,单位类型
              //编号,商品,销售单位类型,销售,单位,赠品,补损,品尝,非销售单位
              if( !sKAExtcat2.equals("2") ) { // 便利没品尝
               //编号,商品,销售,单位,单位类型,补损,单位,单位类型,赠品,单位,单位类型,品尝,单位,单位类型
                //0     1    2   3   4      5    6    7     8    9    10     11   12  13
//                out.print( " COLWIDTH=\"0,110,38,18,0,34,0,0,34,0,0,34,0,0\" COLEDITABLE=\"0,1,1,0,0,1,0,0,1,0,0,1,0,0\">" );
                out.print( " COLWIDTH=\"0,110,38,18,0,34,0,0,34,0,0,34,0,0\" COLEDITABLE=\"0,1,1,0,0,1,0,0,1,0,0,1,0,0\" COMMITCOL=\"0,2,5,8,11\">" );
                //2008年修改，补损放在赠品的前面
                out.print( "编号,商品,销售,-,单位类型,补损,-,单位类型,赠品,-,单位类型,品尝,-,单位类型" );
              }
              else { 
//                out.print( " COLWIDTH=\"0,110,38,18,0,34,0,0,34,0,0\" COLEDITABLE=\"0,1,1,0,0,1,0,0,1,0,0\">" );
                  out.print( " COLWIDTH=\"0,110,38,18,0,34,0,0,34,0,0\" COLEDITABLE=\"0,1,1,0,0,1,0,0,1,0,0\" COMMITCOL=\"0,2,5,8,11\">" );
                out.print( "编号,商品,销售,,单位类型,补,,单位类型,赠,,单位类型" );
              }
              out.print( newline );
              // 如果是便利，不显示品尝
              // 如果定义客户商品绑定的大小单位标志为0，销售之录入大单位
              // 如果商品的换算比例是1，销售只录入大单位
              // 非销售都是录入小单位
              String str = "";
              for ( int rr = 0 ;rr<ds.getRowCount();rr ++ ) {
                  out.print( ds.getStringAt(rr,"商品编号") +",");
                  out.print( ds.getStringAt(rr,"商品简称")  +",");
                  
                  if ( ds.getStringAt(rr,"untnum").equalsIgnoreCase("1")||ds.getStringAt(rr,"大小单位标志").equalsIgnoreCase("0") ) {
                    str = ds.getStringAt(rr,"QTY_1");if ( str.equalsIgnoreCase("0") ) str = "";
                    if ( !ds.getStringAt(rr,"scabl1").equalsIgnoreCase("1") )
                      str= NOEDITFLAG;
                    out.print(str +",");
                    out.print(ds.getStringAt(rr,"unit1")+",");
                    out.print("1,");
                    
                  }
                  else {
                    str = ds.getStringAt(rr,"QEX_1");if ( str.equalsIgnoreCase("0") ) str = "";
                    if ( !ds.getStringAt(rr,"scabl1").equalsIgnoreCase("1") )
                      str= NOEDITFLAG;
                    out.print(str +",");
                    out.print(ds.getStringAt(rr,"smlunt1")+","); // 其他小单位
                    out.print("0,");
                  }
                  str = ds.getStringAt(rr,"QEX_2");if ( str.equalsIgnoreCase("0") ) str = "";
                  //2008年修改，补损放在赠品的前面
                  if ( !ds.getStringAt(rr,"scabl3").equalsIgnoreCase("1") )
                      str= NOEDITFLAG;
                  out.print( str +","+ds.getStringAt(rr,"smlunt1")+",0,");
                  str = ds.getStringAt(rr,"QEX_3");if ( str.equalsIgnoreCase("0") ) str = "";
                  //2008年修改，补损放在赠品的前面
                  if ( !ds.getStringAt(rr,"scabl2").equalsIgnoreCase("1") )
                      str= NOEDITFLAG;
                  out.print(str +","+ds.getStringAt(rr,"smlunt1")+",0");
                  
                  if( !sKAExtcat2.equals("2") ) {// =0  便利没品尝 =1 有品尝
                    str = ds.getStringAt(rr,"QEX_4");if ( str.equalsIgnoreCase("0") ) str = "";
                    if ( !ds.getStringAt(rr,"scabl4").equalsIgnoreCase("1") )
                      str= NOEDITFLAG;
                    out.print( ","+str +","+ds.getStringAt(rr,"smlunt1")+",0");
                  }
                  out.print( newline );
              }
              out.println( "</SINGLETABLE>" );
              out.println( "<input type=\"hidden\" name=\"action\" value=\"save\">" );
              out.println( "<input type=\"hidden\" name=\"corpid\" value=\""+corpid+"\">" );
              out.println( "<input type=\"hidden\" name=\"itemtype\" value=\""+itemtype+"\">" );
              out.println( "<input type=\"hidden\" name=\"curdat\" value=\""+curdat+"\">" );
              out.println( "<input type=\"hidden\" name=\"brand\" value=\""+brand+"\">" );
              out.println( "<input type=\"hidden\" name=\"bascal\" value=\""+bascal+"\">" );
              out.println( "<input type=\"hidden\" name=\"katype\" value=\""+katype+"\">" );
              out.println( "<input type=\"hidden\" name=\"corpsoid\" value=\""+corpsoid+"\">" );
              out.println( "<input type=\"hidden\" name=\"subtyp\" value=\""+subtyp+"\">" );
    
              out.println( "<input type=\"submit\" value=\"【保 存】\" name=\"com_ok\">" );
              if ( subtyp.equalsIgnoreCase("2") ) 
                out.println( "<a href=\"j2mebasitemtype.jsp?corpid="+corpid+"&corpsoid="+corpsoid+"&showpage="+pageno+"\">返回</a><br>" );
              else 
                out.println( "<a href=\"j2meitemtype.jsp?corpid="+corpid+"&katype="+katype+"&showpage="+pageno+"\">返回</a><br>" );
              
              out.println( "</FORM>" );
        }
    } 
    catch ( Exception e ) 
    { 
            if ( db!= null ) db.Rollback(); 
            out.println( "运行出错："+e.toString() );
            
    } 
    finally
    { 
           if (db!= null ) db.Close(); 
    
    } 

%>

</p>
</body>

</html>