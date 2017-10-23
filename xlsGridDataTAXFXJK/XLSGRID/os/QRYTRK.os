function XLSGRID_QRYTRK(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//闂佸憡姊绘慨鎯归崶鈺冨暗閻犲洦褰冮�??   
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" );  
var sql = "select a.project,a.id,a.title ,a.retitle,a.dtlusr,a.stat,a.prio,a.crtusr,a.crtdat " + 
           " from trkhdr a,trkdtl b where a.guid=b.trkguid(+) ";




function Fprocess1()  
{
      var ret = 0; 
      var db = null;  
      var ds = null; 
      var sql1 = "and a.crtusr = '"+usr+"' and a.stat='1' order by a.prio desc";
      try   
      { 
            db = new pubpack.EADatabase(); 
            ds = db.QuerySQL(sql+sql1);           
            return ds.GetXml() ; 
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

function Fprocess2()  
{
      var ret = 0; 
      var db = null;  
      var ds = null; 
      var sql1 = "and a.crtusr = '"+usr+"' and a.stat like '%"+stat+"%' order by a.prio desc";//and b.style not in(1,4)
      try  
      { 
            db = new pubpack.EADatabase(); 
            ds = db.QuerySQL(sql+sql1);           
            return ds.GetXml() ; 
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

function Fprocess3()  
{
      var ret = 0; 
      var db = null;  
      var ds = null; 
      var sql1 = "and a.crtusr = '"+usr+"' and a.stat='2' order by a.prio desc";
      try  
      { 
            db = new pubpack.EADatabase(); 
            ds = db.QuerySQL(sql+sql1);           
            return ds.GetXml() ; 
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

function Fprocess4()  
{
      var ret = 0; 
      var db = null;  
      var ds = null; 
      var sql1 = "and a.crtusr = '"+usr+"' and a.stat like '%"+stat+"%' order by a.prio desc";//and b.style <>'4'
      try  
      { 
            db = new pubpack.EADatabase(); 
            ds = db.QuerySQL(sql+sql1);           
            return ds.GetXml() ; 
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

function Fprocess5()  
{
      var ret = 0; 
      var db = null;  
      var ds = null; 
      var sql1 = "and a.crtusr = '"+usr+"' and a.stat ='3' order by a.crtdat desc";
      try  
      { 
            db = new pubpack.EADatabase(); 
            ds = db.QuerySQL(sql+sql1);           
            return ds.GetXml() ; 
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

function Fprocess6()  
{
      var ret = 0; 
      var db = null;  
      var ds = null; 
      var sql1 = "and a.crtusr = '"+usr+"' and a.stat like '%"+stat+"%' order by a.prio desc";
      try  
      { 
            db = new pubpack.EADatabase(); 
            ds = db.QuerySQL(sql+sql1);           
            return ds.GetXml() ; 
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
}