function x_selectKey(){
var pub = new JavaPackage("com.xlsgrid.net.pub");

//ҳ��BODY������Ϻ��¼�
//sb������bodyԪ�ؼ�ǰ���head����
//bodysb������body��innerHTML
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
{
  sb.append("<table height=100% width=100%><tr><td width=200>");
  bodysb.append("</td><td></td></tr></table>");
}

//�滻SQL����
function replaceParam(mwobj,request,sql)
{
  if(sql=="--ossql")
  {
    //todo: �������ݿ����ͷ��ز�ͬsql
    return "select table_name from(\n" +
	"select table_name from sys.user_tab_columns where column_name='ID'\n" + 
	"union all\n" + 
	"select table_name from sys.user_tab_columns where column_name='NAME'\n" + 
	") group by table_name  having count(*)=2";
  }
}


//��Ϊ.sp����ʱ�����
//Ԥ���������request,response
function Response()
{
    var sql= "select table_name �ؼ��� from(\n" +
	"select table_name from sys.user_tab_columns where column_name='ID'\n" + 
	"union all\n" + 
	"select table_name from sys.user_tab_columns where column_name='NAME'\n" + 
	") group by table_name  having count(*)=2";
   var ds = pub.EADbTool.QuerySQL(sql);
//   var ds=new EADS();
   ds.AddRow(-1);
   ds.setValueAt(0,0,"DATE");
   var tag = new JavaPackage("com.xlsgrid.net.tag");
   var lv = new tag.XmlDSTable();
   return
   	"\n<div align=right onclick='window.close();'>\n<a href='xlsgrid/jsp/pages/dbEdit.jsp?flag=PARAM&grdid=PARAMDBEDIT&title=%BB%F9%B1%BE%B2%CE%CA%FD%B6%A8%D2%E5'>�����ֵ�ά��\n</a></div>"
   	//"\n<div align=right onclick='location.reload();'>\n<a href='#' target='_self'>ˢ�¹ؼ���\n</a></div>"
   	+ lv.HtmlTable(ds,"�ؼ���","itemClick('[%�ؼ���]')","")
   	+ "<script>\nfunction itemClick(item)\n{\nwindow.returnValue=item;\nwindow.close();\n}\n</script>"
   	;
}

}