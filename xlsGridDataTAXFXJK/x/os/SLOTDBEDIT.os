function x_SLOTDBEDIT(){
//��������ά����������ǰ
//�ű��ڴ˽��в���У�飬������֤�����Ƿ���԰�ȫɾ��
//action: + ����; U ����; - ɾ��
//datads: ά�����洫����������
//rowno: ��ǰҪ������������
function beforeSaveDbData(action,eadb,datads,rowno)
//var eadb = new pub.EADatabase(); var datads = new EAXmlDS();
{throw new Exception("�ֿ�%s��%s��λ�Ѿ�ʹ��");
  var guid = datads.getStringAt(rowno,"guid");
  var orgid = datads.getStringAt(rowno,"��֯���");
  var slotid= datads.getStringAt(rowno,"��λ���");
  var locid = datads.getStringAt(rowno,"�ֿ���");
  if(guid == "") return;
  var oldid;
  var usecount;
  //try{
  	var ds = eadb.QuerySQL("select loc,id from slot where guid='%s'".format([guid]));
  	oldloc = ds.getStringA(0,0);
  	oldslot = ds.getStringA(0,1);
  	usecount = eadb.GetSQL("select count(*) from sltmov where slot='%s'".format([guid]));
  //}catch(e) {return;}
  if( usecount>0)
    if( action=="-" || slotid != oldslot || locid != oldloc )
    {
      throw new Exception("�ֿ�%s��%s��λ�Ѿ�ʹ��,�����޸Ļ�ɾ���ÿ�λ��".format([oldloc,oldslot]));
    }  
}

}