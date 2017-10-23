function x_7-11(){var text = new JavaPackage("java.text");
function test()
{

return FormatDataString("Sat Nov 10 00:00:00 CST 2012");
}


function FormatDataString(datestr)
{
        var sdf = new text.SimpleDateFormat("dd/MM/yyyy");
        var dat = sdf.parse(datestr);
        return dat;
}




}