function x_QueryTimerTask(){var timepack = new JavaPackage ( "com.xlsgrid.net.time" );
function Query()
{
      	return timepack.EARunTimerTask.GetTaskXml();	
}



// selsytid name 
function QueryLogList()
{
        var xml = "";
	var ds = new pub.EAXmlDS();
	var num = 0;
		var fileurl= pub.EAOption.dynaDataRoot+selsytid+"/log";
		//throw new pub.EAException(fileurl);         
		var folds = (new java.io.File(fileurl)).listFiles();//name+".*.log"
		

		if ( folds != null ) {
			folds=pub.EAFunc.sort(folds);
			var c = folds.length();
			for(var i=0;i<c;i++) {
				var f=folds[i];
				if(!f.isDirectory() ) {
					var filename = f.getName();
					
	            			var index = filename.indexOf(".log");	
					if ( index >=0  ) {
						var row= ds.AddRow(ds.getRowCount()-1);
						num++;
						ds.setValueAt(row,"SEQID",num);
						ds.setValueAt(row,"文件名",filename);
						ds.setValueAt(row,"系统",selsytid );
						ds.setValueAt(row,"操作","查看");
					}	
				}
			}
		}
        return ds.GetXml();

}
function QueryLogText()
{
        var xml = "";
	var ds = new pub.EAXmlDS();
	var num = 0;
	var fileurl= pub.EAOption.dynaDataRoot+selsytid+"/log/"+filename;
	return pub.EAFunc.readFile(fileurl);


}
function DeleteLog()
{
        var xml = "";
	var ds = new pub.EAXmlDS();
	var num = 0;
	var fileurl= pub.EAOption.dynaDataRoot+selsytid+"/log/"+filename;
	pub.EAFunc.WriteToFile(fileurl,"");

	return "操作成功";
}



}