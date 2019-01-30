namespace com.sap.gtt.app.tutorial.parceltracking;

using com.sap.gtt.app.tutorial.parceltracking.ParcelTrackingModel;
using com.sap.gtt.core.CoreServices.TrackedProcessService;
using com.sap.gtt.core.CoreModel;

service ParcelTrackingService @extends: TrackedProcessService {

	@CoreModel.UsageType: #userInterface
	@CoreModel.MainEntity: true
	entity ParcelTrackingProcess as projection on ParcelTrackingModel.ParcelTrackingProcess excluding {
		tenant, name, trackedProcessType,		
		lastProcessedEvent,
		CreatedByUser, CreationDateTime,
		LastChangedByUser, LastChangeDateTime
	};

	entity AllTrackedProcessForParcelTrackingProcess as projection on ParcelTrackingModel.AllTrackedProcessForParcelTrackingProcess;
};