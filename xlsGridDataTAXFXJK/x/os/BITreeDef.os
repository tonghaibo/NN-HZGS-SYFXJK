function x_BITreeDef(){var pub= new JavaPackage("com.xlsgrid.net.pub");
var pubpack= new JavaPackage("com.xlsgrid.net.pub");
var xmldb= new JavaPackage("com.xlsgrid.net.xmldb");
var xmldbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var iopack = new JavaPackage ( "java.io" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
var utilpack = new JavaPackage ( "java.util");
var basePath = pubpack.EAOption.dynaDataRoot;

  function  XmlToStd(xml)
  {
      xml = pub.EAFunc.Replace(xml, "&"+"quot;", "\"" );
      xml = pub.EAFunc.Replace(xml, "&"+"amp;quot;", "\"" );
      xml = pub.EAFunc.Replace(xml, "&"+"apos;", "'"  );
    return xml;
  }
//��ѯĳ��org�µĽڵ�
//������� thisorgid�� thisid
function GetSytList()
{
        var xml = "";
        var deforg = webpack.EAWebDeforg.GetDeforg(request); 
        
        //Ӧ�õõ�Ĭ����֯�����й�����֯��ϵͳ
        var sql = "select distinct id,name from (select d.id ,d.name "+
		" from usr a, (select id,name,refid,level lvl from org connect by prior id=refid start with id='"+deforg+"') b , acc c ,syt d"+	
		" where a.org=b.id and a.id='"+G_USRID+"' and c.org=b.id and c.id<>'0' and c.syt=d.id order by b.lvl,b.id,c.id "+
		"  union all select id,name from syt connect by prior refid=id start with id='"+G_SYTID+"' ) order by id";		
	//�¼���֯������ϵͳ + //��ϵͳ�������ϼ�ϵͳ
	sql = "select * from (select id,name,min(lvl) lvl from (
			select d.id ,d.name,0 lvl  from usr a, 		
			(select id,name,refid,level lvl from org connect by prior id=refid start with id='"+deforg+"') b , acc c ,syt d 
			where a.org=b.id and a.id='"+G_USRID+"' and c.org=b.id and c.id<>'0' and c.syt=d.id   
			 union all 
			 select id,name,LEVEL lvl from syt connect by prior refid=id start with id='"+G_SYTID+"'		
			 ) 
			 group by id,name ) order by lvl,id ";

	var sytds= pubpack.EADbTool.QuerySQL(sql);
	for( var i=0;i< sytds.getRowCount(); i ++ ) {
              
              var name = sytds.getStringAt(i,"NAME");
              var id = sytds.getStringAt(i,"ID");
              name = pubpack.EAFunc.Replace(name," ","");
              
              //if ( G_SYTID=="x"|| (G_SYTID!="" && sytlistid .indexOf(id+",")>=0 ) ) {
		
	              xml+="<"+id+" name=\""+name+"\" imageid=\""+imageid+"\" sytid=\""+id+"\" typ=\""+typ+"\" >";      // sytflg˵���ýڵ���һ��ϵͳ
        	      xml+="</"+id+">";
        	//}
        } 
	
        /*
        var sytlistid = GetSytListByDeforg(deforg);
        if( sytlistid =="" ) sytlistid = G_SYTID+",";
        var sytds0 = xmldbpack.EASYTXmlDB.getSytDS();
        
	var sytds = sytds0 .sort("ID");
	
        for( var i=0;i< sytds.getRowCount(); i ++ ) {
              
              var name = sytds.getStringAt(i,"NAME");
              var id = sytds.getStringAt(i,"ID");
              name = pubpack.EAFunc.Replace(name," ","");
              
              if ( G_SYTID=="x"|| (G_SYTID!="" && sytlistid .indexOf(id+",")>=0 ) ) {
		
	              xml+="<"+id+"_"+name+" imageid=\""+imageid+"\" sytid=\""+id+"\" typ=\""+typ+"\" >";      // sytflg˵���ýڵ���һ��ϵͳ
        	      xml+="</"+id+"_"+name+">";
        	}
        }  
        */
        return xml;
}

function GetOrgList()
{
        var xml = "";
        var sytds0 = xmldbpack.EAORGXmlDB.getOrgDs();
        var deforg = webpack.EAWebDeforg.GetDeforg(request);
       
        
	var sytds = sytds0 .sort("ID");
        for( var i=0;i< sytds.getRowCount(); i ++ ) {
              var id = sytds.getStringAt(i,"ID");

              var name = sytds.getStringAt(i,"NAME");
              name = pubpack.EAFunc.Replace(name," ","");
              if ( G_ORGID=="0"|| (deforg !="" && deforg ==id ) ) {	//��ΪȡĬ����֯��

	              xml+="<"+id+" name=\""+name+"\" imageid=\""+imageid+"\"  orgid=\""+id+"\" typ=\""+typ+"\" >";      // sytflg˵���ýڵ���һ��ϵͳ
	              
	              xml+="</"+id+">";
	      }
        }  
        
        return xml;
}

function GetSytListByDeforg(deforg)
{
	var accds0 = xmldbpack.EAACCXmlDB.getAccDS();
        var sytlistid = "";
	var accds = accds0 .sort("ID");
        for( var i=0;i< accds.getRowCount(); i ++ ) {
              var accid = accds.getStringAt(i,"ID");
              var orgid = accds.getStringAt(i,"ORG");
              var sytid = accds.getStringAt(i,"SYT");

              if ( orgid==deforg ) {
              	sytlistid +=sytid +",";
              
              }
              
        }  
        return sytlistid ;
}

// �õ��������Ķ���
function GetLayout()
{
       var xml = "";
        var sytds = xmldbpack.EAORGXmlDB.getOrgDs();
	var ds = new pubpack.EAXmlDS();
	

	var num = 0;
        for( var i=0;i< sytds.getRowCount(); i ++ ) {
		var selsytid = sytds.getStringAt(i,"ID");
		
		if ( thissytid == selsytid ) {
			var fileurl=pubpack.EAOption.dynaDataRoot + "org/" + selsytid+"/layout";     
			var fileurl1=pubpack.EAOption.dynaDataRoot + "org/" + selsytid+"/layout/index.layout";   
			var pagexml = "";
			try {pagexml =pubpack.EAFunc.readFile(fileurl1);
			}catch ( e ) {
				throw new pubpack.EAException("Ŀ¼Ϊ�գ�û�м�¼");
			}
		        var pageds  = new pubpack.EAXmlDS(pagexml); 
			var folds = (new java.io.File(fileurl)).listFiles();
			if ( folds != null ) {
				folds=pub.EAFunc.sort(folds);
				var c = folds.length();
				for(var i=0;i<c;i++) {
					var f=folds[i];
					if(!f.isDirectory() ) {
						var filename = f.getName();
		            			var index = filename.indexOf(".sxg");	
						if ( index >=0  ) {
							var row= ds.AddRow(ds.getRowCount()-1);
							num++;
							ds.setValueAt(row,"SEQID",num);
							ds.setValueAt(row,"FILENAME",filename);
							var layoutid = filename.substring(0,index);
							for ( var j=0;j<pageds.getRowCount();j++){
								if ( pageds.getStringAt(j,"ID")==layoutid ){
									ds.setValueAt(row,"NOTE",pageds.getStringAt(j,"TITLE"));
									break;
								}
							}
							ds.setValueAt(row,"SYTID",selsytid );
							ds.setValueAt(row,"ACTION","�޸Ĳ���" );
							ds.setValueAt(row,"ACTION1","ɾ������" );
						}	
					}
				}
			}
		}
	}
	if ( ds.getRowCount() > 0 ) {
		var ds0 = ds.sort( "FILENAME" );
		for( var i=0;i< ds0.getRowCount(); i ++ ) {
	              var id = ds0.getStringAt(i,"FILENAME");
	              var name = ds0.getStringAt(i,"NOTE");
	              
	              name = pubpack.EAFunc.Replace(name," ","");
	              xml+="<"+id+name +" imageid=\""+imageid+"\"  orgid=\""+thissytid+"\" typ=\""+typ+"\" todo=\"openlayout\" layoutid=\""+id+"\">";      // sytflg˵���ýڵ���һ��ϵͳ
	              
	              xml+="</"+id+name +">";
	        }  
		
	 }             
           

	xml+="<���� imageid=\"9\"  orgid=\""+thissytid+"\" typ=\""+typ+"\" todo=\"openlayout\" layoutid=\"\"></����>";      // sytflg˵���ýڵ���һ��ϵͳ
        return xml;
}
// �õ������б�
function GetDIMMOD()
{
	var xml = "<?xml version='1.0' encoding='GBK'>";
	//var ds = xmldbpack.EAGRDXmlDB.getSytWMList(selsytid,selgrdtyp);
	var sql = "select id,name,guid from dim_model where sytid='"+selsytid+"' order by id";
	var ds = pubpack.EADbTool.QuerySQL(sql);
	if ( ds == null ) return "";
	for ( var i=0;i<ds.getRowCount() ; i ++ ) {
		var id =ds.getStringAt(i,"ID");
		var name = ds.getStringAt(i,"NAME");
		var guid = ds.getStringAt(i,"GUID");
		xml+="<"+name + " imageid=\"5\" modid=\""+id+"\" sytid=\""+selsytid+"\" typ=\""+typ+"\" todo=\"dimmodel\" modguid=\""+guid+"\" topicid=\"\" />";

	}
	xml+="<��������ģ��  imageid=\"5\"  sytid=\""+selsytid+"\" typ=\""+typ+"\" todo=\"newdimmod\" modguid=\"\"/>";

	return xml;
}
//�õ�ģ���������������
function GetDIMTOPIC()
{
	var xml = _GetDIMTOPIC("",modguid,selsytid,typ);
	xml+="<��������  sytid=\""+selsytid+"\" typ=\""+typ+"\" todo=\"newtopic\" modguid=\""+modguid+"\" topicid=\""+topicid+"\"/>";
	return xml;
}
//���͵ݹ麯��
function _GetDIMTOPIC(topicid,modguid,selsytid,typ)
{
	var xml = "<?xml version='1.0' encoding='GBK'>";
	var refidstr = " and refid is null ";
	if ( topicid!= "" ) 
		refidstr = " and refid='"+topicid+"'";
	var sql = "select id,name,guid from dim_topic where refmod='"+modguid+"' "+refidstr+" order by id";

	var ds = pubpack.EADbTool.QuerySQL(sql);
	if ( ds == null ) return "";
	for ( var i=0;i<ds.getRowCount() ; i ++ ) {
		var id =ds.getStringAt(i,"ID");
		var name = ds.getStringAt(i,"NAME");
		var guid = ds.getStringAt(i,"GUID");
		xml+="<"+id+"-"+name + " topicid=\""+id+"\" sytid=\""+selsytid+"\" typ=\""+typ+"\" todo=\"dimtopic\" modguid=\""+modguid+"\" topicguid=\""+guid+"\">";
		//�ݹ飬�ҳ��¼����е�
		xml+=_GetDIMTOPIC(id ,modguid,selsytid,typ);
		xml+="</"+id+"-"+name+">";

	}
	//xml+="<�ڱ�����������  sytid=\""+selsytid+"\" typ=\""+typ+"\" todo=\"newtopic\" modguid=\""+modguid+"\" topicid=\""+topicid+"\"/>";

	return xml;
}

// �õ������б�
function GetGrdList()
{
	var xml = "<?xml version='1.0' encoding='GBK'>";
	//var ds = xmldbpack.EAGRDXmlDB.getSytWMList(selsytid,selgrdtyp);
	var sql = "select id,name from sysmw where syt='"+selsytid+"' and mwtyp='"+mwcls+"'";
	if ( subcls=="") 
		sql+=" and typ is null ";
	else sql+=" and typ ='"+subcls+"'";

	
	var ds = pubpack.EADbTool.QuerySQL(sql);
	if ( ds == null ) return "";
	for ( var i=0;i<ds.getRowCount() ; i ++ ) {
		var id =ds.getStringAt(i,"ID");
		var name = ds.getStringAt(i,"NAME");

		xml+="<"+id+" name=\""+name+"\" mwid=\""+id+"\" mwcls=\""+mwcls+"\" sytid=\""+selsytid+"\" typ=\""+typ+"\" todo=\"openmw\"/>";

	}
	return xml;
}
function GetGrdTypList()
{
	var xml = "<?xml version='1.0' encoding='GBK'>";
	var sql ="select distinct mwtyp,typ,decode(mwtyp,'R','����','Q','��ѯ','F','��','B','����','����')||'-'||NVL(typ,'δ����') id from sysmw where syt='"+selsytid+"' ";
	if ( typ=="REP" ) 
		sql+= " and mwtyp ='R' ";
	else if ( typ=="FORM" ) 
		sql+= " and mwtyp='F' ";
	else if ( typ=="BILL" ) 
		sql+= " and mwtyp ='B' ";
	else if ( typ=="QUERY" ) 
		sql+= " and mwtyp ='Q'";

	else sql+= " and mwtyp not in ( 'R','Q','F','B') ";
	sql+=" order by mwtyp,typ";
	var ds = pubpack.EADbTool.QuerySQL(sql);
	if ( ds == null ) return "";
	for ( var i=0;i<ds.getRowCount() ; i ++ ) {
		var id =ds.getStringAt(i,"id");
		var mwtyp= ds.getStringAt(i,"mwtyp");
		var subcls= ds.getStringAt(i,"typ");

		xml+="<"+id + " mwcls=\""+mwtyp+"\" subcls=\""+subcls+"\" sytid=\""+selsytid+"\" typ=\""+typ+"\" todo=\"openmwtyp\"/>";

	}
	if ( typ=="REP" ) {
		xml+= "<���������м�� mwcls=\"R\" subcls=\"\" sytid=\""+selsytid+"\" typ=\""+typ+"\" todo=\"newmwtyp\"/>";
		
	}
	else if ( typ=="BILL" ) {
		xml+= "<���������м�� mwcls=\"B\" subcls=\"\" sytid=\""+selsytid+"\" typ=\""+typ+"\" todo=\"newmwtyp\"/>";
	}
	else if ( typ=="FORM" ) {
		xml+= "<�������м�� mwcls=\"F\" subcls=\"\" sytid=\""+selsytid+"\" typ=\""+typ+"\" todo=\"newmwtyp\"/>";
	}
	else if ( typ=="QUERY" ) {
		xml+= "<������ѯ�м�� mwcls=\"Q\" subcls=\"\" sytid=\""+selsytid+"\" typ=\""+typ+"\" todo=\"newmwtyp\"/>";

	}

	else 
		xml+= "<���������м�� mwcls=\"M\" subcls=\"\" sytid=\""+selsytid+"\" typ=\""+typ+"\" todo=\"newmwtyp\"/>";

	return xml;
}

//"typ=" +typ+"&imageid=2&sub=wsflow"
// sub ��׺
function GetFlowGraph()
{
        var xml = "";
        var sytds = xmldbpack.EASYTXmlDB.getSytDS();
	var ds = new pubpack.EAXmlDS();
	var num = 0;
	if( sub=="" ) sub="flow";
	
        for( var i=0;i< sytds.getRowCount(); i ++ ) {
		var selsytid = sytds.getStringAt(i,"ID");
		if ( thissytid == selsytid ) {
			var fileurl=basePath + pub.EAOption.get("xmldb.file.grddb")+"/syt" + selsytid;     
			//throw new pubpack.EAException(fileurl);         
			var folds = (new java.io.File(fileurl)).listFiles();
			if ( folds != null ) {
				folds=pub.EAFunc.sort(folds);
				var c = folds.length();
				for(var i=0;i<c;i++) {
					var f=folds[i];
					if(!f.isDirectory() ) {
						var filename = f.getName();
		            			var index = filename.indexOf("."+sub);	
						if ( index >=0  ) {
							var row= ds.AddRow(ds.getRowCount()-1);
							num++;
							ds.setValueAt(row,"SEQID",num);
							ds.setValueAt(row,"FILENAME",filename);
							ds.setValueAt(row,"NOTE","ͼ"+filename);
							ds.setValueAt(row,"SYTID",selsytid );
						}	
					}
				}
			}
		}
	}

	if ( ds.getRowCount() > 0 ) {
		var ds0 = ds.sort( "FILENAME" );
		for( var i=0;i< ds0.getRowCount(); i ++ ) {
	              var id = ds0.getStringAt(i,"FILENAME");
	              var name = ds0.getStringAt(i,"NOTE");
	              
	              name = pubpack.EAFunc.Replace(name," ","");
	              xml+="<"+id +" imageid=\""+imageid+"\"  sytid=\""+thissytid+"\" typ=\""+typ+"\" todo=\"open"+typ+"\" wsid=\""+id+"\">";      // sytflg˵���ýڵ���һ��ϵͳ
	              
	              xml+="</"+id +">";
	        }  
		
	}
	xml+="<����ͼ imageid=\"9\"   sytid=\""+thissytid+"\" typ=\""+typ+"\" todo=\"open"+typ+"\" wsid=\"\"></����ͼ>";      // sytflg˵���ýڵ���һ��ϵͳ

	if( typ=="WSFLOW" ) {
		
		xml+="<WS������ imageid=\"9\"   sytid=\""+thissytid+"\" typ=\""+typ+"\" todo=\"list"+typ+"\" wsid=\"\"></WS������>";      // sytflg˵���ýڵ���һ��ϵͳ
	}
	else if ( typ == "Flow" ) {
		
		xml+="<���������� imageid=\"9\"   sytid=\""+thissytid+"\" typ=\""+typ+"\" todo=\"list"+typ+"\" wsid=\"\"></����������>";      // sytflg˵���ýڵ���һ��ϵͳ
	
	}
	else if ( typ == "WorkFlow" ) {
		
	}
	else if ( typ == "Database" ) {
		
	}
	else if ( typ == "SSO" ) {
		xml+="<SSOվ�㶨�� imageid=\"9\"   sytid=\""+thissytid+"\" typ=\""+typ+"\" todo=\"list"+typ+"\" wsid=\"\"></SSOվ�㶨��>";      // sytflg˵���ýڵ���һ��ϵͳ

	}	
	return xml;


}


}