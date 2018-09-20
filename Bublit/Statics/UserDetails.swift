//
//  UserDetails.swift
//  QuizMaster
//
//  Created by Jake Smith on 28/07/2016.
//  Copyright © 2016 Jake Smith. All rights reserved.
//
import Firebase

public struct UserDetails {
    static var email = String()
    static var username = String()
    static var UID = String()
    static var deviceToken = String()
    static var Friends = [String]() // Friends UIDs
}
