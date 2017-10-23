function x_template_SRC_(){

function OnBeforeGenSta()
{
//
  //可用对象:eaContext,_EADB,bilhdr,bildtl(单据数据集)
  //如果把bilhdr的BILID或bildtl的ITMID清空，则跳过该单据或明细
  
  //end of func
}

function OnGenStaMemo()
{
//
  //可用对象:sta(0:单据头;1:明细),ds(单据数据集),row(当前行号);
  //返回MEMO1或MEMO2,如果返回空字符,用默认的说明信息
  //如果把ds的BILID或ITMID清空，则跳过该单据或明细
  //如果要保存额外信息到  datflwsta 中,请当sta=0时设置ds的字段,后台处理时回自动保存到
  //对应的 datflwsta 字段中:
  //  LOCID  --  REFID1      LOCNAM  --  REFNAM1
  //  CORPID --  REFID2      CORPNAM --  REFNAM2
  //  SUBTYP --  SRCSUBTYP
  
  //end of func
}

function OnUnCkeck()
{
//
  //可用对象:eaContext,_EADB(EADatabase)
  
  //end of func
}

}