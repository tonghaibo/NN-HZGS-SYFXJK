function x_dtlModuleData(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

//	_Sytid		ϵͳ��
//	mdid		�м�����
//	lms		��Ŀ��
//	m_grdColDS	����������xml
//	m_grdDtlDS	��ϸ����xml
function dtlModuleData(_Sytid,mdid,lms,m_grdColDS,m_grdDtlDS)
{
	var db = null;
	var sql = "";
	
	try {
//		pubpack.EAFunc.Log("dtlModuleData info:"+ m_grdColDS);
		
		db = new pubpack.EADatabase();			// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var indexitemid = "";		//ָ���� eg��01,02
		var arr1 = new Array();
		var arr2 = new Array();
		var idxitmid = "";		//ָ���� eg��01,02����չ�ֶΡ�������Ŀ��
		var idxitmtyp = "";		//ָ�������ͣ���չ�ֶΡ�1��ָ�꼴ʹ��ȡֵ��Ҳд��ָ��⣻0��������
		//������xml��ȡָ�����ַ���
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
		
		//��ϸ����ת��
		for ( var col = 0; col < m_grdDtlDS.getColumnCount(); col ++ ) {
			for (var row = 0; row < m_grdColDS.getRowCount(); row ++) {
				if (col == m_grdColDS.getStringAt(row,"ID").split(",")[1]) {
					m_grdDtlDS.setColumnName(col+2, m_grdColDS.getStringAt(row,"VALFLD"));
				}
			}
		}
//		pubpack.EAFunc.Log("dtlModuleData cs:"+ m_grdDtlDS.getRowCount());
		//ɾ������ָ����ƿ�����  table:fin_repframe
		sql = "delete from fin_repframe where repid='"+mdid+"'";
		db.ExcecutSQL(sql);
		
		for ( var row = 0; row < m_grdDtlDS.getRowCount(); row ++ ) {	//��ϸXML���뱨��ָ����ƿ⣺fin_repframe
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