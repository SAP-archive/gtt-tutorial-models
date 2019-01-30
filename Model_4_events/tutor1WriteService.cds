namespace com.sap.gtt.app.tutorial.parceltracking;

using com.sap.gtt.app.tutorial.parceltracking.ParcelTrackingModel;
using com.sap.gtt.core.CoreServices.TrackedProcessWriteService;
using com.sap.gtt.core.CoreModel;

service ParcelTrackingWriteService @extends: TrackedProcessWriteService {

	entity ParcelTrackingProcess as projection on ParcelTrackingModel.ParcelTrackingProcessForWrite excluding {
		shippingStatus
	}
	actions {
		@Swagger.POST
		action parcelTrackingProcess(@Swagger.parameter: 'requestBody' parcelTrackingProcess: ParcelTrackingProcess) returns String;
	};

	entity ParcelTrackingItem as projection on ParcelTrackingModel.ParcelTrackingItem excluding {
		parcel
	};

	entity PickedUpFromShipperEvent as projection on ParcelTrackingModel.PickedUpFromShipperEventForWrite 
	actions {
		@Swagger.POST
		action pickedUpFromShipperEvent(@Swagger.parameter: 'requestBody' pickedUpFromShipperEvent: PickedUpFromShipperEvent) returns String;
	};

	entity ArrivedAtDistributionHubEvent as projection on ParcelTrackingModel.ArrivedAtDistributionHubEventForWrite 
	actions {
		@Swagger.POST
		action arrivedAtDistributionHubEvent(@Swagger.parameter: 'requestBody' arrivedAtDistributionHubEvent: ArrivedAtDistributionHubEvent) returns String;
	};

	entity DelayedEvent as projection on ParcelTrackingModel.DelayedEventForWrite 
	actions {
		@Swagger.POST
		action delayedEvent(@Swagger.parameter: 'requestBody' delayedEvent: DelayedEvent) returns String;
	};
};
