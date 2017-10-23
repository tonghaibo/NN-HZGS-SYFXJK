function x_L_HTML(){function GetBody(){
	return  db.getBlob2String("select bdata from formblob where guid='"+HTMLGUID+"' ","bdata");
	if(sc==""){
		return "";
	}
}
}