function x_WEIXINBO(){function GetBody(){
	return  db.getBlob2String("select bdata from formblob where guid='"+HTMLGUID+"' for update","bdata");

}
}