function XLSGRID_TRK_SAMODIFY431(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//������� 
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" ); 

function commit() 
{
      var ret = 0; 
      var db = null; 
      var ds = null; 
      var ps1 = null;
      var ps2 = null;
      var ps3 = null;
      var project="JQFIN";
      try
      {
             db = new pubpack.EADatabase();
            
             var guid = db.GetSQL("select guid from trkdtl where project='"+project+"' and id='"+id+"' and result='0'"); 
             var trkguid =  db.GetSQL("select trkguid from trkdtl where project='"+project+"' and id='"+id+"'");
             var trkdtl_crtusr = db.GetSQL("select crtusr from trkdtl where guid='"+trkguid+"'");
//             var sql = "update trkdtl set pro_note='"+pro_note+"',tousr='"+tousr+"', " +
//                       "style='�Ѵ���',crtusrorg='"+crtusrorg+"',crtusr='"+crtusr+"'," +
//                       "result='1',project='"+project+"',filepath='"+filepath+"'," +
//                       "filenote='"+filenote+"',title='"+title+"',trkguid='"+trkguid+"', imagepath='"+imagepath+"',imagenote='"+imagenote+"' where  guid='"+guid+"' and id='"+id+"'";
//                   thro 
             if ( edit == "save")          
             {  
             var sql = "update trkdtl set pro_note=?,tousr=?,style=?,crtusrorg=?,crtusr=?, "+
                       "result=?,project=?,filepath=?,filenote=?,title=?,trkguid=?,imagepath=?, "+
                       "imagenote=?,selforg=?,aimorg=?  where guid=? and id=? ";
             ps1 = db.prepareStatement(sql);
             ps1.setString(1,pro_note);
             ps1.setString(2,tousr);
             ps1.setString(3,"2");//�޸Ĺ��ģ�ԭ���ǡ��Ѵ���
             ps1.setString(4,crtusrorg);
             ps1.setString(5,crtusr);
             ps1.setString(6,"1");
             ps1.setString(7,project);
             ps1.setString(8,filepath);
             ps1.setString(9,filenote);
             ps1.setString(10,title);
             ps1.setString(11,trkguid);
             ps1.setString(12,imagepath);
             ps1.setString(13,imagenote);
             ps1.setString(14,selforg);
             ps1.setString(15,aimorg);
             ps1.setString(16,guid);
             ps1.setString(17,id);
             ret = ps1.executeUpdate(); 
             ps1.close();
               
                                     
//             var sql1 = "insert into trkdtl(id,project,crtusr,style,title,crtusrorg," +  
//                        " result,trkguid) values ('"+id+"','"+project+"'," +  
//                        " '"+tousr+"','δ����','"+title+"','"+crtusrorg+"'," + 
//                        " '0','"+trkguid+"')";
            var sql1 = ""; 
             if ( flag == "1" )
             {
              sql1 = "insert into trkdtl(id,project,crtusr,style,title,crtusrorg, " +
                        "result,trkguid,acc,syt,selforg,aimorg) values (?,?,?,?,?,?,?,?,?,?,?,?) ";
             ps2 = db.prepareStatement(sql1);    
             ps2.setString(1,id);
             ps2.setString(2,project);  
             ps2.setString(3,tousr);  
             ps2.setString(4,"4");  //�޸Ĺ��ģ�ԭ���ǡ���δ����
             ps2.setString(5,title);  
             ps2.setString(6,crtusrorg);  
             ps2.setString(7,"0");  
             ps2.setString(8,trkguid);
             ps2.setString(9,acc);
             ps2.setString(10,syt);
             ps2.setString(11,aimorg);
             ps2.setString(12,selforg);
             ps2.executeUpdate();
             }
             else  //edit != "save"
             {
            sql1 = "insert into trkdtl(id,project,crtusr,style,title,crtusrorg, " +
                        "result,trkguid,acc,selforg,aimorg,syt) values (?,?,?,?,?,?,?,?,?,?,?,?) ";
             ps2 = db.prepareStatement(sql1);    
             ps2.setString(1,id);
             ps2.setString(2,project);  
             ps2.setString(3,trkdtl_crtusr);  
             ps2.setString(4,"4");  //�޸Ĺ��ģ�ԭ���ǡ���δ����
             ps2.setString(5,title);  
             ps2.setString(6,crtusrorg);  
             ps2.setString(7,"0");  
             ps2.setString(8,trkguid);
             ps2.setString(9,acc);
             ps2.setString(10,aimorg);
             ps2.setString(11,selforg);
             ps2.setString(12,syt);
             ps2.executeUpdate();
             
             
             
             }
             ps2.close();             
             db.ExcecutSQL("update trkhdr set stat='2',dtlusr='"+tousr+"', aimorg='"+aimorg+"' where  id='"+id+"'");
             db.Commit();  
             }
             else//�޸�
             {
                 var sql = "update  trkdtl set project=?,tousr=?,imagenote=?,title=?,pro_note=? where id=? and result=? and crtusr=?";
                 ps3 = db.prepareStatement(sql);
                 ps3.setString(1,project);
                 ps3.setString(2,tousr);
                 ps3.setString(3,imagenote);
                 ps3.setString(4,title);
                 ps3.setString(5,pro_note);             
                 ps3.setString(6,id);
                 ps3.setString(7,"1");
                 ps3.setString(8,crtusr);
                 ret =  ps3.executeUpdate();
                 ps3.close();
                 db.Commit();                      
             }
                    
            //db.ExcecutSQL(sql1);          
             
            //ret = db.ExcecutSQL(sql);
            return ret ; 
      }
      catch(e)
      {
            throw e;
            db.Rollback();
       }
       finally
       {
             db.Close();
       }
}

function file()
{
     // return  "/"+pubpack.EAOption.get("xlsgrid.file.dynadata.root")+"upload/";  
     return  "/"+pubpack.EAOption.get("filestore")+"upload/";  
}

function update()
{
	//���ļ���д�����ݿⲢ���´˵���״̬
	var ret = 0; 
      var db = null; 
      var ds = null; 
      var ps1 = null;
      var ps2 = null;
      var ps3 = null;
      var project="JQFIN";
//      throw new Exception("��ʼ��������");//�����׳�����

      try
      {
             db = new pubpack.EADatabase();
            
             
             var sql = "update TRK_SAMODIFY set stat='6', doc=? "+
             "  where guid=? ";
             

             ps1 = db.prepareStatement(sql);
             ps1.setString(1,doc);
             ps1.setString(2,guid);
//             ps1.setString(3,id);
//		throw new Exception(ps1);//�����׳�������ʾps1�ڽ�����
             ret = ps1.executeUpdate(); 
             ps1.close();
             db.Commit();  
                                 
            //db.ExcecutSQL(sql1);          
             
            //ret = db.ExcecutSQL(sql);
      }
      catch(e)
      {
            throw e;
            db.Rollback();
       }
       finally
       {
             db.Close();
       }

}
}