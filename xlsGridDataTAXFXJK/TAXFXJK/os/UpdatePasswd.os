function TAXFXJK_UpdatePasswd(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");

function UpdatePwd()
{
	var db = null;
	var sql = "";
	var ds = null;
	try
	{
		db = new pubpack.EADatabase();
		sql = "select * from usr where id = '"+usrid+"'and org = '"+org+"' and passwd = '"+oldpwd+"'";
		ds = db.QuerySQL(sql);
		if(ds.getRowCount() == 0)
			throw new pubpack.EAException("��������������,����������!");
		else
		{
			if(newpwd != newpwdagain)
				throw new pubpack.EAException("�������������벻һ��,����������!");
			else if(newpwd == oldpwd)
				throw new pubpack.EAException("�¾����벻����ͬ,����������!");
			else
			{
				var guid = ds.getStringAt(0,"guid");
				sql = "update usr set passwd = '"+newpwd+"' where id = '"+usrid+"'and org = '"+org+"'";
				db.ExcecutSQL(sql);
			}
		}	
		return "�����޸ĳɹ�!";
		db.Commit();	
	}
	catch(e)
	{
		db.Rollback();
		throw new pubpack.EAException(e.toString());
	}
	finally
	{
		if(db != null)
			db.Close();
	}
}
}