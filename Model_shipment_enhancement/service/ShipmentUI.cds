//!>{ fiori }
namespace com.sap.gtt.app.shipmentsample.partner.enhancement;

using com.sap.gtt.app.shipmentsample.partner.enhancement.ShipmentService;

////////////////////////////////////////////////////////////////////////////
//
//    Annotations for Shipment
//

annotate ShipmentService.ShipmentProcess with @(
	Common: {
		Label: '{@i18n>Shipment}',
		SemanticKey: [ shipmentId ],
	},
	UI: {
		Identification: [
			{Value: shipmentId},
		],
		HeaderInfo: {
			TypeName: '{@i18n>Shipment}',
			TypeNamePlural: '{@i18n>Shipments}',
			Title: {
				Label: '{@i18n>Shipment}',
				Value: shipmentId
			},
			Description: {
				Label: '{@i18n>Track_Shipment}',
				Value: description
			}
		},
		SelectionFields: [
			shipmentId,
			forwardingAgent,
			transportationStatus,
			customStatus,
			deliveryStatus,
			temperatureStatus
		],
		PresentationVariant: {
			SortOrder: [
				{Property: shipmentId, Descending: true}
			]
		},
	},
	Capabilities: {
		Insertable:false, Updatable:false, Deletable:false,
		FilterRestrictions: {
			NonFilterableProperties: [
				to_personalDataProtectionStatus,
				description,
				containerId,
				forwardingAgent,
				externalId,
				transportationPlanningPoint,
				shipmentVolumeUnit,
				shipmentWeightUnit,
				to_shipmentType,
				to_shippingType,
				to_transportationStatus,
				to_customStatus,
				to_deliveryStatus,
				to_temperatureStatus,
				to_shipmentCompletionType,
				to_legIndicator,
				to_shippingCondition,
				processRoute,
				currentProcessLocation,
			]
		},
		SortRestrictions: {
			NonSortableProperties: [
				senderbusinessPartnerID,
				forwardingAgentbusinessPartnerID
			]
		},
		SearchRestrictions: {
			Searchable: false
		}
	},
) {
	id @title:'{@i18n>ID}' @Common.FieldControl: #Hidden;
	description @title: '{@i18n>Description}';
	forwardingAgent @important;

	@UIExt.GeoMap.DisplayOnListReportPage.Enabled: true
	@UIExt.GeoMap.DisplayOnListReportPage.PopupPresentationVariantID: 'GeoMap'
	@UIExt.GeoMap.DisplayOnObjectPage.FacetID: 'ProcessGeoMap'
	@UIExt.GeoMap.Route.Status.Color.PropertyPath: to_deliveryStatus.Criticality
	@UIExt.GeoMap.Route.Status.Text.PropertyPath: to_deliveryStatus.Text
	@UIExt.GeoMap.Route.Status.Value.PropertyPath: deliveryStatus
	@UIExt.GeoMap.Route.Status.ValueList.Entity: DeliveryStatus
	@Common.FieldControl: #Hidden
	processRoute;

	@Common.FieldControl: #Hidden
	currentProcessLocation;
};

// Line Items for Lists
annotate ShipmentService.ShipmentProcess with @UI.LineItem: [
	{Value: shipmentId},
	{Value: containerId},
	{Value: route},
	{Value: transportationPlanningPoint},
	{Value: shipmentVolume},
	{Value: shipmentWeight},
	{Value: deliveryStatus, Criticality: to_deliveryStatus.Criticality, CriticalityRepresentation: #WithoutIcon},
	{Value: temperatureStatus, Criticality: to_temperatureStatus.Criticality, CriticalityRepresentation: #WithoutIcon},
	{Value: transportationStatus},
	{Value: customStatus},
	{Value: shipmentType},
	{Value: shippingType},
];

// Presentation for Popover on Overview Geo Map
annotate ShipmentService.ShipmentProcess with @UI.PresentationVariant#GeoMap: {
	Visualizations: [
		'@UI.LineItem#GeoMap'
	]
};

annotate ShipmentService.ShipmentProcess with @UI.LineItem#GeoMap: [
	{Value: shipmentId},
	{Value: deliveryStatus, Criticality: to_deliveryStatus.Criticality, CriticalityRepresentation: #WithoutIcon},
];

// Facets for Object Page
annotate ShipmentService.ShipmentProcess with @(
	UI.HeaderFacets: [
		{$Type: 'UI.DataField', Value: shipmentId},
		{$Type: 'UI.ReferenceFacet', Target: '@UI.DataPoint#transportationStatus'},
		{$Type: 'UI.ReferenceFacet', Target: '@UI.DataPoint#customStatus'},
		{$Type: 'UI.ReferenceFacet', Target: '@UI.DataPoint#deliveryStatus'},
		{$Type: 'UI.ReferenceFacet', Target: '@UI.DataPoint#temperatureStatus'},
		{$Type: 'UI.ReferenceFacet', Target: '@UI.DataPoint#temperature'},
	],

	UI.DataPoint#transportationStatus: {
		Value: transportationStatus,
		Title: '{@i18n>Transportation_Status}',
		Criticality: to_transportationStatus.Criticality
	},

	UI.DataPoint#customStatus: {
		Value: customStatus,
		Title: '{@i18n>Custom_Status}',
		Criticality: to_customStatus.Criticality
	},

	UI.DataPoint#deliveryStatus: {
		Value: deliveryStatus,
		Title: '{@i18n>Delivery_Status}',
		Criticality: to_deliveryStatus.Criticality
	},
	
	UI.DataPoint#temperatureStatus: {
		Value: temperatureStatus,
		Title: '{@i18n>Temperature_Status}',
		Criticality: to_temperatureStatus.Criticality
	},
	
	UI.DataPoint#temperature: {
		Value: presentTemperature,
		Title: '{@i18n>Temperature}'
	},

	UI.FieldGroup#DetailInfo1: {
		Label: '{@i18n>Detailed_Information_1}',
		Data: [
			// URL link navigate to external website
			{
				$Type: 'UI.DataFieldWithUrl',
				Value: containerId,
				Label: '{@i18n>Container_ID}',
				Url: {
					$edmJson: {
						$Apply: [
							'http://www.shippingline.org/track/?type=container&container={containerId}&line=&track=Track+container',
							{
								$LabeledElement: {
									$Path: 'containerId'
								},
								$Name: 'containerId'
							}
						],
						$Function: 'odata.fillUriTemplate'
					}
				}
			},
			{Value: shippingType},
			{$Type: 'UI.DataFieldForAnnotation', Label: '{@i18n>Forwarding_Agent}', Target: 'forwardingAgent/@Communication.Contact'},
			{Value: route},
			{Value: transportationPlanningPoint},
		]
	},
	UI.FieldGroup#DetailInfo2: {
		Label: '{@i18n>Detailed_Information_2}',
		Data: [
			{Value: shipmentVolume},
			{Value: shipmentWeight},
			{Value: totalShipmentWeight},
			{Value: shipmentType},
			{Value: carrierShipmentId},
		]
	},

	UI.Facets: [
		{
			$Type: 'UI.ReferenceFacet',
			ID: 'ProcessGeoMap',
			Label: '{@i18n>Map}',
		},
		{
			$Type: 'UI.CollectionFacet',
			ID: 'InformationAndEvents',
			Label: '{@i18n>Information_and_Events}',
			Facets: [
				{
					$Type: 'UI.CollectionFacet', ID: 'Events', Label: '{@i18n>Event_Messages}',
					Facets: [
						{$Type: 'UI.ReferenceFacet', Target: 'processEvents/@UI.LineItem#GenericEvents'},
					]
				},
				{
					$Type: 'UI.CollectionFacet', ID: 'Deliveries', Label: '{@i18n>Deliveries}',
					Facets: [
						{$Type: 'UI.ReferenceFacet', Target: 'deliveries/@UI.LineItem'},
					]
				},
				{
					$Type: 'UI.CollectionFacet',
					ID: 'DetailInfo',
					Label: '{@i18n>Detailed_Information}',
					Facets: [
						{$Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#DetailInfo1'},
						{$Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#DetailInfo2'},
					]
				}
			]
		}
	]
);

// Value Lists
annotate ShipmentService.ShipmentProcess with {
	shipmentType   @ValueList:{ type:#fixed, entity:'ShipmentType' };
	shippingType  @ValueList:{ type:#fixed, entity:'ShippingType' };
	transportationStatus @ValueList:{ type:#fixed, entity:'TransportationStatus' };
	customStatus @ValueList:{ type:#fixed, entity:'CustomStatus' };
	deliveryStatus @ValueList:{ type:#fixed, entity:'DeliveryStatus' };
	temperatureStatus @ValueList:{ type:#fixed, entity:'TemperatureStatus' };
	shipmentCompletionType @ValueList:{ type:#fixed, entity:'ShipmentCompletionType' };
	legIndicator @ValueList:{ type:#fixed, entity:'LegIndicator' };
	shippingCondition @ValueList:{ type:#fixed, entity:'ShippingCondition' };
};


////////////////////////////////////////////////////////////////////////////
//
//    Annotations for Delivery
//

annotate ShipmentService.Delivery with @(
	Capabilities: {
		Insertable:false, Updatable:false, Deletable:false,
		FilterRestrictions: {
			NonFilterableProperties: [
				delivery,
			]
		},
		SortRestrictions: {
			NonSortableProperties: [
				delivery,
			]
		},
		SearchRestrictions: {
			Searchable: false
		}
	},
) {
	shipment @Common.FieldControl:#Hidden;
};

annotate ShipmentService.Delivery with @UI.LineItem: [
	// URL link navigation
	{
		$Type: 'UI.DataFieldWithUrl',
		Value: delivery,
		Label: '{@i18n>Delivery}',
		Url: {
			$edmJson: {
				$Apply: [
					'#TrackedProcess-display?model={model}&deliveryId={deliveryId}',
					{
						$LabeledElement: 'com.sap.gtt.app.deliverysample',
						$Name: 'model'
					},
					{
						$LabeledElement: {
							$Apply: [
								{ $Path: 'delivery' }
							],
							$Function: 'odata.uriEncode'
						},
						$Name: 'deliveryId'
					}
				],
				$Function: 'odata.fillUriTemplate'
			}
		}
	},
];
