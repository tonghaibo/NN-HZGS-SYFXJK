function x_testEDI(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var EAfunc = new pubpack.EAFunc();

function start()
{
	var ssss = "100165613/      Ҭ��¹������ǣ�����           ��     ��        4        -        -     4.00        -     4.00     4.00    1    1  6901160002009   �����/550ml*2/��                                                       0.00  102717619/      Ҭ��¹���һ��33��/500         ƿ     ��       12        -        -    12.00        -    12.00    12.00    1    1  6901160007073   ml/ƿ                                                                   0.00 ";
//	ssss = ssss.toString();
//	var s = ssss.replace(" {2,}", " "); 
//	var s = ssss.split("100165613");
//	var s = EAfunc.regexReplace(ssss, "\\s+",",");
//	var ss = s.split(",");
//	return ss.length();
//	return s.length();
	var count = 1;
	for(var details_r = 0;details_r < 2;details_r++)
	{
		count ++;
		details_r++;
	}
	return count;
}

}