function x_CHIS_SEARCH(){
//
// 
//
function GetBody()
{
	
	var html = "<table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\"  height=\"25\" style=\"background:#eee;\">
			<tr>
				<td>
					<input id=\"sec\" type=\"text\" value=\"\" name=\"T1\"  style=\"border:1px solid #EAEAEA;border-radius:10px;height:40px;width:97%; margin-top: 10px; margin-bottom: 10px; margin-left: 6px;font-size:14pt; text-align:left;padding-left: 20px;padding-top: 5px;\" size=\"100%\">
				</td>
				<td onclick=\"showInfo()\">
					<img src=\"xlsgrid/images/flash/appicon/icon_63.png\" style=\"padding-left: 4px;padding-top: 2px;\" width=\"49\" height=\"38px\">
				</td>
			</tr>
		</table>
		<script>
			function showInfo() {
				var val = document.getElementById('sec').value;
				if(val.trim() == '') {
					alert('ËÑË÷Ç°,ÇëÌîÐ´ËÑË÷ÐÅÏ¢');
					return;
				}
				if('"+tablename+"' == 'YX_DOC') {
					openWindow('L.sp?id=CHIS_SERINFO&tablename="+tablename+"&val='+val.trim()+'&flg=doc');
				}
				else if('"+tablename+"'== 'YX_DOCDEPT') {
					openWindow('L.sp?id=CHIS_SERINFO&tablename="+tablename+"&val='+val.trim()+'&flg=DEPT');
				}
				else if('"+tablename+"'== 'CHIS_ICD10') {
					openWindow('L.sp?id=CHIS_SERINFO&tablename="+tablename+"&val='+val.trim()+'&flg=ICD10');
				}
			}
		</script>
		";
		
	return html;
}

}