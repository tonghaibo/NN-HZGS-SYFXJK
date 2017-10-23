function x_SLOTDBEDIT(){
//基本数据维护保存数据前
//脚本在此进行操作校验，比如验证数据是否可以安全删除
//action: + 插入; U 更新; - 删除
//datads: 维护界面传过来的数据
//rowno: 当前要操作的数据行
function beforeSaveDbData(action,eadb,datads,rowno)
//var eadb = new pub.EADatabase(); var datads = new EAXmlDS();
{throw new Exception("仓库%s的%s库位已经使用");
  var guid = datads.getStringAt(rowno,"guid");
  var orgid = datads.getStringAt(rowno,"组织编号");
  var slotid= datads.getStringAt(rowno,"库位编号");
  var locid = datads.getStringAt(rowno,"仓库编号");
  if(guid == "") return;
  var oldid;
  var usecount;
  //try{
  	var ds = eadb.QuerySQL("select loc,id from slot where guid='%s'".format([guid]));
  	oldloc = ds.getStringA(0,0);
  	oldslot = ds.getStringA(0,1);
  	usecount = eadb.GetSQL("select count(*) from sltmov where slot='%s'".format([guid]));
  //}catch(e) {return;}
  if( usecount>0)
    if( action=="-" || slotid != oldslot || locid != oldloc )
    {
      throw new Exception("仓库%s的%s库位已经使用,不能修改或删除该库位。".format([oldloc,oldslot]));
    }  
}

}