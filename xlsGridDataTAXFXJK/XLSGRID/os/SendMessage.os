function XLSGRID_SendMessage(){var pub = new JavaPackage("com.xlsgrid.net.pub");

//����ÿ���������������ϴ����̼��
function sendJQLS()
{
	var str = msg; 
	var eaSms = new pub.EASMS();
	//13917350951,13816326778��13801644075
	eaSms.Send("13681995622",str);
	eaSms.Send("13917350951",str);
	eaSms.Send("13816326778",str);
	eaSms.Send("13801644075",str);
}

//��ţ�����̿�������ʾ
function sendMNJXS()
{
	var str = "�ɹ������˾����̿��,��:"+msg+"�ʼ�¼��"; 
	var eaSms = new pub.EASMS();
	eaSms.Send("13681995623",str);//��˾�ֻ�
	eaSms.Send("15901686158",str);//����
	eaSms.Send("13816318518",str);
//	eaSms.Send("13801644075",str);
}

//��ţ�������ŵ��������ʾ
function sendMNJXSCORP()
{
	var str = "�ɹ������˾������ŵ���,��:"+msg+"�ʼ�¼��"; 
	var eaSms = new pub.EASMS();
	eaSms.Send("13681995623",str);//��˾�ֻ�
	eaSms.Send("15901686158",str);//����
	eaSms.Send("13816318518",str);
//	eaSms.Send("13801644075",str);
}
}