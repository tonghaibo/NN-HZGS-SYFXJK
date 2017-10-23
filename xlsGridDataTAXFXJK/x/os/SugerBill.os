function x_SugerBill(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var SuggerBillMsg = new x_GSMN();

function InsertSuggerDB()
{
	var db = null;
	var msg = "";
	var msgs = "";
	var MidTab = "STOCKBILL";
	var MidTab1 = "AREASUGPRICE";
	try
	{
		db = new pubpack.EADatabase();
		msg = SuggerBillMsg.start();
		if(msg == ""||msg == "#&#&")
			return ;
		else
		{
			msgs = msg.split("#&#&");
			if(msgs.length() >= 1)
			{
				if(msgs[0] != "")
				{
					var sql = "insert into "+MidTab+"_BAK (AREA,PRJID,OPENPRICE,HIGHTPEICE,LOWPRICE,NEWPRICE,CHECKQTY,UPDOWNRAL,BILLQTY)
						select AREA,PRJID,OPENPRICE,HIGHTPEICE,LOWPRICE,NEWPRICE,CHECKQTY,UPDOWNRAL,BILLQTY from "+MidTab;
					db.ExcecutSQL(sql);				
					sql = "delete from "+MidTab;
					db.ExcecutSQL(sql);
					sql = " insert into "+MidTab+" a(AREA,PRJID,OPENPRICE,HIGHTPEICE,LOWPRICE,NEWPRICE,CHECKQTY,UPDOWNRAL,BILLQTY) 
					            values(trim(?),trim(?),trim(?),trim(?),trim(?),trim(?),trim(?),trim(?),trim(?))
					          ";
					var pstmt = db.GetConn().prepareStatement(sql);	
					var orderArrayList = msgs[0].split("йч");
					for(var a = 0;a < orderArrayList.length();a ++)
					{
						var row = orderArrayList[a].split("~~~");
						for(var r = 0;r < row.length();r ++)
						{
							if(r == 0||r == 1)
								pstmt.setString(r+1,row[r]);
							else
								pstmt.setDouble(r+1,row[r]);
						}	
						pstmt.executeUpdate();
					}
				}
				if(msgs[1] != "")
				{
					var sql = "insert into "+MidTab1+"_BAK (AREA,PRJID,PRICE,DAYINCREASE,WEEKINCREASE,MONTHINCREASE,YEARINCREASE)
						   select AREA,PRJID,PRICE,DAYINCREASE,WEEKINCREASE,MONTHINCREASE,YEARINCREASE from "+MidTab1;
					db.ExcecutSQL(sql);				
					sql = "delete from "+MidTab1;
					db.ExcecutSQL(sql);
					sql = " insert into "+MidTab1+" a(PRJID,AREA,PRICE,DAYINCREASE,WEEKINCREASE,MONTHINCREASE,YEARINCREASE) 
					            values(trim(?),trim(?),trim(?),trim(?),trim(?),trim(?),trim(?))
					          ";
					var pstmt = db.GetConn().prepareStatement(sql);	
					var orderArrayList = msgs[1].split("йч");
					for(var a = 0;a < orderArrayList.length();a ++)
					{
						var row = orderArrayList[a].split("~~~");
						for(var r = 0;r < row.length();r ++)
							pstmt.setString(r+1,row[r]);
						pstmt.executeUpdate();
					}
				}
			}
		}
		db.Commit(); 	
	}
	catch(e)
	{
		db.Rollback();
		throw new Exception(e);
	}
}
}