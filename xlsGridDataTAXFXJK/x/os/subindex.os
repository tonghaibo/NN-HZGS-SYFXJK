function x_subindex(){
var pub = new JavaPackage("com.xlsgrid.net.pub");

//从指定的视图中构造子系统入口门户界面
//flag从param表或从中构造出来的视图名:
//     id作为识别号，name作为名称，refid作为图标，note作为url;url前加@符号，默认在新窗口打开
//      id＝title的记录作为标题，而不是模块页签。
//where是过滤条件： where=id='demo'
//order是排序条件： order=id desc

function Response()
{
  var flag=pub.EAFunc.getRequestParam(request,"flag");
  if(flag==null) return "请提供flag参数，指定提供子系统信息的视图名称。";
  var where=pub.EAFunc.getRequestParam(request,"where");
  var sql = "select id,name,icon,url from %s ".format([flag]);
  if(where!=null && where !="")
    sql += "where %s".format([where]);
  var order=request.getParameter("order");
  if(order!=null && order!="")
    sql += " order by %s".format([order]);
  var ds = pub.EADbTool.QuerySQL(sql);
  
  var sb = new java.lang.StringBuffer();
  buildStyle(sb);
  buildUI(sb,ds);
  //注意：设置 分类 为 COMFUNC，以保证客户端脚本有效。
  sb.append("<SCRIPT language=jscript src=\"xlsgrid/js/x/subindex.djs\"></SCRIPT>");
  
  return sb.toString();
}

function buildStyle(sb)
{// width:140px; 
  sb.append("<style>.tab {height:31px; text-align:center; vertical-align:middle;background:#336699;\n");
  sb.append("FONT-SIZE: 12px; color: #FFFFFF; CURSOR: hand; background-image: url('xlsgrid/images/xlsgrid/tab.bg.off.gif');}");
  sb.append("span{FONT-SIZE: 12px; color: #FFFFFF; CURSOR: hand; } body{OVERFLOW-X: auto; OVERFLOW-Y: auto; MARGIN: 0px 0px;}</style>");
}

function buildUI(tb,ds)
{
  var rc = ds.getRowCount();
  var modulecount=rc;
  var sb = new java.lang.StringBuffer();
  sb.append("<tr>");
  var c=0;
  var headtitle="";
  var hastitle=false;
//  var firsturl="";
//  var urlinit=false;
  for(var i=0;i<rc;i++)
  {
    var id=ds.getStringAt(i,"id");
    var title=ds.getStringAt(i,"name");
    if(id=="title")
    {
      var ticon=ds.getStringAt(i,"icon");
      if(ticon=="")
        ticon = "xlsgrid/images/xlsgrid/title.jpg";
      tb.append(getHeadHtm(ticon,rc-1));
      modulecount--;
      headtitle=title;
      hastitle=true;
    }
    else
    {
      var url=ds.getStringAt(i,"url");
      if(url.length()>0 && url.charAt(0)=="@")
         url=url.substring(1);
     /* if(!urlinit)
      {
        urlinit=true;
        firsturl=url;
      }*/
      sb.append("<td class=\"tab\" onclick=showpage("+c+",\""+url+"\") id=tab"+c+">");
      sb.append(title);
      sb.append("</td>");
      c++;
    }
  }
  sb.append("</tr>");
  if(!hastitle)
    tb.append(getHeadHtm("xlsgrid/images/xlsgrid/title.jpg",rc));
  tb.append(sb);
  
  tb.append(getmsgRow(headtitle,modulecount));
  
  tb.append("<tr><td colspan=\""+(modulecount+1)+"\" with=\"100%\" height=\"100%\"><IFRAME with=\"100%\" height=\"100%\" name=\"_page\" id=\"_page\" frameBorder=\"0\" src=\"\n");
  //tb.append(firsturl);
  tb.append("\" width=\"100%\" height=\"100%\" scrolling=\"auto\"></IFRAME></td></tr>");
  
  tb.append("</table>");
}

function getHeadHtm(titleicon,modulecount)
{
      var sb = new java.lang.StringBuffer();
      sb.append("<table height=\"100%\" cellSpacing=\"0\" cellPadding=\"0\" width=\"100%\"><tr><td bgcolor=\"#336699\" width=\"376\" rowspan=\"2\">\n");
      sb.append("<img border=\"0\" src=\""+titleicon+"\"></td>\n"); 
      sb.append("<td width=\"999\" bgcolor=\"#2874C8\" height=\"19\" align=\"right\" colspan=\""+modulecount+"\" valign=\"bottom\">\n"); 
      sb.append("<a href=\"../mydesktop.jsp\"><font color=\"#FFFF00\">我的桌面</font></a></td></tr>");
      return sb.toString();
}

function getmsgRow(msg,modulecount)
{
      var sb = new java.lang.StringBuffer();
      
      sb.append("<tr height=\"21\"><td colSpan=\"6\">\n");
      sb.append("<table style=\"FONT-SIZE: 12px; BACKGROUND: #4b9fd9; COLOR: #ffffff\" height=\"100%\" width=\"100%\">\n"); 
      sb.append("<tr><td align=\"left\" width=\"190\">\n"); 
      if(msg=="")
      {
      sb.append("&nbsp;<span onclick=\"history.go(-1);\">上一步</span>\n"); 
      sb.append("&nbsp;|&nbsp;<span onclick=\"history.go(1);\">下一步</span>\n"); 
      sb.append("&nbsp;|&nbsp;<span onclick=\"_page.location.reload();\">刷新</span>&nbsp;|&nbsp;\n"); 
      }
      sb.append("</td><td align=\"center\"><font id=\"usrinfo\" color=\"#ffffcc\" size=\"4\">\n");
      if(msg=="")
      {
        var usr = web.EASession.GetLoginInfo(request);
        msg = usr.getAccshtnam()+"欢迎您: "+usr.getUsrnam();
      }
      sb.append(msg);
      sb.append("</font></td><td align=\"right\"><span onclick='if(confirm(\"确实要关闭吗？\")) window.close();'>关闭&nbsp;</span></td>\n"); 
      sb.append("</tr></table></td></tr>");
      return sb.toString();
}



}