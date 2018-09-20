//
//  UserDetails.swift
//  Bublit
//
//  Created by Jake Smith on 28/07/2016.
//  Copyright © 2016 Jake Smith. All rights reserved.
//
import Firebase

public struct MapData {
    static let mapStyle = "[\r\n  {\r\n    \"featureType\": \"administrative\",\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"visibility\": \"off\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"administrative.land_parcel\",\r\n    \"stylers\": [\r\n      {\r\n        \"visibility\": \"off\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"administrative.locality\",\r\n    \"elementType\": \"labels.text\",\r\n    \"stylers\": [\r\n      {\r\n        \"weight\": 0.5\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"administrative.locality\",\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#f1ecff\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"administrative.locality\",\r\n    \"elementType\": \"labels.text.stroke\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#a5a5a9\"\r\n      },\r\n      {\r\n        \"visibility\": \"simplified\"\r\n      },\r\n      {\r\n        \"weight\": 1.5\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"administrative.neighborhood\",\r\n    \"stylers\": [\r\n      {\r\n        \"visibility\": \"off\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"landscape\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#5ba3ff\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"poi\",\r\n    \"stylers\": [\r\n      {\r\n        \"visibility\": \"off\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"poi\",\r\n    \"elementType\": \"labels.text\",\r\n    \"stylers\": [\r\n      {\r\n        \"visibility\": \"off\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"road\",\r\n    \"elementType\": \"labels\",\r\n    \"stylers\": [\r\n      {\r\n        \"visibility\": \"off\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"road\",\r\n    \"elementType\": \"labels.icon\",\r\n    \"stylers\": [\r\n      {\r\n        \"visibility\": \"off\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"road.highway\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#426ec4\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"transit\",\r\n    \"stylers\": [\r\n      {\r\n        \"visibility\": \"off\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"water\",\r\n    \"elementType\": \"labels.text\",\r\n    \"stylers\": [\r\n      {\r\n        \"visibility\": \"off\"\r\n      }\r\n    ]\r\n  }\r\n]"
    static let userBubbleScale: Float = 0.05
}

