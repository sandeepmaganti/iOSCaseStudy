//
//  ListEvents.swift
//  ProductViewer
//
//  Copyright © 2016 Target. All rights reserved.
//

import Tempo

struct ListItemPressed: EventType {
    var item: Product
}

enum NetworkLoader: EventType {
    case show
    case hide
}
