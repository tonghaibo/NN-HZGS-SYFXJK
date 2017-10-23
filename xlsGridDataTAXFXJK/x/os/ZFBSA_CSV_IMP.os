function x_ZFBSA_CSV_IMP(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var filepack = new JavaPackage ( "java.io" );
var util = new JavaPackage ( "java.util" );

// 快速保存一个csv文件
function savetxt()
{
      var db = null;
      var ds = null;
      var ds1 = null;
      var msg= "";
      var sql = "";
      var sql1 = "";
      
      try {
      	    
      	    db = new pubpack.EADatabase();
                       
            // 先保存到临时文件
            var filename = pubpack.EAOption.dynaDataRoot+"tmp.txt";
//            throw new pubpack.EAException ( ""+filename  );
	    pubpack.EAFunc.WriteToFile(filename,filePath);
            var fi = new filepack.FileInputStream(filename);
            var ir = new filepack.InputStreamReader(fi,"GBK");
            var reader = new filepack.BufferedReader(ir);
            var lineStr = "";
            var cnt = 0 ;
            var lineno = 0;
            
            sql = "insert into IMPORT_ALIPAY(TYP,ORDERID,MNY,FREIGHT,SUMMNY,DAT)
		           values (?,?,?,?,?,?)";   
	    ds = db.GetConn().prepareStatement(sql); 
	
	    while ((lineStr = reader.readLine()) != null)
            {
//                 throw new pubpack.EAException ( ""+lineStr );	
		   lineno++;
		   if(lineno >= 2 && lineStr != ",,,")
		   {
//			    throw new pubpack.EAException ( ""+lineStr );
			    var st = new util.StringTokenizer(lineStr,",");
			    var sc = "";
			    while (st.hasMoreTokens()) { 
				// 每一行的多个字段用TAB隔开表示
				var s1 = st.nextToken(",");
							
				if( s1 == null )
				{
	//				throw new pubpack.EAException ("123");
					sc += "0,";	 
				}
				else 
					sc += s1.trim()+",";
			    } 
//			    throw new pubpack.EAException (sc);			    
	                    var strval = sc.split(",");	  
	                    var orderid = "";
	                    var mny = 0;
	                    var freight = 0;
	                    var summny = 0;
	                    var dat = null;     
	                    
	                    try        
	                    {
	                    	if(typ == "SA")
			       	{
		                    	orderid = strval[0];
		                    	mny = strval[1];
		                    	freight = strval[2];
		                    	summny = strval[3];
		                    	dat = strval[4];
		                }
		                else 
		                {
		                	orderid = strval[0];
		                    	mny = strval[1];
		                    	dat = strval[2];
		                }
	                    		                    	
	                    } catch(e){}
	     
	
//			    throw new pubpack.EAException (orderid+"-"+mny+"-"+freight+"-"+summny+",dat="+dat);   
			    	
			    if(mny != "")
			    	mny = 1.0*mny;
			    if(freight != "")
			    	freight = 1.0*freight ;
			    if(summny !="")
			    	summny = 1.0*summny ;			    	
			    
//			    throw new pubpack.EAException (""+dat);           	
//	                    throw new pubpack.EAException (""+strval.length());           
//                    	    throw new pubpack.EAException (strval[0]+"-"+strval[1]+"-"+strval[2]+"-"+strval[3]);    
                    	    
                    	    if( orderid != "" && orderid != "合计" && orderid != "小计" && (( typ == "SA" && summny != 0 ) || typ == "ZFB") )
                    	    {                                  			    
				    sql1 = "select * from IMPORT_ALIPAY where typ = '"+typ+"' and orderid = '"+orderid+"' ";
//				    throw new pubpack.EAException (sql1);
				    ds1 = db.QuerySQL(sql1);
				    			    
				    if( ds1.getRowCount() == 0 )
				    {				    
			                    if(typ == "SA")
			                    {
						    ds.setString(1,typ);
						    ds.setString(2,orderid);
						    ds.setDouble(3,mny);
				                    ds.setDouble(4,freight);
				                    ds.setDouble(5,summny);
				                    ds.setString(6,dat);
	//		                    	    throw new pubpack.EAException ("123");	                                    
			                    }
			                    else if(typ == "ZFB") 
			                    {
//			                    	    throw new pubpack.EAException ("orderid="+orderid+",mny="+mny+",dat="+dat);
			                    	    ds.setString(1,typ);
						    ds.setString(2,orderid);
						    ds.setDouble(3,0);	                                    
				                    ds.setDouble(4,0);
				                    ds.setDouble(5,mny);
				                    ds.setString(6,dat);
			                    }			                    
		                   	    ds.addBatch(); 
		                     }
		             }		        
	            }
            }      
//            throw new pubpack.EAException (ds.GetXml());       
            cnt = ds.executeBatch().length(); 
            
            if(cnt>0)
            	msg+=" 成功导入"+cnt+"笔数据！";
            else 
            	msg+=" 成功导入"+cnt+"笔数据！\n\n 请核实是否已经导入数据，或者.csv文件没有数据！";
            
	    db.Commit();
	    reader.close();
	    fi.close();
      }
      catch ( ee ) {
            db.Rollback();
            throw new pubpack.EAException ( ee.toString() );
      }
      finally {
            if (db!=null) db.Close();
      }
      return msg;
}



}