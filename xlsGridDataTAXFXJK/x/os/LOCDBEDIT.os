function x_LOCDBEDIT(){
//��������ά����������ǰ
//�ű��ڴ˽��в���У�飬������֤�����Ƿ���԰�ȫɾ��
//action: + ����; U ����; - ɾ��
//datads: ά�����洫����������
//rowno: ��ǰҪ������������
function beforeSaveDbData(action,eadb,datads,rowno)
//var eadb = new pub.EADatabase(); var datads = new EAXmlDS();
{
  var guid = datads.getStringAt(rowno,"guid");
  var orgid=datads.getStringAt(rowno,"��֯���");
  var locid=datads.getStringAt(rowno,"�ֿ���");
  if(guid == "") return;
  var oldid;
  var usecount;
  //try{
  	oldid = eadb.GetSQL("select id from LOC where guid='%s'".format([guid]));
  	usecount = eadb.GetSQL("select count(*) from bilhdr where org='%s' and locid='%s'".format([orgid,oldid]));
  //}catch(e) {return;}
  if( usecount>0)
    if( action=="-" || (action=="U" && oldid != locid) )
    {
      throw new Exception("�ֿ�%s�Ѿ�ʹ��,�����޸Ļ�ɾ���òֿ⡣".format([oldid]));
    }
}

}