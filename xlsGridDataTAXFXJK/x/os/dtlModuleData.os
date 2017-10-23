function x_dtlModuleData(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

//	_Sytid		系统号
//	mdid		中间件编号
//	lms		栏目数
//	m_grdColDS	右栏绑定数据xml
//	m_grdDtlDS	明细数据xml
function dtlModuleData(_Sytid,mdid,lms,m_grdColDS,m_grdDtlDS)
{
	var db = null;
	var sql = "";
	
	try {
//		pubpack.EAFunc.Log("dtlModuleData info:"+ m_grdColDS);
		
		db = new pubpack.EADatabase();			// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var indexitemid = "";		//指标项 eg：01,02
		var arr1 = new Array();
		var arr2 = new Array();
		var idxitmid = "";		//指标项 eg：01,02（扩展字段、区分栏目）
		var idxitmtyp = "";		//指标项类型（扩展字段、1：指标即使是取值类也写入指标库；0：其他）
		//从右栏xml获取指标项字符串
		for ( var row = 0; row < m_grdColDS.getRowCount(); row ++ ) {
			var itmid = m_grdColDS.getStringAt(row,"INDEXID");
			var itmtyp = m_grdColDS.getStringAt(row,"WHERE");
			if (itmid != "") {
				if (indexitemid == "")
					indexitemid += itmid;
				else if (indexitemid.indexOf(itmid) == -1)
					indexitemid += ","+ itmid;
				
				if (idxitmid == "")
					idxitmid += itmid;
				else
					idxitmid += ","+ itmid;
				
				if (itmtyp == "" || itmtyp == "0") itmtyp = "0";
				else itmtyp = "1";
				if (idxitmtyp == "")
					idxitmtyp += itmtyp;
				else
					idxitmtyp += ","+ itmtyp;
			}
			if (idxitmid != "" && itmid == "") {
				arr1.push(idxitmid);
				idxitmid = "";
				arr2.push(idxitmtyp);
				idxitmtyp = "";
			}
		}
		
		//明细列名转换
		for ( var col = 0; col < m_grdDtlDS.getColumnCount(); col ++ ) {
			for (var row = 0; row < m_grdColDS.getRowCount(); row ++) {
				if (col == m_grdColDS.getStringAt(row,"ID").split(",")[1]) {
					m_grdDtlDS.setColumnName(col+2, m_grdColDS.getStringAt(row,"VALFLD"));
				}
			}
		}
//		pubpack.EAFunc.Log("dtlModuleData cs:"+ m_grdDtlDS.getRowCount());
		//删除报表指标设计库数据  table:fin_repframe
		sql = "delete from fin_repframe where repid='"+mdid+"'";
		db.ExcecutSQL(sql);
		
		for ( var row = 0; row < m_grdDtlDS.getRowCount(); row ++ ) {	//明细XML存入报表指标设计库：fin_repframe
			for (var i = 1; i <= lms; i ++) {
				var indexid = "";
				var indexnam = "";
				var hc = "";
				var isget = 0;
				if (lms == 1) {
					try {
						indexid = m_grdDtlDS.getStringAt(row,"IDXID");
						indexnam = m_grdDtlDS.getStringAt(row,"XM");
						hc = m_grdDtlDS.getStringAt(row,"HC");
					} catch (e) {
						indexid = m_grdDtlDS.getStringAt(row,"IDXID"+ i);
						indexnam = m_grdDtlDS.getStringAt(row,"XM"+ i);
						hc = m_grdDtlDS.getStringAt(row,"HC"+ i);
					}
				} else {
					indexid = m_grdDtlDS.getStringAt(row,"IDXID"+ i);
					indexnam = m_grdDtlDS.getStringAt(row,"XM"+ i);
					hc = m_grdDtlDS.getStringAt(row,"HC"+ i);
				}
				if (indexid.indexOf(",") != -1) {
					isget = indexid.split(",")[1];
					indexid = indexid.split(",")[0];
				}
				sql = "insert into fin_repframe select sys_guid(),'"
					+ mdid +"','"+ indexid +"','"+ indexnam +"','"+ indexitemid
					+"','"+ hc +"',"+ i +","+ (row+1) +",'"+ _Sytid +"','"+isget+"','"+arr1[i-1]+"','"+arr2[i-1]+"' from dual";
				db.ExcecutSQL(sql);
			}
		}
		db.Commit();
	}
	catch ( ee ) {
		db.Rollback();
		pubpack.EAFunc.Log("dtlModuleData error:"+ee.toString() +"("+ mdid +")");
	}
	finally {
		if (db!=null) db.Close();
	}
}

}