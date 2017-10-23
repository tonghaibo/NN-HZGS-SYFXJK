<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>main</title>
</head>
<body>
<%
          response.setHeader("Pragma","No-cache"); 
          response.setHeader("Cache-Control","no-cache"); 
          response.setDateHeader("Expires", 0);  
          String extcat8 = "";
          String plandate1 = "";
          String plandate2 = "";
          int daycount = 0;//低温计划的天数
          try
          {
          
          out.println("<p align=\"center\">");
          extcat8=EAFunc.NVL(request.getParameter("extcat8"),"");
          plandate1 = "select id,name from param where typ='PLANDATE' and refid = '1'";
          plandate2 = "select id,name from param where typ='PLANDATE' and refid = '2'";
          EAXmlDS plands1 = EADbTool.QuerySQL(plandate1);
          EAXmlDS plands2 = EADbTool.QuerySQL(plandate2);
          String sysdate = EADbTool.GetSQL("select to_char(sysdate,'yyyy-mm-dd') from dual");
          Calendar ca = Calendar.getInstance();
          int p =  ca.get(Calendar.DAY_OF_WEEK);
         // int date1 = Integer.parseInt(plands1.getStringAt(0,"id"));//周一
         // int date2 = Integer.parseInt(plands2.getStringAt(0,"id"));//周四
         
          //07-30改成 周日 与周三
          
          int date1 = Integer.parseInt(plands1.getStringAt(0,"id"));//周三
          int date2 = Integer.parseInt(plands2.getStringAt(0,"id"));//周日  
          String plandat1 = "";
          String plandat2 = "";
          String itemtype = EAFunc.NVL(request.getParameter("itemtype"),"");
          if (itemtype.equalsIgnoreCase("2") )
          {
                if ( p==4 || p==5) //本周三--四录下周一二三
                {
                  switch (date1)
                  {
                    
//                    case 6:ca.add(Calendar.DATE,1);break;
//                    case 5:ca.add(Calendar.DATE,2);break;
                    case 3:ca.add(Calendar.DATE,5);break;     //周三
                    case 4:ca.add(Calendar.DATE,4);break;    //周四
//                    case 6:ca.add(Calendar.DATE,3);break;    //周四
                   default:throw new Exception ("今天不是录入计划时间，<br/><a href='main.jsp'>返回主页</a>");
                  }
                  plandat1 = plands1.getStringAt(0,"name");
                  daycount = 3;
                  String sql = EADbTool.GetSQL("SELECT TO_CHAR(SYSDATE,'HH24MIss') FROM DUAL");
                   if (Double.parseDouble(sql)>Double.parseDouble(plandat1))
                   {               
                     throw new EAException ("已经超出录入计划时间，<br/><a href='main.jsp'>返回主页</a>");
                    }
                }
                else if ( p==1 || p==2)//本周日及下周一录下周四---七
                {
                  switch (date2)
                  {
                    
                    case 7:ca.add(Calendar.DATE,4);break; //周日
                    case 1:ca.add(Calendar.DATE,3);break;  //周一
                    default:throw new Exception ("今天不是录入计划时间，<br/><a href='main.jsp'>返回主页</a>");
                  }
                  plandat2 = plands2.getStringAt(0,"name");
                  daycount = 4;
                  String sql = EADbTool.GetSQL("SELECT TO_CHAR(SYSDATE,'HH24MIss') FROM DUAL");
                   if (Double.parseDouble(sql)>Double.parseDouble(plandat2))
                   {               
                     throw new EAException ("已经超出录入计划时间，<br/><a href='main.jsp'>返回主页</a>");
                    }
                }
          }
         String y1 = (ca.getTime().getYear()+1900)+"";
         String m1 = (ca.getTime().getMonth()+1)+"";
         String d1 = ca.getTime().getDate()+"";
         String _d = y1+m1+d1;
          EAUserinfo usrinfo = MobileLogin.CheckIfLogin(request);
          // 得到登陆的USER ID
          String sUID  = usrinfo.getUsrid();
          Calendar cal = Calendar.getInstance();
          String str = "";
          String flag = "";
          String brand = "";
          String _date = "";//传到后边的日期
          String num = "";
          String bascal = "";
          String number = "";//条线中心 sesison的number
          String locid = "";
          String type = "";
          //String curdat = EADbTool.GetSQL("select to_char(sysdate,'hh24miss') from dual");
          number = EAFunc.NVL(request.getParameter("number"),"");
          flag = EAFunc.NVL(request.getParameter("flag"),""); //按天或是按周录入标志
          
          brand = EAFunc.NVL(request.getParameter("brand"),"");
          //num = EAFunc.NVL(request.getParameter("num"),"");
          bascal = EAFunc.NVL(request.getParameter("bascal"),""); 
           //String first  = EAFunc.NVL(request.getParameter("first"),""); 
          locid = EAFunc.NVL(request.getParameter("locid"),"");
          type = EAFunc.NVL(request.getParameter("type"),"");
          out.println("送货日期<br/>");
          if ( type.equalsIgnoreCase("b"))
          {
          if ( flag.equalsIgnoreCase("day"))//按天录入
          {
               if ( itemtype.equalsIgnoreCase("2"))//itemtype=2 低温
               {
                  for ( int i=0;i<daycount;i++)
                  {
                         cal.set(Integer.parseInt(y1),Integer.parseInt(m1)-1,Integer.parseInt(d1));
                         cal.add(Calendar.DATE,i);//默认是明天    
                         String year = (cal.getTime().getYear()+1900)+"";
                         String month = (cal.getTime().getMonth()+1)+"";
                         String date = cal.getTime().getDate()+"";
                         _date = year+"-"+month+"-"+date;
                         str += "<a href=\"planenter.jsp?brand="+brand+"&itemtype="+itemtype+"&flag="+flag+"\">"
                         str = "<anchor>"+_date;
                         str += "<go href=\"planEnter.jsp\">";
                         str += "<postfield name=\"brand\" value=\""+brand+"\"/>";
                         str += "<postfield name=\"itemtype\" value=\""+itemtype+"\"/>";
                         str += "<postfield name=\"flag\" value=\""+flag+"\"/>";
                         str += "<postfield name=\"_date\" value=\""+_date+"\"/>";
                         str += "<postfield name=\"bascal\" value=\""+bascal+"\"/>";
                         str += "<postfield name=\"number\" value=\""+number+"\"/>";
                         str += "<postfield name=\"locid\" value=\""+locid+"\"/>";
                         str += "<postfield name=\"type\" value=\""+type+"\"/>";   
                         str += "<postfield name=\"extcat8\" value=\""+extcat8+"\"/>"; 
                         str += "<postfield name=\"daycount\" value=\""+daycount+"\"/>";                       
                         str += "</go></anchor><br/>";
                         cal = Calendar.getInstance();//此处必须再重新创建cal实例，否则日期会叠加在一起                         
                         out.print(str);
                  }
               }
               else  //itemtype=1  常温便利按天录入
               { 
                  Calendar cc = Calendar.getInstance();
                  String yy1 = cc.getTime().getYear()+1900+"";
                  String mm1 = cc.getTime().getMonth()+1+"";
                  String dd1 = cc.getTime().getDate()+"";
                  int d =  Integer.parseInt(dd1);
                  int m =  Integer.parseInt(mm1);
                  int y =  Integer.parseInt(yy1);
                  if ( d>=1&&d<=10) //说明是1旬的
                  {
                       cc.set(y,m-1,11);
                       for ( int n=0;n<10;n++)
                       {
                           cc.set(y,m-1,12);
                           cc.add(Calendar.DATE,n);
                           String yy = (cc.getTime().getYear()+1900)+"";
                           String mm = (cc.getTime().getMonth()+1)+"";
                           String dd = (cc.getTime().getDate())+"";
                           _date = yy+"-"+mm+"-"+dd;
                           str = "<anchor>"+_date;
                           str += "<go href=\"planEnter.jsp\">";
                           str += "<postfield name=\"brand\" value=\""+brand+"\"/>";
                           str += "<postfield name=\"itemtype\" value=\""+itemtype+"\"/>";
                           str += "<postfield name=\"flag\" value=\""+flag+"\"/>";
                           str += "<postfield name=\"_date\" value=\""+_date+"\"/>";
                           str += "<postfield name=\"bascal\" value=\""+bascal+"\"/>";
                           str += "<postfield name=\"number\" value=\""+number+"\"/>";
                           str += "<postfield name=\"locid\" value=\""+locid+"\"/>";
                           str += "<postfield name=\"type\" value=\""+type+"\"/>";
                           str += "<postfield name=\"extcat8\" value=\""+extcat8+"\"/>"; 
                           str += "</go></anchor><br/>";   
                           cc = Calendar.getInstance();
                           out.print(str);
                       }
                  }
                  else if(d>=11&&d<=20)//说明是2旬的
                  {
                      cc.set(y,m-1,11);
                      int ppp = 0;
                      if ( m==1||m==3||m==5||m==7||m==8||m==10||m==12 )
                          ppp=11;
                      else if ( y%4 ==0&&m==2)
                        ppp = 9;                     
                      else if ( y%4 != 0 &&m==2)
                        ppp = 8;
                      else 
                      ppp =10;    
                      for (int n=0;n<ppp;n++)
                      {
                           cc.set(y,m-1,22);
                           cc.add(Calendar.DATE,n);
                           String yy = (cc.getTime().getYear()+1900)+"";
                           String mm = (cc.getTime().getMonth()+1)+"";
                           String dd = (cc.getTime().getDate())+"";
                           _date = yy+"-"+mm+"-"+dd;
                           str = "<anchor>"+_date;
                           str += "<go href=\"planEnter.jsp\">";
                           str += "<postfield name=\"brand\" value=\""+brand+"\"/>";
                           str += "<postfield name=\"itemtype\" value=\""+itemtype+"\"/>";
                           str += "<postfield name=\"flag\" value=\""+flag+"\"/>";
                           str += "<postfield name=\"_date\" value=\""+_date+"\"/>";
                           str += "<postfield name=\"bascal\" value=\""+bascal+"\"/>";
                           str += "<postfield name=\"number\" value=\""+number+"\"/>";
                           str += "<postfield name=\"locid\" value=\""+locid+"\"/>";
                           str += "<postfield name=\"type\" value=\""+type+"\"/>";
                            str += "<postfield name=\"extcat8\" value=\""+extcat8+"\"/>"; 
                           str += "</go></anchor><br/>";   
                           cc = Calendar.getInstance();
                           out.print(str);                    
                      }
                  }
                  else//说明是3旬的
                  {
                     int time = 0;
                     if ( m==1||m==3||m==5||m==7||m==8||m==10||m==12 )
                        time = 11;
                     else if ( y%4 ==0&&m==2)
                        time = 9;                     
                      else if ( y%4 != 0 &&m==2)
                        time = 8;
                      else 
                      time =10;
                     for (int n=0;n<10;n++)
                     {   
                         cc.set(y,m,2);
                         cc.add(Calendar.DATE,n);
                         String yy = (cc.getTime().getYear()+1900)+"";
                         String mm = (cc.getTime().getMonth()+1)+"";
                         String dd = (cc.getTime().getDate())+"";
                         _date = yy+"-"+mm+"-"+dd;
                         str = "<anchor>"+_date;
                         str += "<go href=\"planEnter.jsp\">";
                         str += "<postfield name=\"brand\" value=\""+brand+"\"/>";
                         str += "<postfield name=\"itemtype\" value=\""+itemtype+"\"/>";
                         str += "<postfield name=\"flag\" value=\""+flag+"\"/>";
                         str += "<postfield name=\"_date\" value=\""+_date+"\"/>";
                         str += "<postfield name=\"bascal\" value=\""+bascal+"\"/>";
                         str += "<postfield name=\"number\" value=\""+number+"\"/>";
                         str += "<postfield name=\"locid\" value=\""+locid+"\"/>";
                         str += "<postfield name=\"type\" value=\""+type+"\"/>";
                          str += "<postfield name=\"extcat8\" value=\""+extcat8+"\"/>"; 
                         str += "</go></anchor><br/>";   
                         cc = Calendar.getInstance();
                         out.print(str);
                     }
                  }       
               }
          }//以上是便利按天录入
          else if(flag.equalsIgnoreCase("time")) //输入一个日期：按周录入
          {    
               if ( itemtype.equalsIgnoreCase("1")) //常温
               {
                    Calendar ccc = Calendar.getInstance();
                    String yyy1 = ccc.getTime().getYear()+1900+"";
                    String mmm1 = ccc.getTime().getMonth()+1+"";
                    String ddd1 = ccc.getTime().getDate()+"";
                    int dd =  Integer.parseInt(ddd1);
                    int mm =  Integer.parseInt(mmm1);
                    int yy =  Integer.parseInt(yyy1);
                   if ( dd>=1&&dd<=10) //1旬
                   {
                       ccc.set(yy,mm-1,12);
                       String yy1 = (ccc.getTime().getYear()+1900)+"";
                       String mm1 = (ccc.getTime().getMonth()+1)+"";
                       String dd1 = (ccc.getTime().getDate())+"";
                       _date = yy1+"-"+mm1+"-"+dd1;
                       out.print("输入计划开始日期<br/>");
                       out.print("年<input type =\"text\" name=\"yy1\" format=\"*N\" value=\""+yy1+"\"/>");
                       out.print("月<input type =\"text\" name=\"mm1\" format=\"*N\" value=\""+mm1+"\"/>");
                       out.print("日<input type =\"text\" name=\"dd1\" format=\"*N\" value=\""+dd1+"\"/>");
                       out.print("<br/>");
                       out.print( "所要计划的天数<br/>");
                       out.print( "天数<input type =\"text\" name=\"days1\" value=\"10\" format=\"*N\"/>");
                       str = "<anchor>"+"确定";
                       str += "<go href=\"planEnter.jsp\">";
                       str += "<postfield name=\"y1\" value=\"$(yy1)\"/>";
                       str += "<postfield name=\"m1\" value=\"$(mm1)\"/>";
                       str +="<postfield name=\"d1\" value=\"$(dd1)\"/>"; 
                       str += "<postfield name=\"days\" value=\"$(days1)\"/>";
                       str += "<postfield name=\"brand\" value=\""+brand+"\"/>";
                       str += "<postfield name=\"itemtype\" value=\""+itemtype+"\"/>";
                       str += "<postfield name=\"flag\" value=\""+flag+"\"/>";
                       str += "<postfield name=\"_date\" value=\""+_date+"\"/>";
                       str += "<postfield name=\"bascal\" value=\""+bascal+"\"/>";
                       str += "<postfield name=\"number\" value=\""+number+"\"/>";
                       str += "<postfield name=\"locid\" value=\""+locid+"\"/>";
                       str += "<postfield name=\"type\" value=\""+type+"\"/>";
                        str += "<postfield name=\"extcat8\" value=\""+extcat8+"\"/>"; 
                       str += "</go></anchor><br/>";   
                       ccc = Calendar.getInstance();
                       out.print(str);
                   
                   }
                   else if ( dd>=11&&dd<=20)
                   {
                       ccc.set(yy,mm-1,22);
                       String yy1 = (ccc.getTime().getYear()+1900)+"";
                       String mm1 = (ccc.getTime().getMonth()+1)+"";
                       String dd1 = (ccc.getTime().getDate())+"";
                       _date = yy1+"-"+mm1+"-"+dd1;
                       out.print("输入计划开始日期<br/>");
                       out.print("年<input type =\"text\" name=\"yy1\" format=\"*N\" value=\""+yy1+"\"/>");
                       out.print("月<input type =\"text\" name=\"mm1\" format=\"*N\" value=\""+mm1+"\"/>");
                       out.print("日<input type =\"text\" name=\"dd1\" format=\"*N\" value=\""+dd1+"\"/>");
                       out.print("<br/>");
                       out.print( "所要计划的天数<br/>");
                       
                      int ll = 0;
                     if ( mm==1||mm==3||mm==5||mm==7||mm==8||mm==10||mm==12 )
                        ll = 11;
                     else if ( yy%4 ==0&&mm==2)
                        ll = 9;                     
                      else if ( yy%4 != 0 &&mm==2)
                        ll = 8;
                      else 
                       ll =10;
                       
                       out.print( "天数<input type =\"text\" name=\"days1\" value=\""+ll+"\" format=\"*N\"/>");
                       str = "<anchor>"+"确定";
                       str += "<go href=\"planEnter.jsp\">";
                       str += "<postfield name=\"y1\" value=\"$(yy1)\"/>";
                       str += "<postfield name=\"m1\" value=\"$(mm1)\"/>";
                       str +="<postfield name=\"d1\" value=\"$(dd1)\"/>"; 
                       str += "<postfield name=\"days\" value=\"$(days1)\"/>";
                       str += "<postfield name=\"brand\" value=\""+brand+"\"/>";
                       str += "<postfield name=\"itemtype\" value=\""+itemtype+"\"/>";
                       str += "<postfield name=\"flag\" value=\""+flag+"\"/>";
                       str += "<postfield name=\"_date\" value=\""+_date+"\"/>";
                       str += "<postfield name=\"bascal\" value=\""+bascal+"\"/>";
                       str += "<postfield name=\"number\" value=\""+number+"\"/>";
                       str += "<postfield name=\"locid\" value=\""+locid+"\"/>";
                       str += "<postfield name=\"type\" value=\""+type+"\"/>";
                        str += "<postfield name=\"extcat8\" value=\""+extcat8+"\"/>"; 
                       str += "</go></anchor><br/>";   
                       ccc = Calendar.getInstance();
                       out.print(str);
                   }
                   else
                   {
                       ccc.set(yy,mm-1+1,2);
                       String yy1 = (ccc.getTime().getYear()+1900)+"";
                       String mm1 = (ccc.getTime().getMonth()+1)+"";
                       String dd1 = (ccc.getTime().getDate())+"";
                       _date = yy1+"-"+mm1+"-"+dd1;
                       out.print("输入计划开始日期常温<br/>");
                       out.print("年<input type =\"text\" name=\"yy1\" format=\"*N\" value=\""+yy1+"\"/>");
                       out.print("月<input type =\"text\" name=\"mm1\" format=\"*N\" value=\""+mm1+"\"/>");
                       out.print("日<input type =\"text\" name=\"dd1\" format=\"*N\" value=\""+dd1+"\"/>");
                       out.print("<br/>");
                       out.print( "所要计划的天数<br/>");
                       out.print( "天数<input type =\"text\" name=\"days1\" value=\"10\" format=\"*N\"/>");
                       str = "<anchor>"+"确定";
                       str += "<go href=\"planEnter.jsp\">";
                       str += "<postfield name=\"y1\" value=\"$(yy1)\"/>";
                       str += "<postfield name=\"m1\" value=\"$(mm1)\"/>";
                       str +="<postfield name=\"d1\" value=\"$(dd1)\"/>"; 
                       str += "<postfield name=\"days\" value=\"$(days1)\"/>";
                       str += "<postfield name=\"brand\" value=\""+brand+"\"/>";
                       str += "<postfield name=\"itemtype\" value=\""+itemtype+"\"/>";
                       str += "<postfield name=\"flag\" value=\""+flag+"\"/>";
                       str += "<postfield name=\"_date\" value=\""+_date+"\"/>";
                       str += "<postfield name=\"bascal\" value=\""+bascal+"\"/>";
                       str += "<postfield name=\"number\" value=\""+number+"\"/>";
                       str += "<postfield name=\"locid\" value=\""+locid+"\"/>";
                       str += "<postfield name=\"type\" value=\""+type+"\"/>";
                        str += "<postfield name=\"extcat8\" value=\""+extcat8+"\"/>"; 
                       str += "</go></anchor><br/>";   
                       ccc = Calendar.getInstance();
                       out.print(str);
                   
                   }
               }
               else//itemtype=2 低温
               {
                      //cal.set(Integer.parseInt(y1),Integer.parseInt(m1)-1,Integer.parseInt(d1));
                      out.print("输入计划开始日期低温<br/>");
                      out.print("年<input type =\"text\" name=\"y1\" format=\"*N\" value=\""+y1+"\"/>");
                      out.print("月<input type =\"text\" name=\"m1\" format=\"*N\" value=\""+m1+"\"/>");
                      out.print("日<input type =\"text\" name=\"d1\" format=\"*N\" value=\""+d1+"\"/>");
                      out.print("<br/>");
                      String y2 = (cal.getTime().getYear()+1900)+"";
                      String m2 = (cal.getTime().getMonth()+1)+"";
                      String d2 = cal.getTime().getDate()+"";
                      out.print( "所要计划的天数<br/>");
                      out.print( "天数<input type =\"text\" name=\"days\" value=\""+daycount+"\" format=\"*N\"/>");
                      out.print( "<anchor>"+"确定");
                      out.print( "<go href=\"planEnter.jsp\">");
                      out.print( "<postfield name=\"y1\" value=\"$(y1)\"/>");
                      out.print( "<postfield name=\"m1\" value=\"$(m1)\"/>");
                      out.print( "<postfield name=\"d1\" value=\"$(d1)\"/>"); 
                      out.print( "<postfield name=\"days\" value=\"$(days)\"/>");
                      out.print( "<postfield name=\"itemtype\" value=\""+itemtype+"\"/>");
                      out.print( "<postfield name=\"flag\" value=\""+flag+"\"/>");
                      out.print( "<postfield name=\"brand\" value=\""+brand+"\"/>");
                      out.print( "<postfield name=\"bascal\" value=\""+bascal+"\"/>");
                      out.print( "<postfield name=\"number\" value=\""+number+"\"/>");
                      out.print( "<postfield name=\"locid\" value=\""+locid+"\"/>");
                      out.print( "<postfield name=\"_d\" value=\""+_d+"\"/>");
                      out.print( "<postfield name=\"type\" value=\""+type+"\"/>");
                      out.print(  "<postfield name=\"extcat8\" value=\""+extcat8+"\"/>");
                      out.print( "</go></anchor><br/>");
              }              
            }
            out.print( "<a href=\"checkType.jsp?number="+number+"&amp;locid="+locid+"&amp;curdat="+curdat+"&amp;type="+type+"\">返回常低温</a><br/>");
            out.print( "<a href=\"main.jsp\">返回主页</a>");
            out.print( "</p></card></wml>");
          }
          else  //按月录
          {
              if (itemtype.equalsIgnoreCase("1") )
              {
              if ( flag.equalsIgnoreCase("month"))
              {
              Calendar c = Calendar.getInstance();
              int cur_month = c.getTime().getMonth()+1+1;//下月
              int cur_year = c.getTime().getYear()+1900;
              int cur_date = 1;
              c.set(cur_year,cur_month-1,1);


                                         String yy = (c.getTime().getYear()+1900)+"";
                           String mm = (c.getTime().getMonth()+1)+"";
                           String dd = (c.getTime().getDate())+"";

              out.print("计划开始日期<br/>");
              out.print("年<input type =\"text\" name=\"cur_year\" format=\"*N\" value=\""+yy+"\"/>");
              out.print("月<input type =\"text\" name=\"cur_month\" format=\"*N\" value=\""+mm+"\"/>");
              out.print("日<input type =\"text\" name=\"cur_date\" format=\"*N\" value=\""+dd+"\"/>");
              int month = Integer.parseInt(mm);//当前月
              int dates = 0;//每月天数
              if ( month == 1 || month == 3 || month ==5 ||month == 7||month ==8 ||month ==10 || month ==12 )
              {
                  dates = 31;
              }
              else if ( month == 4 || month ==6 || month ==9 || month ==11 )
              {
                dates = 30;
              }
              else
              {
                  if ( Integer.parseInt(yy) % 4 == 0 && month == 2 )
                  {
                    dates = 29;
                  }
                  else
                  {
                    dates = 28;
                  }
              }
              out.print( "所要计划的天数<br/>");
              out.print( "天数<input type =\"text\" name=\"dates\" value=\""+dates+"\" format=\"*N\"/>");
              out.print( "<anchor>"+"确定");
              out.print( "<go href=\"planEnter.jsp\">");
              out.print( "<postfield name=\"y1\" value=\"$(cur_year)\"/>");
              out.print( "<postfield name=\"m1\" value=\"$(cur_month)\"/>");
              out.print( "<postfield name=\"d1\" value=\"$(cur_date)\"/>"); 
              out.print( "<postfield name=\"days\" value=\"$(dates)\"/>");
              out.print( "<postfield name=\"itemtype\" value=\""+itemtype+"\"/>");
              out.print( "<postfield name=\"flag\" value=\""+flag+"\"/>");
              out.print( "<postfield name=\"brand\" value=\""+brand+"\"/>");
              out.print( "<postfield name=\"bascal\" value=\""+bascal+"\"/>");
              out.print( "<postfield name=\"number\" value=\""+number+"\"/>");
              out.print( "<postfield name=\"locid\" value=\""+locid+"\"/>");
               out.print( "<postfield name=\"type\" value=\""+type+"\"/>");
               out.print(  "<postfield name=\"extcat8\" value=\""+extcat8+"\"/>");
              out.print( "</go></anchor><br/>");

              }
              else
              {
                Calendar cc = Calendar.getInstance();
                int cur_month = cc.getTime().getMonth()+1+1;//下月
                int cur_year = cc.getTime().getYear()+1900;
                int cur_date = 1;
                cc.set(cur_year,cur_month-1,1);

             String yy = (cc.getTime().getYear()+1900)+"";
                           String mm = (cc.getTime().getMonth()+1)+"";
                           String dd = (cc.getTime().getDate())+"";

                int month = Integer.parseInt(mm);//当前月
                int dates = 0;//每月天数
                if ( month == 1 || month == 3 || month ==5 ||month == 7|| month ==8 ||month ==10 || month ==12 )
                {
                    dates = 31;
                }
                else if ( month == 4 || month ==6 ||month ==9 || month ==11 )
                {
                    dates = 30;
                }
                else
                {
                    if ( Integer.parseInt(yy) % 4 == 0 && month == 2 )
                    {
                      dates = 29;
                    }
                    else
                    {
                      dates = 28;
                    }
                }
                cc.set(cur_year,cur_month-1,0); 
                for ( int i=0;i<dates;i++ )
                {
                   
                    cc.add(Calendar.DATE,1);
                    String mon_year = cc.getTime().getYear()+1900+"";
                    String mon_month = cc.getTime().getMonth()+1+"";
                    String mon_date = cc.getTime().getDate()+"";
                    _date = mon_year+"-"+mon_month+"-"+mon_date;
                    str = "<anchor>"+_date;
                    str += "<go href=\"planEnter.jsp\">";
                    str += "<postfield name=\"brand\" value=\""+brand+"\"/>";
                    str += "<postfield name=\"itemtype\" value=\""+itemtype+"\"/>";
                    str += "<postfield name=\"flag\" value=\""+flag+"\"/>";
                    str += "<postfield name=\"_date\" value=\""+_date+"\"/>";
                    str += "<postfield name=\"bascal\" value=\""+bascal+"\"/>";
                    str += "<postfield name=\"number\" value=\""+number+"\"/>";
                    str += "<postfield name=\"locid\" value=\""+locid+"\"/>";
                    str += "<postfield name=\"type\" value=\""+type+"\"/>";
                     str += "<postfield name=\"extcat8\" value=\""+extcat8+"\"/>";
                    str += "</go></anchor><br/>";   
                    out.print(str);
                }
              }              
            }
            else //卖场低温
            {
                      if ( flag.equalsIgnoreCase("time"))
                      {
                      String m_y1 = y1;
                      String m_m1 = m1;
                      String m_d1 = d1;
                      out.print("输入计划开始日期低温<br/>");
                      out.print("年<input type =\"text\" name=\"m_y1\" format=\"*N\" value=\""+m_y1+"\"/>");
                      out.print("月<input type =\"text\" name=\"m_m1\" format=\"*N\" value=\""+m_m1+"\"/>");
                      out.print("日<input type =\"text\" name=\"m_d1\" format=\"*N\" value=\""+m_d1+"\"/>");
                      out.print("<br/>");
                      String y2 = (cal.getTime().getYear()+1900)+"";
                      String m2 = (cal.getTime().getMonth()+1)+"";
                      String d2 = cal.getTime().getDate()+"";
                      out.print( "所要计划的天数<br/>" );
                      out.print( "天数<input type =\"text\" name=\"m_days\" value=\""+daycount+"\" format=\"*N\"/>" );
                      out.print( "<anchor>"+"确定" );
                      out.print( "<go href=\"planEnter.jsp\">" );
                      out.print( "<postfield name=\"y1\" value=\"$(m_y1)\"/>" );
                      out.print( "<postfield name=\"m1\" value=\"$(m_m1)\"/>" );
                      out.print( "<postfield name=\"d1\" value=\"$(m_d1)\"/>" ); 
                      out.print( "<postfield name=\"days\" value=\"$(m_days)\"/>" );
                      out.print( "<postfield name=\"itemtype\" value=\""+itemtype+"\"/>" );
                      out.print( "<postfield name=\"flag\" value=\""+flag+"\"/>" );
                      out.print( "<postfield name=\"brand\" value=\""+brand+"\"/>" );
                      out.print( "<postfield name=\"bascal\" value=\""+bascal+"\"/>" );
                      out.print( "<postfield name=\"number\" value=\""+number+"\"/>" );
                      out.print( "<postfield name=\"locid\" value=\""+locid+"\"/>" );
                      out.print( "<postfield name=\"_d\" value=\""+_d+"\"/>" );
                      out.print( "<postfield name=\"type\" value=\""+type+"\"/>");
                      out.print( "<postfield name=\"extcat8\" value=\""+extcat8+"\"/>");
                      out.print( "</go></anchor><br/>");
                }
                else
                {
                     for ( int i=0;i<daycount;i++)
                  {
                         cal.set(Integer.parseInt(y1),Integer.parseInt(m1)-1,Integer.parseInt(d1));
                         cal.add(Calendar.DATE,i);//默认是明天    
                         String year = (cal.getTime().getYear()+1900)+"";
                         String month = (cal.getTime().getMonth()+1)+"";
                         String date = cal.getTime().getDate()+"";
                         _date = year+"-"+month+"-"+date;
                         str = "<anchor>"+_date;
                         str += "<go href=\"planEnter.jsp\">";
                         str += "<postfield name=\"brand\" value=\""+brand+"\"/>";
                         str += "<postfield name=\"itemtype\" value=\""+itemtype+"\"/>";
                         str += "<postfield name=\"flag\" value=\""+flag+"\"/>";
                         str += "<postfield name=\"_date\" value=\""+_date+"\"/>";
                         str += "<postfield name=\"bascal\" value=\""+bascal+"\"/>";
                         str += "<postfield name=\"number\" value=\""+number+"\"/>";
                         str += "<postfield name=\"locid\" value=\""+locid+"\"/>";
                         str += "<postfield name=\"type\" value=\""+type+"\"/>";
                         str += "<postfield name=\"daycount\" value=\""+daycount+"\"/>";
                         str += "<postfield name=\"extcat8\" value=\""+extcat8+"\"/>";
                         str += "</go></anchor><br/>";
                         cal = Calendar.getInstance();//此处必须再重新创建cal实例，否则日期会叠加在一起                         
                         out.print(str);

                  }                
                }
            
            }
              out.print( "<a href=\"checkType.jsp?number="+number+"&amp;locid="+locid+"&amp;curdat="+curdat+"&amp;type="+type+"\">返回常低温</a><br/>");
              out.print( "<a href=\"main.jsp\">返回主页</a>");
              out.print( "</p></card></wml>");
           }
          }
          catch(EAException e)
          {
            out.println(e.toString());
            out.print( "</p>");
          }
 %>         
 
 </body>
 </html>