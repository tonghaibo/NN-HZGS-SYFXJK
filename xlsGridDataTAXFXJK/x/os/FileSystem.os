function x_FileSystem(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var xmldbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var iopack = new JavaPackage ( "java.io" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
var basePath = pubpack.EAOption.dynaDataRoot;

//================================================================// 
// ������LoadFile
// ˵��������һ���ļ�·���������ļ�
// ������path
// ���أ�
// ������
// ���ߣ�
// �������ڣ�12/03/06 22:47:11
// �޸���־��
//================================================================// 
function LoadFile()
{
              var xml = "<?xml version = '1.0'?>";
              if ( path.length() == 0) 
                    path = basePath ;
              path+="/xmldb";
              xml += "<"+path+">" ;
              var file = new webpack.EAFileTree();
              //try {
                    xml += file.GetXml(path,"",0);
              //}
              //catch ( pubpack.EAException e ) {
                  // û��Ŀ¼������Ҫ����
                  //return e.toString();
              //}
              xml += "</"+path+">";
              throw new Exception(xml);
              return xml;
}              
}