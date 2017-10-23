function x_qrcode(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var awtpack = new JavaPackage ( "java.awt" );
var awtimagepack = new JavaPackage ( "java.awt.image" );
var iopack = new JavaPackage ( "java.io" );
var imageiopack = new JavaPackage ( "javax.imageio" );
var swetakepack = new JavaPackage("com.swetake.util");

/*

�˷���˴����Ѿ���ֲ��JAVA�ˣ����÷�ʽ��
	EAQrcode.sp
	
*/

//��Ϊ.sp����ʱ�����
//Ԥ���������request,response
function Response()
{
	
      var codesize=pubpack.EAFunc.NVL( request.getParameter("codesize"),"small") ;//codesize=small(default)��big
      var srcValue=""+pubpack.EAFunc.NVL( request.getParameter("data"),"") ;//data �Ƕ�ά�������
      var action=pubpack.EAFunc.NVL( request.getParameter("action"),"decode") ;//action=decode,encode
      var imgformat=pubpack.EAFunc.NVL( request.getParameter("imgformat"),"jpg") ;//


      var max_data_size_small = 84;  
      var max_data_size_large = 500;  
      
      var ret= "ok";
      try {
      	if(action == "decode" ){	//����ͼƬ
      		//var d = srcValue.getBytes();
      		var dataLength = srcValue.length();//d.length;  
      		var imageWidth = 269;
      		var MAX_DATA_LENGTH = max_data_size_large;
      		if(codesize=="small") {
      			imageWidth = 113;
      			MAX_DATA_LENGTH = max_data_size_small;

      		}
      		var imageHeight = imageWidth ;
      		var bi = new awtimagepack.BufferedImage(imageWidth, imageHeight, awtimagepack.BufferedImage.TYPE_INT_RGB);  
        	var g = bi.createGraphics();  
        	g.setBackground(awtpack.Color.WHITE);  
        	g.clearRect(0, 0, imageWidth, imageHeight);  
        	g.setColor(awtpack.Color.BLACK);  
      		if (dataLength > 0 && dataLength <= MAX_DATA_LENGTH) {    
      		    var qrcode = new swetakepack.Qrcode();  
	            qrcode.setQrcodeErrorCorrect("M"); // L, Q, H, Ĭ��  
	            qrcode.setQrcodeEncodeMode("B"); // A, N, Ĭ��  
	            if(codesize=="small")
	                 qrcode.setQrcodeVersion(5); // 37�ֽ�, (37-1)*3+2+3-1+1 = 113  
	            else qrcode.setQrcodeVersion(18);// 0<= version <=40; 89�ֽ�,    (89-1)*3+2+3-1+1 = 269

	            var b = qrcode.calQrcode(srcValue.getBytes());//  
	            var qrcodeDataLen = b.length;  
	            for (var i = 0; i < qrcodeDataLen; i++) {  
	                for (var j = 0; j < qrcodeDataLen; j++) {  
	                    if (b[j][i]) {  
	                        g.fillRect(j * 3 + 2, i * 3 + 2, 3, 3);  
	                    }  
	                }  
	            }  
      		}
      		else {
      			if(dataLength <=0  ) return "data is null"; 
      			else return "datalength is too big,max size is "+MAX_DATA_LENGTH;  
      		}
      		g.dispose();  
        	bi.flush();  
        	try {  
	            imageiopack.ImageIO.write(bi, imgformat, response.getOutputStream() ); //"png"  
	        } catch (IOException ioe) {  
	            return "Generate QRCode image error!" + ioe.getMessage();  

	        } 
      	}
      		      
        
            
            
            
      }
      catch ( ee ) {
            //db.Rollback();
            throw new pubpack.EAException ( ee.toString() );
      }
      finally {
            //if (db!=null) db.Close();
      }
      return ret ;
}
}