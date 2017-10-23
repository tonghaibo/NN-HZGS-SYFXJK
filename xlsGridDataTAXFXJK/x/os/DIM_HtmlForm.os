function x_DIM_HtmlForm(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
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
      var sql = "";
      var _sql = "";
      var ds = null;
      var _ds = null;
      var GHtml = "";
      var sql_view = "";
      //"+_ds.getRowCount()+"
      try {
            db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
            sql_view += "create or replace view v_dimtopic as \n";
            _sql = "select seq,id,name,note,vdim from 
            	    (
		            select 0 seq,id,name,NOTE,decode(instr(vdim,','),0,vdim,substr(vdim,0,instr(vdim,',')-1)) vdim from dim_topic where refmod='"+FORMGUID+"' and id = '"+TOPICID+"' and sytid = '"+SYTID+"' 
	            	    union all
	            	    select rownum seq,id,name,NOTE,vdim
	            	      from 
	            	      (
	            	    		select id,name,NOTE,decode(instr(vdim,','),0,vdim,substr(vdim,0,instr(vdim,',')-1)) vdim from dim_topic where refmod='"+FORMGUID+"' and id <> '"+TOPICID+"' and sytid = '"+SYTID+"' 
	            	    		order by id
	            	      )
	            )
	            order by seq
             	   ";
            _ds = db.QuerySQL(_sql);
            ret += "<script language = \"javascript\">
	    	    	function showInfo(str)
	    	    	{
	    	    		for(var i = 0;i <  "+_ds.getRowCount()+";i ++)
	    	    			document.getElementById(\"topic\"+i).style.display = 'none';
	    	    		document.getElementById(str).style.display = 'block';
	    	    	}
	    	    </script>
	    	   ";
	    ret += "<LINK rel=stylesheet type=text/css HREF=\"xlsgrid/css/main.css\"> \n";
	    ret += "<script language='javascript' src='xlsgrid/js/main.js' ></Script> \n";
	    ret +="<body style=\"background-color: #FFFFFF\">";
	    ret += "<table width=100% cellspacing=0 cellpadding=0 border=\"0\"> \n";
            for(var r = 0;r < _ds.getRowCount();r ++)
            {
            	    var topic = _ds.getStringAt(r,"ID");
            	    var vdim = _ds.getStringAt(r,"vdim");
            	    var name = _ds.getStringAt(r,"name");
	            sql = "select id ,name ,refmod ,control ,keyval ,defval ,wher ,seq 
	            	   from
            		   (
	            		select id||"+r+" id,name,refmod ,control ,keyval,defval,wher,seq
				 from dim_dim
				where refmod=(select refmod from dim_topic where sytid='"+SYTID+"' and id='"+topic+"' )
				  and control <> 'DATEBOX' 
				union all
				select 'STA'||id||'"+r+"' id,'开始'||name name,refmod ,control ,keyval ,'' defval,'' wher,0 seq 
				 from dim_dim
				where refmod=(select refmod from dim_topic where sytid='"+SYTID+"' and id='"+topic+"' )
				  and control = 'DATEBOX' 
				union all
				select 'END'||id||'"+r+"' id,'截止'||name name, refmod,control, keyval,'' defval,'' wher,1 seq			
			        from dim_dim
				where refmod=(select refmod from dim_topic where sytid='"+SYTID+"' and id='"+topic+"' )
				  and control = 'DATEBOX' 
			 )
		         order by seq";
//		         throw new Exception(sql);
		    ds = db.QuerySQL(sql);
	            ret += "
				<tr>
					<td height=25 align = 'left'  background=\"xlsgrid/images/title-bar-bk.jpg\" style=\"font-size:14px\"  style=\"border-top:1px solid #80B7E0;cursor:pointer;\" onclick=\"showInfo('topic"+r+"')\"> 
					<table cellspacing=0 cellpadding=0 border=\"0\" width=\"100%\">	<tr>		<td width=\"24\" align=center><img src='xlsgrid/images/toolbar/search.gif' border=0></td>		<td align=\"left\"><font size=\"2px\" color = \"#000080\">"+_ds.getStringAt(r,"NAME")+"</font></font></td>	</tr></table>
					</td>
				</tr>
				<tr id = topic"+r+" 
			    ";
		  if(r > 0)
			 ret +=  " style=\"display:none;\"><td>";
		  else
		  	ret += "><td>";
//		  ret+=" <font color='#888888'>　"+_ds.getStringAt(r,"NOTE")+"</font>";

	            ret +="<form name = f_"+r+" method='post' action='show.sp?grdid=DIMREP_PC' Target='_right'> \n";
	            GHtml = xmldsform.HtmlForm(request,ds,"NAME","ID","KEYVAL","","Y","Y","","WHER","CONTROL","0","50");
	            ret += EAfunc.Replace(GHtml,"f1","f_"+r);

	            ret += "<input type = 'hidden' id = 'sytid' name = 'sytid' value = "+SYTID+">
	            		    	<input type = 'hidden' id = 'row' name = 'row' value = "+r+">
	            		    	<input type = 'hidden' id = 'topic' name = 'topic' value = "+topic+">
	            		    	<input type = 'hidden' id = 'FORMGUID' name = 'FORMGUID' value = "+FORMGUID+">
	            		    	<table width='100%' border='0' cellpadding='0' cellspacing='1' >
		            		<tr>
	            		    <td></td>
	            		    <td align = 'center'><input type = 'submit' value = ' 查 询 ' ></td>
	            		    <!--
	          		    <td align = 'right'><input type = 'button' value = ' 查 询 ' onclick = \"window.open('show.sp?grdid=DIMREP_PC&topic="+TOPICID+"&sytid="+SYTID+"','_right');\"></td>
	          		    -->
	            		</tr>
	            	    </table>
	            	 </form>
	            	 </td>
	            	 </tr>";
	        if(r > 0)
	        	sql_view += "union all \n";
		sql_view += "select '"+r+"' r,'"+FORMGUID+"' formguid,'"+topic+"' topic,'"+name+"' name,'"+SYTID+"' sytid,'"+vdim+"' vdim from dual \n";
	   }
	   ret += "</table> 
	   	  </body>";	
	  // ret = EAfunc.Replace(ret,"000000","FFFFFF");
	  db.ExcecutSQL(sql_view);
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