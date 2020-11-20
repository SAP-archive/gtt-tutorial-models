namespace com.sap.gtt.app.deliverysample.filteronitem;

using sap.appcore.bp.p.BusinessPartner;
using sap.appcore.loc.p.Location;
using sap.appcore.prod.p.Product;
using com.sap.gtt.core.CoreModel;

context DeliveryModel {

	// Delivery specific types
	// ----------------------------------------------------------------------
	type DocumentNumber                     : String(10); // usual document number type in SAP ERP system
	type CustomPONumber                     : String(20); // Customer purchase order number (type BSTNK) in SAP ERP system

	entity ShippingStatus {
		key Code                            : String(10) @title:'{@i18n>Status_Code}' @Common:{ Text:Text, TextArrangement:#TextOnly };
		Text                                : String(50) @title:'{@i18n>Status_Name}';
	};


	entity DeliveryStatus {
		key Code                            : String(10) @title:'{@i18n>Status_Code}' @Common:{ Text:Text, TextArrangement:#TextOnly };
		Text                                : String(50) @title:'{@i18n>Status_Name}';
		Criticality                         : Integer @Common.FieldControl:#Hidden;
	};


	entity ShippingType {
		key Code                            : String(10) @title:'{@i18n>Type_Code}' @Common:{ Text:Text, TextArrangement:#TextOnly };
		Text                                : String(50) @title:'{@i18n>Type_Name}';
	};

	// Delivery data
	// Delivery Item corresponds to ERP table LIPS
	// Delivery Head corresponds to ERP table LIKP
	// ----------------------------------------------------------------------
	entity DeliveryItem {
		key delivery                        : Association to one DeliveryProcess;
		key deliveryItem                    : String(6) @title:'{@i18n>Delivery_Item_Number}'; // LIPS-POSNR
		distributionChannel                 : String(255) @title:'{@i18n>Distribution_Channel}';
		plant                               : String(4) @title:'{@i18n>Plant}'; // LIPS-WERKS

		//@Common.SemanticObject: 'Location'
		storageLocation                     : Association to one Location.Location @title:'{@i18n>Storage_Location}'; // LIPS-LGORT

		material                            : String(40) @title:'{@i18n>Material}'; // LIPS-MATNR

		product                             : Association to one Product.Product @title:'{@i18n>Product}'; // LIPS-MATNR

		@Measures.Unit: qtyUnit
		deliveryQty                         : Decimal(13,3) @title:'{@i18n>Delivery_Quantity}'; // LIPS-LFIMG

		@Measures.Unit: qtyUnit
		pickingQty                          : Decimal(13,3) @title:'{@i18n>Picking_Quantity}';

		@Semantics.UnitOfMeasure: true
		qtyUnit                             : CoreModel.UnitOfMeasure @title:'{@i18n>Quantity_Unit}'; // LIPS-MEINS
	};

	entity DeliveryItemForSearch {
		key deliveryItem                    : String(6) @title:'{@i18n>Delivery_Item_Number}'; // LIPS-POSNR
		distributionChannel                 : String(255) @title:'{@i18n>Distribution_Channel}';
		plant                               : String(4) @title:'{@i18n>Plant}'; // LIPS-WERKS
		storageLocation                     : Association to one Location.Location @title:'{@i18n>Storage_Location}'; // LIPS-LGORT
		material                            : String(40) @title:'{@i18n>Material}'; // LIPS-MATNR
		product                             : Association to one Product.Product @title:'{@i18n>Product}'; // LIPS-MATNR
		@Measures.Unit: qtyUnit
		deliveryQty                         : Decimal(13,3) @title:'{@i18n>Delivery_Quantity}'; // LIPS-LFIMG
		@Measures.Unit: qtyUnit
		pickingQty                          : Decimal(13,3) @title:'{@i18n>Picking_Quantity}';
		@Semantics.UnitOfMeasure: true
		qtyUnit                             : CoreModel.UnitOfMeasure @title:'{@i18n>Quantity_Unit}'; // LIPS-MEINS
	};
	
	// Tracked Process "Delivery"
	// "Create" on that entity would mean to create a new delivery w/o event
	// ----------------------------------------------------------------------
	entity BaseDeliveryProcess {
		// Delivery specific data
		deliveryId                          : DocumentNumber @title:'{@i18n>Delivery_ID}'; // LIKP-VBELN
		salesOrderId                        : DocumentNumber @title:'{@i18n>Sales_Order_ID}'; // VBAK-VBELN

		shipToParty                         : Association to one BusinessPartner.BusinessPartner @title:'{@i18n>Ship_To_Party}'; // LIKP-KUNNR

		soldToParty                         : Association to one BusinessPartner.BusinessPartner @title:'{@i18n>Sold_To_Party}'; // LIKP-KUNAG

		salesOrganization                   : String(4) @title:'{@i18n>Sales_Organization}'; // VBAK-VKORG
		deliveryDate                        : Date @title:'{@i18n>Delivery_Date}'; // LIKP-LFDAT
		loadingDate                         : Date @title:'{@i18n>Loading_Date}'; // LIKP-LDDAT
		transPlanDate                       : Date @title:'{@i18n>Transportation_Plan_Date}'; // LIKP-TDDAT

		shippingPoint                       : Association to one Location.Location @title:'{@i18n>Shipping_Point}';

		@Measures.Unit: deliveryWeightUnit
		deliveryWeight                      : Decimal(15,3) @title:'{@i18n>Delivery_Weight}'; // LIKP-NTGEW

		@Measures.Unit: deliveryWeightUnit
		deliveryNetWeight                   : Decimal(15,3) @title:'{@i18n>Delivery_Net_Weight}'; // LIKP-NTGEW

		@Semantics.UnitOfMeasure: true
		deliveryWeightUnit                  : CoreModel.UnitOfMeasure @title:'{@i18n>Delivery_Weight_Unit}'; // LIKP-GEWEI

		@Measures.Unit: deliveryVolumeUnit
		deliveryVolume                      : Decimal(15,3) @title:'{@i18n>Delivery_Volume}';    // LIKP-VOLUM

		@Semantics.UnitOfMeasure: true
		deliveryVolumeUnit                  : CoreModel.UnitOfMeasure @title:'{@i18n>Delivery_Volume_Unit}'; // LIKP-VOLEH

		shippingType                        : String(20) @title: '{@i18n>Shipping_Type}' enum { // LIKP-VSART
												truck        = '01' @title: '{@i18n>Truck}';
												mail         = '02' @title: '{@i18n>Mail}';
												train        = '03' @title: '{@i18n>Train}';
												ship         = '04' @title: '{@i18n>Ship}';
											};

		purchaseOrderId                     : CustomPONumber @title:'{@i18n>Purchase_Order_ID}'; // VBAK-BSTNK
		numberOfPackages                    : Integer @title:'{@i18n>Number_of_Packages}';

		deliveryStatus                      : String(2) @title:'{@i18n>Delivery_Status}' enum {
												onTime  = '01' @title: '{@i18n>On_Time}' @Criticality: 3;
												delayed = '02' @title: '{@i18n>Delayed}' @Criticality: 1;
											} default '01';

		@CoreModel.KeepStatusSequence: true
		shippingStatus                      : String(50) @title:'{@i18n>Shipping_Status}' enum  {
												notStarted       = '01' @title: '{@i18n>Not_Started}';
												pickingCompleted = '02' @title: '{@i18n>Picking_Completed}';
												goodsIssued      = '03' @title: '{@i18n>Goods_Issued}';
												proofOfDelivery  = '04' @title: '{@i18n>Proof_of_Delivery}';
											} default '01';

		items                               : Composition of many DeliveryItem on items.delivery = $self;
	};

	@CoreModel.PlannedEvents: [
		{eventType: PickingCompletedEvent, matchLocation: false, technicalToleranceValue: 'PT1H',
			periodicOverdueDetection: 'PT24H', maxOverdueDetection: 3},
		{eventType: GoodsIssuedEvent, matchLocation: false, technicalToleranceValue: 'PT1H',
			periodicOverdueDetection: 'PT24H', maxOverdueDetection: 3},
		{eventType: ProofOfDeliveryEvent, matchLocation: false, technicalToleranceValue: 'PT1H',
			periodicOverdueDetection: 'PT24H', maxOverdueDetection: 3}
	]
	@CoreModel.AdmissibleUnplannedEvents: [
		{eventType: DelayedEvent},
		{eventType: GoodsDamageEvent},
	]
	@CoreModel.StatusProperties: ['shippingStatus', 'deliveryStatus']
	@CoreModel.Indexable: true
	entity DeliveryProcess : CoreModel.TrackedProcess, BaseDeliveryProcess{
		@CoreModel.ItemFilter.target: items
		item								: Association to one DeliveryItemForSearch;
	};
	entity DeliveryProcessForWrite : CoreModel.TrackedProcessForWrite, BaseDeliveryProcess{};
	entity AllTrackedProcessForDeliveryProcess : CoreModel.AllTrackedProcess, BaseDeliveryProcess{};

	// Event for Picking Completed
	// ----------------------------------------------------------------------
	entity BasePickingCompletedEvent {
		// event specific data
		// empty here
	};
	@UI.HeaderInfo.Title.Label: '{@i18n>Picking_Completed}'
	@SAP_EM.eventCode: {Code: 'PICK_COMPL', Text: '{@i18n>Picking_Completed}', Type: 'PLANNED'}
	@CoreModel.UpdateStatus: [
		{pathToStatus: 'DeliveryProcess.shippingStatus', newValue: '02'}
	]
	@CoreModel.Indexable: false
	entity PickingCompletedEvent : CoreModel.Event, BasePickingCompletedEvent{};
	entity PickingCompletedEventForWrite : CoreModel.EventForWrite, BasePickingCompletedEvent{};
	annotate PickingCompletedEvent with {
		location @CoreModel.ObjectIdentifierType: #customerLocation;
	};

	// Event for Goods Issued
	// ----------------------------------------------------------------------
	entity BaseGoodsIssuedEvent {
		// event specific data
		// empty here
	};
	@UI.HeaderInfo.Title.Label: '{@i18n>Goods_Issued}'
	@SAP_EM.eventCode: {Code: 'GI', Text: '{@i18n>Goods_Issued}', Type: 'PLANNED'}
	@CoreModel.UpdateStatus: [
		{pathToStatus: 'DeliveryProcess.shippingStatus', newValue: '03'}
	]
	@CoreModel.Indexable: false
	entity GoodsIssuedEvent : CoreModel.Event, BaseGoodsIssuedEvent{};
	entity GoodsIssuedEventForWrite : CoreModel.EventForWrite, BaseGoodsIssuedEvent{};
	annotate GoodsIssuedEvent with {
		location @CoreModel.ObjectIdentifierType: #customerLocation;
	};

	// Event for Proof of Delivery
	// ----------------------------------------------------------------------
	entity BaseProofOfDeliveryEvent {
		// event specific data
		// empty here
	};
	@UI.HeaderInfo.Title.Label: '{@i18n>Proof_of_Delivery}'
	@SAP_EM.eventCode: {Code: 'POD', Text: '{@i18n>Proof_of_Delivery}', Type: 'PLANNED'}
	@CoreModel.UpdateStatus: [
		{pathToStatus: 'DeliveryProcess.shippingStatus', newValue: '04'}
	]
	@CoreModel.Indexable: false
	entity ProofOfDeliveryEvent : CoreModel.Event, BaseProofOfDeliveryEvent{};
	entity ProofOfDeliveryEventForWrite : CoreModel.EventForWrite, BaseProofOfDeliveryEvent{};
	annotate ProofOfDeliveryEvent with {
		location @CoreModel.ObjectIdentifierType: #customerLocation;
	};

	// Event for delays of all kind - usually an unplanned event
	// ----------------------------------------------------------------------
	entity BaseDelayedEvent {
		// event specific data
		// empty here
	};
	@UI.HeaderInfo.Title.Label: '{@i18n>Delayed}'
	@SAP_EM.eventCode: {Code: 'DELAY', Text: '{@i18n>Delayed}', Type: 'UNPLANNED'}
	@CoreModel.UpdateStatus: [
		{pathToStatus: 'DeliveryProcess.deliveryStatus', newValue: '02'}
	]
	@CoreModel.Indexable: false
	entity DelayedEvent : CoreModel.Event, BaseDelayedEvent{};
	entity DelayedEventForWrite : CoreModel.EventForWrite, BaseDelayedEvent{};
	annotate DelayedEvent with {
		location @CoreModel.ObjectIdentifierType: #customerLocation;
	};

	// Event for Goods Damage, with 2 custom property, Damage Description, Damage Quantity
	// ----------------------------------------------------------------------
	entity BaseGoodsDamageEvent {
		damageDescription                   : String(255) @title: '{@i18n>Damage_Description}';
		damageQuantity                      : Decimal(13,3) @title: '{@i18n>Damage_Quantity}';
	};
	@UI.HeaderInfo.Title.Label: '{@i18n>Goods_Damaged}'
	@SAP_EM.eventCode: {Code: 'GD', Text: '{@i18n>Goods_Damaged}', Type: 'UNPLANNED'}
	@CoreModel.Indexable: false
	entity GoodsDamageEvent : CoreModel.Event, BaseGoodsDamageEvent{};
	entity GoodsDamageEventForWrite : CoreModel.EventForWrite, BaseGoodsDamageEvent{};
	annotate GoodsDamageEvent with {
		location @CoreModel.ObjectIdentifierType: #customerLocation;
	};


	@CoreModel.UsageType: #inboundMessage
	@SAP_EM.applicationObjectType: 'OBP10_DELIV_FILTER'
	@SAP_EM.primaryTrackingIdType: 'DEL_NO_FILTER'
	entity DeliveryProcessInbound as projection on DeliveryProcess {
		@SAP_EM.fieldName                   : 'DEL_NO'
		deliveryId,

		@SAP_EM.fieldName                   : 'SO_NO'
		salesOrderId,

		@SAP_EM.fieldName                   : 'SHIP_TO_PARTY'
		@CoreModel.ObjectIdentifierType: #customer
		shipToParty,

		@SAP_EM.fieldName                   : 'SOLD_TO_PARTY'
		@CoreModel.ObjectIdentifierType: #customer
		soldToParty,

		@SAP_EM.fieldName                   : 'SALES_ORGANIZATION'
		salesOrganization,

		@SAP_EM.fieldName                   : 'DELIVERY_DATE'
		deliveryDate,

		@SAP_EM.fieldName                   : 'LOADING_DATE'
		loadingDate,

		@SAP_EM.fieldName                   : 'TRANS_PLAN_DATE'
		transPlanDate,

		@CoreModel.ObjectIdentifierType: #shippingPoint
		@SAP_EM.fieldName                   : 'SHIPPING_POINT'
		shippingPoint,

		@SAP_EM.fieldName                   : 'DELIVERY_WEIGHT'
		deliveryWeight,

		@SAP_EM.fieldName                   : 'DELIVERY_NET_WEIGHT'
		deliveryNetWeight,

		@SAP_EM.fieldName                   : 'DELIVERY_WEIGHT_UNIT'
		deliveryWeightUnit,

		@SAP_EM.fieldName                   : 'DELIVERY_VOLUME'
		deliveryVolume,

		@SAP_EM.fieldName                   : 'DELIVERY_VOLUME_UNIT'
		deliveryVolumeUnit,

		@SAP_EM.fieldName                   : 'SHIPPING_TYPE'
		shippingType,

		@SAP_EM.fieldName                   : 'NO_OF_PACKAGES'
		numberOfPackages,

		@SAP_EM.fieldName                   : 'PO_NO'
		purchaseOrderId,

		@SAP_EM.itemizedEntity              : 'DeliveryProcessItemInbound'
		items : redirected to DeliveryProcessItemInbound
	};

	@CoreModel.UsageType: #inboundMessage
	@SAP_EM.itemized: true
	entity DeliveryProcessItemInbound as projection on DeliveryItem {
		@SAP_EM.fieldName                   : 'DELIVERY_ITEM'
		deliveryItem,

		@SAP_EM.fieldName                   : 'PLANT'
		plant,

		@SAP_EM.fieldName                   : 'STORAGE_LOC'
		storageLocation,

		@CoreModel.ObjectIdentifierType: #product
		@SAP_EM.fieldName                   : 'MATERIAL'
		product,

		@SAP_EM.fieldName                   : 'DELIVERY_QTY'
		deliveryQty,

		@SAP_EM.fieldName                   : 'QUANTITY_UNIT'
		qtyUnit,

		@SAP_EM.fieldName                   : 'PICKING_QTY'
		pickingQty,

		@SAP_EM.fieldName                   : 'DISTRIBUTION_CHANNEL'
		distributionChannel
	};

	@CoreModel.UsageType: #inboundMessage
	entity GoodsDamageEventInbound as projection on GoodsDamageEvent {
		@SAP_EM.fieldName                   : 'DAMAGE_DES'
		damageDescription,

		@SAP_EM.fieldName                   : 'DAMAGE_QUAN'
		damageQuantity
	};

};
