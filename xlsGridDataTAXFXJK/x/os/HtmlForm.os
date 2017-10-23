function x_HtmlForm(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var tag = new JavaPackage("com.xlsgrid.net.tag");
var xmldsform = new tag.XmlDSForm();
var EAfunc = new pubpack.EAFunc();
//作为.sp服务时的入口
//预定义变量：request,response
function Response()
{
 //     var code = request.getParameter("CODE");
      var db = null;
      var ret= "";
      try {
            db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
            var sql = "select id,name,refmod,control,keyval,defval,wher,seq
            		 from
            		 (
	            		select id,name,refmod,control,keyval,defval,wher,seq   
				 from dim_dim
				where refmod=(select refmod from dim_topic where sytid='"+SYTID+"' and id='"+TOPICID+"')
				  and control <> 'DATEBOX' 
				union all
				select 'STA'||id id,'开始'||name name,refmod,control,keyval,'' defval,'' wher,0 seq   
				 from dim_dim
				where refmod=(select refmod from dim_topic where sytid='"+SYTID+"' and id='"+TOPICID+"')
				  and control = 'DATEBOX' 
				union all
				select 'END'||id id,'截止'||name name,refmod,control,keyval,'' defval,'' wher,1 seq   
				 from dim_dim
				where refmod=(select refmod from dim_topic where sytid='"+SYTID+"' and id='"+TOPICID+"')
				  and control = 'DATEBOX' 
			)
			order by seq";
            var ds = db.QuerySQL(sql);
            ret += "<LINK rel=stylesheet type=text/css HREF=\"xlsgrid/css/main-right.css\">";
            ret +="<form method='post' action='show.sp?grdid=DIMREP_PC' Target='_right'> \n";
            ret += xmldsform.HtmlForm(request,ds,"NAME","ID","KEYVAL","","Y","Y","","WHER","CONTROL","0","50");
            ret += "<br>";
            ret += "<br>";
            ret += "<table width='100%' border='0' cellpadding='0' cellspacing='1' >
            		<tr>
            		    <td>
            		    	<input type = 'hidden' id = 'topic' name = 'topic' value = "+TOPICID+">
            		    </td>
            		</tr>
            		<tr>
            		    <td>
            		    	<input type = 'hidden' id = 'sytid' name = 'sytid' value = "+SYTID+">
            		    </td>
            		</tr>
            		<tr>
            		    <td></td>
            		    <td align = 'right'><input type = 'submit' value = '查询' ></td>
            		    <!--
          		    <td align = 'right'><input type = 'button' value = '查询' onclick = \"window.open('show.sp?grdid=DIMREP_PC&topic="+TOPICID+"&sytid="+SYTID+"','_right');\"></td>
          		    -->
            		</tr>
            	    </table>
            	 </form>";
            ret = EAfunc.Replace(ret,"000000","FFFFFF");
      }
      catch ( ee ) {
            db.Rollback();
            throw new pubpack.EAException ( ee.toString() );
      }
      finally {
            if (db!=null) db.Close();
      }
      return ret ;
}
}