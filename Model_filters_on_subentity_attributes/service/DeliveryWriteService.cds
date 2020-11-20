namespace com.sap.gtt.app.deliverysample.filteronitem;

using com.sap.gtt.app.deliverysample.filteronitem.DeliveryModel;
using com.sap.gtt.core.CoreServices.TrackedProcessWriteService;
using com.sap.gtt.core.CoreModel;

service DeliveryWriteService @extends: TrackedProcessWriteService {

	entity DeliveryProcess as projection on DeliveryModel.DeliveryProcessForWrite excluding { 
		shippingStatus, deliveryStatus
	}
	actions {
		@Swagger.POST
		action deliveryProcess(@Swagger.parameter: 'requestBody' deliveryProcess: DeliveryProcess) returns String;
	};

	entity DeliveryItem as projection on DeliveryModel.DeliveryItem excluding {
		delivery
	};

	entity PickingCompletedEvent as projection on DeliveryModel.PickingCompletedEventForWrite 
	actions {
		@Swagger.POST
		action pickingCompletedEvent(@Swagger.parameter: 'requestBody' pickingCompletedEvent: PickingCompletedEvent) returns String;
	};

	entity GoodsIssuedEvent as projection on DeliveryModel.GoodsIssuedEventForWrite 
	actions {
		@Swagger.POST
		action goodsIssuedEvent(@Swagger.parameter: 'requestBody' goodsIssuedEvent: GoodsIssuedEvent) returns String;
	};

	entity ProofOfDeliveryEvent as projection on DeliveryModel.ProofOfDeliveryEventForWrite 
	actions {
		@Swagger.POST
		action proofOfDeliveryEvent(@Swagger.parameter: 'requestBody' proofOfDeliveryEvent: ProofOfDeliveryEvent) returns String;
	};

	entity DelayedEvent as projection on DeliveryModel.DelayedEventForWrite 
	actions {
		@Swagger.POST
		action delayedEvent(@Swagger.parameter: 'requestBody' delayedEvent: DelayedEvent) returns String;
	};
    
	entity GoodsDamageEvent as projection on DeliveryModel.GoodsDamageEventForWrite 
	actions {
		@Swagger.POST
		action goodsDamageEvent(@Swagger.parameter: 'requestBody' goodsDamageEvent: GoodsDamageEvent) returns String;
	};

};

