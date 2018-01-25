/**
 * CRAN_VEC_ADV_Rebalp_TST  Rebalp unit test
 *
 * Fecha: 14/03/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/

@isTest
public with sharing class CRAN_VEC_ADV_Rebalp_TST {
	@isTest 
	static void Rebalp_model_test() {
		CRAN_VEC_ADV_NewRebalpRQ newRebalp = (CRAN_VEC_ADV_NewRebalpRQ)JSON.deserialize('{"lang":"en","objList":[{"objType":"cont","obj":[{"avqId":"5473887"},{"avqId":"5473899"}]}],"rebalMethod":"ips","invstAmount":"100000","invstCurry":"EUR"}',CRAN_VEC_ADV_NewRebalpRQ.class);
		CRAN_VEC_ADV_RebalpRQ rebalp = (CRAN_VEC_ADV_RebalpRQ)JSON.deserialize('{"lang":"en","order":{"orderNr":"99485433","isNew":false}}',CRAN_VEC_ADV_RebalpRQ.class);
		CRAN_VEC_ADV_RebalpRS rebalpRs = (CRAN_VEC_ADV_RebalpRS)JSON.deserialize('{"order":{"orderNr":"99485433","isNew":false},"status":"rdy_trx_gen"}',CRAN_VEC_ADV_RebalpRS.class);
		
		newRebalp.setLang(newRebalp.getLang());
		newRebalp.setRebalMethod(newRebalp.getRebalMethod());
		newRebalp.setInvstAmount(newRebalp.getInvstAmount());
		newRebalp.setInvstCurry(newRebalp.getInvstCurry());
		newRebalp.setObjList(newRebalp.getObjList());

		rebalp.setLang(rebalp.getLang());
		rebalp.setOrder(rebalp.getOrder());

		rebalpRs.setOrder(rebalpRs.getOrder());
		rebalpRs.setStatus(rebalpRs.getStatus());
		System.assert('rdy_trx_gen'.equals(rebalpRs.getStatus()));
	}
}