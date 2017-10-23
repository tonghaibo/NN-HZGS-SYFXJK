function x_demo(){function demo()
{
  var url = "/login.jsp?msg="+msg;
  var nurl = java.net.URLEncoder.encode(url,"UTF-8");
  var rd = request.getRequestDispatcher(nurl);
  return url + rd + nurl;

    var sun = new JavaPackage("sun.io");
  
  var de = sun.ByteToCharConverter.getDefault().getCharacterEncoding();
  url=new String(url.getBytes(encoding),defaultencoding);
  var rd = request.getRequestDispatcher(url);
  return url + rd;

//	var ret = 1;
//	for(var i=2;i<5;i++)
//	{
//		for(var j=2;j<5;j++)
//		{
//			if(i==3)
//			break;
//		}
//		ret += i ;
//	}
//	return ret;
//  return "ok";
//  throw Exception("Exception");
}
}