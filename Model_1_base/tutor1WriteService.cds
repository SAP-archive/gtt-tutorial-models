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
};