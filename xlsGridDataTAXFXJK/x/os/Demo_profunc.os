function x_Demo_profunc(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var orajdbc = new JavaPackage("oracle.jdbc");

//���ô洢����
function invokeProcedure()
{
	var db = null;
	var ret = "";
	try {
		db = new pub.EADatabase();
		var conn = db.GetConn();
		var statement = conn.createStatement();
		var in_price = "5.0";
		var stmt = conn.prepareCall("call P_GET_PRICE(?,?,?,?)");
		stmt.registerOutParameter(1, java.sql.Types.FLOAT);
		stmt.registerOutParameter(2, java.sql.Types.CHAR);
		stmt.registerOutParameter(3, orajdbc.OracleTypes.CURSOR);
		stmt.setString(4, in_price);
		stmt.executeUpdate();

		var retCode = stmt.getInt(1);
		var retMsg = stmt.getString(2);
		ret += "retCode:" + retCode + "; retMsg:" + retMsg + ";\n";
		if (retCode == -1) { // �������ʱ�����ش�����Ϣ
                	return "����";
            	} 
            	else {
	                // ȡ�ý����
	                var rs = stmt.getCursor(3);
	                var ric;
	                var price;
	                var updated;
	                // �Խ���������
	                while (rs.next()) {
	                    ric = rs.getString(1);
	                    price = rs.getString(2);
	                    updated = rs.getString(3);
	                    ret += "ric:" + ric + ";price:" + price + "; updated:" + updated + "; \n";
	                }
		}
            return ret;
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

//���ú���
function invokeFunction()
{
	var db = null;
	var ret = "";
	try {
		db = new pub.EADatabase();
		var conn = db.GetConn();
		var statement = conn.createStatement();
		var in_price = "4.0";
		// ���ú���
	        var stmt = conn.prepareCall("{? = call F_GET_PRICE(?)}");
	        stmt.registerOutParameter(1, orajdbc.OracleTypes.CURSOR);
	        stmt.setString(2, in_price);
	        stmt.executeUpdate();
	        // ȡ�ý����
	        var rs = stmt.getCursor(1);
	        var ric;
	        var price;
	        var updated;
	
	        while (rs.next()) {
			ric = rs.getString(1);
	                price = rs.getString(2);
	                updated = rs.getString(3);
	                ret += "ric:" + ric + "; price:" + price + "; " + updated + "; \n";
	            }
            return ret;
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

function getDemoStr()
{
	var demostr = "
--�������
CREATE TABLE STOCK_PRICES(
    RIC VARCHAR(6) PRIMARY KEY,
    PRICE NUMBER(7,2),
    UPDATED DATE );
	
--��������
INSERT INTO stock_prices values('1111',1.0,SYSDATE);
INSERT INTO stock_prices values('1112',2.0,SYSDATE);
INSERT INTO stock_prices values('1113',3.0,SYSDATE);
INSERT INTO stock_prices values('1114',4.0,SYSDATE);

--����һ�������α�
CREATE OR REPLACE PACKAGE PKG_PUB_UTILS IS
    --��̬�α�
    TYPE REFCURSOR IS REF CURSOR;
END PKG_PUB_UTILS;

--�����洢����
CREATE OR REPLACE PROCEDURE P_GET_PRICE
(
  AN_O_RET_CODE OUT NUMBER,
  AC_O_RET_MSG  OUT VARCHAR2,
  CUR_RET OUT PKG_PUB_UTILS.REFCURSOR,
  AN_I_PRICE IN NUMBER
) 
IS
BEGIN
    AN_O_RET_CODE := 0;
    AC_O_RET_MSG  := '�����ɹ�';
    
    OPEN CUR_RET FOR
        SELECT * FROM STOCK_PRICES WHERE PRICE<AN_I_PRICE;
EXCEPTION
    WHEN OTHERS THEN
        AN_O_RET_CODE := -1;
        AC_O_RET_MSG  := '�������:' || SQLCODE || CHR(13) || '������Ϣ:' || SQLERRM;
END P_GET_PRICE;

--����������F_GET_PRICE
CREATE OR REPLACE FUNCTION F_GET_PRICE(v_price IN NUMBER)
    RETURN PKG_PUB_UTILS.REFCURSOR
AS
    stock_cursor PKG_PUB_UTILS.REFCURSOR;
BEGIN
    OPEN stock_cursor FOR
    SELECT * FROM stock_prices WHERE price < v_price;
    RETURN stock_cursor;
END;	";
		
	return demostr;		
}

}