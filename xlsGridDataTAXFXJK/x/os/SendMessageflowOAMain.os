function x_SendMessageflowOAMain(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var pubpack=new JavaPackage("com.xlsgrid.net.pub");
var utilpack = new JavaPackage("java.util");
var map = new utilpack.HashMap();
var webpack=new JavaPackage("com.xlsgrid.net.web");
var usrinfo = webpack.EASession.GetLoginInfo(request);
var usrid = usrinfo.getUsrid();
var userpwd = usrinfo.getUsrpwd();

//fromstat��������ǰ��״̬
//tostat����������һ����״̬
//bilid���������ݱ��
//dat��������������
//grdid���������Ӧ�Ĺ���������
//sytid��ϵͳ��
//accid�����׺�

function SendMessageflowOAMain(db,fromstat,tostat,bilid,dat,grdid,sytid,accid)
{
	var ds = null;
	var ds2 = null;
	var sql = "";
	try
	{
		//ͨ����ǰ�������״̬����ѯ���Ƿ���Ҫ����һ������״̬���ж�����ʾ
		sql = "select * from sysaction where grdid = '"+grdid+"'  and sytid = '"+sytid+"' and srcid = '"+fromstat+"' and destid = '"+tostat+"' and nvl(ismess,'0')  = '1'";
		ds = db.QuerySQL(sql);
		if(ds.getRowCount() > 0)
		{
			var tousr = ds.getStringAt(0,"tousr");
			var torol = ds.getStringAt(0,"torol");
		
			sql= "select b.* from usrrol a,usr b
				where a.usr = b.guid
				and a.rol = (select guid from rol where id = '"+torol+"') and a.acc = '"+accid+"'";

			ds2 = db.QuerySQL(sql);
			if(ds2.getRowCount() > 0)
			{
				for(var rr = 0;rr < ds2.getRowCount();rr ++ )
				{
					var usrid = ds2.getStringAt(rr,"id");
					var mobile = ds2.getStringAt(rr,"mobile");
					if(mobile != "")
					{
						if(map.isEmpty())
							map.put(usrid ,mobile );
						else if(!(map.containsKey(usrid )))
							map.put(usrid ,mobile );
					}
				}
				
			}
				
//			throw new Exception(map);
			//�����ֻ�����
			SendMessage(map,bilid ,dat);
		}	
	}
	catch(e)
	{
		throw new pubpack.EAException(e.toString());
	}
}


//�����ֻ�����
function SendMessage(mobilemap,bilid,dat)
{
	var url = "http://www.xlsgrid.net/xlsgrid/ROOT_XLSGRID/XLSGRID.SendMessage.sendJQPXEDI.osp?usrid=xlsgrid&userpwd=0&sytid=XLSGRID"; 
	var httpcall = new webget.HttpCall();
	var msg = "����:�ɹ�������"+bilid+"��"+dat+"������Ҫ������";
	
	var set = mobilemap.entrySet();
	var it = set.iterator();
	var mobiles = "";
	while(it.hasNext())
	{
		var usrid = it.next();
		var mobile = usrid.getValue();
		
		if(mobiles != "")
			mobiles += ",";
		mobiles += mobile;	
	}
	
	if(mobiles  != "")
	{
		var params = "msg="+msg+"&phoneNumber="+mobiles ;
		httpcall.Post(url,params,"GBK");
	}	

}


}