<?xml version="1.0"?>
<svg  >
 <rect id="PROCESS:1"  fill="#CC6744" x="360" y="30" width="80"  height="40" selectflag="mouseclick"  menuid="-1" url="entry.sp?grdid=TK&processid=1">1未分派</rect>
 <rect id="PROCESS:1ret"  fill="#FFFFFF" stroke="#FFFFFF" x="448" y="68" width="2"  height="2" >
 </rect>
 <rect id="PROCESS:2"  fill="#FF9966" x="360" y="100" width="80"  height="40" selectflag="mouseclick"  menuid="-1" url="entry.sp?grdid=TK&processid=2">2已分派</rect>
 <rect id="PROCESS:2ret"  fill="#FFFFFF" stroke="#FFFFFF" x="448" y="138" width="2"  height="2" >
 </rect>
 <rect id="PROCESS:3"  fill="#C2A00D" x="360" y="170" width="80"  height="40" selectflag="mouseclick"  menuid="-1" url="entry.sp?grdid=TK&processid=3">3已处理</rect>
 <rect id="PROCESS:3ret"  fill="#FFFFFF" stroke="#FFFFFF" x="448" y="208" width="2"  height="2" >
 </rect>
 <rect id="PROCESS:9"  fill="#71A216" x="360" y="240" width="80"  height="40" selectflag="mouseclick"  menuid="-1" url="entry.sp?grdid=TK&processid=9">9完成</rect>
 <rect id="PROCESS:9ret"  fill="#FFFFFF" stroke="#FFFFFF" x="448" y="278" width="2"  height="2" >
 </rect>
 <rect id="PROCESS:8"  fill="#66FFCC" x="360" y="310" width="80"  height="40" selectflag="mouseclick"  menuid="-1" url="entry.sp?grdid=TK&processid=8">8分派到股室</rect>
 <rect id="PROCESS:8ret"  fill="#FFFFFF" stroke="#FFFFFF" x="448" y="348" width="2"  height="2" >
 </rect>
 <rect id="PROCESS:0"  fill="#00cc99" x="360" y="380" width="80"  height="40" selectflag="mouseclick"  menuid="-1" url="entry.sp?grdid=TK&processid=0">0关闭</rect>
 <rect id="PROCESS:0ret"  fill="#FFFFFF" stroke="#FFFFFF" x="448" y="418" width="2"  height="2" >
 </rect>
 <connector from="PROCESS:1"  to="PROCESS:2" fromcp="23" tocp="21" type="208"  id="connector_1_2" stroke="#000000">
 </connector>
 <text id="TEXT12" x="400" y="70"  width="80" height="30"  align="left" valign="middle" menuid="-1">任务分派</text>
 <connector from="PROCESS:2"  to="PROCESS:3" fromcp="23" tocp="21" type="208"  id="connector_2_3" stroke="#000000">
 </connector>
 <text id="TEXT23" x="400" y="140"  width="80" height="30"  align="left" valign="middle" menuid="-1">任务处理</text>
 <connector from="PROCESS:3"  to="PROCESS:9" fromcp="23" tocp="21" type="208"  id="connector_3_9" stroke="#000000">
 </connector>
 <text id="TEXT39" x="400" y="210"  width="80" height="30"  align="left" valign="middle" menuid="-1">任务完成</text>
 <connector from="PROCESS:1"  to="PROCESS:8" fromcp="12" tocp="12" type="208"  id="connector_1_8" stroke="#000000">
 </connector>
 <text id="TEXT18" x="280" y="30"  width="80" height="30"  align="left" valign="middle" menuid="-1">分派到股室</text>
 <connector from="PROCESS:8"  to="TEXT82" fromcp="32" tocp="12" type="108"  id="connector_8_2" stroke="#000000">
 </connector>
 <text id="TEXT82" x="480" y="350"  width="80" height="30"  align="left" valign="middle" menuid="-1">任务分派</text>
 <connector from="PROCESS:2"  to="PROCESS:1ret" fromcp="32" tocp="32" type="208"  id="connector_2_1" stroke="#000000">
 </connector>
 <text id="TEXT21" x="470" y="100"  width="80" height="30"  align="left" valign="middle" menuid="-1">取消分派</text>
 <connector from="PROCESS:1"  to="PROCESS:0" fromcp="12" tocp="12" type="208"  id="connector_1_0" stroke="#000000">
 </connector>
 <text id="TEXT10" x="280" y="30"  width="80" height="30"  align="left" valign="middle" menuid="-1">关闭</text>
 <connector from="PROCESS:2"  to="PROCESS:0" fromcp="12" tocp="12" type="208"  id="connector_2_0" stroke="#000000">
 </connector>
 <text id="TEXT20" x="280" y="100"  width="80" height="30"  align="left" valign="middle" menuid="-1">关闭</text>
 <connector from="PROCESS:3"  to="PROCESS:3" fromcp="32" tocp="12" type="208"  id="connector_3_3" stroke="#000000">
 </connector>
 <text id="TEXT33" x="0" y="0"  width="0" height="0"  align="left" valign="middle" menuid="-1">继续处理</text>
 <connector from="PROCESS:9"  to="TEXT92" fromcp="32" tocp="12" type="108"  id="connector_9_2" stroke="#000000">
 </connector>
 <text id="TEXT92" x="480" y="280"  width="80" height="30"  align="left" valign="middle" menuid="-1">重置任务</text>
</svg>
