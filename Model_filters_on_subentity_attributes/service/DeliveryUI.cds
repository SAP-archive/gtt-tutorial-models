//!>{ fiori }
namespace com.sap.gtt.app.deliverysample.filteronitem;

using com.sap.gtt.app.deliverysample.filteronitem.DeliveryService;


////////////////////////////////////////////////////////////////////////////
//
//    Annotations for Delivery
//

annotate DeliveryService.DeliveryProcess with @(
	Common: {
		Label: '{@i18n>Delivery}',
		SemanticKey: [ deliveryId ],
		FilterExpressionRestrictions: [{
			Property: deliveryDate,
			AllowedExpressions: #SingleInterval,
		},{
			Property: loadingDate,
			AllowedExpressions: #SingleInterval,
		},{
			Property: transPlanDate,
			AllowedExpressions: #SingleInterval,
		}],
	},
	UI: {
		Identification: [
			{Value: deliveryId},
		],
		HeaderInfo: {
			TypeName: '{@i18n>Delivery}',
			TypeNamePlural: '{@i18n>Deliveries}',
			Title: {
				Label: '{@i18n>Outbound_Delivery}',
				Value: deliveryId
			},
			Description: {
				Label: '{@i18n>Track_Outbound_Delivery}',
				Value: description
			}
		},
		SelectionFields: [
			deliveryId,
			sender,
			salesOrganization,
			deliveryDate,
			deliveryStatus,
			shippingStatus,
			item.deliveryQty,
			item.qtyUnit,
			item.productproductId
		],
		PresentationVariant: {
			SortOrder: [
				{Property: deliveryId, Descending: true}
			]
		},
	},
	Capabilities: {
		Insertable: false, Updatable: false, Deletable: false,
		FilterRestrictions: {
			NonFilterableProperties: [
				to_personalDataProtectionStatus,
				description,
				sender,
				shipToParty,
				soldToParty,
				shippingPoint,
				to_shippingType,
				to_deliveryStatus,
				to_shippingStatus,
				deliveryWeightUnit,
				deliveryVolumeUnit,
			]
		},
		SortRestrictions: {
			NonSortableProperties: [
				senderbusinessPartnerID,
				shipToPartybusinessPartnerID,
				soldToPartybusinessPartnerID,
				shippingPointlocationId,
			]
		},
		SearchRestrictions: {
			Searchable: false
		}
	},
) {
	id @title: '{@i18n>ID}' @Common.FieldControl: #Hidden;
	description @title: '{@i18n>Description}';
};

// Line Items for Lists
annotate DeliveryService.DeliveryProcess with @UI.LineItem: [
	{Value: deliveryId},
	{Value: sender},
	{Value: salesOrderId},
	{Value: purchaseOrderId},
	{Value: shipToParty},
	{Value: salesOrganization},
	{Value: deliveryDate},
	{Value: loadingDate},
	{Value: deliveryStatus, Criticality: to_deliveryStatus.Criticality, CriticalityRepresentation: #WithoutIcon},
	{Value: shippingStatus},
];

// Facets for Object Page
annotate DeliveryService.DeliveryProcess with @(
	UI.HeaderFacets: [
		{$Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#SenderInfo'},
		{$Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#TrackingInfo'},
		{$Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#shippingStatus'},
		{$Type: 'UI.ReferenceFacet', Target: '@UI.DataPoint#deliveryStatus'},
	],
	UI.FieldGroup#SenderInfo: {
		Label: '{@i18n>Sender}',
		Data: [
			{$Type: 'UI.DataFieldForAnnotation', Label: '{@i18n>Sender}', Target: 'sender/@Communication.Contact'},
			{Value: logicalSenderSystem},
		]
	},
	UI.FieldGroup#TrackingInfo: {
		Label: '{@i18n>Tracking_ID}',
		Data: [
			{Value: trackingId},
			{Value: trackingIdType},
		]
	},
	UI.FieldGroup#shippingStatus: {
		Data: [
			{Value: shippingStatus},
		]
	},
	UI.DataPoint#deliveryStatus: {
		Value: deliveryStatus,
		Title: '{@i18n>Delivery_Status}',
		Criticality: to_deliveryStatus.Criticality
	},
	UI.FieldGroup#SalesAndPurchase: {
		Label: '{@i18n>Sales_and_Purchase}',
		Data: [
			{Value: salesOrderId},
			{Value: purchaseOrderId},
			{Value: salesOrganization},
			{$Type: 'UI.DataFieldForAnnotation', Label: '{@i18n>Ship_To_Party}', Target: 'shipToParty/@Communication.Contact'},
			{$Type: 'UI.DataFieldForAnnotation', Label: '{@i18n>Sold_To_Party}', Target: 'soldToParty/@Communication.Contact'},
		]
	},
	UI.FieldGroup#ShippingInformation: {
		Label: '{@i18n>Shipping_Information}',
		Data: [
			{Value: shippingType},
			{Value: shippingPoint},
			{Value: transPlanDate},
			{Value: loadingDate},
			{Value: deliveryDate},
		]
	},
	UI.FieldGroup#PackageDetails: {
		Label: '{@i18n>Package_Details}',
		Data: [
			{Value: numberOfPackages},
			{Value: deliveryVolume},
			{Value: deliveryWeight},
			{Value: deliveryNetWeight},
		]
	},

	UI.Facets: [
		{
			$Type: 'UI.CollectionFacet',
			ID: 'BusinessProcess',
			Label: '{@i18n>Business_Process}',
			Facets: [
				{
					$Type: 'UI.CollectionFacet',
					ID: 'DetailInfo',
					Label: '{@i18n>Detailed_Information}',
					Facets: [
						{$Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#SalesAndPurchase'},
						{$Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#ShippingInformation'},
						{$Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#PackageDetails'},
					]
				},
				{
					$Type: 'UI.CollectionFacet', ID: 'DeliveryItems', Label: '{@i18n>Delivery_Items}',
					Facets: [
						{$Type: 'UI.ReferenceFacet', Target: 'items/@UI.LineItem'},
					]
				},
				{
					$Type: 'UI.CollectionFacet', ID: 'Events', Label: '{@i18n>Event_Messages}',
					Facets: [
						{$Type: 'UI.ReferenceFacet', Target: 'processEvents/@UI.LineItem#GenericEvents'},
					]
				}
			]
		},
	]
);

annotate DeliveryService.DeliveryProcess with {
	deliveryStatus @ValueList: {type: #fixed, entity: 'DeliveryStatus'};
	shippingStatus @ValueList: {type: #fixed, entity: 'ShippingStatus'};
	shippingType @ValueList: {type: #fixed, entity: 'ShippingType'};
};


////////////////////////////////////////////////////////////////////////////
//
//    Annotations for DeliveryItem
//

annotate DeliveryService.DeliveryItem with @(
	Capabilities: {
		Insertable:false, Updatable:false, Deletable:false,
		FilterRestrictions: {
			NonFilterableProperties: [
				deliveryItem,
				distributionChannel,
				plant,
				storageLocationlocationId,
				material,
				deliveryQty,
				pickingQty,
			]
		},
		SortRestrictions: {
			NonSortableProperties: [
				deliveryItem,
				distributionChannel,
				plant,
				storageLocationlocationId,
				material,
				deliveryQty,
				pickingQty,
			]
		},
		SearchRestrictions: {
			Searchable: false
		}
	},
) {
	// Element-level Annotations
	delivery @Common.FieldControl:#Hidden;
	qtyUnit @Common.FieldControl:#Hidden;
};

// Line Item for DeliveryItem
annotate DeliveryService.DeliveryItem with @UI.LineItem: [
	{Value: deliveryItem},
	{Value: product.description},
	{Value: deliveryQty},
	{Value: pickingQty},
];


// Event Object Page
annotate DeliveryService.GoodsDamageEvent with @UI.FieldGroup#CustomData: {
	Label: '{@i18n>Custom_Data}',
	Data: [
		{Value: damageQuantity},
		{Value: damageDescription},
	]
};

annotate DeliveryService.DeliveryItemForSearch with @Common.Label: '{@i18n>Delivery_Items}';
