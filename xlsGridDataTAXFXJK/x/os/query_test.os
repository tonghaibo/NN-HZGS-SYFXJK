function x_query_test(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var tag = new JavaPackage("com.xlsgrid.net.tag");
var xmldsform = new tag.XmlDSForm();
//作为.sp服务时的入口	
//预定义变量：request,response
function Response()
{
//      var code = request.getParameter("CODE");
//      var db = null;
      var ret= "";
      try {
//            db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
	    ret="	<html>
				<head>
				<meta http-equiv='Content-Type' content='text/html; charset=gb2312'>
				<STYLE>
    							.navPoint {
						COLOR: #225f98; CURSOR: hand; FONT-FAMILY: 'Webdings'; FONT-SIZE: 9pt
						}
				</STYLE>
				<script>
					function switchLBar()
					{
						if (LPoint.innerText==3)
						{
							LPoint.innerText=4;
							leftTd.style.display ='none'; 
    							leftTd.style.width = 10;
						}
						else
						{
							LPoint.innerText=3;
							leftTd.style.display=''; 
   							leftTd.style.width = 200;
						}
					}
				</script>
				</head> 
				<body  topmargin='0' leftmargin='0' scroll=no>
					<table border='0' width='100%' cellspacing='0' cellpadding='0' height='100%'>
						<tr>
							<td id=leftTd width=200>
			       					 <IFRAME name='_left' id='_left' src='html_test.sp?TOPICID="+TOPICID+"&SYTID="+SYTID+"&FORMGUID="+FORMGUID+"'
			        					 frameBorder=0 width='100%' height='100%' border='0' 
			        					 scrolling='yes' style='border: 1px solid #808080' >
			       					 </IFRAME>			  
							</td>
			    				<TD class=navPoint id=LPoint bgColor=#C1E0FF onclick=switchLBar() style='WIDTH: 6pt;vertical-align: middle;'>
			      					3
			    				</TD>
							<td>
				        			<IFRAME name='_right' id='_right' src='show.sp?grdid=DIMREP_PC&topic="+TOPICID+"&sytid="+SYTID+"'
				        				frameBorder=0 width='100%' height='100%' border='0'
				        				scrolling='yes' style='border: 1px solid #808080' >
				        			</IFRAME>			  
							</td>
						</tr>
					</table>
				</body>
			</html>
	";

      }
      catch ( ee ) {
 //           db.Rollback();
            throw new pubpack.EAException ( ee.toString() );
      }
//      finally 
//      {
//            if (db!=null) db.Close();
//      }
      return ret ;
}

}