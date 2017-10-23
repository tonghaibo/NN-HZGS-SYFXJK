function XLSGRID_UPDATEUSR(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
//================================================================// 
// 函数：GetMaxid
// 说明：得到最大的编号
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：05/27/06 14:08:25
// 修改日志：
//================================================================// 
function GetMaxid()
{
      var ret = "";
      try {
            if ( refid == "2" )       // 业务员从10000开始编号
                  ret = pubpack.EADbTool.GetSQL("SELECT NVL(MAX(to_number(ID))+1,1) FROM USR where isnumber(id)='1' and post='"+refid+"'");
            else
                  ret = pubpack.EADbTool.GetSQL("SELECT NVL(MAX(to_number(ID))+1,1) FROM USR where isnumber(id)='1' and post!='"+refid+"'");
      }
      catch (  e ){
            ret = e.toString();
      }
      
      return ret;
}
}