function x_LHTML1(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web");

var xmlpack = new JavaPackage ( "com.xlsgrid.net.xmldb");
var layoutpack = new JavaPackage ( "com.xlsgrid.net.layout");
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd");

var langpack = new JavaPackage ( "java.lang");

//WNDMOD �����ͣ�������չ�У�
//	_this.SetListValue(list1,"HTML","HTML");
//	_this.SetListValue(list1,"OS","OS�ű�");
//	_this.SetListValue(list1,"MW","�м������");	
//	_this.SetListValue(list1,"FRAME","�ڲ�FRAME");
//	_this.SetListValue(list1,"FRAMEGROUP","��ҳFRAME��");	
//	_this.SetListValue(list1,"SCROLLIMAGE","����ͼƬ");
//	_this.SetListValue(list1,"TOOLBAR","ϵͳĬ�Ϲ�����");		
//	_this.SetListValue(list1,"MENU","�˵���");	
//	_this.SetListValue(list1,"FLASH","��Ƶ��ʾ");	
//	_this.SetListValue(list1,"���","���(��׼)");
//	_this.SetListValue(list1,"�հױ��","�հױ��");
//
//WNDMOD ���ڷ��, DSMOD ������Դ ,WHEREBY ����, SORTBY ����,SQLTXT  SQL���, LAYCOL ������ ,LAYROW ������,MOREURL ÿҳ�м�¼��, OSMWID OS�м��, OSFUNC OS����,OSPARAM OS�����Ĳ���,IFRAMEURL IFRAME��URL,IFSCROLLBAR �Ƿ���ʾ������,HTMLGUID,MOREURL,OPENLAYID HTML
function GetBody(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	return _GetHTML(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
}
// HTML 
function _GetHTML(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	if (WNDMOD == "MENU") return  _GetOS1(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	if (WNDMOD == "LOGIN") return  _GetOS4(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	if (WNDMOD == "TOUBLELIST") return _GetList(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	if (WNDMOD == "texscoll") return _GetTextSColl(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	if (WNDMOD == "TITLEPAGE") return _GetTitlePage(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	if (WNDMOD == "IMGTEXT") return _GetImgText(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	if (WNDMOD == "SINGDIV") return _GetSingDiv(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
}

function _GetOS1(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
//EAImgBlob.sp?guid=AF00638627EB46608EABEFC53FC0164A 
//style=\"border: solid thin #FF8C69\" 
//onclick=\"window.location='"+url+"';\" 
var layid="L.sp?id="+id;//id��ȫ�ֱ����������ֱ��ʹ��
	var parent = new x_LHTML1();
	var html = "";
	var ds=db.QuerySQL("select * from ( select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' order by seqid)");
	html = 
	"<script >function showbgc(ids){document.getElementById(ids).background=\"EAImgBlob.sp?guid=D29CA9F07F7A45EE85790D9251472274\";}</script>"+
	"<script >function showbgc2(ids){document.getElementById(ids).background=\"\";}</script>"+
	"<table border=\"1\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\"><tr><td style=\"padding-left: 5px; padding-right: 5px\">"+	// ����һ��5pt��λ��
	"<table border=\"0\" width=\"100%\" height=\"50\"  style=\"border-collapse:collapse\" background=EAImgBlob.sp?guid=AF00638627EB46608EABEFC53FC0164A  ><tr>";
	for(var c = 0; c < ds.getRowCount(); c ++){
		var a=ds.getStringAt(c,"name");
		var url=ds.getStringAt(c,"url");
		var id ="mnu"+c;
		
		if(url!=layid){
		
		html += "<td valign=center align=center onclick=\"javascript:window.location='"+url+"';\" onmouseout=\"showbgc2('"+id+"')\" onmouseover=\"showbgc('"+id+"');\"  id="+id+" ><a href=\""+url+"\" style=\"text-decoration:none; \"><font color=#FFFFFF size=\"3\" >"+a+"</font></a></td>";
		}
		else{
		html += "<td valign=center align=center onclick=\"javascript:window.location='"+url+"';\"  id="+id+"   background=EAImgBlob.sp?guid=D29CA9F07F7A45EE85790D9251472274><a href=\""+url+"\" style=\"text-decoration:none; \"><font color=#FFFFFF size=\"3\" >"+a+"</font></a></td>";
		
		}
	}
	html += "</tr></table></td></tr></table>";
	return html;
}

//�����б�
function _GetList(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	
	var html = "";
	var sql = "select * from ( select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' "  ;
	if(WHEREBY!="" ) sql+= " AND " +WHEREBY;
	if(SORTBY!="" ) sql+= " "+SORTBY;
	else sql+= " order by crtdat desc ";
	if(LAYCOL !=""&& LAYROW!="" ) sql+=") where  rownum<"+LAYCOL+"*"+LAYROW;
	
	// "+WHEREBY +" "+SORTBY;
	var ds=db.QuerySQL(sql);
	html += "<table valign=\"top\">";
	html += "<tr>";
	var n = 0;
	var val = "";
	
	for (var r=0;r<LAYCOL;r++) {
		html += "<td valign=\"top\">";
		html +="<table>";
		for (var i=0;i<LAYROW;i++) {
			if (n < ds.getRowCount()) {
				val = ds.getStringAt(n,"name");
				var dat = ds.getStringAt(n,"crtdat");
				html +="<tr height=\"20\">";
				html +="<td>";
				html +="<table cellpadding=\"2\" cellspacing=\"0\">";
				html +="<tr>";
				if (ds.getStringAt(n,"icon") != "") {
					html +="<td width=\"30\">";
					html +="<img src=\""+ds.getStringAt(n,"icon")+"\" width=20 height=20/>";
					html +="</td>";
				}
				html +="<td style=\"border-bottom: 1px dotted #C0C0C0;\" >";
				var url = ds.getStringAt(n,"url") ;
				if(OPENLAYID!=""){
					url = "L.sp?id="+OPENLAYID+"&layhdrguid="+ds.getStringAt(n,"GUID");
				}
				
				if (ds.getStringAt(n,"url") != "") {
					html +="<a href=\""+url+"\" target=\""+ds.getStringAt(n,"target")+"\">"+val+"</a>";
				} else {
					html +=val;
				}
				html +="</td>";
				html +="</tr>";
				html +="</table>";
				html +="</td>";
				html +="</tr>";
			} else {
				break;
			}
			n++;
		}
		
		html +="</table>";
		html +="</td>";
	}
	html += "</tr>";
	html += "</table>";
	
	return html;
}

//��������
function _GetTextSColl(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	var html = "";
	var sql = "select * from ( select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' order by  seqid)"  ;
	var ds=db.QuerySQL(sql);
	
	html +="<div id=\"colee_bottom\" style=\"overflow:hidden;height:200px;width:400px;\">";
	html += "<div id=\"colee_bottom1\">";
	for (var r = 0; r < ds.getRowCount(); r ++) {
		var icon = ds.getStringAt(r,"icon");
		var name = ds.getStringAt(r,"name");
		var url = ds.getStringAt(r,"url");
		if (OPENLAYID != "") {
			url = "L.sp?id="+OPENLAYID+"&layhdrguid="+ds.getStringAt(r,"GUID");
		}
		if (url != "") {
			html += "<a target=\""+ds.getStringAt(r,"target")+"\" href=\""+url+"\">"+name+"</a><BR/>";
		} else {
			html += name;
		}
	}
	html += " <div id=\"colee_bottom2\"></div> ";
	html += "</div>";
	html += "<script>marqueeStart(2, \"up\");</script>";
	
	html += "<script>
			var speed=30
			var colee_bottom2=document.getElementById(\"colee_bottom2\");
			var colee_bottom1=document.getElementById(\"colee_bottom1\");
			var colee_bottom=document.getElementById(\"colee_bottom\");
//			colee_bottom2.innerHTML=colee_bottom1.innerHTML
			colee_bottom.scrollTop=colee_bottom.scrollHeight
			function Marquee2(){
			if(colee_bottom1.offsetTop-colee_bottom.scrollTop>=0)
			colee_bottom.scrollTop+=colee_bottom2.offsetHeight
			else{
			colee_bottom.scrollTop--
			}
			}
			var MyMar2=setInterval(Marquee2,speed)
			colee_bottom.onmouseover=function() {clearInterval(MyMar2)}
			colee_bottom.onmouseout=function() {MyMar2=setInterval(Marquee2,speed)}
		</script>";
	return html;
}

//��ҳ�б�
function _GetTitlePage(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	var html = "";
	var sql = "select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' order by crtdat desc "  ;
	var ds=db.QuerySQL(sql);
	
	html += "<script src=\"http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js\"></script>";
	html += "<script >
		    $(document).ready(function(){
		            $(\"ul li:gt(10)\").hide();//��ʼ����ǰ��4��������ʾ���������������ء�
		            var total_q=$(\"ul li\").index()+1;//������
		            var current_page=10;//ÿҳ��ʾ������
		            var current_num=1;//��ǰҳ��
		            var total_page= Math.round(total_q/current_page);//��ҳ��  
		            var next=$(\".next\");//��һҳ
		            var prev=$(\".prev\");//��һҳ
		            $(\".total\").text(total_page);//��ʾ��ҳ��
		            $(\".current_page\").text(current_num);//��ǰ��ҳ��
		             
		            //��һҳ
		            $(\".next\").click(function(){
		                if(current_num==total_page){
		                        return false;//���������ҳ���ͽ�����һҳ
		                    }
		                    else{
		                        $(\".current_page\").text(++current_num);//�����һҳ��ʱ��ǰҳ����ֵ�ͼ�1
		                        $.each($('ul li'),function(index,item){
		                            var start = current_page* (current_num-1);//��ʼ��Χ
		                            var end = current_page * current_num;//������Χ
		                            if(index >= start && index < end){//�������ֵ����start��end֮���Ԫ�ؾ���ʾ���������
		                                $(this).show();
		                            }else {
		                                $(this).hide(); 
		                            }
		                        });
		                    }
		            });
		            //��һҳ����
		            $(\".prev\").click(function(){
		                    if(current_num==1){
		                        return false;
		                    }else{
		                        $(\".current_page\").text(--current_num);
		                        $.each($('ul li'),function(index,item){
		                            var start = current_page* (current_num-1);//��ʼ��Χ
		                            var end = current_page * current_num;//������Χ
		                            if(index >= start && index < end){//�������ֵ����start��end֮���Ԫ�ؾ���ʾ�����������
		                                $(this).show();
		                            }else {
		                                $(this).hide(); 
		                            }
		                        });     
		                    }
		                     
		                })
		    })
		</script>";
	
	html += "<style>
		    .main{width:500px;zoom:1;margin:0 auto;}
		    .item{width:500px;overflow:hidden;}
		   
		    .clear{zoom:1;}
		    .clear:after{content:\"\";display:block;height:0;clear:both;visibility:hidden;}
		    
		    .page_btn{padding-top:20px;}
		    .page_btn a{cursor:pointer;padding:5px;border:solid 1px #ccc;font-size:12px;}
		    .page_box{float:right;}
		    .num{padding:0 10px;}
		</style>";
	
	
	html += "<div class=\"main\">";
	html += "<div class=\"item\">";
	html += "<ul class=\"clear\">";
	for (var r = 0; r < ds.getRowCount(); r ++) {
		var icon = ds.getStringAt(r,"icon");
		var name = ds.getStringAt(r,"name");
		var url = ds.getStringAt(r,"url");

		if (url != "") {
			url = "L.sp?id="+OPENLAYID+"&layhdrguid="+ds.getStringAt(r,"GUID");
			html += "<li><a target=\""+ds.getStringAt(r,"target")+"\" href=\""+url+"\">"+name+"</a></li>";
		} else {
			html += "<li>"+name+"</li>";
		}
	}
	html += "</ul>";
	html += "</div>";
	html += "<div class=\"page_btn clear\">";
	html += "<span class=\"page_box\">";
	html += "<a class=\"prev\">��һҳ</a><span class=\"num\"><span class=\"current_page\">1</span><span style=\"padding:0 3px;\">/</span><span class=\"total\"></span></span><a class=\"next\">��һҳ</a>";
	html += "</span>";
	html += "</div>";
	html += "</div>";
	
	return html;
}

function _GetImgText(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	var html = "";
	var sql = "select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' order by crtdat desc "  ;
	
	var ds=db.QuerySQL(sql);
	
	for (var r =0;r <3; r ++) {
		var txt = "txt";
		var img = ds.getStringAt(r,"icon");
		var name = ds.getStringAt(r,"name");
		var htmlguid=ds.getStringAt(r,"htmlguid");
		var context = db.getBlob2String("select b.bdata from LSYSURL a,formblob b where a.htmlguid=b.guid and a.htmlguid='"+htmlguid+"' for update","bdata");
		var url = ds.getStringAt(r,"url");
		if (url != "") {
			url += "&layhdrguid="+ds.getStringAt(r,"GUID");
		}
		txt=txt+r;
		html += "<table valign=\"top\" cellpadding=\"5\">";
		html += "<tr>";
		html += "<td><img src=\""+img+"\" width=\"200\" height=\"200\"/></td>";
		html += "<td valign=\"top\">";
		html += "<table  width=\"300\">";
		html += "<tr>";
		html += "<td><h3>"+name+"</h3></td>";
		html += "</tr>";
		html += "<tr>";
		html += "<td height=\"40\"></td>";
		html += "</tr>";
		html += "<tr>";
		html += "<td id=\""+txt+"\">";
		html += "<a href=\""+url+"\">"+context+"</a>";
		html += "</td>";
		html += "</tr>";
		html += "</table>";
		html += "</td>";
		html += "</tr>";
		html += "<tr>";
		html += "<td colspan=2><hr style=\"border-top:1px dashed #cccccc; height:1px\"></td>";
		html += "</tr>";
		html += "</table>";
	}
	
	html += "
			<script>
				window.onload = function(){
					for (var r=0;r<3;r++) {
						var txt = \"txt\";
						txt=txt+r;
						 var text = document.getElementById(txt),
						 str = text.innerHTML,
						 textLeng = 400;
						 if(str.length > textLeng ){
							   text .innerHTML = str.substring(0,textLeng)+\"��������\";
						 } 
					 }
				 }
			 </script>
			";
	
	return html;
}

//��������
function _GetSingDiv(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	var html = "";
	var sql = "select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' order by crtdat desc ";
	var ds=db.QuerySQL(sql);
	
	html += "<table>";
	html += "<tr>";
	html += "<td align=\"center\">";
	html += "<table cellpadding=\"10\">";
	for (var r=3;r<ds.getRowCount(); r ++) {
		var img = ds.getStringAt(r,"icon");
		var name = ds.getStringAt(r,"name");
		var url = ds.getStringAt(r,"url");
		if (url != "") {
			url += "&layhdrguid="+ds.getStringAt(r,"GUID");
		}
		html += "<tr>";
		html += "<td align=\"center\">";
		html += "<div style=\"position: relative;\" >";
		html += "<a href=\""+url+"\"><img src=\""+img+"\" width=\"200\" height=\"200\"/></a>";
		html += "<div style=\"left: 0px; top: 150px; width: 200px; height: 50px; position: absolute; z-index: 100; opacity: 0.5; background-color: rgb(0, 0, 0); -moz-opacity: 0.5;\"><font color=\"#FFFFFF\" size=\"3\">"+name+"</font></div>";
		html += "</div>";
		html += "</td>";
		html += "</tr>";
	}
	html += "</table>";
	html += "</td>";
	html += "</tr>";
	html += "</table>";
	
	return html;
}



}