function x_subindex(){
var pub = new JavaPackage("com.xlsgrid.net.pub");

//��ָ������ͼ�й�����ϵͳ����Ż�����
//flag��param�����й����������ͼ��:
//     id��Ϊʶ��ţ�name��Ϊ���ƣ�refid��Ϊͼ�꣬note��Ϊurl;urlǰ��@���ţ�Ĭ�����´��ڴ�
//      id��title�ļ�¼��Ϊ���⣬������ģ��ҳǩ��
//where�ǹ��������� where=id='demo'
//order������������ order=id desc

function Response()
{
  var flag=pub.EAFunc.getRequestParam(request,"flag");
  if(flag==null) return "���ṩflag������ָ���ṩ��ϵͳ��Ϣ����ͼ���ơ�";
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
  //ע�⣺���� ���� Ϊ COMFUNC���Ա�֤�ͻ��˽ű���Ч��
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
      sb.append("<a href=\"../mydesktop.jsp\"><font color=\"#FFFF00\">�ҵ�����</font></a></td></tr>");
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
      sb.append("&nbsp;<span onclick=\"history.go(-1);\">��һ��</span>\n"); 
      sb.append("&nbsp;|&nbsp;<span onclick=\"history.go(1);\">��һ��</span>\n"); 
      sb.append("&nbsp;|&nbsp;<span onclick=\"_page.location.reload();\">ˢ��</span>&nbsp;|&nbsp;\n"); 
      }
      sb.append("</td><td align=\"center\"><font id=\"usrinfo\" color=\"#ffffcc\" size=\"4\">\n");
      if(msg=="")
      {
        var usr = web.EASession.GetLoginInfo(request);
        msg = usr.getAccshtnam()+"��ӭ��: "+usr.getUsrnam();
      }
      sb.append(msg);
      sb.append("</font></td><td align=\"right\"><span onclick='if(confirm(\"ȷʵҪ�ر���\")) window.close();'>�ر�&nbsp;</span></td>\n"); 
      sb.append("</tr></table></td></tr>");
      return sb.toString();
}



}