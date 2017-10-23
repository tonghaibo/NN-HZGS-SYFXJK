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
			throw new pubpack.EAException("旧密码输入有误,请重新输入!");
		else
		{
			if(newpwd != newpwdagain)
				throw new pubpack.EAException("两次新密码输入不一致,请重新输入!");
			else if(newpwd == oldpwd)
				throw new pubpack.EAException("新旧密码不能相同,请重新输入!");
			else
			{
				var guid = ds.getStringAt(0,"guid");
				sql = "update usr set passwd = '"+newpwd+"' where id = '"+usrid+"'and org = '"+org+"'";
				db.ExcecutSQL(sql);
			}
		}	
		return "密码修改成功!";
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