@isTest
private class CRAN_VEC_ADV_Pojo_TST {
	
	@isTest 
	static void CRAN_VEC_ADV_OmsDocument_RS_TST() {
		CRAN_VEC_ADV_OmsDocument_RS response = new CRAN_VEC_ADV_OmsDocument_RS();
		response.pdfContent = 'Contenido';
		response.errors = new List<CRAN_VEC_ADV_ProcessSTError_CLS>();
	}
	
	
	@isTest 
	static void CRAN_VEC_ADV_MergeOMS_RS_TST() {
		CRAN_VEC_ADV_MergeOMS_RS response = new CRAN_VEC_ADV_MergeOMS_RS();
		response.pdfContent = 'Contenido';
		response.errors = new List<CRAN_VEC_ADV_ProcessSTError_CLS>();
	}

	@isTest 
	static void CRAN_VEC_ADV_OmsPrintList_RS_TST() {
		CRAN_VEC_ADV_OmsPrintList_RS response = new CRAN_VEC_ADV_OmsPrintList_RS();
		List<CRAN_VEC_ADV_OmsPrintList_RS.Oms> omsList = new List<CRAN_VEC_ADV_OmsPrintList_RS.Oms>();
		CRAN_VEC_ADV_OmsPrintList_RS.Oms oms = new  CRAN_VEC_ADV_OmsPrintList_RS.Oms();
		oms.omsId = '1111';
		oms.orderNr = '1112';
		omsList.add(oms);

		response.omsIdList = omsList;
		response.errors = new List<CRAN_VEC_ADV_ProcessSTError_CLS>();
	}

	
	@isTest 
	static void CRAN_VEC_ADV_DetOrderRS_TST() {
		CRAN_VEC_ADV_DetOrderRS response = new CRAN_VEC_ADV_DetOrderRS();
		response.setErrors(new List<CRAN_VEC_ADV_ProcessSTError_CLS>());
		response.getErrors();
        CRAN_VEC_ADV_OrderDet_RS orderDet = new CRAN_VEC_ADV_OrderDet_RS();
        orderDet.setOrderNr('1111111');
        orderDet.setIsNew(true);
        orderDet.getOrderNr();
        orderDet.getIsNew();
        orderDet.personId = '233';
        orderDet.rolId = '233';
        orderDet.expiryDate = '233';
        orderDet.expired = '233';
		response.setOrder(orderDet);
		response.getOrder();
		List<CRAN_VEC_ADV_DetRebalpVersionRS> versionList = new List<CRAN_VEC_ADV_DetRebalpVersionRS>();
		CRAN_VEC_ADV_DetRebalpVersionRS version = new CRAN_VEC_ADV_DetRebalpVersionRS();
		version.setIsFinal('IsFinal');
		version.getIsFinal();
		version.setName('Name');
		version.getName();
		version.setId('Id');
		version.getId();
		version.setInvstAmount(123);
		version.getInvstAmount();
		version.setInvstCurry('invstCurry');
		version.getInvstCurry();
		version.setNode(new CRAN_VEC_ADV_CalcRebalpNodeRS());
		version.getNode();
		version.setRestrList(new List<CRAN_VEC_ADV_CalcRebalpRestrictionRS>());
		version.getRestrList();
		version.setOmsId('omsId');
		version.getOmsId();
		List<CRAN_VEC_ADV_DetRebalpVersionRS.CRAN_VEC_ADV_OrderItem_CLS> refOrderList = new List<CRAN_VEC_ADV_DetRebalpVersionRS.CRAN_VEC_ADV_OrderItem_CLS>();
		CRAN_VEC_ADV_DetRebalpVersionRS.CRAN_VEC_ADV_OrderItem_CLS order = new CRAN_VEC_ADV_DetRebalpVersionRS.CRAN_VEC_ADV_OrderItem_CLS();
		order.orderNr = 'nr';
		order.hasRestr = 'Yes';
		order.metaType = 'metaType';
		order.metaTypeId = 'metaTypeId';
		order.type = 'type';
		order.typeId = 'typeId';
		order.orderType = 'orderType';
		order.orderTypeId = 'orderTypeId';
		order.orderStatus = 'orderStatus';
		order.orderStatusId = 'orderStatusId';
		order.orderPrcEstim = 1;
		order.orderLimit = 1;
		order.orderQty = 1;
		order.apprxAmount = 1;
		order.sellAmount = 1;
		order.sellCurry = 'sellCurry';
		order.buyAmount = 1;
		order.buyCurry = 'buyCurry';
		order.xrateType = 21;
		order.orderTrxDate = 'orderTrxDate';
		order.omsId = 'omsId';
		CRAN_VEC_ADV_DetRebalpVersionRS.CRAN_VEC_ADV_AssetItem item = new CRAN_VEC_ADV_DetRebalpVersionRS.CRAN_VEC_ADV_AssetItem();
		item.assetName = 'assetName';
		item.assetId = 'assetId';
		item.assetBuId = 'assetBuId';
		item.isin = 'isin';
		item.assetType = 'assetType';
		item.assetTypeId = 'assetTypeId';
		item.assetRefCurry = 'assetRefCurry';
		order.assetItem = item;
		refOrderList.add(order);
		CRAN_VEC_ADV_DetRebalpVersionRS.CRAN_VEC_ADV_ListOrderItem_CLS listOrderItem = new CRAN_VEC_ADV_DetRebalpVersionRS.CRAN_VEC_ADV_ListOrderItem_CLS();
		listOrderItem.orderItem = refOrderList;
		version.refOrderList = refOrderList;
		versionList.add(version);
		response.setVersionList(versionList);
		response.getVersionList();
	}

	@isTest 
	static void CRAN_VEC_ADV_MergeOMS_RQ_TST() {
		CRAN_VEC_ADV_MergeOMS_RQ mergeOmsRq = new CRAN_VEC_ADV_MergeOMS_RQ();
		List<CRAN_VEC_ADV_MergeOMS_RQ.Oms> omsList = new List<CRAN_VEC_ADV_MergeOMS_RQ.Oms>();
		CRAN_VEC_ADV_MergeOMS_RQ.Oms oms = new CRAN_VEC_ADV_MergeOMS_RQ.Oms();		
		oms.omsId = '1111';
		omsList.add(oms);
		mergeOmsRq.omsList = omsList;
	}

	
	@isTest 
	static void CRAN_VEC_ADV_CalcRebalpRestrictionRS_TST() {
		CRAN_VEC_ADV_CalcRebalpRestrictionRS crrestRs = new CRAN_VEC_ADV_CalcRebalpRestrictionRS();
		crrestRs.setId('1111');
		crrestRs.getId();
		crrestRs.setName('name');
		crrestRs.getName();
		crrestRs.setTypeName('typeName');
		crrestRs.getTypeName();
		crrestRs.setTopRestr('topRestr');
		crrestRs.getTopRestr();
		crrestRs.setEvalResult('evalResult');
		crrestRs.getEvalResult();
		crrestRs.setRemark('remark');
		crrestRs.getRemark();
		crrestRs.setViolObj('violObj');
		crrestRs.getViolObj();
		crrestRs.setViolClass('violClass');
		crrestRs.getViolClass();
		crrestRs.setViolValue('SviolValue');
		crrestRs.getViolValue();
		crrestRs.setValueFrom('SvalueFrom');
		crrestRs.getValueFrom();
		crrestRs.setValueTo('valueTo');
		crrestRs.getValueTo();
		crrestRs.setPrio('prio');
		crrestRs.getPrio();
		crrestRs.setOverrideRestr(true);
		crrestRs.getOverrideRestr();
		crrestRs.setJustif('justif');
		crrestRs.getJustif();
		crrestRs.setOrderNr('orderNr');
		crrestRs.getOrderNr();
	}

	
	@isTest 
	static void CRAN_VEC_ADV_CalcRebalpRQ_TST() {
		CRAN_VEC_ADV_CalcRebalpRQ crRq = new CRAN_VEC_ADV_CalcRebalpRQ();
		crRq.setLang('lang');
		crRq.getLang();
		crRq.setPrintMode('printMode');
		crRq.getPrintMode();
		crRq.setOrder(new CRAN_VEC_ADV_Order_CLS());
		crRq.getOrder();
		crRq.setVersionList(new List<CRAN_VEC_ADV_CalcRebalpVersion>());
		crRq.getVersionList();
	}

	
	@isTest 
	static void CRAN_VEC_ADV_CalcRebalpVersion_TST() {
		CRAN_VEC_ADV_CalcRebalpVersion crv = new CRAN_VEC_ADV_CalcRebalpVersion();
		crv.setIsFinal(true);
		crv.getIsFinal();
		crv.setName('name');
		crv.getName();
		crv.setId('id');
		crv.getId();
		crv.setInvstAmount(11);
		crv.getInvstAmount();
		crv.setInvstCurry('invstCurry');
		crv.getInvstCurry();
		crv.setNodeList(new List<CRAN_VEC_ADV_CalcRebalpNodeList>());
		crv.getNodeList();
		crv.setRestrList(new List<CRAN_VEC_ADV_CalcRebalpRestriction>());
		crv.getRestrList();
	}

	
	@isTest 
	static void CRAN_VEC_ADV_CalcRebalpVersionRS_TST() {
		CRAN_VEC_ADV_CalcRebalpVersionRS crvRs = new CRAN_VEC_ADV_CalcRebalpVersionRS();
		crvRs.setIsFinal('isFinal');
		crvRs.getIsFinal();
		crvRs.setName('name');
		crvRs.getName();
		crvRs.setId('id');
		crvRs.getId();
		crvRs.setInvstAmount(11);
		crvRs.getInvstAmount();
		crvRs.setInvstCurry('invstCurry');
		crvRs.getInvstCurry();
		crvRs.setNode(new CRAN_VEC_ADV_CalcRebalpNodeRS());
		crvRs.getNode();
		crvRs.setRestrList(new List<CRAN_VEC_ADV_CalcRebalpRestrictionRS>());
		crvRs.getRestrList();
		crvRs.setOmsId('omsId');
		crvRs.getOmsId();
	}

	
	@isTest 
	static void CRAN_VEC_ADV_NewCustomFormRQ_CLS_TST() {
		CRAN_VEC_ADV_NewCustomFormRQ_CLS ncfRq = new CRAN_VEC_ADV_NewCustomFormRQ_CLS();
		ncfRq.setLang('lang');
		ncfRq.getLang();
		ncfRq.setObjList(new List<CRAN_VEC_ADV_ObjList_CLS>());
		ncfRq.getObjList();
		ncfRq.setQuestType('questType');
		ncfRq.getQuestType();
		ncfRq.setIsAdvBp(true);
		ncfRq.getIsAdvBp();
	}

	
	@isTest 
	static void CRAN_VEC_ADV_RebalpList_RS_TST() {
		CRAN_VEC_ADV_RebalpList_RS rlRs = new CRAN_VEC_ADV_RebalpList_RS();
		List<CRAN_VEC_ADV_RebalpList_RS.OrderItem>listOi = new List<CRAN_VEC_ADV_RebalpList_RS.OrderItem>();
		CRAN_VEC_ADV_RebalpList_RS.OrderItem rlRsOi = new CRAN_VEC_ADV_RebalpList_RS.OrderItem();
		rlRsOi.orderNr = '1111';
		rlRsOi.hasRestr = 'No';
		rlRsOi.metaType = 'metaType';
		rlRsOi.type = 'type';
		rlRsOi.orderStatusId = 'orderStatusId';
		rlRsOi.orderStatus = 'orderStatus';
		rlRsOi.orderPrcEstim = 11;
		rlRsOi.orderQty = 12;
		rlRsOi.orderTrxDate = 'orderTrxDate';
		rlRsOi.apprAmount = 13;
		rlRsOi.omsId = '1112';
		CRAN_VEC_ADV_RebalpList_RS.AssetItem ai = new CRAN_VEC_ADV_RebalpList_RS.AssetItem();
		ai.assetName = 'assetName';
		ai.isin = 'isin';
		ai.assetType = 'assetType';
		ai.assetRefCurry = 'assetRefCurry';
		rlRsOi.assetItem = ai;
		rlRsOi.orderType = 'orderType';
		listOi.add(rlRsOi);
		List<CRAN_VEC_ADV_RebalpList_RS.Proposal> listProp = new List<CRAN_VEC_ADV_RebalpList_RS.Proposal>();
		CRAN_VEC_ADV_RebalpList_RS.Proposal prop = new CRAN_VEC_ADV_RebalpList_RS.Proposal();
		prop.bpId = 'bpId';
		prop.contId = 'contId';
		prop.propStatusId = 'propStatusId';
		prop.propDate = 'propDate';
		prop.propOrderNr = 'propOrderNr';
		prop.propDesc = 'propDesc';
		prop.propInvMeth = 'propInvMeth';
		prop.propCurry = 'propCurry';
		prop.propAmount = 'propAmount';
		prop.refOrderList = listOi;
		listProp.add(prop);
		rlRs.rebalPropList = listProp;
		rlRs.errors = new List<CRAN_VEC_ADV_ProcessSTError_CLS>();
	}

	@isTest 
	static void CRAN_VEC_ADV_ExecRebalpFinalRQ_CLS_TST() {
		CRAN_VEC_ADV_ExecRebalpFinalRQ_CLS erfrq = new CRAN_VEC_ADV_ExecRebalpFinalRQ_CLS();
		erfrq.lang= 'lang';
		erfrq.mode = 'Mode';
		erfrq.order = new CRAN_VEC_ADV_Order_CLS();

		CRAN_VEC_ADV_ExecRebalpFinalRQ_CLS.CRAN_VEC_ADV_transList_CLS tl = new CRAN_VEC_ADV_ExecRebalpFinalRQ_CLS.CRAN_VEC_ADV_transList_CLS();
		tl.orderNr = '1111';
		tl.action = true;
		List<CRAN_VEC_ADV_ExecRebalpFinalRQ_CLS.CRAN_VEC_ADV_transList_CLS> tllist = new List<CRAN_VEC_ADV_ExecRebalpFinalRQ_CLS.CRAN_VEC_ADV_transList_CLS>();
		tllist.add(tl);

		erfrq.transList = tllist;
	}

	@isTest 
	static void CRAN_VEC_ADV_OrderDet_RS_TST() {
		CRAN_VEC_ADV_OrderDet_RS od = new CRAN_VEC_ADV_OrderDet_RS();
		od.getOrderNr();
		od.setOrderNr('1111');
		od.getIsNew();
		od.setIsNew(true);
		od.personId = '1112';
		od.rolId = '1113';
		od.expiryDate = '12-01-2017';
		od.expired = 'yes';
	}

	
}