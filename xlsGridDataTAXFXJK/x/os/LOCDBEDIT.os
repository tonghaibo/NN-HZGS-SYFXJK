function x_LOCDBEDIT(){
//基本数据维护保存数据前
//脚本在此进行操作校验，比如验证数据是否可以安全删除
//action: + 插入; U 更新; - 删除
//datads: 维护界面传过来的数据
//rowno: 当前要操作的数据行
function beforeSaveDbData(action,eadb,datads,rowno)
//var eadb = new pub.EADatabase(); var datads = new EAXmlDS();
{
  var guid = datads.getStringAt(rowno,"guid");
  var orgid=datads.getStringAt(rowno,"组织编号");
  var locid=datads.getStringAt(rowno,"仓库编号");
  if(guid == "") return;
  var oldid;
  var usecount;
  //try{
  	oldid = eadb.GetSQL("select id from LOC where guid='%s'".format([guid]));
  	usecount = eadb.GetSQL("select count(*) from bilhdr where org='%s' and locid='%s'".format([orgid,oldid]));
  //}catch(e) {return;}
  if( usecount>0)
    if( action=="-" || (action=="U" && oldid != locid) )
    {
      throw new Exception("仓库%s已经使用,不能修改或删除该仓库。".format([oldid]));
    }
}

}