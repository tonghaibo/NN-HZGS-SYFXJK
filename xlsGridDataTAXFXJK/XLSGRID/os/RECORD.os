function XLSGRID_RECORD(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//闂備礁鎲″缁樻叏閹灐褰掑炊閳哄啫鏆楅柣鐘叉处瑜板啴鎯??   
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" );  

function check()
{
              var db = null;
              var ds = null;
              var sql = "";
              
            try
            {
                  db = new pubpack.EADatabase();
                  if ( usrid == "scott" )
                  {
                      
                  sql =" select distinct d.name prj,a.id,a.title ,e.name 事务类型 ,c.name,b.style,a.prio,a.crtusr,to_char(a.crtdat,'yyyy-mm-dd hh24:mi:ss') crtdat," +
                       " a.dtlusr 最后处理,a.show  from  trkhdr a,trkdtl b ,v_usr c,v_prj d ,trktyp e where a.guid=b.trkguid  " +
                       " and a.show =e.id " +
                       " and b.crtusr=c.name " +
                       " and a.project=d.name " +
                       " and b.style='未处理' " + 
                       " and a.stat like '"+s+"%' " +
                       " and d.id like '"+prj+"%' " +
                       " and e.id in ('6','7','8','9','10') " +
                       " and a.crtusr like '"+create+"%' " +
                       " and e.id like '"+trktyp+"%'  " +
                       " order by crtdat desc ";
                       
                       
                    }
                    else
                    {
                     sql =" select distinct d.name prj,a.id,a.title ,e.name 事务类型 ,c.name,b.style,a.prio,a.crtusr,to_char(a.crtdat,'yyyy-mm-dd hh24:mi:ss') crtdat," +
                       " a.dtlusr 最后处理,a.show  from  trkhdr a,trkdtl b ,v_usr c,v_prj d ,trktyp e where a.guid=b.trkguid and " +
                       " c.id  = '"+usrid+"' " +
                       " and a.show =e.id " +
                       " and b.crtusr=c.name " +
                       " and a.project=d.name " +
                       " and b.style='未处理' " +
                       " and a.stat like '"+s+"%' " +
                       " and d.id like '"+prj+"%' " +
                       " and e.id in ('6','7','8','9','10') " +
                       " and a.crtusr like '"+create+"%' " +
                       " and e.id like '"+trktyp+"%'  " +
                       " order by crtdat desc " ;
                       
                    }  
                       ds = db.QuerySQL(sql); 
                       return ds.GetXml();
            }
            catch(e)
            {
                   throw e;
            }
            finally
            {
                   db.Close();
            }

}






//
////================================================================// 
//// 函数：function replaceParam(mwobj,request,sql)
//// 说明：通过返回的sql替换数据源里的sql
//// 参数：
//// 返回：
//// 样例：
//// 作者：
//// 创建日期：03/26/07 15:52:17
//// 修改日志：
////================================================================// 
//function replaceParam(mwobj,request,sql)
//{
//var web = new JavaPackage("com.xlsgrid.net.web");
//var usr = web.EASession.GetLoginInfo(request);
//var usrid = usr.getUsrid();
//        if ( sql.substring(2,11) == "puppyhome")
//        {
//            
//            if ( usrid == "scott")
//            {
//                 sql = " --puppyhome \r\n"+
//                       " select distinct d.name prj,a.id,a.title ,e.name 事务类型 ,c.name,b.style,a.prio,a.crtusr,to_char(a.crtdat,'yyyy-mm-dd hh24:mi:ss') crtdat, "+
//                       " a.dtlusr 最后处理,a.show  from "+
//                       " trkhdr a,trkdtl b ,v_usr c,v_prj d ,trktyp e where a.guid=b.trkguid "+
//                       " and a.show =e.id  "+
//                       " and b.crtusr=c.name "+
//                       " and a.project=d.name "+
//                       " and a.prio like '[%PRIO]%' "+
//                       " and a.stat like '[%s]%' "+
//                       " and d.id like '[%prj]%' "+
//                       " and e.id in ('6','7','8','9','10') "+
//                       " and a.crtusr like '%[%create]%' "+
//                       " and a.title like '%[%title]%' "+
//                       " and e.finkey like '%[%finkey]%' "+
//                       " and e.id like '[%trktyp]%'  "+
//                       " order by crtdat desc";
//                //    throw new Exception (sql);
//            }
//            else
//            {
//            
//                  sql = " --puppyhome "+
//                       "select distinct d.name prj,a.id,a.title ,e.name 事务类型 ,c.name,b.style,a.prio,a.crtusr,to_char(a.crtdat,'yyyy-mm-dd hh24:mi:ss') crtdat,"+
//                       " a.dtlusr 最后处理,a.show  from "+
//                       " trkhdr a,trkdtl b ,v_usr c,v_prj d ,trktyp e where a.guid=b.trkguid "+
//                       " and  c.id='[%SYS_USRID]'  "+
//                       " and a.show =e.id  "+
//                       " and b.crtusr=c.name "+
//                       " and a.project=d.name "+
//                       " and b.style='未处理' "+
//                       " and a.prio like '[%PRIO]%' "+
//                       " and a.stat like '[%s]%' "+
//                       " and d.id like '[%prj]%' "+
//                       " and e.id in ('6','7','8','9','10') "+
//                       " and a.crtusr like '%[%create]%' "+
//                       " and a.title like '%[%title]%' "+
//                       " and e.finkey like '%[%finkey]%' "+
//                       " and e.id like '[%trktyp]%'  "+
//                       " order by crtdat desc";
//            
//            }
//            
//            return sql;
//        }
//}

}