namespace com.sap.gtt.app.shipmentsample.partner.enhancement; // initial namespace, may be subject to change

using com.sap.gtt.app.shipmentsample.partner.enhancement.ShipmentModel;
using com.sap.gtt.core.CoreServices.TrackedProcessService;
using com.sap.gtt.core.CoreModel;

service ShipmentService @extends: TrackedProcessService {

	@CoreModel.UsageType: #userInterface
	@CoreModel.MainEntity: true
	entity ShipmentProcess as projection on ShipmentModel.ShipmentProcess excluding {
		tenant, name, trackedProcessType,
		lastProcessedEvent,
		CreatedByUser, CreationDateTime,
		LastChangedByUser, LastChangeDateTime
	};

	entity Delivery as projection on ShipmentModel.Delivery;

	entity CarrierArrivalEvent as projection on ShipmentModel.CarrierArrivalEvent;
	entity LoadingBeginEvent as projection on ShipmentModel.LoadingBeginEvent;
	entity LoadingEndEvent as projection on ShipmentModel.LoadingEndEvent;
	entity DepartureEvent as projection on ShipmentModel.DepartureEvent;
	entity CustomsInEvent as projection on ShipmentModel.CustomsInEvent;
	entity ClearCustomsEvent as projection on ShipmentModel.ClearCustomsEvent;
	entity ArrivalAtDestinationEvent as projection on ShipmentModel.ArrivalAtDestinationEvent;
	entity UnloadingEvent as projection on ShipmentModel.UnloadingEvent;
	entity ReturnEmptyContainerEvent as projection on ShipmentModel.ReturnEmptyContainerEvent;
	entity DelayedEvent as projection on ShipmentModel.DelayedEvent;
	
	entity TemperatureInfoEvent as projection on ShipmentModel.TemperatureInfoEvent;

	//
	// Entities for Value Lists
	//
	entity TemperatureStatus as projection on ShipmentModel.TemperatureStatus;
	entity DeliveryStatus as projection on ShipmentModel.DeliveryStatus;
	entity ShippingType as projection on ShipmentModel.ShippingType;
	entity ShipmentType as projection on ShipmentModel.ShipmentType;
	entity TransportationStatus as projection on ShipmentModel.TransportationStatus;
	entity CustomStatus as projection on ShipmentModel.CustomStatus;
	entity LegIndicator as projection on ShipmentModel.LegIndicator;
	entity ShipmentCompletionType as projection on ShipmentModel.ShipmentCompletionType;
	entity ShippingCondition as projection on ShipmentModel.ShippingCondition;

	// Entity AllTrackedProcessXXX for hierarchy table
	entity AllTrackedProcessForShipmentProcess as projection on ShipmentModel.AllTrackedProcessForShipmentProcess;

 };
