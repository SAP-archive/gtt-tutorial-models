namespace com.sap.gtt.app.shipmentsample.partner.enhancement; // initial namespace, may be subject to change

using sap.appcore.bp.p.BusinessPartner;
using sap.appcore.loc.p.Location;
using com.sap.gtt.core.CoreModel;

context ShipmentModel {

	/// Shipment specific types
	// ----------------------------------------------------------------------
	type DocumentNumber                     : String(10); // usual document number type in SAP ERP system
	type CustomPONumber                     : String(20); // Customer purchase order number (type BSTNK) in SAP ERP system

	entity DeliveryStatus {
		key Code                            : String(10) @title:'{@i18n>Status_Code}' @Common:{ Text:Text, TextArrangement:#TextOnly };
		Text                                : String(50) @title:'{@i18n>Status_Name}';
		Criticality                         : Integer @Common.FieldControl:#Hidden;
	};

	entity ShippingType {
		key Code                            : String(10) @title:'{@i18n>Type_Code}' @Common:{ Text:Text, TextArrangement:#TextOnly };
		Text                                : String(50) @title:'{@i18n>Type_Name}';
	};

	entity ShipmentType {
		key Code                            : String(10) @title:'{@i18n>Type_Code}' @Common:{ Text:Text, TextArrangement:#TextOnly };
		Text                                : String(50) @title:'{@i18n>Type_Name}';
	};

	entity CustomStatus {
		key Code                            : String(10) @title:'{@i18n>Type_Code}' @Common:{ Text:Text, TextArrangement:#TextOnly };
		Text                                : String(50) @title:'{@i18n>Type_Name}';
	};
	
	entity TemperatureStatus {
		key Code                            : String(10) @title:'{@i18n>Status_Code}' @Common:{ Text:Text, TextArrangement:#TextOnly };
		Text                                : String(50) @title:'{@i18n>Status_Name}';
		Criticality                         : Integer @Common.FieldControl:#Hidden;
	};

	entity TransportationStatus {
		key Code                            : String(10) @title:'{@i18n>Type_Code}' @Common:{ Text:Text, TextArrangement:#TextOnly };
		Text                                : String(50) @title:'{@i18n>Type_Name}';
	};

	entity LegIndicator {
		key Code                            : String(10) @title:'{@i18n>Type_Code}' @Common:{ Text:Text, TextArrangement:#TextOnly };
		Text                                : String(50) @title:'{@i18n>Type_Name}';
	};

	entity ShipmentCompletionType {
		key Code                            : String(10) @title:'{@i18n>Type_Code}' @Common:{ Text:Text, TextArrangement:#TextOnly };
		Text                                : String(50) @title:'{@i18n>Type_Name}';
	};

	entity ShippingCondition {
		key Code                            : String(10) @title:'{@i18n>Type_Code}' @Common:{ Text:Text, TextArrangement:#TextOnly };
		Text                                : String(50) @title:'{@i18n>Type_Name}';
	};

	// Delivery data
	// ----------------------------------------------------------------------
	entity Delivery {
		key shipment                        : Association to one ShipmentProcess;
		key delivery                        : DocumentNumber @title:'{@i18n>Delivery_ID}';
	};


	// Tracked Process "Shipment"
	// "Create" on that entity would mean to create a new Shipment w/o event
	// ----------------------------------------------------------------------
	entity BaseShipmentProcess {
		// Shipment specific data
		shipmentId                          : DocumentNumber @title:'{@i18n>Shipment_ID}';
		deliveries                          : Composition of many Delivery on deliveries.shipment = $self @title: '{@i18n>Deliveries}';
		containerId                         : String(20) @title:'{@i18n>Container_ID}';
		forwardingAgent                     : Association to one BusinessPartner.BusinessPartner @title:'{@i18n>Forwarding_Agent}';
		transportationPlanningPoint         : String(4) @title:'{@i18n>Transportation_Planning_Point}';
		route                               : String(6) @title:'{@i18n>Route}';
		carrierShipmentId                   : String(20) @title:'{@i18n>Carrier_Shipment_Number}';
		externalId                          : String(20) @title:'{@i18n>External_ID2}';

		@Measures.Unit: shipmentVolumeUnit
		shipmentVolume                      : Decimal(15,3) @title:'{@i18n>Shipment_Volume}';

		@Semantics.UnitOfMeasure: true
		shipmentVolumeUnit                  : CoreModel.UnitOfMeasure @title:'{@i18n>Shipment_Volume_Unit}';

		@Measures.Unit: shipmentWeightUnit
		shipmentWeight                      : Decimal(15,3) @title:'{@i18n>Shipment_Weight}';

		@Measures.Unit: shipmentWeightUnit
		totalShipmentWeight                 : Decimal(15,3) @title:'{@i18n>Total_Shipment_Weight}';

		@Semantics.UnitOfMeasure: true
		shipmentWeightUnit                  : CoreModel.UnitOfMeasure @title:'{@i18n>Shipment_Weight_Unit}';

		shipmentType                        : String(20) @title: '{@i18n>Shipment_Type}' enum {
												individualShipmentRoad = '0001' @title: '{@i18n>Indiv_Shipment_Road}';
												collectiveShipmentRoad  = '0002' @title: '{@i18n>Collct_Shipmt_Road}';
												collectiveShipment = '0003' @title: '{@i18n>Collective_Shipment}';
												prelimLegByRoad = '0004' @title: '{@i18n>Prelim_Leg_by_Road}';
												mainLegBySea = '0005' @title: '{@i18n>Main_Leg_by_Sea}';
												subseqLegByRoad = '0006' @title: '{@i18n>Subseq_Leg_by_Road}';
												inboudShipment = '0010' @title: '{@i18n>Inbound_Shipment}';
											};

		shippingType                        : String(20) @title: '{@i18n>Shipping_Type}' enum {
												truck        = '01' @title: '{@i18n>Truck}';
												mail         = '02' @title: '{@i18n>Mail}';
												train        = '03' @title: '{@i18n>Train}';
												ship         = '04' @title: '{@i18n>Sea}';
											};

		transportationStatus                : String(20) @title:'{@i18n>Transportation_Status}' enum {
												notStarted       = '01' @title: '{@i18n>Not_Started}';
												loading          = '02' @title: '{@i18n>Loading}';
												inTransit        = '03' @title: '{@i18n>In_Transit}';
												unloading        = '04' @title: '{@i18n>Unloading}';
												arrived          = '05' @title: '{@i18n>Arrived}';
											} default '01';

		@CoreModel.keepStatusSequence       : true
		customStatus                        : String(20) @title:'{@i18n>Customs_Status}' enum {
												open             = '01' @title: '{@i18n>Open}';
												customsIn        = '02' @title: '{@i18n>Customs_In}';
												CustomsClear     = '03' @title: '{@i18n>Customs_Clear}';
											} default '01';

		deliveryStatus                      : String(20) @title:'{@i18n>Delivery_Status}' enum {
												onTime  = '01' @title: '{@i18n>On_Time}' @Criticality: 3;
												delayed = '02' @title: '{@i18n>Delayed}' @Criticality: 1;
											} default '01';
		

		shipmentCompletionType              : String(20) @title:'{@i18n>Shipment_Completion_Type}' enum {
												loadedOutboundShipment = '1' @title: '{@i18n>Loaded_Outbound_Shipment}';
												loadedInboundShipment  = '2' @title: '{@i18n>Loaded_Inbound_Shipment}';
												emptyOutboundShipment  = '3' @title: '{@i18n>Empty_Outbound_Shipment}';
												emptyInboundShipment  = '4'  @title: '{@i18n>Empty_Inbound_Shipment}';
											};

		legIndicator                        : String(20) @title:'{@i18n>Leg_Indicator}' enum {
												preliminaryLeg = '1' @title: '{@i18n>Preliminary_Leg}';
												mainLeg  = '2' @title: '{@i18n>Main_Leg}';
												subsequentLeg  = '3' @title: '{@i18n>Subsequent_Leg}';
												directLeg  = '4' @title: '{@i18n>Direct_Leg}';
												returnLeg = '5' @title: '{@i18n>Return_Leg}';
											};

		shippingCondition                   : String(20) @title:'{@i18n>Shipping_Condition}' enum {
												standard = '01' @title: '{@i18n>Standard}';
												pickUp  = '02' @title: '{@i18n>Pick_Up}';
											};
		
		/*---------------------------------- Added Parameters - Start ----------------------------------*/
		
		temperatureStatus                   : String(2) @title:'{@i18n>Temperature_Status}' enum {
												normal     = '01' @title: '{@i18n>Normal}' @Criticality: 3;
												overheated = '02' @title: '{@i18n>Overheated}' @Criticality: 1;
											} default '01';
											
		@Measures.Unit: temperatureUnit
		presentTemperature              	: String(6)  @title:'{@i18n>Temperature}';
		
		@Semantics.UnitOfMeasure: true
		temperatureUnit                     : CoreModel.UnitOfMeasure @title:'{@i18n>Temperature_Unit}'; 
		/*---------------------------------- Added Parameters - End ----------------------------------*/
		
		// Shipment map properties
		processLocations                    : Association to many CoreModel.ProcessLocation on processLocations.process = $self;
		currentProcessLocation              : Association to one CoreModel.CurrentProcessLocation {id};
		processRoute						: Association to one CoreModel.ProcessRoute {id};

		@CoreModel.Map.CurrentProcessLocation.Longitude: true
		longitude							: Decimal(9,6) @title: '{@i18n>Last_Reported_Longitude}';
		@CoreModel.Map.CurrentProcessLocation.Latitude: true
		latitude							: Decimal(8,6) @title: '{@i18n>Last_Reported_Latitude}';
		@CoreModel.Map.CurrentProcessLocation.UpdateTimestamp: true
		currentLocationTimestamp			: Timestamp @title: '{@i18n>Last_Reported_Time}';
	};
	@CoreModel.PlannedEvents: [
		{eventType: CarrierArrivalEvent, matchLocation: false, technicalToleranceValue: 'PT2H'},
		{eventType: LoadingBeginEvent, matchLocation: true, technicalToleranceValue: 'PT2H'},
		{eventType: LoadingEndEvent, matchLocation: true, technicalToleranceValue: 'PT2H'},
		{eventType: DepartureEvent, matchLocation: true, technicalToleranceValue: 'PT2H',
			periodicOverdueDetection: 'PT24H', maxOverdueDetection: 3},
		{eventType: CustomsInEvent, matchLocation: true, technicalToleranceValue: 'PT2H',
			periodicOverdueDetection: 'PT24H', maxOverdueDetection: 3},
		{eventType: ClearCustomsEvent, matchLocation: true, technicalToleranceValue: 'PT2H',
			periodicOverdueDetection: 'PT24H', maxOverdueDetection: 3},
		{eventType: ArrivalAtDestinationEvent, matchLocation: true, technicalToleranceValue: 'PT2H',
			periodicOverdueDetection: 'PT24H', maxOverdueDetection: 3},
		{eventType: UnloadingEvent, matchLocation: true, technicalToleranceValue: 'PT2H',
			periodicOverdueDetection: 'PT24H', maxOverdueDetection: 3},
		{eventType: ReturnEmptyContainerEvent, matchLocation: true, technicalToleranceValue: 'PT2H',
			periodicOverdueDetection: 'PT24H', maxOverdueDetection: 3},
		// Added Planned Event
		{eventType: TemperatureInfoEvent, matchLocation: false},
	]
	@CoreModel.AdmissibleUnplannedEvents: [
		{eventType: DelayedEvent},
		//Added Unplanned Event
		{eventType: OverheatedEvent}
	]
	@CoreModel.StatusProperties: ['transportationStatus','customStatus', 'deliveryStatus', 'temperatureStatus']
	@CoreModel.Indexable: true
	entity ShipmentProcess : CoreModel.TrackedProcess, BaseShipmentProcess{};
	entity ShipmentProcessForWrite : CoreModel.TrackedProcessForWrite, BaseShipmentProcess{};
	entity AllTrackedProcessForShipmentProcess : CoreModel.AllTrackedProcess, BaseShipmentProcess{};

	// Event for Carrier Arrival
	// ----------------------------------------------------------------------
	entity BaseCarrierArrivalEvent {
		// event specific data
		// empty here
	};
	@UI.HeaderInfo.Title.Label: '{@i18n>Carrier_Arrival}'
	@SAP_EM.eventCode: {Code: 'ZWS_ARRIV_CARR', Text: '{@i18n>Carrier_Arrival}', Type: 'PLANNED'}
	@CoreModel.Indexable: false
	entity CarrierArrivalEvent : CoreModel.Event, BaseCarrierArrivalEvent{};
	entity CarrierArrivalEventForWrite : CoreModel.EventForWrite, BaseCarrierArrivalEvent{};
	annotate CarrierArrivalEvent with {
		location @CoreModel.ObjectIdentifierType: #shippingPoint;
	};

	// Event for Loading Begin
	// ----------------------------------------------------------------------
	entity BaseLoadingBeginEvent {
		// event specific data
		// empty here
	};
	@UI.HeaderInfo.Title.Label: '{@i18n>Loading_Begin}'
	@SAP_EM.eventCode: {Code: 'ZWS_LOAD_BEGIN', Text: '{@i18n>Loading_Begin}', Type: 'PLANNED'}
	@CoreModel.UpdateStatus: [
		{pathToStatus: 'ShipmentProcess.transportationStatus', newValue: '02'}
	]
	@CoreModel.Indexable: false
	entity LoadingBeginEvent : CoreModel.Event, BaseLoadingBeginEvent{};
	entity LoadingBeginEventForWrite : CoreModel.EventForWrite, BaseLoadingBeginEvent{};
	annotate LoadingBeginEvent with {
		location @CoreModel.ObjectIdentifierType: #shippingPoint;
	};

	// Event for Loading End
	// ----------------------------------------------------------------------
	entity BaseLoadingEndEvent {
		// event specific data
		// empty here
	};
	@UI.HeaderInfo.Title.Label: '{@i18n>Loading_End}'
	@SAP_EM.eventCode: {Code: 'ZWS_LOAD_END', Text: '{@i18n>Loading_End}', Type: 'PLANNED'}
	@CoreModel.Indexable: false
	entity LoadingEndEvent : CoreModel.Event, BaseLoadingEndEvent{};
	entity LoadingEndEventForWrite : CoreModel.EventForWrite, BaseLoadingEndEvent{};
	annotate LoadingEndEvent with {
		location @CoreModel.ObjectIdentifierType: #shippingPoint;
	};

	// Event for Departure
	// ----------------------------------------------------------------------
	entity BaseDepartureEvent {
		// event specific data
		// empty here
	};
	@UI.HeaderInfo.Title.Label: '{@i18n>Departure}'
	@SAP_EM.eventCode: {Code: 'ZWS_DEPARTURE', Text: '{@i18n>Departure}', Type: 'PLANNED'}
	@CoreModel.UpdateStatus: [
		{pathToStatus: 'ShipmentProcess.transportationStatus', newValue: '03'}
	]
	@CoreModel.Indexable: false
	entity DepartureEvent : CoreModel.Event, BaseDepartureEvent{};
	entity DepartureEventForWrite : CoreModel.EventForWrite, BaseDepartureEvent{};
	annotate DepartureEvent with {
		location @CoreModel.ObjectIdentifierType: #shippingPoint;
	};

	// Event for Customs In
	// ----------------------------------------------------------------------
	entity BaseCustomsInEvent {
		// event specific data
		// empty here
	};
	@UI.HeaderInfo.Title.Label: '{@i18n>Customs_In}'
	@SAP_EM.eventCode: {Code: 'ZWS_CUSTOMS_IN', Text: '{@i18n>Customs_In}', Type: 'PLANNED'}
	@CoreModel.UpdateStatus: [
		{pathToStatus: 'ShipmentProcess.customStatus', newValue: '02'}
	]
	@CoreModel.Indexable: false
	entity CustomsInEvent : CoreModel.Event, BaseCustomsInEvent{};
	entity CustomsInEventForWrite : CoreModel.EventForWrite, BaseCustomsInEvent{};
	annotate CustomsInEvent with {
		location @CoreModel.ObjectIdentifierType: #customerLocation;
	};

	// Event for Clear Customs
	// ----------------------------------------------------------------------
	entity BaseClearCustomsEvent {
		// event specific data
		// empty here
	};
	@UI.HeaderInfo.Title.Label: '{@i18n>Clear_Customs}'
	@SAP_EM.eventCode: {Code: 'ZWS_CLEAR_CUSTOMS', Text: '{@i18n>Clear_Customs}', Type: 'PLANNED'}
	@CoreModel.UpdateStatus: [
		{pathToStatus: 'ShipmentProcess.customStatus', newValue: '03'}
	]
	@CoreModel.Indexable: false
	entity ClearCustomsEvent : CoreModel.Event, BaseClearCustomsEvent{};
	entity ClearCustomsEventForWrite : CoreModel.EventForWrite, BaseClearCustomsEvent{};
	annotate ClearCustomsEvent with {
		location @CoreModel.ObjectIdentifierType: #customerLocation;
	};

	// Event for Arrival at Destination
	// ----------------------------------------------------------------------
	entity BaseArrivalAtDestinationEvent {
		// event specific data
		// empty here
	};
	@UI.HeaderInfo.Title.Label: '{@i18n>Arrival_at_Destination}'
	@SAP_EM.eventCode: {Code: 'ZWS_ARRIV_DEST', Text: '{@i18n>Arrival_at_Destination}', Type: 'PLANNED'}
	@CoreModel.UpdateStatus: [
		{pathToStatus: 'ShipmentProcess.transportationStatus', newValue: '05'}
	]
	@CoreModel.Indexable: false
	entity ArrivalAtDestinationEvent : CoreModel.Event, BaseArrivalAtDestinationEvent{};
	entity ArrivalAtDestinationEventForWrite : CoreModel.EventForWrite, BaseArrivalAtDestinationEvent{};
	annotate ArrivalAtDestinationEvent with {
		location @CoreModel.ObjectIdentifierType: #customerLocation;
	};

	// Event for Unloading
	// ----------------------------------------------------------------------
	entity BaseUnloadingEvent {
		// event specific data
		// empty here
	};
	@UI.HeaderInfo.Title.Label: '{@i18n>Unloading}'
	@SAP_EM.eventCode: {Code: 'ZWS_UNLOAD', Text: '{@i18n>Unloading}', Type: 'PLANNED'}
	@CoreModel.UpdateStatus: [
		{pathToStatus: 'ShipmentProcess.transportationStatus', newValue: '04'}
	]
	@CoreModel.Indexable: false
	entity UnloadingEvent : CoreModel.Event, BaseUnloadingEvent{};
	entity UnloadingEventForWrite : CoreModel.EventForWrite, BaseUnloadingEvent{};
	annotate UnloadingEvent with {
		location @CoreModel.ObjectIdentifierType: #customerLocation;
	};

	// Event for Accidents of all kind - usually an unplanned event
	// ----------------------------------------------------------------------
	entity BaseReturnEmptyContainerEvent {
		// event specific data
		// empty here
	};
	@UI.HeaderInfo.Title.Label: '{@i18n>Return_Empty_Container}'
	@SAP_EM.eventCode: {Code: 'ZWS_RETURN_CONTAINER', Text: '{@i18n>Return_Empty_Container}', Type: 'PLANNED'}
	@CoreModel.Indexable: false
	entity ReturnEmptyContainerEvent : CoreModel.Event, BaseReturnEmptyContainerEvent{};
	entity ReturnEmptyContainerEventForWrite : CoreModel.EventForWrite, BaseReturnEmptyContainerEvent{};
	annotate ReturnEmptyContainerEvent with {
		location @CoreModel.ObjectIdentifierType: #customerLocation;
	};
	
	//Added Planned Event
	// Event for Temperature Info
	// ----------------------------------------------------------------------
	entity BaseTemperatureInfoEvent {
		newTemperature                  			: String(6) @title: '{@i18n>Temperature}';
		temperatureUnit                             : CoreModel.UnitOfMeasure @title:'{@i18n>Temperature_Unit}';
	};
	@UI.HeaderInfo.Title.Label: '{@i18n>Temperature_Info}'
	@SAP_EM.eventCode: {Code: 'ZWS_TEMP_INFO', Text: '{@i18n>Temperature_Info}', Type: 'PLANNED'}
	@CoreModel.Indexable: false
	entity TemperatureInfoEvent : CoreModel.Event, BaseTemperatureInfoEvent{};
	entity TemperatureInfoEventForWrite : CoreModel.EventForWrite, BaseTemperatureInfoEvent{};
	
	//Added Unplanned Event
	// Event for Overheating Alert
	// ----------------------------------------------------------------------
	entity BaseOverheatedEvent {
		newTemperature                  			: String(6) @title: '{@i18n>Temperature}';
		temperatureUnit                             : CoreModel.UnitOfMeasure @title:'{@i18n>Temperature_Unit}';
	};
	@UI.HeaderInfo.Title.Label: '{@i18n>Overheated}'
	@SAP_EM.eventCode: {Code: 'ZWS_OVERHEATED', Text: '{@i18n>Overheated}', Type: 'UNPLANNED'}
	@CoreModel.UpdateStatus: [
		{pathToStatus: 'ShipmentProcess.temperatureStatus', newValue: '02'}
	]
	@CoreModel.Indexable: false
	entity OverheatedEvent : CoreModel.Event, BaseOverheatedEvent{};
	entity OverheatedEventForWrite : CoreModel.EventForWrite, BaseOverheatedEvent{};


	// Event for delays of all kind - usually an unplanned event
	// ----------------------------------------------------------------------
	entity BaseDelayedEvent {
		// event specific data
		// empty here
	};
	@UI.HeaderInfo.Title.Label: '{@i18n>Delayed}'
	@SAP_EM.eventCode: {Code: 'ZWS_DELAY_SHIPMENT', Text: '{@i18n>Delayed}', Type: 'UNPLANNED'}
	@CoreModel.UpdateStatus: [
		{pathToStatus: 'ShipmentProcess.deliveryStatus', newValue: '02'}
	]
	@CoreModel.Indexable: false
	entity DelayedEvent : CoreModel.Event, BaseDelayedEvent{};
	entity DelayedEventForWrite : CoreModel.EventForWrite, BaseDelayedEvent{};
	annotate DelayedEvent with {
		location @CoreModel.ObjectIdentifierType: #customerLocation;
	};

	@CoreModel.UsageType: #inboundMessage
	@SAP_EM.applicationObjectType: 'ZWSE_SHP'
	@SAP_EM.primaryTrackingIdType: 'ZWSE_SHP_NO'
	entity ShipmentProcessRoad as projection on ShipmentProcess {
		@SAP_EM.fieldName                   : 'SHP_NO'
		shipmentId,
		@SAP_EM.fieldName                   : 'CONTAINER_ID'
		containerId,
		@SAP_EM.fieldName                   : 'FORWARDING_AGENT'
		@CoreModel.ObjectIdentifierType: #customer
		forwardingAgent,
		@SAP_EM.fieldName                   : 'TRANSPORTATION_PLANNING_POINT'
		transportationPlanningPoint,
		@SAP_EM.fieldName                   : 'ROUTE'
		route,
		@SAP_EM.fieldName                   : 'EXTERNAL_ID1'
		carrierShipmentId,
		@SAP_EM.fieldName                   : 'EXTERNAL_ID2'
		externalId,
		@SAP_EM.fieldName                   : 'SHIPMENT_VOLUME'
		shipmentVolume,
		@SAP_EM.fieldName                   : 'SHIPMENT_VOLUME_UNIT'
		shipmentVolumeUnit,
		@SAP_EM.fieldName                   : 'SHIPMENT_WEIGHT'
		shipmentWeight,
		@SAP_EM.fieldName                   : 'SHIPMENT_WEIGHT_UNIT'
		shipmentWeightUnit,
		@SAP_EM.fieldName                   : 'TOTAL_SHIPMENT_WEIGHT'
		totalShipmentWeight,
		@SAP_EM.fieldName                   : 'SHIPMENT_TYPE'
		shipmentType,
		@SAP_EM.fieldName                   : 'SHIPPING_TYPE'
		shippingType,
		@SAP_EM.fieldName                   : 'LEG_INDICATOR'
		legIndicator,
		@SAP_EM.fieldName                   : 'SHIPMENT_COMP'
		shipmentCompletionType,
		@SAP_EM.fieldName                   : 'SHIPPING_CONDITION'
		shippingCondition,
		@SAP_EM.itemizedEntity              : 'ShipmentProcessDeliveryRoad'
		deliveries : redirected to ShipmentProcessDeliveryRoad
	};


	@CoreModel.UsageType: #inboundMessage
	@SAP_EM.itemized: true
	entity ShipmentProcessDeliveryRoad as projection on Delivery {
		@SAP_EM.fieldName                   : 'DEL_NO'
		delivery
	};
	
	@CoreModel.UsageType: #inboundMessage
	entity TemperatureInfoEventInbound as projection on TemperatureInfoEvent {
		@SAP_EM.fieldName                   : 'TEMPERATURE'
		newTemperature,
		@SAP_EM.fieldName                   : 'TEMPERATURE_UNIT'
		temperatureUnit
	};
	
	 @CoreModel.UsageType: #inboundMessage
	entity OverheatedEventInbound as projection on OverheatedEvent {
		@SAP_EM.fieldName                   : 'TEMPERATURE'
		newTemperature,
		@SAP_EM.fieldName                   : 'TEMPERATURE_UNIT'
		temperatureUnit
	};

};
