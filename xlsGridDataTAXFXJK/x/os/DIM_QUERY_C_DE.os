function x_DIM_QUERY_C_DE(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var tag = new JavaPackage("com.xlsgrid.net.tag");
var xmldsform = new tag.XmlDSForm();
var EAfunc = new pubpack.EAFunc();
//作为.sp服务时的入口	
//预定义变量：request,response
function Response()
{
	var db = null;
      var ret= "";
      var sql = "";
      var _sql = "";
      var ds = null;
      var _ds = null;
      var GHtml = "";

      var ret= "";
      try {
            db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
            var toolbarhtml = "";
            /*
            _sql = "select seq,id,name,note,vdim from 
            	    (
		            select 0 seq,id,name,NOTE,decode(instr(vdim,','),0,vdim,substr(vdim,0,instr(vdim,',')-1)) vdim 
		            	from dim_topic where refmod='"+FORMGUID+"' and id = '"+TOPICID+"' and sytid = '"+SYTID+"' 
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
            */
            _sql = "select rownum seq, a.* from (select rownum seq,id,name,vdim from dim_topic where refmod ='"+FORMGUID+"' and sytid = '"+SYTID+"' and refid is null order by lvl,id ) a";
            _ds = db.QuerySQL(_sql);
            var firsttopic = "";
            for(var r = 0;r < _ds.getRowCount();r ++)
            {	//有多少个主题
            	    var topic = _ds.getStringAt(r,"ID");
            	    var vdim = _ds.getStringAt(r,"vdim");
            	    var name = _ds.getStringAt(r,"name");
            	    var bkimg = "background='xlsgrid/images/xlsgrid/tab.bg.off.grid.gif'";
            	   
            	    if ( r == 0 ) {
            	    	bkimg = "background='xlsgrid/images/xlsgrid/tab.bg.on.grid.gif'";firsttopic  = topic ; 
            	    }

            	    	
	            toolbarhtml+="<td width='150' id='page"+(r+1)+"' bgcolor='#336699' height='31' align='center' "+bkimg +" style=\"border-right: 1px solid #808080; border-top: 1px solid #808080; border-bottom: 1px solid #808080\"><p align='center'>
			<a href='javascript:show_right("+(r+1)+",\""+topic +"\");'>	<font color='#333333'>"+name+"</font></a>　</td>\r";
							              
		
	   }
	   toolbarhtml+="<td  height='31' bgcolor='#EEEEEE' align='center'  style='border-bottom: 1px solid #808080'><p align='left'>
			&nbsp;<div id='pathtip'></div></td>\r"; //

	   // 生成查询条件
	   sql = "select id ,name ,refmod ,control ,keyval ,defval ,wher ,seq 
            	   from
            		   (
            		select id id,name,refmod ,control ,keyval,defval,wher,seq
			 from dim_dim
			where refmod='"+FORMGUID+"'
			  and NVL(control,' ') <> 'DATEBOX' 
			union all
			select 'STA'||id id,'开始'||name name,refmod ,control ,keyval ,'' defval,'' wher,0 seq 
			 from dim_dim
			where refmod='"+FORMGUID+"'
			  and control = 'DATEBOX' 
			union all
			select 'END'||id id,'截止'||name name, refmod,control, keyval,'' defval,'' wher,1 seq			
		        from dim_dim
			where refmod='"+FORMGUID+"'
			  and control = 'DATEBOX' 
		 )
	         order by seq";

		    ds = db.QuerySQL(sql);
	            ret += "<table border='0' width='100%' cellspacing='0' cellpadding='0' height='100%'>

				<tr>
					<td height=30 align = 'left'  background=\"xlsgrid/images/xlsgrid/tab.bg.on.grid.gif\" style=\"font-size:14px\"  style=\"border-top:1px solid #80B7E0;cursor:pointer;\" \"> 
					<table cellspacing=0 cellpadding=0 border=\"0\" width=\"100%\">	<tr>		<td width=\"24\" align=center><img src='xlsgrid/images/toolbar/search.gif' border=0></td>		<td align=\"left\"><font size=\"2px\" color = \"#000080\">组合查询条件</font></font></td>	</tr></table>
					</td>
				</tr>
				<tr ";
		    ret += "><td valign=top>";
	            ret +="<form name = f1 method='post' action='show.sp?grdid=BIMain' Target='_blank'> \n";
	            var resetstr = "";
	            for ( var i=0;i<ds.getRowCount();i++ ) {
	            	resetstr+= "try{document.all('"+ds.getStringAt(i,"ID")+"').value='';}catch(e){}";
	            }
	            GHtml = xmldsform.HtmlForm(request,ds,"NAME","ID","KEYVAL","","Y","Y","","WHER","CONTROL","0","50");
	            ret += GHtml;
	            ret += "<input type = 'hidden' id = 'sytid' name = 'sytid' value = "+SYTID+">
	            		    	<input type = 'hidden' id = 'row' name = 'row' value =1>
	            		    	<input type = 'hidden' id = 'topic' name = 'topic' value = ''>
	            		    	<input type = 'hidden' id = 'FORMGUID' name = 'FORMGUID' value = "+FORMGUID+">
	            		    	     				
	            		    	<table width='100%' border='0' cellpadding='0' cellspacing='1' >
		            		<tr>
	            		    <td></td>
	            		    <td align = 'center'><input type = 'submit' value = ' 查 询 ' >&nbsp;<input type = 'button' value = ' 重 置 ' onclick='javascript:f_reset();' ></td>
	            		   
	            		</tr>
	            	    </table>
	            	 </form>
	            	 </td>
	            	 </tr>";
	        
	   ret += "</table> ";	

	  
	  var lefthtml = ret; ret= "";
	
	    ret="	<html>
	    			<LINK rel=stylesheet type=text/css HREF='xlsgrid/css/main.css'>
	    			<script language='javascript' src='xlsgrid/js/main.js' ></Script>
	    			<script language='javascript' src='xlsgrid/images/flash/FusionCharts.js' ></Script>
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
   							leftTd.style.width = 220;
						}
					}
					function switchRBar()
					{
						if (RPoint.innerText==4)
						{
							RPoint.innerText=3;
							rightTd.style.display ='none'; 
    							rightTd.style.width = 10;
						}
						else
						{
							RPoint.innerText=4;
							rightTd.style.display=''; 
   							rightTd.style.width = 400;
						}
					}

					function switchLangBar(){
					        if (document.all('w_langbar').style.display!='none'){
					          document.all('w_langbar').style.display='none';
					          langtext.innerHTML = '&nbsp;动态新闻>> &nbsp';
					        }
					        else{
					          document.all('w_langbar').style.display='';
					          langtext.innerHTML = '<<&nbsp;';
					
					        }
					      }
					      function hideLangBar(){
					        if (document.all('w_langbar').style.display!='none'){
					          switchLangBar();
					        }
					      }
					      function showLangBar(){
					        if (document.all('w_langbar').style.display=='none'){
					          switchLangBar();
					        }
					      }
					      function switchScrollTextBar(){
					
					        if (document.all('w_scrolltextbar').style.display!='none'){
					        
					          document.all('w_scrolltextbar').style.display='none';
					          scrolltext.innerHTML = '&nbsp;动态通知>> &nbsp';
					        }
					        else{
					       
					          document.all('w_scrolltextbar').style.display='';
					          scrolltext.innerHTML = '<<&nbsp;';
					
					        }
					      }
					      function hideScrollTextBar(){
					        if (document.all('w_scrolltextbar').style.display!='none'){
					          switchLangBar();
					        }
					      }
					      function showScrollTextBar(){
					        if (document.all('w_scrolltextbar').style.display=='none'){
					          switchLangBar();
					        }
					      }
					      
					      function SetToolbar(url){
					        _toolbar.location=url;
					      }
					      
					      
					      var curPage = 1; 
					       // 切换页面的触发事件
					    function show_right(rnPage,topic){
					      nPage=rnPage;
					      document.all('page'+curPage).background='xlsgrid/images/xlsgrid/tab.bg.off.grid.gif';
					      document.all('page'+nPage).background='xlsgrid/images/xlsgrid/tab.bg.on.grid.gif';
					    

					      document.all.f1.topic.value=topic;
					      document.all.f1.row.value=rnPage;

					      f1.submit();
					     
					      document.all('page'+curPage).style.borderBottomStyle ='solid';
					      document.all('page'+nPage).style.borderBottomStyle ='none';
					      curPage = nPage;
					    }	
					    var G_FIRSTTOPIC = '"+firsttopic +"';
					    //修改查询条件的值
					    function f_chgvalue(paramid, val ) {
					    	try{document.all(paramid).value = val;}catch ( e ) {alert ( e ) ;}
					    }	
					    function f_submit( ){
					    	 f1.submit();

					    }	
					    function f_reset()
					    {
					    	"+resetstr+"
					    
					    }
//					    var g_chart1 = new FusionCharts('xlsgrid/images/flash/MSColumn3D.swf', 'ChartId1', '400', '300');
//					    var g_chart2 = new FusionCharts('xlsgrid/images/flash/Pie3D.swf', 'ChartId2', '400', '300');
										   //chart1.setDataURL('xlsgrid/images/flash/MSColumn3D.xml');		   
										
										   //chart2.setDataURL('xlsgrid/images/flash/Pie3D.xml');		   
										   //chart2.render('chartdiv2');
										
					    //更新分析图1
					    var chartxml = '':
					    function f_updatechart1(xml){
					    	    var chart1 = new FusionCharts('xlsgrid/images/flash/MSColumn3D.swf', 'ChartId1', '400', '300'); 
					            chart1.setDataXML(xml);
					            
					            chart1.render('chartdiv1');
					            chartxml  = xml;
					    }
					    //更新分析图1
					    function f_updatechart2(xml){
					    	    //var chart2 = new FusionCharts('xlsgrid/images/flash/Pie3D.swf', 'ChartId2', '400', '300'); 
					            //chart2.setDataXML(xml);
					            //chart2.render('chartdiv2');
					    }
					    function f_showpath(tip){
					    	document.all('pathtip').innerHTML= tip;
					    
					    }
					    function f_chgchart()
					    {
					    	var swf = document.all('chgchart').value;
					    	alert ( swf );
					    	var chart1 = new FusionCharts('xlsgrid/images/flash/'+swf+'.swf', 'ChartId1', '500', '300'); 
					            chart1.setDataXML(chartxml  );
					            
					            chart1.render('chartdiv1');
					    }

				</script>
				</head> 
				<body  topmargin='0' leftmargin='0' scroll=no onload='javascript:show_right(1,G_FIRSTTOPIC );'>
					<table border='0' width='100%' cellspacing='0' cellpadding='0' height='100%'>
						<tr>
							<td id=leftTd width=220 background=xlsgrid/images/tree_bg.jpg>
			       					 
			       					 "+lefthtml +"		  
							</td>
			    				<TD  class=navPoint id=LPoint bgColor=#F3FCF6 onclick=switchLBar() style='border:1px solid #CCCCCC;WIDTH: 3pt;vertical-align: middle;'>
			      					3
			    				</TD>
							<td>
								<table border='0'  width='100%' cellspacing='0' cellpadding='0' height='100%'>
								<tr height=25>
								<td bgcolor='#CEDFF2' background=xlsgrid/images/xlsgrid/tab.bg.grid.png>
								   <table border='0'  cellspacing='0' cellpadding='0' height='100%' width='100%'>
								   <tr>"+toolbarhtml+"
							            </tr>
								  </table>
								</td>
								</tr>

								<tr><td>
									<table width=100% height=100% border='0' cellspacing='0' cellpadding='0' >
									<tr><td >
					        			<IFRAME name='_right' id='_right' frameBorder=0 width='100%' height='100%' border='0'
					        				scrolling='yes' style='border: 0px solid #808080' >
					        			</IFRAME>	
					        			</td>
					        			<TD  class=navPoint id=RPoint bgColor=#EEEEEE onclick=switchRBar() style='border-right: 1px solid #CCCCCC; border-left: 1px solid #CCCCCC; WIDTH: 3pt;vertical-align: middle;'>
						      					4
						    				</TD>

					        			<td id=rightTd width=400>
					        				<table width=100% height=100% border='0' cellspacing='0' cellpadding='0' >
					        				<tr><td height=30%>
					        				<p align=center>选择分析图类型</p>
					        				<p align=center><select id=chgchart size='1' name='chgchart' onchange='f_chgchart();' style='border: 1px solid #808080'>
					        				<option value='Pie'>饼图</option>
					        				</select>
					        				</p>
					        				</td></tr>

					        				<tr><td height=70% valign=top>

					        				<div id='chartdiv1' align='center'> 对比图 </div>
								      		
										</td></tr>
										
					        			</td>
				        			
				        			</td></tr>

				        			</table>		  
							</td>
						</tr>
					</table>
				</body>
			</html>
	";

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