namespace com.sap.gtt.app.shipmentsample.partner.enhancement;

using com.sap.gtt.app.shipmentsample.partner.enhancement.ShipmentModel;
using com.sap.gtt.core.CoreServices.TrackedProcessWriteService;
using com.sap.gtt.core.CoreModel;

service ShipmentWriteService @extends: TrackedProcessWriteService {

	entity ShipmentProcess as projection on ShipmentModel.ShipmentProcessForWrite excluding {
		transportationStatus, customStatus, deliveryStatus,
		processLocations, currentProcessLocation,
		processRoute
	}
	actions {
		@Swagger.POST
		action shipmentProcess(@Swagger.parameter: 'requestBody' shipmentProcess: ShipmentProcess) returns String;
	};

	entity Delivery as projection on ShipmentModel.Delivery excluding {
		shipment
	};

	entity CarrierArrivalEvent as projection on ShipmentModel.CarrierArrivalEventForWrite
	actions {
		@Swagger.POST
		action carrierArrivalEvent(@Swagger.parameter: 'requestBody' carrierArrivalEvent: CarrierArrivalEvent) returns String;
	};

	entity LoadingBeginEvent as projection on ShipmentModel.LoadingBeginEventForWrite
	actions {
		@Swagger.POST
		action loadingBeginEvent(@Swagger.parameter: 'requestBody' loadingBeginEvent: LoadingBeginEvent) returns String;
	};

	entity LoadingEndEvent as projection on ShipmentModel.LoadingEndEventForWrite
	actions {
		@Swagger.POST
		action loadingEndEvent(@Swagger.parameter: 'requestBody' loadingEndEvent: LoadingEndEvent) returns String;
	};

	entity DepartureEvent as projection on ShipmentModel.DepartureEventForWrite
	actions {
		@Swagger.POST
		action departureEvent(@Swagger.parameter: 'requestBody' departureEvent: DepartureEvent) returns String;
	};

	entity CustomsInEvent as projection on ShipmentModel.CustomsInEventForWrite
	actions {
		@Swagger.POST
		action customsInEvent(@Swagger.parameter: 'requestBody' customsInEvent: CustomsInEvent) returns String;
	};

	entity ClearCustomsEvent as projection on ShipmentModel.ClearCustomsEventForWrite
	actions {
		@Swagger.POST
		action clearCustomsEvent(@Swagger.parameter: 'requestBody' clearCustomsEvent: ClearCustomsEvent) returns String;
	};

	entity ArrivalAtDestinationEvent as projection on ShipmentModel.ArrivalAtDestinationEventForWrite
	actions {
		@Swagger.POST
		action arrivalAtDestinationEvent(@Swagger.parameter: 'requestBody' arrivalAtDestinationEvent: ArrivalAtDestinationEvent) returns String;
	};

	entity UnloadingEvent as projection on ShipmentModel.UnloadingEventForWrite
	actions {
		@Swagger.POST
		action unloadingEvent(@Swagger.parameter: 'requestBody' unloadingEvent: UnloadingEvent) returns String;
	};

	entity ReturnEmptyContainerEvent as projection on ShipmentModel.ReturnEmptyContainerEventForWrite
	actions {
		@Swagger.POST
		action returnEmptyContainerEvent(@Swagger.parameter: 'requestBody' returnEmptyContainerEvent: ReturnEmptyContainerEvent) returns String;
	};

	entity DelayedEvent as projection on ShipmentModel.DelayedEventForWrite
	actions {
		@Swagger.POST
		action delayedEvent(@Swagger.parameter: 'requestBody' delayedEvent: DelayedEvent) returns String;
	};
	
	entity TemperatureInfoEvent as projection on ShipmentModel.TemperatureInfoEventForWrite
	actions {
		@Swagger.POST
		action temperatureInfoEvent(@Swagger.parameter: 'requestBody' temperatureInfoEvent: TemperatureInfoEvent) returns String;
	};

};

