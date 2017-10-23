function XLSGRID_SendMessage(){var pub = new JavaPackage("com.xlsgrid.net.pub");

//连锁每天晚上销售数据上传进程监控
function sendJQLS()
{
	var str = msg; 
	var eaSms = new pub.EASMS();
	//13917350951,13816326778，13801644075
	eaSms.Send("13681995622",str);
	eaSms.Send("13917350951",str);
	eaSms.Send("13816326778",str);
	eaSms.Send("13801644075",str);
}

//蒙牛经销商库存短信提示
function sendMNJXS()
{
	var str = "成功生成了经销商库存,共:"+msg+"笔记录！"; 
	var eaSms = new pub.EASMS();
	eaSms.Send("13681995623",str);//公司手机
	eaSms.Send("15901686158",str);//金恒昌
	eaSms.Send("13816318518",str);
//	eaSms.Send("13801644075",str);
}

//蒙牛经销商门店库存短信提示
function sendMNJXSCORP()
{
	var str = "成功生成了经销商门店库存,共:"+msg+"笔记录！"; 
	var eaSms = new pub.EASMS();
	eaSms.Send("13681995623",str);//公司手机
	eaSms.Send("15901686158",str);//金恒昌
	eaSms.Send("13816318518",str);
//	eaSms.Send("13801644075",str);
}
}