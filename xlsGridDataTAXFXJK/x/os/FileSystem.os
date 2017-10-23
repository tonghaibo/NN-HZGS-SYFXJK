function x_FileSystem(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var xmldbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var iopack = new JavaPackage ( "java.io" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
var basePath = pubpack.EAOption.dynaDataRoot;

//================================================================// 
// 函数：LoadFile
// 说明：载入一个文件路径的所有文件
// 参数：path
// 返回：
// 样例：
// 作者：
// 创建日期：12/03/06 22:47:11
// 修改日志：
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
                  // 没有目录，不需要报错
                  //return e.toString();
              //}
              xml += "</"+path+">";
              throw new Exception(xml);
              return xml;
}              
}