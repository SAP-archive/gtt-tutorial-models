namespace com.sap.gtt.app.tutorial.parceltracking;

using com.sap.gtt.core.CoreModel;


context ParcelTrackingModel {

//Tracked process "Parcel Tracking"
	entity BaseParcelTrackingProcess {
		parcelId               : String(10) @title:'Parcel ID';
		shipper                : String(20) @title: 'Shipper';
		shipperlocation        : String(255) @title: 'Shipper Location';
		receiver               : String(20) @title: 'Receiver';
		receiverlocation       : String(255) @title: 'Receiver Location';

		@CoreModel.KeepStatusSequence: true
		shippingStatus         : String(50) @title:'Shipping Status'  enum  {
			notStarted       = '01' @title: 'Not Started'; //Parcel process not started
			pickingCompleted = '02' @title: 'Picking Completed'; //Goods picked up 
			received         = '03' @title: 'Received'; //Goods received
		} default '01';
	};

	@CoreModel.StatusProperties : ['shippingStatus']
	@CoreModel.Indexable : true
	entity ParcelTrackingProcess : CoreModel.TrackedProcess, BaseParcelTrackingProcess{};
	entity ParcelTrackingProcessForWrite : CoreModel.TrackedProcessForWrite, BaseParcelTrackingProcess{};
	entity AllTrackedProcessForParcelTrackingProcess : CoreModel.AllTrackedProcess, BaseParcelTrackingProcess{};

//Data provision from SAP ERP or other external sender systems
	@CoreModel.UsageType: #inboundMessage
	@SAP_EM.applicationObjectType: 'OB_PT_00'
	@SAP_EM.primaryTrackingIdType: 'PAR_00'
	entity ParcelTrackingProcessInbound as projection on ParcelTrackingProcess {
		@SAP_EM.fieldName      : 'PAL_ID'
		parcelId,

		@SAP_EM.fieldName      : 'SHIPPER'
		shipper,

		@SAP_EM.fieldName      : 'SHIP_LOC'
		shipperlocation,

		@SAP_EM.fieldName      : 'RECEIVER'
		receiver,

		@SAP_EM.fieldName      : 'REC_LOC'
		receiverlocation,

		@SAP_EM.fieldName      : 'SHIP_STAT'
		shippingStatus
	};
};