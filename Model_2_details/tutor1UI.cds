namespace com.sap.gtt.app.tutorial.parceltracking;

using com.sap.gtt.app.tutorial.parceltracking.ParcelTrackingService;

//Annotations for Parcel Tracking
annotate ParcelTrackingService.ParcelTrackingProcess with @(
	Common: {
		Label: 'Parcel Tracking',
		SemanticKey: [ parcelId ],
		FilterExpressionRestrictions: [],
	},
	UI: {
		Identification: [
			{Value: parcelId},
		],
		HeaderInfo: {
			TypeName: 'Parcel Delivery',
			TypeNamePlural: 'Parcel Deliveries',
			Title: {
				Label: 'Parcel Tracking',
				Value: parcelId
			},
			Description: {
				Label: 'Parcel Tracking',
				Value: description
			}
		},
		SelectionFields: [
			parcelId
		],
		PresentationVariant: {
			SortOrder: [
				{Property: parcelId, Descending: true}
			]
		},
	},
	Capabilities: {
		Insertable: false, Updatable: false, Deletable: false,
		FilterRestrictions: {
			NonFilterableProperties: [
				shipper,
				description,
				sender,
				receiver,
				shippingstatus,
				shipperlocation,
				shipperlocation
			]
		},
		SortRestrictions: {
			NonSortableProperties: [
				shipper,
				description,
				sender,
				receiver,
				shippingstatus,
				shipperlocation,
				shipperlocation
			]
		},
		SearchRestrictions: {
			Searchable: false
		}
	},
) {};

annotate ParcelTrackingService.ParcelTrackingProcess with @(
	UI.HeaderFacets: [
		{$Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#SenderInfo'}
	],
	UI.FieldGroup#SenderInfo: {
		Label: 'Sender',
		Data: [
			{Value: logicalSenderSystem},
			{Value: trackingId},
			{Value: trackingIdType}
		]
	},
	UI.FieldGroup#Locations: {
		Label: 'Location',
		Data: [
			{Value: shipperlocation},
			{Value: receiverlocation}
		]
	},

	UI.Facets: [
		{
			$Type: 'UI.CollectionFacet',
			ID: 'BusinessProcess',
			Label: 'Business Process',
			Facets: [
				{
					$Type: 'UI.CollectionFacet',
					ID: 'DetailInfo',
					Label: 'Detailed Information',
					Facets: [
						{$Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#Locations'},
					]
				},
			]
		},
	]
);

//Line items for lists on Overview page
annotate ParcelTrackingService.ParcelTrackingProcess with @UI.LineItem: [
	{Value: parcelId},
	{Value: shipper},
	{Value: receiver},
	{Value: shippingStatus}
];