namespace com.sap.gtt.app.deliverysample.filteronitem;

using com.sap.gtt.app.deliverysample.filteronitem.DeliveryModel;
using com.sap.gtt.core.CoreServices.TrackedProcessService;
using com.sap.gtt.core.CoreModel;

service DeliveryService @extends: TrackedProcessService {

	@CoreModel.UsageType: #userInterface
	@CoreModel.MainEntity: true
	entity DeliveryProcess as projection on DeliveryModel.DeliveryProcess excluding {
		tenant, name, trackedProcessType,
		lastProcessedEvent,
		CreatedByUser, CreationDateTime,
		LastChangedByUser, LastChangeDateTime
	};

	entity DeliveryItem as projection on DeliveryModel.DeliveryItem;

	entity PickingCompletedEvent as projection on DeliveryModel.PickingCompletedEvent;
	entity GoodsIssuedEvent as projection on DeliveryModel.GoodsIssuedEvent;
	entity ProofOfDeliveryEvent as projection on DeliveryModel.ProofOfDeliveryEvent;
	entity DelayedEvent as projection on DeliveryModel.DelayedEvent;
	entity GoodsDamageEvent as projection on DeliveryModel.GoodsDamageEvent;

	//
	// Entities for Value Lists
	//
	entity DeliveryStatus        as projection on DeliveryModel.DeliveryStatus;
	entity ShippingStatus        as projection on DeliveryModel.ShippingStatus;
	entity ShippingType          as projection on DeliveryModel.ShippingType;
	
	// Entity AllTrackedProcessXXX for hierarchy table
	entity AllTrackedProcessForDeliveryProcess as projection on DeliveryModel.AllTrackedProcessForDeliveryProcess;
	
	entity DeliveryItemForSearch as projection on DeliveryModel.DeliveryItemForSearch;
};
