function x_iconlist(){var pub = new JavaPackage("com.xlsgrid.net.pub");

function newframewin(sb,title,contentsb)
{
sb.append("<table bgcolor=\"#FFFFFFFF\" width=\"100%\" height=\"100%\" id=\"table3\" cellspacing=\"5\">\n");
sb.append("  <tr><td height=\"142\" bgcolor=\"#d1e2fe\" valign=\"top\" width=\"100%\">\n"); 
sb.append("  <table width=\"100%\" ID=\"Table5\"><tr><td width=\"31\">\n"); 
sb.append("  <img border=\"0\" src=\"xlsgrid/images/my/bartop.jpg\" width=\"30\" height=\"14\"></td>\n"); 
sb.append("  <td align=\"center\"><font color=\"#014e82\">\n"); 
sb.append(title); 
sb.append("  </font></td><td width=\"32\" align=\"right\">\n"); 
sb.append("  <img border=\"0\" src=\"xlsgrid/images/my/bartop.jpg\" width=\"30\" height=\"14\"></td>\n"); 
sb.append("  </tr></table><div id=\"Div1\" width=\"100%\" height=\"100%\">\n"); 
sb.append(contentsb.toString());
sb.append("  </div></td></tr></table>");
}

var titlecls="";
function newwin(sb,title,contentsb)
{
sb.append("<TABLE height=\"100%\" cellSpacing=\"0\" width=\"100%\" border=\"0\"><TBODY><TR>\n");
sb.append("<TD style=\"BORDER-RIGHT: #3a77ba 1px solid; BORDER-TOP: #3a77ba 1px solid; BORDER-LEFT: #3a77ba ");
sb.append("1px solid; BORDER-BOTTOM: #3a77ba 1px solid\" bgColor=\"#ffffff\" height=\"23\">\n");
sb.append("<TABLE width=\"100%\" height=\"100%\"><TR><TD width=154>&nbsp;");
sb.append("<IMG height=\"9\" src=\"xlsgrid/images/my/collapse.gif\" width=\"9\" border=\"0\">&nbsp;<span class=\""+titlecls+"\">");
sb.append(title);
sb.append("</span></TD><TD><IMG height=15 src=\"xlsgrid/images/my/barright.jpg\" width=22 ");
sb.append("align=right border=0></TD></TR></TABLE>");
sb.append("</TD></TR>\n");
sb.append("<TR><TD style=\"BORDER-RIGHT: #3a77ba 1px solid; BORDER-LEFT: #3a77ba 1px solid; BORDER-BOTTOM: #3a77ba 1px solid\"");
sb.append("vAlign=\"top\" bgColor=\"#ffffff\"><FONT color=\"#014e82\">");
sb.append(contentsb.toString());
sb.append("</TD></TR></TBODY></TABLE>");
}

function iconHelper(sb)
{
sb.append("<STYLE> .icon { vertical-align: middle; text-align:center; \n");//
sb.append("\tborder:2px solid #ffffff ;width: 100px; height:100px; }body{MARGIN: 0px 0px;OVERFLOW: auto;}</STYLE>\n"); 
sb.append("<script>function mouseover(sender){\n"); 
sb.append("  sender.style.border='2px solid #3a77ba';\n"); 
sb.append("  sender.style.cursor='hand';}\n"); 
sb.append("function iconclick(ev,newwin,url){\n"); 
sb.append("if(newwin==1 || ev.ctrlKey)window.open(url);\n"); 
sb.append("else window.location=url;}\n"); 
sb.append("function mouseout(sender){\n"); 
sb.append("  sender.style.border='2px solid #ffffff';}</script>");
}

function newicontable(sb,ds,cols)
{
sb.append("<div style=\"width=100%; height=100% overflow: scroll;\">");
sb.append("<TABLE>\n");
//var ds=new EADS();
var rc = ds.getRowCount();
var c=1.0*cols;
var i=-1;
for(var k=0;k<rc;k+=c)
{
  sb.append("\n<tr>");
  for(var j=0;j<c;j++)
  {
     i++;
     if(i<rc)
     {
        var url=ds.getStringAt(i,"url");
        if(url=="")
          url = "BillEntry.sp?grdid="+ds.getStringAt(i,"id");
        var newwin = 0;
        if(url.length()>0 && url.charAt(0)=="@")
        {
          url=url.substring(1);
          newwin=1;
        }
        sb.append("\n<td><div onmouseover=\"mouseover(this)\" onmouseout=\"mouseout(this);\" class=\"icon\" ");
        var iconfile=ds.getStringAt(i,"icon");
        if(iconfile=="")
          iconfile= "xlsgrid/images/icon/icon3.gif";
        sb.append("onclick=\"iconclick(event,"+newwin+",'%s')\">".format([url]));
        sb.append("<br><IMG src=\"%s\" border=\"0\"><BR>".format([iconfile]));
        sb.append(ds.getStringAt(i,"name"));
        sb.append("</div></td>");
      }
      else sb.append("\n<td><div class=\"icon\"></div></td>");
  }
  sb.append("\n</tr>");
}
sb.append("</tr></table></div>");
}

function getIconDs(request)
{
  var flag=pub.EAFunc.getRequestParam(request,"flag");
  var file = pub.EAFunc.getRequestParam(request,"file");
  if(flag==null && file==null) 
  	throw new Exception("no flag special the source table");
  if(file!=null)
  {
    //使用实例的中间件目录
    var root = pub.EAOption.dynaDataRoot;
    var str = pub.EAFunc.readFile(root+file);
    return new pub.EAXmlDS(str);
  }
  var where=pub.EAFunc.getRequestParam(request,"where");
  var sql = "select id,name,icon,url from %s ".format([flag]);
  if(where!=null && where !="")
    sql += "where %s".format([where]);
  var order=pub.EAFunc.getRequestParam(request,"order");
  if(order!=null && order!="")
    sql += "order by %s".format([order]);
  return pub.EADbTool.QuerySQL(sql);
}
//flag从param表或从中构造出来的视图名:
//     id作为识别号，name作为名称，refid作为图标，note作为url;url前加@符号，默认在新窗口打开
//where是过滤条件
//title是小标题
//title0是大标题
//mode是窗口类型：0是含外框
//cols是每行的图标数量
function Response()//request,response)
{
  var ds = getIconDs(request);
  var cols=pub.EAFunc.getRequestParam(request,"cols");
  if(cols==null || cols=="")
    cols=6;
  var sb=new java.lang.StringBuffer();
  iconHelper(sb);
  var cs = new java.lang.StringBuffer();
  newicontable(cs,ds,cols);
  var ws = new java.lang.StringBuffer();
  var title=pub.EAFunc.getRequestParam(request,"title");
  if(title==null) title = "";
  newwin(ws,title,cs);
  var mode = pub.EAFunc.getRequestParam(request,"mode");
  var title0=pub.EAFunc.getRequestParam(request,"title0");
  if(title0==null) title0= title;
  if(mode=="0") 
   newframewin(sb,title0,ws);  
  else sb.append(ws);
  return sb.toString();
}

function addHeaderHtml(mwobj,request,sb,usrinfo)
{
  mwobj.setHtmlView("y");
}

}