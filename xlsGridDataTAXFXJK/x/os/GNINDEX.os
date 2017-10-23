function x_GNINDEX(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web");	
var web = new JavaPackage ( "com.xlsgrid.net.web" );
var ret = "";
 //药品配伍禁忌查询
function GetBody(){
	var css="";
	var html="";
	var script="";
	
html="	



<html><head><meta http-equiv=\"x-ua-compatible\" content=\"IE=8;\">


<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">
<title>上海警务保障综合应用管理系统</title>
<style type=\"text/css\">
.dtHighLight{
	background:#F0F8FF !important;
}
</style>

</head>
<body class=\"index\">
<div class=\"mini-fit\" style=\"height: 405px;\">
<div id=\"wrapper\" class=\"wrap\">
	<div id=\"header\">
		<div class=\"head-in clearfix\">
			<div class=\"fl clearfix\">
				<img style=\"margin: 5px 50px; 0 50px;\" src=\"EAFormBlob.sp?guid=13E20CD180BEA95EE050007F01001B70\">
				<span style=\"font-family: 微软雅黑;font-size:30px;position: relative; font-weight: bold; top:-24px; color:#FFF\">上海警务保障综合应用管理系统</span>		
                
			</div>
            	
			<div class=\"options fr\">
				<div style=\"color:#FFF;float:left;\">欢迎，上海市闵行区公安局 超级管理员</div>
				<div style=\"float:left;width:30px;height:1px;\"></div>
				<div class=\"time font-5\" style=\"float:right\"><span id=\"currentData\" style=\"color:#FFF\">2015年4月16日</span></div>
				
			</div>
		</div>
	</div>
	<div class=\"mini-fit\" style=\"height: 405px;\">
		<div id=\"container\">
				<div id=\"wrapper\" class=\"wrap\">
					<!--侧边栏-->
					<div class=\"sidebar\">
						<!--用户信息区-->
						<div class=\"user\">
							<img class=\"head\" src=\"EAFormBlob.sp?guid=13E27FE3240AF2A5E050007F01002FDB\" width=\"51\" height=\"51\" alt=\"\">
							<p class=\"tips\">
								<span class=\"font-1\"><strong>您好，superadmin</strong></span>
								<span><a class=\"set\" href=\"#\" openjsp=\"/default/coframe/rights/user/update_password.jsp\">修改密码</a><a class=\"login-out\" href=\"logout.jsp\" target=\"_top\">注销</a></span>
							</p>
						</div>
						<!--左侧菜单-->
						<div class=\"menu-wrap\">
							<ul class=\"menu\" style=\"margin-bottom: 30px;\"><li><dl><dt><a href=\"#\" url=\"/zcgl/ZCGLIndex.jsp\" id=\"1681\" menuseq=\".1681.\">待办工作</a></dt></dl></li><li><dl><dt><a href=\"#\" url=\"\" id=\"1221\" menuseq=\".1221.\">预算管理</a></dt><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/bps/FormerYearsBudgetsList.jsp\" id=\"1281\" menuseq=\".1221.1281.\">往年预算展示<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/bps/YSSQList.jsp\" id=\"1242\" menuseq=\".1221.1242.\">本年度预算列表<i>>></i></a></li></ul></dd></dl></li><li><dl><dt><a href=\"#\" url=\"\" id=\"1301\" menuseq=\".1301.\">经费使用</a></dt><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/bps/JFSQList.jsp\" id=\"1321\" menuseq=\".1301.1321.\">经费使用申请列表<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/bps/JSSQReportForm.jsp\" id=\"1341\" menuseq=\".1301.1341.\">经费使用状况<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/bps/JFSQFBGConfig.jsp\" id=\"1381\" menuseq=\".1301.1381.\">公用经费（非包干）额度调整<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/bps/JFSQFBGEarlyWarning.jsp\" id=\"1401\" menuseq=\".1301.1401.\">公用经费（非包干）额度预警<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/bps/JFSQBGEarlyWarning.jsp\" id=\"1402\" menuseq=\".1301.1402.\">各单位包干经费预警<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/bps/JFSQMyWorkList.jsp\" id=\"1303\" menuseq=\".1301.1303.\">经费审批<i>>></i></a></li></ul></dd></dl></li><li><dl><dt><a href=\"#\" url=\"\" id=\"1021\" menuseq=\".1021.\">资产管理</a></dt><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/zcgl/AssetManagerList.jsp\" id=\"1481\" menuseq=\".1021.1481.\">卡片管理<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/bps/ZclyList.jsp\" id=\"1621\" menuseq=\".1021.1621.\">资产领用<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/bps/ZcdbList.jsp\" id=\"1622\" menuseq=\".1021.1622.\">资产调拨<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/bps/ZCJYList.jsp\" id=\"1661\" menuseq=\".1021.1661.\">资产借用<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/bps/ZcghList.jsp\" id=\"1662\" menuseq=\".1021.1662.\">资产归还<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/bps/MyCZSB.jsp\" id=\"1663\" menuseq=\".1021.1663.\">资产处置<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/zcgl/FcdjDyList.jsp\" id=\"1065\" menuseq=\".1021.1065.\">警务用房管理<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/zcgl/devloping.jsp\" id=\"1703\" menuseq=\".1021.1703.\">被装管理<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/zcgl/devloping.jsp\" id=\"1704\" menuseq=\".1021.1704.\">警用器械管理<i>>></i></a></li></ul></dd></dl></li><li><dl><dt><a href=\"#\" url=\"/zcgl/devloping.jsp\" id=\"1701\" menuseq=\".1701.\">综合查询</a></dt></dl></li><li><dl><dt><a href=\"#\" url=\"/zcgl/devloping.jsp\" id=\"1705\" menuseq=\".1705.\">辅助决策</a></dt></dl></li><li><dl><dt><a href=\"#\" url=\"\" id=\"1\" menuseq=\".1.\">权限管理</a></dt><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/coframe/dict/dict_manager.jsp\" id=\"51\" menuseq=\".1.51.\">配置业务字典<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/policy/access_rules_list.jsp\" id=\"50\" menuseq=\".1.50.\">设置安全策略<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/coframe/framework/application/application_manage.jsp\" id=\"3\" menuseq=\".1.3.\">应用功能管理<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/coframe/framework/menu/menu_manage.jsp\" id=\"4\" menuseq=\".1.4.\">菜单管理<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/coframe/rights/role/role_manager.jsp\" id=\"6\" menuseq=\".1.6.\">角色管理<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/coframe/flowconfig/process_manager.jsp\" id=\"10\" menuseq=\".1.10.\">流程配置<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/coframe/rights/user/user_list.jsp\" id=\"7\" menuseq=\".1.7.\">用户管理<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/coframe/auth/role_auth.jsp\" id=\"5\" menuseq=\".1.5.\">授权管理<i>>></i></a></li></ul></dd></dl></li><li><dl><dt><a href=\"#\" url=\"\" id=\"2\" menuseq=\".2.\">组织管理</a></dt><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/coframe/org/organization/org_tree.jsp\" id=\"8\" menuseq=\".2.8.\">组织机构管理<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/coframe/org/group/group_tree.jsp\" id=\"52\" menuseq=\".2.52.\">工作组管理<i>>></i></a></li></ul></dd></dl></li><li><dl><dt><a href=\"#\" url=\"\" id=\"9\" menuseq=\".9.\">工作流程</a></dt><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/gocom/cap/workflow/client/task/myTask.jsp\" id=\"11\" menuseq=\".9.11.\">我的任务<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/org.gocom.cap.workflow.client.agent.queryAgent.flow\" id=\"12\" menuseq=\".9.12.\">代理设置<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/org.gocom.cap.workflow.client.agent.queryAgentByAgentTo.flow\" id=\"13\" menuseq=\".9.13.\">查看代理<i>>></i></a></li></ul></dd><dd><ul class=\"module_m\" onmouseover=\"addHighLight(this)\" onmouseout=\"removeHighLight(this)\"><li><a href=\"#\" url=\"/org.gocom.cap.workflow.client.process.startProcess.flow\" id=\"14\" menuseq=\".9.14.\">启动流程<i>>></i></a></li></ul></dd></dl></li></ul>
						</div>
						<div class=\"mini-menu mini-contextmenu\" id=\"contextMenu\" style=\"width: auto; height: auto; display: none;\"><div class=\"mini-menu-border\"><a class=\"mini-menu-topArrow\" href=\"#\" onclick=\"return false\"></a><div class=\"mini-menu-inner\"><div class=\"mini-menu-float\"><div class=\"mini-menuitem\" id=\"mini-4\"><div class=\"mini-menuitem-inner\"><div class=\"mini-menuitem-icon\" style=\"display: none;\"></div><div class=\"mini-menuitem-text\">操作</div><div class=\"mini-menuitem-allow\" style=\"display: block;\"></div></div></div><span id=\"\" class=\"mini-separator\"></span><div class=\"mini-menuitem\"><div class=\"mini-menuitem-inner\"><div class=\"mini-menuitem-icon\"></div><div class=\"mini-menuitem-text\">打开</div><div class=\"mini-menuitem-allow\"></div></div></div><div class=\"mini-menuitem\"><div class=\"mini-menuitem-inner\"><div class=\"mini-menuitem-icon\"></div><div class=\"mini-menuitem-text\">关闭</div><div class=\"mini-menuitem-allow\"></div></div></div></div><div class=\"mini-menu-toolbar\"></div><div style=\"clear:both;\"></div></div><a class=\"mini-menu-bottomArrow\" href=\"#\" onclick=\"return false\"></a></div></div>
					</div>
					<!--右侧主内容区-->
					<div class=\"main\">
						<!--面包屑导航条-->
						<div class=\"positionbar\">
							<ul class=\"position clearfix\" id=\"positionbar\">
								<li class=\"index\">
									<a><span>首页</span></a><b class=\"arrow\"></b>
								</li>
							</ul>
						</div>
						<!--主体内容显示区-->
						<div class=\"submain radius\">
							<b class=\"b1\"></b>
							<b class=\"b2\"></b>
							<div class=\"fmain\">
								
								<iframe id=\"mainframe\" src=\"http://www.xlsgrid.net/xlsgrid/ROOT_0/entry.sp?&sytid=x&grdid=GN_ZCXQ\" frameborder=\"0\" name=\"main\" style=\"width:100%;height:100%;\" border=\"0\">
									
								</iframe>
								
							</div>
							<b class=\"b3\"></b>
							<b class=\"b4\"></b>
						</div>
					</div>
				</div>
		</div>
	</div>
	<div id=\"footer\">
		<p>(c) Copyright 上海硕格信息科技有限公司 2015</p>
	</div>
</div>
</div>

</body></html>
";
return css+html+script;
}

}